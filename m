Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZJGHxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZJGHxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZJGHxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:53:16 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30773 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZJGHxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:53:15 -0400
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: ext Steven Noonan <steven@uplinklabs.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <1254814298.31336.63.camel@eenurkka-desktop>
	 <f488382f0910060322y12e2e7dbm9a1372e481c9013f@mail.gmail.com>
	 <1254825795.31336.204.camel@eenurkka-desktop>
	 <f488382f0910060422t420ade8bvdefbf3e3d0720266@mail.gmail.com>
	 <1254832609.31336.290.camel@eenurkka-desktop>
	 <f488382f0910061754g6d15cf58v572e85701fc5aa4f@mail.gmail.com>
	 <f488382f0910061822wf8da0c1m7f118f04fe793abe@mail.gmail.com>
	 <1254893230.30157.28.camel@eenurkka-desktop>
	 <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
Content-Type: text/plain
Organization: Nokia
Date: Wed, 07 Oct 2009 10:49:38 +0300
Message-Id: <1254901778.30157.62.camel@eenurkka-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2009 07:50:46.0654 (UTC) FILETIME=[E138D9E0:01CA4722]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 09:30 +0200, ext Steven Noonan wrote:
> 
> Okay, wow, I'm a moron. I misread what cpu_idle() was intended to be
> for. I thought that cpu_idle() was a function that was periodically
> called whenever the CPU had nothing to do, but now I see that it's
> actually the main loop. I should really read the code next time.
> 
> I've moved the statistics printout code to the _inside_ of that
> infinite loop and retested. I had it print every several hundred
> iterations. Here's the results (note the machine was idle the whole
> time, except for about the first 10-20 seconds while the machine
> booted):
> 
> [    3.627716] timings[0]: 2250511125 / 3627716116
> [    6.946216] timings[0]: 4780901366 / 6946213531
> [   13.355182] timings[0]: 9385417604 / 13355183525
> [   18.551304] timings[1]: 16300853077 / 18551301189
> [   21.589039] timings[0]: 15984495433 / 21589037480
> [   47.152733] timings[1]: 44386121538 / 47152731476
> [   51.682630] timings[0]: 45713834076 / 51682628295
> [   79.587359] timings[0]: 73524821916 / 79587356820
> [   88.630110] timings[1]: 85324277596 / 88630109605
> [   96.082386] timings[0]: 89691306072 / 96082384539
> 

Those look good.

Well, might as well then go for:
/drivers/cpufreq/cpufreq_conservative.c
dbs_check_cpu() ->
load = 100 * (wall_time - idle_time) / wall_time; <- What is your load?

Let assume load is sane, look for (in dbs_check_cpu())
	if (load < (dbs_tuners_ins.down_threshold - 10)) {

whether it is taken ever...if not, what is your
(dbs_tuners_ins.down_threshold - 10) ?

- Eero

