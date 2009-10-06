Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbZJFNPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbZJFNPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbZJFNPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:15:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:37241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbZJFNPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:15:35 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [bisected] commit: a9327cac440be4d8333bba975cbbf76045096275 causes   iostat output
Date: Tue, 6 Oct 2009 18:44:01 +0530
User-Agent: KMail/1.12.0 (Linux/2.6.32-rc3-0.1-default; KDE/4.3.0; x86_64; ; )
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
References: <4e5e476b0910040349l21b69a97o7a11b2138bc8f573@mail.gmail.com> <20091004190653.GH26573@kernel.dk>
In-Reply-To: <20091004190653.GH26573@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910061844.01499.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009 00:36:53 Jens Axboe wrote:
> On Sun, Oct 04 2009, Corrado Zoccolo wrote:
> > Hi,
> > with 2.6.32-rc1 I started getting the following strange output from
> > "iostat -kx 2":
> > Linux 2.6.31bisect (et2) 	04/10/2009 	_i686_	(2 CPU)
> >
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >           10,70    0,00    3,16   15,75    0,00   70,38
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await  svctm  %util
> > sda              18,22     0,00    0,67    0,01    14,77     0,02
> > 43,94     0,01   10,53 39043915,03 2629219,87
> > sdb              60,89     9,68   50,79    3,04  1724,43    50,52
> > 65,95     0,70   13,06 488437,47 2629219,87
> >
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >            2,72    0,00    0,74    0,00    0,00   96,53
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await  svctm  %util
> > sda               0,00     0,00    0,00    0,00     0,00     0,00
> > 0,00     0,00    0,00   0,00 100,00
> > sdb               0,00     0,00    0,00    0,00     0,00     0,00
> > 0,00     0,00    0,00   0,00 100,00
> >
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >            6,68    0,00    0,99    0,00    0,00   92,33
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await  svctm  %util
> > sda               0,00     0,00    0,00    0,00     0,00     0,00
> > 0,00     0,00    0,00   0,00 100,00
> > sdb               0,00     0,00    0,00    0,00     0,00     0,00
> > 0,00     0,00    0,00   0,00 100,00
> >
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >            4,40    0,00    0,73    1,47    0,00   93,40
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await  svctm  %util
> > sda               0,00     0,00    0,00    0,00     0,00     0,00
> > 0,00     0,00    0,00   0,00 100,00
> > sdb               0,00     4,00    0,00    3,00     0,00    28,00
> > 18,67     0,06   19,50 333,33 100,00
> >
> > Global values for service time and utilization are garbage. For
> > interval values, utilization is always 100%, and service time is
> > higher than normal.
> >
> > I bisected it down to:
> > [a9327cac440be4d8333bba975cbbf76045096275] Seperate read and write
> > statistics of in_flight requests
> > and verified that reverting just that commit indeed solves the issue
> > on 2.6.32-rc1.
>

Thanks for reporting.

> I've reverted this commit since the next -rc is close, then we can debug
> and potentially re-introduce this change after that. Thanks a lot for
> reporting and bisecting it, too!

Sorry. I missed converting to 2 seperate variables at 

@@ -1030,7 +1030,7 @@ static void part_round_stats_single(int cpu, struct 
hd_struct *part,
 	if (now == part->stamp)
 		return;
 
-	if (part->in_flight) {
+	if (part_in_flight(part)) {
 		__part_stat_add(cpu, part, time_in_queue,
 				part_in_flight(part) * (now - part->stamp));
 		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));

which caused this regression. I would post the patch with this fix included.

Thanks
Nikanth
