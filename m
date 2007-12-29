Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXL2Vpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXL2Vpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 16:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXL2Vp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 16:45:27 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42082 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXL2Vp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 16:45:26 -0500
Date: Sat, 29 Dec 2007 23:45:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229214522.GG27360@does.not.exist>
References: <20071228212341.GA6939@uranus.ravnborg.org> <200712291924.52077.ak@suse.de> <20071229185842.GA20099@uranus.ravnborg.org> <200712292217.37474.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712292217.37474.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 10:17:37PM +0100, Andi Kleen wrote:
> 
> > Until we are on par with stack usage I recommend to keep
> > -fno-unit-at-a-time disabled for gcc less than 4.00 as
> > suggested by Adrian (as is what we have today).
> 
> Again the correct fix is to add "noinline" to the functions that are getting
> inlined here in 3.4 but not 4+.

The problem isn't that gcc 3.4 and gcc 4.x inlined different functions, 
the problem is that with gcc 3.4 the stack usage was higher.

AFAIR, the problem was roughly something like:

<--  snip  -->

static void foo(void)
{
...
}

static void bar(void)
{
...
}

void foobar(void)
{
	foo();
	bar();
}

<--  snip  -->

Without inlining the maxmimum stack usage inside foobar() is
max(stack usage foo(), stack usage bar()). [1]

With foo() and bar() inlined (-funit-at-a-time also enables 
-finline-functions-called-once), the maxmimum stack usage inside 
foobar() is sum(stack usage foo(), stack usage bar()). And this
worst case is the area where gcc 4 is much better than gcc 3.4.

We have cases in the kernel were a switch handles a dozen cases
(e.g. ioctl handling) and each results in a call to a different static 
function.

> -Andi

cu
Adrian

[1] this ignores function call stack usages, but these are low compared 
    to the interesting ones

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

