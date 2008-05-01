Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbYEAWVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbYEAWVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYEAWVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:21:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbYEAWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:21:33 -0400
Date: Thu, 1 May 2008 15:20:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: venkatesh.pallipadi@intel.com, davem@davemloft.net,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-Id: <20080501152051.4eb4bad3.akpm@linux-foundation.org>
In-Reply-To: <20080501215633.GU29330@cs181133002.pp.htv.fi>
References: <20080430013108.GA18207@linux-os.sc.intel.com>
	<20080429.212833.192304794.davem@davemloft.net>
	<924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
	<20080501215633.GU29330@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 00:56:33 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Apr 30, 2008 at 05:49:46AM -0700, Pallipadi, Venkatesh wrote:
> >  
> > >-----Original Message----- From: David Miller 
> > >From: Venki Pallipadi <venkatesh.pallipadi@intel.com> Date: Tue, 29 
> > >Apr 2008 18:31:09 -0700
> > >
> > >> Some flavors of gcc 4.1.0 and 4.1.1 seems to have trouble 
> > >understanding
> > >> weak function definitions. Calls to function from the same 
> > >file where it is
> > >> defined as weak _may_ get inlined, even when there is a 
> > >non-weak definition of
> > >> the function elsewhere. I tried using attribute 'noinline' 
> > >which does not
> > >> seem to help either.
> > >> 
> > >> One workaround for this is to have weak functions defined in 
> > >different
> > >> file as below. Other possible way is to not use weak 
> > >functions and go back
> > >> to ifdef logic.
> > >> 
> > >> There are few other usages in kernel that seem to depend on 
> > >weak (and noinline)
> > >> working correctly, which can also potentially break and 
> > >needs such workarounds.
> > >> Example -
> > >> mach_reboot_fixups() in arch/x86/kernel/reboot.c is one such 
> > >call which
> > >> is getting inlined with a flavor of gcc 4.1.1.
> > >> 
> > >> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > >> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > >
> > >This sounds like a bug.  And if gcc does multi-file compilation it
> > >can in theory do the same mistake even if you move it to another
> > >file.
> > >
> > >We need something more bulletproof here.
> > >
> > 
> > The references here
> > http://gcc.gnu.org/ml/gcc-bugs/2006-05/msg02801.html
> > http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> > 
> > seem to suggest that the bug is only with weak definition in the same
> > file.
> > So, having them in a different file should be good enough workaround
> > here.
> >...
> 
> A workaround here is the wrong solution since this isn't the only place 
> that suffers from this issue.
> 
> We currently give a #warning for 4.1.0.
> But not for 4.1.1.
> (Accordingto the bug >= 4.1.2 is fixed.)
> 
> And a #warning is not enough.
> 
> The huge problem is that "empty __weak function in the same file and 
> non-weak arch function" has recently become a common pattern

Perhaps the commonest.  Certainly there will be more.

> with 
> several new usages added during this merge window alone.
> 
> And the breakages can be very subtle runtime breakages.
> 
> I see only the following choices:
> - remove __weak and replace all current usages
> - move all __weak functions into own files, and ensure that also happens
>   for future usages
> - #error for gcc 4.1.{0,1}

Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?

Yes, I guess we should ban 4.1.x.  Ouch.

