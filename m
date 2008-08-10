Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYHJDFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYHJDFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 23:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYHJDFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 23:05:36 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42128 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753455AbYHJDFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 23:05:36 -0400
Date: Sun, 10 Aug 2008 11:05:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080810030521.GA2332@gondor.apana.org.au>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809143727.GA30499@gondor.apana.org.au> <200808091757.32999.wolfgang.walter@stwm.de> <489DC15D.9070308@zytor.com> <20080809185224.GH13158@linux-os.sc.intel.com> <20080809193724.GJ13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809193724.GJ13158@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 12:37:24PM -0700, Suresh Siddha wrote:
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

This check isn't necessary.

> 
> 	if (TS_state)
> 		stts();
> }

But yes this scheme looks good to me.

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

Couldn't we just move clts before the USEDFPU check? That huld
close the window.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
