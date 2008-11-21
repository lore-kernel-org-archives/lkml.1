Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYKUPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYKUPxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYKUPxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:53:35 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40975 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYKUPxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:53:34 -0500
Date: Fri, 21 Nov 2008 07:53:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc5] RCU detected CPU 0 stall (t=4294893165/750
	jiffies)
Message-ID: <20081121155333.GB6775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081119123717.GE24427@vanheusden.com> <49267FA4.60609@cn.fujitsu.com> <20081121094543.GP24427@vanheusden.com> <20081121151205.GA6775@linux.vnet.ibm.com> <20081121153425.GR24427@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121153425.GR24427@vanheusden.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 04:34:26PM +0100, Folkert van Heusden wrote:
> > > I'm afraid there's no script for that: it happens during boot.
> > 
> > This is a HZ=250 machine, correct?  If so, please try the following
> > patch (already in -tip), which helps suppress boot-time false positives.
> 
> That's correct, 250Hz.
> 
> > diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> > index 5f89b62..301dda8 100644
> > --- a/include/linux/rcuclassic.h
> > +++ b/include/linux/rcuclassic.h
> > @@ -41,7 +41,7 @@
> >  #include <linux/seqlock.h>
> >  
> >  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> > -#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
> > +#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */
> 
> Isn't it better to let the define depend on the value of CONFIG_HZ?
> E.g.
> 
> Signed-off-by: Folkert van Heusden <folkert@vanheusden.com>
> 
> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 5f89b62..301dda8 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -41,7 +41,7 @@
>  #include <linux/seqlock.h>
> 
>  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> -#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
> +#define RCU_SECONDS_TILL_STALL_CHECK	( (CONFIG_HZ / 100) * 3 * HZ) /* for rcp->jiffies_stall */
>  #define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
>  #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */

The stalls occur when CPUs spin in the kernel with preemption (or irqs
or whatever) disabled.  So while I suppose that there is some
possibility that such a spin might be a function of HZ, I have never
seen this happen.

The reason I asked for your HZ value was to make sure that the stall
detection was 3 seconds (750 jiffies).  If you had been running a
75HZ system (admittedly unlikely) you would have seen a 10-second stall,
and the patch would not help.  In that case, the right thing to do would
have been to work out why the system was spinning for 10 seconds during
boot -- tough to get a 5-second boot when the system spins for 10
seconds coming up, right?  ;-)

							Thanx, Paul

> Folkert van Heusden
> 
> -- 
> MultiTail na wan makriki wrokosani fu tan luku den logfile nanga san
> den commando spiti puru. Piki puru spesrutu sani, wroko nanga difrenti
> kroru, tya kon makandra, nanga wan lo moro.
> http://www.vanheusden.com/multitail/
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
