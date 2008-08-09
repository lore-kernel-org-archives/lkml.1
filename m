Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYHIW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYHIW7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYHIW7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:59:14 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:41939 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbYHIW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:59:13 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sun, 10 Aug 2008 00:59:10 +0200
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080809185224.GH13158@linux-os.sc.intel.com> <20080809193724.GJ13158@linux-os.sc.intel.com>
In-Reply-To: <20080809193724.GJ13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808100059.10729.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Suresh Siddha wrote:
> On Sat, Aug 09, 2008 at 11:52:24AM -0700, Siddha, Suresh B wrote:
> > Backing out lazy allocation is not just enough here. Let me think a little
> > more on this.
> 
> Can we have something like irq_ts_save() and irq_ts_restore(), which will
> do something like:
> 
> int irq_ts_save()
> {
> 	if (!in_interrupt())
> 		return 0;
> 
> 	if (read_cr0() & X86_CR0_TS) {
> 		clts();
> 		return 1;
> 	}
> 	return 0;
> }
> 
> void irq_ts_restore(int TS_state)
> {
> 	if (!in_interrupt())
> 		return 0;
> 
> 	if (TS_state)
> 		stts();
> }
> 
> and use this around padlock usage. Taking a spurious DNA fault in the 
process
> context(even inside the kernel) should be ok. Main issue is with the 
interrupt
> context and we can prevent the DNA fault in the irq context using above.
> 
> Either above, or we have to remove the lazy fpu allocation and make the
> below code in kernel_fpu_begin() atomic by disabling interrupts(to fix
> the security hole with padlock usage)
> 
> kernel_fpu_begin:
> 	...
> 
> 	local_irq_disable();
> 
>         if (me->status & TS_USEDFPU)
>                 __save_init_fpu(me->task);
>         else
>                 clts(); 
> 
> 	local_irq_enable();
> 	...
> 
> 

The first solution - if it works and padlock is the only which has problem 
with it - seems to be a good fix for 2.6.26. If it works I can't say as I'm 
not familiar enough with these things. But I'll happily test it :-).

The second would be a little bit intrusive, wouldn't it? Most machines don't 
have padlock, and therfore don't need this change but nevertheless may be 
affected (i.e. they use MMX for memcpy or MMX/SSE with raid6) and now get a 
different behaviour. Don't know how expensive such a local_irq_enable/disable 
would be.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
