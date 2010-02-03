Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0BCXpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:45:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:62675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779Ab0BCXpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:45:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,401,1262592000"; 
   d="scan'208";a="489487381"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: Roland McGrath <roland@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Date: Wed, 3 Feb 2010 15:45:12 -0800
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Topic: [patch] x86: ptrace and core-dump extensions for xstate
Thread-Index: AcqlKdurKGg2ELO3TsiffO3nRPC3rgAAFHwA
Message-ID: <8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
 <20100203230817.E6529AA@magilla.sf.frob.com>
In-Reply-To: <20100203230817.E6529AA@magilla.sf.frob.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +	case PTRACE_GETXSTATEREGS:	/* Get the child extended state. */
> > +		return copy_regset_to_user(child,
> > +					   task_user_regset_view(current),
> > +					   REGSET_XSTATE,
> > +					   0, xstate_size,
> > +					   datap);
> > +
> > +	case PTRACE_SETXSTATEREGS:	/* Set the child extended state. */
> > +		return copy_regset_from_user(child,
> > +					     task_user_regset_view(current),
> > +					     REGSET_XSTATE,
> > +					     0, xstate_size,
> > +					     datap);
> 
> I think this is a poor choice of interface for this.  The other existing
> PTRACE_GET*REGS calls use a fixed-size and fixed-layout block that is a
> known constant in the userland ABI.  Here, userland has no way to know
> xstate_size, so you are accessing a chunk of user memory where userland
> doesn't really know how much you are going to access.
> 
> AFAICT from skimming the Intel manuals, there is no specified upper bound
> on how big the xsave size might grow in future processors.  I would think
> that it might be limited to a page, since there is no way to indicate a
> partial copy to restart after a page fault.  So for unpinned access (such
> as in user mode, or the user memory access in the signal frame setup), in
> full-thrashing situations an xsave spanning multiple pages might thrash
> totally and never make progress.  OTOH, the manual does not say that the
> buffer can't span two pages today, just that it has to be 64-byte aligned.
> So perhaps we already have that issue (for signal frame setup or for direct
> user-space uses of xsave/xrstor) and it's just not really an issue that
> matters (thrashing is thrashing--it's already pathological, so who cares if
> it's literal livelock or not).  The upshot being, I don't think there is an
> obvious upper bound that userland can presume statically here.
> 
> AFAICT, the only way for userland to guess xstate_size is to use cpuid
> itself.  Even if that is actually reliable, or even if the kernel gave
> userland some other means to know the kernel's xstate_size value, IMHO that
> is a pretty dubious and error-prone way to construct the ABI.  Usually when
> userland supplies a buffer whose size is not a permanent constant of the
> ABI, userland says how big a buffer it's passing in.
> 

Gdb calls cpuid during startup time to find out the actual xstate_size
on the target machine. It has to be reliable. There is no need for
another ptrace option. But we should document it clearly in ABI.


H.J.
