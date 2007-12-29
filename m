Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXL2SWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXL2SWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXL2SWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:22:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52896 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXL2SWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:22:42 -0500
Date: Sat, 29 Dec 2007 19:22:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229182241.GA19919@uranus.ravnborg.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071229093904.GA17390@uranus.ravnborg.org> <20071229095253.GC27360@does.not.exist> <200712291316.07938.ak@suse.de> <20071229125412.GE27360@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071229125412.GE27360@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 02:54:13PM +0200, Adrian Bunk wrote:
> On Sat, Dec 29, 2007 at 01:16:07PM +0100, Andi Kleen wrote:
> > 
> > If -funit-at-a-time really increases stack size too much on some compiler
> > version the right fix would be to check where it does that using make checkstack
> > and then add "noinline" attributes there to prevent the compiler from inlining.
> > That would prevent them.
> > 
> > Globally disabling it is too big a hammer.
> > 
> > e.g. I know XFS did it in a similar way to prevent this problem.
> > 
> > So I would reenable it for now and if you know it causes problems on specific
> > compiler versions, Adrian, you could watch make checkstack there and submit
> > noinline patches as needed.
> 
> The main point is that we are _only_ talking about gcc 3.4 on i386 - for 
> more recent compilers we do not disable unit-at-a-time.

I took a second look and realized that Adrian is right about the disabling.
I had overlooked the 'no' part in -fno-unit-at-a-time.

So to try it out I build a gcc with crosstool:
gcc --version:
i686-unknown-linux-gnu-gcc (GCC) 3.4.5

This is the version that should exhibit the behaviour with increased text size.
Build two kernels - one without and one with -funit-at-a-time:

size output:
   text    data     bss     dec     hex filename
4878494  471580  610304 5960378  5af2ba o-i386/vmlinux
4955008  472934  614400 6042342  5c32e6 o-i386-no-funit-at-a-time/vmlinux

[Last line is with unit-at-a-time disabled as per the filename.]

With a i386 defconfig we see an *increase* in text size if we disable -funit-at-a-time.
That is we see the opposite of the expected.

Now the bug in gcc may have been fixed between 3.4 and 3.4.5 - I dunno.

So this simple test favour to always enable unit-at-a-time.

	Sam
