Return-Path: <linux-kernel-owner+w=401wt.eu-S1765056AbYEAV5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765056AbYEAV5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbYEAV5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:57:23 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57600 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761216AbYEAV5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:57:22 -0400
Date: Fri, 2 May 2008 00:56:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: David Miller <davem@davemloft.net>, trini@kernel.crashing.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501215633.GU29330@cs181133002.pp.htv.fi>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 05:49:46AM -0700, Pallipadi, Venkatesh wrote:
>  
> >-----Original Message----- From: David Miller 
> >From: Venki Pallipadi <venkatesh.pallipadi@intel.com> Date: Tue, 29 
> >Apr 2008 18:31:09 -0700
> >
> >> Some flavors of gcc 4.1.0 and 4.1.1 seems to have trouble 
> >understanding
> >> weak function definitions. Calls to function from the same 
> >file where it is
> >> defined as weak _may_ get inlined, even when there is a 
> >non-weak definition of
> >> the function elsewhere. I tried using attribute 'noinline' 
> >which does not
> >> seem to help either.
> >> 
> >> One workaround for this is to have weak functions defined in 
> >different
> >> file as below. Other possible way is to not use weak 
> >functions and go back
> >> to ifdef logic.
> >> 
> >> There are few other usages in kernel that seem to depend on 
> >weak (and noinline)
> >> working correctly, which can also potentially break and 
> >needs such workarounds.
> >> Example -
> >> mach_reboot_fixups() in arch/x86/kernel/reboot.c is one such 
> >call which
> >> is getting inlined with a flavor of gcc 4.1.1.
> >> 
> >> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >
> >This sounds like a bug.  And if gcc does multi-file compilation it
> >can in theory do the same mistake even if you move it to another
> >file.
> >
> >We need something more bulletproof here.
> >
> 
> The references here
> http://gcc.gnu.org/ml/gcc-bugs/2006-05/msg02801.html
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> 
> seem to suggest that the bug is only with weak definition in the same
> file.
> So, having them in a different file should be good enough workaround
> here.
>...

A workaround here is the wrong solution since this isn't the only place 
that suffers from this issue.

We currently give a #warning for 4.1.0.
But not for 4.1.1.
(Accordingto the bug >= 4.1.2 is fixed.)

And a #warning is not enough.

The huge problem is that "empty __weak function in the same file and 
non-weak arch function" has recently become a common pattern with 
several new usages added during this merge window alone.

And the breakages can be very subtle runtime breakages.

I see only the following choices:
- remove __weak and replace all current usages
- move all __weak functions into own files, and ensure that also happens
  for future usages
- #error for gcc 4.1.{0,1}

> Thanks,
> Venki

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

