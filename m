Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbYDDBUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbYDDBUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYDDBT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:19:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41616 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYDDBT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:19:56 -0400
Date: Fri, 4 Apr 2008 02:19:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Triplett <josh@freedesktop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080404011951.GC9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403024117.GZ9785@ZenIV.linux.org.uk> <47F53E84.8080607@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F53E84.8080607@freedesktop.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 01:31:00PM -0700, Josh Triplett wrote:
> I mostly kept up with Sparse email, hence the recent mails, but built
> up a backlog of patches to deal with.  (Sparse has a fairly low patch
> rate, so that backlog constitutes less than 10 patches, counting the
> ones that still need further work or discussion before they can
> merge.)  Also, in switching my email to an IMAP server, I managed to
> lose the read/unread status on some of my list mail, including
> linux-sparse, which slowed me down a fair bit when trying to process
> those mails.
> 
> I have a small handful of pending patches to work through on
> linux-sparse, with yours at the top of that list; I also have some
> local patches that I need to test and push.  Apologies for the
> processing delay.
> 
> I should have thought to send a "still alive" note with an explanation
> to linux-sparse.  I'll make sure to do so in the future.  (Some time
> in the next couple of years I have a thesis to write. :) )
> 
> I'll catch the backlog up and then send out an "all patches merged"
> mail, so that anyone with additional patches or anyone who thinks
> their patch got lost can resend.

OK...  FWIW, I'll probably do relaxed integer constant expressions on
top of whatever shows up in your tree + patches I've sent to the list
at some point in the next couple of weeks.  For now I'd say that we
can keep ignoring the errors from _IO...() uses in context that expect
an i-c-e (mostly - indices in array initializers); it's not widespread
and we'd lived with that for quite a while.

As far as annoyances go, lack of VLA support is responsible for far more
lost warnings.  I don't have anything in that direction beyond rather
vague plans (*and* a monstrous backlog of my own, both kernel-side and
sparse-side, so it's unlikely to drift up the list in the next couple
of months).  Does anybody have any pending work in that direction?  It's
not _that_ hard to do, but for pity sake, go with C99 standard when doing
it; gcc is choke-full of broken and barely documented extensions in that
area, so reverse-engineering them is going to result in utter mess.

C99 VLAs are fairly dumb and straightforward - the underlying idea is
"for each variable of type that involves a VLA, compiler should be able
to slap a shadow variable containing the array size in scope nearby".
Thus
	* no variably-modified members in structs or unions (not only
no VLA, but no pointers to VLA, etc.); we would need shadow variables
for each struct instance and that obviously wouldn't work in that model).
	* no functions returning variably-modified type.
	* no variably-modified objects in global scope.
	* no VLA static in function.
	* typedef *can* be variably-modified, but only in block scope.
Warning: this can get sticky for us - all sizes are evaluated when
typedef is reached.  IOW,
	typedef int a[n];
	a x;
	if (n++ == 5) {
		a y;
		int z[n];
	}
will have size of y equal to that of x, but *not* equal to that of z.
	* do *NOT* jump inside the scope of anything variably modified;
not with goto, not with switch (again, you'll miss initialization of
shadows).

Passing a VLA (let alone pointer to such, etc.) to a function is done
exactly as we would for normal arrays; $DEITY help you if the function's
idea of sizes doesn't match that of caller - shadow stuff is _NOT_ passed
at all.  No match => undefined behaviour.

Mixing VLA with normal arrays: compatible if the elements are compatible,
but if you have actual sizes that do not match, you are in nasal daemon
country.  So composite type of two VLA ones is *either*, and if actual
sizes differ, well, too bad for you.

Basically, everything works as if you had SYM_VLA(element, symbol) that
behaved almost as SYM_ARRAY.  With initializers for symbols created at
the point where we declare the object in question (or type, in case of
typedef).  Passing such sucker to function converts to SYM_VLA with *new*
symbol - one in function scope and initialized there.  Note that this
is where the things get extremely ugly for gcc - there you can pass
an object out of its scope and _that_ is what leads to lovely internal
compiler errors for things like
	sizeof *({int n = f(); int a[n]; &a;})
since we get shadow symbol dead and gone with the scope while the type
(SYM_PTR(SYM_VLA(int, n)) outlives the scope, leaving a landmine for
sizeof.

Another thing to keep in mind is that sizeof(VLA) is not a constant
expression *and* that sizeof argument is evaluated.  IOW, not only
	sizeof(int [n = f()])
has side effects, but in
	int (*p)[n];
	...
	sizeof(*(g(), p))
will have g() evaluated.  Note that if p had been declared as
	int (*p)[4];
the same sizeof() would *NOT* have called anything.  This, BTW, is where
the rules for what an integer constant expression is are getting bloody
important: 

int n = 1;
int f(void)
{
	int (*p)[1 + (0 && n)];
	return sizeof(*(g(), p));
}

_must_ call g() according to C99, while the same with
enum {n = 1;} must not, even though n won't be even looked at in either
case *and* any sane compiler will find return value of f() at compile
time, turning it to
inf f(void)
{
	g();
	return sizeof(int);
}
in the first case and
int f(void)
{
	return sizeof(int);
}
in the second.

One more thing: use of sizeof(variably-modified type) may or may not
evaluate size expressions in there if they do not affect the result.
IOW, it's unspecified whether
	sizeof(int (*)[n++])
increments n; different compilers are broken in different ways and it
might be worth generating a warning on such.  Note that
	sizeof(int [n++])
*is* guaranteed to increment n - the unspecified part is for size expressions
in such sizeof(type) buried behind a pointer.
