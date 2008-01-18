Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYARNbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYARNbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbYARNbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:31:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:57502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761267AbYARNbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:31:22 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19M7qxZchlMEodgwV+7H0ZLjjZTH3FCpJ5xAW1vT/
	y8HLOumEOMkF8L
Date: Fri, 18 Jan 2008 14:31:16 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Jakob Oestergaard <jakob@unthought.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118133116.GA31790@atjola.homenet>
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org> <20080118094826.GN25527@unthought.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080118094826.GN25527@unthought.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.01.18 10:48:26 +0100, Jakob Oestergaard wrote:
> On Thu, Jan 17, 2008 at 01:25:39PM -0800, Linus Torvalds wrote:
> ...
> > Why do you make that mistake, when it is PROVABLY NOT TRUE!
> > 
> > Try this trivial program:
> > 
> > 	int main(int argc, char **argv)
> > 	{
> > 	        int i;
> > 	        const int *c;
> > 	
> > 	        i = 5;
> > 	        c = &i;
> > 	        i = 10;
> > 	        return *c;
> > 	}
> > 
> > and realize that according to the C rules, if it returns anything but 10, 
> > the compiler is *buggy*.
> 
> That's not how this works (as we obviously agree).
> 
> Please consider a rewrite of your example, demonstrating the usefulness and
> proper application of const pointers:
> 
> extern foo(const int *);
> 
> int main(int argc, char **argv)
> {
>  int i;
> 
>  i = 5;
>  foo(&i);
>  return i;
> }
> 
> Now, if the program returns anything else than 5, it means someone cast away
> const, which is generally considered a bad idea in most other software
> projects, for this very reason.

Not at all.

#include <stdio.h>
#include <stdlib.h>

char *lookup[5];

const char *get()
{
	*(*lookup = malloc(1)) = '1';
	return *lookup;
}

void set(const char *d, char val)
{
	for (int i = 0; i < 5; ++i)
		if (lookup[i] == d)
			*(lookup[i]) = val;
}

int main()
{
	const char *p = get();

	printf("%c\n", *p);
	set(p, '2');
	printf("%c\n", *p);

	return 0;
}

Do you see anything that casts the const away? No? Me neither. Still,
the memory that p points to was changed, because there was another
pointer and that was not const.

> *That* is the purpose of const pointers.

The only thing that const can tell you is that you should not modify the
value _yourself_, using that pointer _directly_. It's somewhat like a
soft "half" protected/private specifier. You may read this value, but if
you want to write to it, please use the setter function I provide for
you. Because that setter function might do some special stuff, like
counting how often that value was written.

And accepting a pointer to a const as an argument does _only_ say: It's
ok to call this function if you only received a pointer to a const, the
function does the Right Thing for such pointers. It does not guarantee
at all, that the function won't change the memory the pointer is
pointing to. Take a set of functions that manage memory for foo objects:

const struct foo *get(someIdentifier);
struct foo *makeWritable(const struct foo *);
void free(const struct foo *);

get() returns a pointer to a foo object, and it might return a pointer
to a _shared_ instance. Obviously it should make the pointer const, the
caller should not modify the shared instance.

makeWritable() accepts a pointer to a const foo, because you generally
want to pass it such a pointer to get a non-const one instead. The
function might just use ref-counting and see if it needs to create a
copy returning a pointer to points to a different location in memory or
if it can just return its _internal_ _non-const_ pointer. No casts!

free() also accepts a pointer to a const foo, because you obviously want
to be able to free the shared stuff, too. It just happens to not always
go away immediately, because there's some ref-counting going on. But you
are _still_ invalidating your const pointer. You lost all rights to
using it, because you _gave it up_ when you called free(). An important
part of free() is to _invalidate_ the _pointer_. Whether or not the
object it pointed to was modified or not doesn't matter at all, because
you have no valid means of accessing it _anyway_, it's totally out of
scope.

Now I can hear you screaming "But that's refcounting! That's totally
different!". It's _not_. Just "pretend" that get() cannot return the
same thing twice, then your ref-counting only goes up to one and boom,
you've just reinvented malloc/free, with a const pointer being passed to
free().

Passing a pointer to free invalidates that pointer, and all pointers
that share the same value. And then, when no valid ways to access the
object are left, free() is free to use the memory in any way it wants.
Without any stricht need to use the const pointer to perform any writes.
That might be an optimization, but you can do without.

What you're arguing about is actually that you don't want anyone to be
able to use a const pointer to invalidate any other pointer, not that
you don't want an object to be changed through a const pointer, because
that is simply not what happens.

If you want to restrict the set of pointers that can be invalidated by
an other pointer, you'll have to use something else because const does
not talk about invalidating aliasing pointers.

Björn
