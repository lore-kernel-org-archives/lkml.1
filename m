Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYDRB0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYDRB0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 21:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYDRB0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 21:26:15 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:35361 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYDRB0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 21:26:15 -0400
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Fabio Checconi <fchecconi@gmail.com>
Date: Fri, 18 Apr 2008 11:26:00 +1000
Message-ID: <4807F8A8.4090605@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       paolo.valente@unimore.it
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080415082236.GD12774@kernel.dk>
In-Reply-To: <20080415082236.GD12774@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Apr 01 2008, Fabio Checconi wrote:
>> [sorry for reposting, wrong subject]
>>
>> Hi,
>>     we are working to a new I/O scheduler based on CFQ, aiming at
>> improved predictability and fairness of the service, while maintaining
>> the high throughput it already provides.

Here are some microbenchmark results.  Test setup is a 2-way IA64 with a
single 15k RPM 73GiB SCSI disk with TCQ depth set to 1.  Workloads are
generated with FIO: 128 processes issuing synchronous, O_DIRECT, 16KiB
block size requests.

Figures are quoted as average (stdev).  CFQ (i=0) means idle window
disabled.  All other tunables are default.

==================================x8=======================================

                Random Readers
-----------------------------------------------
           Latency (ms)       Bandwidth (KiB/s)
-----------------------------------------------
CFQ        841.788 (4070.3)   2428.032 (23.1)
CFQ (i=0)  536.728 (216.9)    3841.024 (8.5)
BFQ        884.4 (8816.0)     2439.04 (1375.0)


            Sequential 1MiB Readers
-----------------------------------------------
           Latency (ms)       Bandwidth (KiB/s)
-----------------------------------------------
CFQ        2865.331 (737.2)   46866.048 (103.1)
CFQ (i=0)  2544.618 (1047.2)  52685.952 (294.2)
BFQ        2860.795 (419.1)   46850.944 (81.5)


Clearly BFQ suffers from the same idle window problems as CFQ, but otherwise
the performance seems comparable in bandwidth terms.  I'm guessing variability
in random workload service is due to max budget being too large compared to
CFQ's default time-slice.  Sequential access looks nice and consistent, though.

