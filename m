Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYCWT6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYCWT6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYCWT6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:58:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:45778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbYCWT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MKaj0L/caQ0OlIOLxqGm3St/ZhnEGONvlOak6ueIzHUc0W4ZzlFnDsfgjuvK1yXNShfvWNQCB5rzU6gVBSGawkCSFc1HGebW3MHzquKH/yGWVdUuHZR5/woPMFv3mRDr6Aa3WT0PMwIEMXR8zzXL7+1DjYHPw+AuR4HQth9t1S0=
Date: Sun, 23 Mar 2008 20:57:48 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
Message-ID: <20080323195743.GA6028@joi>
References: <20080302185935.GA6100@joi> <1204485071.6240.56.camel@lappy> <20080302194748.GA6005@joi> <1204487917.6240.64.camel@lappy> <20080323154416.GA6817@joi> <1206287670.6437.113.camel@lappy> <20080323184427.GA6691@joi> <1206299168.6437.119.camel@lappy> <1206299341.6437.121.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206299341.6437.121.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 08:09:01PM +0100, Peter Zijlstra wrote:
> On Sun, 2008-03-23 at 20:06 +0100, Peter Zijlstra wrote:
> > On Sun, 2008-03-23 at 19:46 +0100, Marcin Slusarz wrote:
> > 
> > > 4 different lockups:
> > > http://alan.umcs.lublin.pl/~mslusarz/kernel/2008.03.23-lockup/ 
> > 
> > Brilliant, these are extremely helpful.
> > 
> > What seems to happen is a classic xtime deadlock, doing a xtime
> > seq_readlock while holding a seq_writelock.
> > 
> > Only need to figure out _why_ that is happening....
> 
> Does your machine boot with the following patch applied:

Yes :). 20 boots and no lockup (10 with nmi_watchdog=2 and
10 with nmi_watchdog=2 and netconsole).

> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 671af61..e300889 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -190,9 +190,6 @@ static void change_clocksource(void)
>  	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
>  
>  	tick_clock_notify();
> -
> -	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
> -	       clock->name);
>  }
>  #else
>  static inline void change_clocksource(void) { }
> 
> 
