Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbYBBLpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbYBBLpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbYBBLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:45:34 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:45678 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754192AbYBBLpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:45:33 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-164.messagelabs.com!1201952731!8162794!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Sat, 2 Feb 2008 12:45:27 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: rcu_process_callbacks pending in tick_nohz_stop_sched_tick (Was: NOHZ: local_softirq_pending 20)
Message-ID: <20080202114527.GA8734@digi.com>
References: <20071123112442.GA12047@bre-cln-ukleine.digi.com> <alpine.LFD.0.9999.0711231323490.26417@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.9999.0711231323490.26417@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 Feb 2008 11:45:28.0076 (UTC) FILETIME=[1B2E94C0:01C86591]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15704.003
X-TM-AS-Result: No--10.590500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Gleixner wrote:
> On Fri, 23 Nov 2007, Uwe Kleine-König wrote:
> > my kernel reported:
> > 
> > 	NOHZ: local_softirq_pending 20
> 
> Thats TASKLET_SOFTIRQ
>  
> > I cannot interpret it, but probably this is bad, because before
> > bc5393a6c9c0e70b4b43fb2fb63e3315e9a15c8f this used to BUG().
> 
> We removed the BUG, because it's a situation where the kernel can
> easily recover. It should never happen that the kernel goes to sleep
> with a pending softirq, but it's not a fatal error.
> 
> > This happend while having a high load.  Up to now it only happend once
> > and I cannot reproduce it.
> 
> That's hard to tell then. Without a reproducible test case I can not
> do much to help debugging this.
Back then I added some debug code to tick_nohz_stop_sched_tick to get
some more information when this happens again.  As this happened just
now I saw:

	- tick_nohz_stop_sched_tick was called from irq_exit
	  Actually this didn't surprise me, because
	  tick_nohz_stop_sched_tick is only called at two places, namely
	  irq_exit and cpu_idle.  And I cannot see how
	  local_softirq_pending() != 0 can happen in the latter (without
	  first happening in irq_exit maybe).

	- it happened three times in a row at the following times:

		[ 1593.470000] NOHZ: (c003a3ac) local_softirq_pending 20
		[ 1593.470000] Tasklet state=1, func=c0046248, data=0
		[ 1593.920000] NOHZ: (c003a3ac) local_softirq_pending 20
		[ 1593.920000] Tasklet state=1, func=c0046248, data=0
		[ 1594.980000] NOHZ: (c003a3ac) local_softirq_pending 20
		[ 1594.980000] Tasklet state=1, func=c0046248, data=0

	  (c003a3ac = irq_exit+0x24/0x94)

	- There was a single tasklet in __get_cpu_var(tasklet_vec).list:

	  	state = 1
		func = rcu_process_callbacks (= c0046248)
		data = 0

	- directly afterwards the oom-killer started killing tasks

I think the only user of rcu in my kernel is networking code.  Does this
help anyone to further debug my problem here?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
