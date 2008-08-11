Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbYHKUVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbYHKUVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYHKUTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:19:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:3614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbYHKUTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:19:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,190,1217833200"; 
   d="scan'208";a="32479371"
Date: Mon, 11 Aug 2008 13:19:01 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Message-ID: <20080811201901.GN13158@linux-os.sc.intel.com>
References: <20080808231121.GA13158@linux-os.sc.intel.com> <20080809143727.GA30499@gondor.apana.org.au> <200808091757.32999.wolfgang.walter@stwm.de> <489DC15D.9070308@zytor.com> <20080809185224.GH13158@linux-os.sc.intel.com> <20080809193724.GJ13158@linux-os.sc.intel.com> <20080810030521.GA2332@gondor.apana.org.au> <20080811190131.GL13158@linux-os.sc.intel.com> <20080811192203.GC12788@elte.hu> <48A0920B.30306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A0920B.30306@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 12:24:59PM -0700, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >
> >> Reported-and-bisected-by: Wolfgang Walter <wolfgang.walter@stwm.de>
> >> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >
> > no fundamental objection to the x86 bits.
> >
> > shouldnt this:
> >
> > +       if (!in_interrupt())
> > +               return 0;
> >
> > just be eliminated and the cr0/TS save/restore be made unconditional?
> > irq-assymetric APIs are not nice in general.
> >
> > Reading/setting cr0 isnt _that_ slow. (or if it is, by how much does it
> > slow things down, exactly?)
> >
> 
> Setting it is relatively slow.  I think that's part of the reason for
> special instructions to muck with the TS flag.
> 
> Reading it might be slow on obsolete processors.

In addition to the slowness(Wolf has collected some data with earlier
patch and I think it showed a double digit increase in cpu utilization with
some crypt tests):

we can't unconditionally do clts() in the process context. We have
to disable pre-emption to avoid interactions with context switch and
lazy restore. So there will be RT latency issues aswell.

thanks,
suresh
