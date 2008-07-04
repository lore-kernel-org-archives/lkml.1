Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYGDWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYGDWBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYGDWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:01:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbYGDWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:01:08 -0400
Date: Fri, 4 Jul 2008 15:01:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Anvin <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: the printk problem
Message-Id: <20080704150100.1f7b8a65.akpm@linux-foundation.org>
In-Reply-To: <20080704204252.GM14894@parisc-linux.org>
References: <20080625131101.GA6205@digi.com>
	<20080704104634.GA31634@digi.com>
	<20080704111540.ddffd241.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0807041147450.2815@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807041250220.2815@woody.linux-foundation.org>
	<20080704132716.f1e12554.akpm@linux-foundation.org>
	<20080704204252.GM14894@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(heck, let's cc lkml - avoid having to go through all this again)

On Fri, 4 Jul 2008 14:42:53 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Jul 04, 2008 at 01:27:16PM -0700, Andrew Morton wrote:
> > On Fri, 4 Jul 2008 13:02:05 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > > so I think we could easily just say that we extend %p in various ways:
> > > > 
> > > >  - %pS - print pointer as a symbol
> > > > 
> > > > and leave tons of room for future extensions for different kinds of 
> > > > pointers. 
> > 
> > If this takes off we might want a register-your-printk-handler
> > interface.  Maybe.
> > 
> > We also jump through hoops to print things like sector_t and
> > resource_size_t.  They always need to be cast to `unsiged long long',
> > which generates additional stack space and text in some setups.
> 
> The thing is that GCC checks types.  So it's fine to add "print this
> pointer specially", but you can't in general add new printf arguments
> without also hacking GCC.  Unless you use -Wno-format, and require
> sparse to check special kernel types.

It would be excellent if gcc had an extension system so that you could
add new printf control chars and maybe even tell gcc how to check them.
But of course, if that were to happen, we couldn't use it for 4-5 years.

What I had initially proposed was to abuse %S, which takes a wchar_t*. 
gcc accepts `unsigned long *' for %S.

Then, we put the kernel-specific control char after the S, so we can
print an inode (rofl) with

	struct inode *inode;

	printk("here is an inode: %Si\n", (unsigned long *)inode);

Downsides are:

- there's a cast, so you could accidentally do

	printk("here is an inode: %Si\n", (unsigned long *)dentry);

- there's a cast, and they're ugly

- gcc cannot of course check that the arg matches the control string

Unfortunately (and this seems weird), gcc printf checking will not
accept a void* for %S: it _has_ to be wchar_t*, and the checker won't
permit void* substitution for that.

Anyway, Linus took all that and said "let's abuse %p instead".  It
_will_ accept any pointer so we can instead do:

	printk("here is an inode: %pi\n", inode);

which is nicer.


I think the main customers of this are print_symbol():

	printk("I am about to call %ps\n", fn);
	(*fn)();

and NIPQUAD and its ipv6 version.

We don't know how much interest there would be in churning NIPQUAD from
the net guys.  Interestingly, there's also %C (wint_t) which is a
32-bit quantity.  So we could just go and say "%C prints an ipv4
address" and be done with it.  But there's no way of doing that for
ipv6 addresses so things would become asymmetrical there.

Another customer is net mac addresses.  There are surely others.  One
which should have been in printf 30 years ago was %b: binary.


> > And then there's the perennial "need to cast u64 to unsigned long long
> > to print it".  If we were to do
> > 
> > 	printk("%SL", (void *)some_u64);
> > 
> > then that's still bloody ugly, but it'll save a little text-n-stack.
> 
> u64 is easy to fix, and I don't know why we haven't.  Just make it
> unsigned long long on all architectures.

Yeah.  Why don't we do that?
