Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZLNRt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZLNRt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbZLNRtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:49:25 -0500
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:46638 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932265AbZLNRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:49:21 -0500
Message-ID: <4B267A9C.6010804@moving-picture.com>
Date: Mon, 14 Dec 2009 17:49:16 +0000
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: High load average on idle machine running 2.6.32
References: <4B1D8C5D.9040900@moving-picture.com> <4B2121E2.2030900@moving-picture.com>
In-Reply-To: <4B2121E2.2030900@moving-picture.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Pearson wrote:

>> I've booted a 64 bit 2.6.32 kernel on dual processor, quad core Xeon 
>> E5440 machine. The load average when the machine is idle varies 
>> between 2 and 3.
>>
>> When using a 2.6.31 kernel on the same machine, the load average when 
>> idle is nearly 0
>>
>> The kernel doesn't use modules - all that is needed is compiled in. 
>> The machine uses NFS-root
>>
>> Strangely, when I run 'iftop' (from 
>> http://www.ex-parrot.com/pdw/iftop/) using the 2.6.32 kernel, the load 
>> average drops to below 0.5  - stop running iftop, and the load average 
>> climbs again ...
>>
>> Any idea what might be causing this?
> 
> 
> It looks like whatever is causing this happened between 2.6.31-git7 and 
> 2.6.31-git8 - unfortunately I don't know how to find out what change 
> caused this ...
> 
> Also, if I 'hot-unplug' CPUs 1 to 7, the load average drops to 0 - when 
> I re-enable theses CPUs, the load average climbs.
> 
> I guess this is a problem with my particular config - or maybe because 
> I'm using NFS-root (the root file system is readonly), or using a 
> non-module kernel?

I gave 'git bisect' a go - which appears to suggest that my problem 
started at:

% git bisect bad
d7c33c4930f569caf6b2ece597432853c4151a45 is first bad commit
commit d7c33c4930f569caf6b2ece597432853c4151a45
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Sep 11 12:45:38 2009 +0200

     sched: Fix task affinity for select_task_rq_fair

     While merging select_task_rq_fair() and sched_balance_self() I made
     a mistake that leads to testing the wrong task affinty.

     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     LKML-Reference: <new-submission>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 3d7aa3e193c7faf9c7ebbb1443c6f63269d86d04 
9cfb647eb5d80f156fd8a495da68f765c3fdd772 M      kernel


However, while running the bisects, it became harder to decide what was 
a 'bad' and a 'good' idle load average - for example the kernel with the 
above patch gave an idle load average of about 1.5 - which is not as 
high as the idle load average seen with a 2.6.32 kernel and the kernel 
without this patch gave an idle load average of about 0.7 - which is not 
as low as the idle load average with a 2.6.31 kernel ...

So I guess, it is not just one patch that has caused the issue I'm 
seeing, which I guess is to be expected as the above patch was part of 
the 'scheduler updates for v2.6.32' patch set 
<http://marc.info/?l=linux-kernel&m=125322428306777&w=2>

I guess as no one else has reported this issue - it must be something to 
do with my set up - could using NFS-root affect how the load average is 
calculated?

Or, do I have something strange or missing in my kernel config that 
could cause this issue?

Thanks

James Pearson
