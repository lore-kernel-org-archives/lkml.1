Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbXCYLAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbXCYLAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXCYLAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:00:24 -0400
Received: from www.osadl.org ([213.239.205.134]:33901 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738AbXCYLAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:00:23 -0400
Subject: Re: [PATCH] Avoid time_offset overflows
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070325010903.a0e6e624.akpm@linux-foundation.org>
References: <1174696834.5690.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703240153220.14457@scrub.home>
	 <20070325010903.a0e6e624.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 13:07:52 +0200
Message-Id: <1174820872.10840.494.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 01:09 -0800, Andrew Morton wrote:
> On Sat, 24 Mar 2007 06:20:45 +0100 (CET) Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > Hi,
> > 
> > On Fri, 23 Mar 2007, john stultz wrote:
> > 
> > > @@ -314,8 +314,8 @@ #endif
> > >  		    freq_adj += time_freq;
> > >  		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
> > >  		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
> > > -		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
> > > -		    			<< SHIFT_UPDATE;
> > > +		    do_div(time_offset, NTP_INTERVAL_FREQ);
> > > +		    time_offset <<= SHIFT_UPDATE;
> > >  		} /* STA_PLL */
> > >  	    } /* txc->modes & ADJ_OFFSET */
> > >  	    if (txc->modes & ADJ_TICK)
> > 
> > This is wrong, time_offset is signed and do_div is unsigned.
> > In general I planned to do the same change, but the do_div API could use a 
> > little cleanup to provide some clear function for signed/unsigned divide 
> > (hopefully with a better name than div_long_long_rem_signed or 
> > do_div_llr).
> > 
> 
> Can we do a minimal thing for 2.6.21, worry about API beautification later?

Here you go. It's ugly, but it should do the trick for now.

	tglx

Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -196,7 +196,7 @@ void __attribute__ ((weak)) notify_arch_
  */
 int do_adjtimex(struct timex *txc)
 {
-	long mtemp, save_adjust;
+	long mtemp, save_adjust, rem;
 	s64 freq_adj, temp64;
 	int result;
 
@@ -314,7 +314,9 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    do_div(time_offset, NTP_INTERVAL_FREQ);
+		    time_offset = div_long_long_rem_signed(time_offset,
+							   NTP_INTERVAL_FREQ,
+							   &rem);
 		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */


