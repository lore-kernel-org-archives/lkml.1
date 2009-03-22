Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZCVQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZCVQx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 12:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZCVQxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 12:53:35 -0400
Received: from exc03vs1.exchange.cysonet.com ([85.158.200.86]:49912 "EHLO
	exc03vs1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbZCVQxd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 12:53:33 -0400
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Sun, 22 Mar 2009 17:53:29 +0100
Subject: RE: Page Cache writeback too slow,   SSD/noop scheduler/ext2
From: Jos Houtman <jos@hyves.nl>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <C5EC2B99.C3B3%jos@hyves.nl>
Thread-Topic: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Thread-Index: AcmqFCDvW3l49C3aQ26ES049hanvLQAVbQk1ACk5J3Q=
In-Reply-To: <C5EB16F4.C318%jos@hyves.nl>
X-Priority: 10
Mime-version: 1.0
Content-type: text/plain;
	charset="ISO-8859-1"
Content-transfer-encoding: 8BIT
X-OriginalArrivalTime: 22 Mar 2009 16:53:29.0645 (UTC) FILETIME=[BA12B5D0:01C9AB0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/09 11:53 AM, "Andrew Morton" <akpm@linux-foundation.org> wrote:

> On Fri, 20 Mar 2009 19:26:06 +0100 Jos Houtman <jos@hyves.nl> wrote:
> 
>> Hi,
>> 
>> We have hit a problem where the page-cache writeback algorithm is not
>> keeping up.
>> When memory gets low this will result in very irregular performance drops.
>> 
>> Our setup is as follows:
>> 30 x Quad core machine with 64GB ram.
>> These are single purpose machines running MySQL.
>> Kernel version: 2.6.28.7
>> A dedicated SSD drive for the ext2 database partition
>> Noop scheduler for the ssd drive.
>> 
>> 
>> The current hypothesis is as follows:
>> The wk_update function does not write enough dirty pages, which allows the
>> number of dirty pages to grow to the dirty_background limit.
>> When memory is low,  __background_writeout() comes around and __forcefully__
>> writes dirty pages to disk.
>> This forced write fills the disk queue and starves read calls that MySQL is
>> trying to do: basically killing performance  for a few seconds.
>> This pattern repeats as soon as the cleared memory is filled again.
>> 
>> Decreasing the dirty_writeback_centisecs to 100 doesn__t help
>> 
>> I don__t know why this is, but I did some preliminary tracing using systemtap
>> and it seems that the majority of times wk_update calls decides to do
>> nothing.
>> 
>> Doubling /sys/block/sdb/queue/nr_requests  to 256, seems to help abit:  the
>> nr_dirty pages is increasing more slowly.
>> But I am unsure of side-effects and am afraid of increasing the starvation
>> problem for mysql.
>> 
>> 
>> I__am very much willing to work on this issue and see it fixed, but would
>> like to tap into the knowledge of people here.
>> So:
>> * Have more people seen this or simular issues?
>> * Is the hypothesis above a viable one?
>> * Suggestions/pointers for further research and statistics I should measure
>> to improve the understanding of this problem.
>> 
> 
> I don't think that noop-iosched tries to do anything to prevent
> writes-starve-reads.  Do you get better behaviour from any of the other IO
> schedulers?
> 

I did a quick stress test and cfq does not immediately seem to hurt
performance, although some of my colleague's have tested this in the past
with the opposite results (which is why we use noop).

But despite the scheduler, the real problem is in the writeback algorithm
not keeping up. 
We can grow 600K dirty pages during the day, and only ~300k is flushed to
disk during the night hours.

While a quick look at the writeback algorithm let me to expect
__wk_update()__ to flush ~1024 pages every 5 seconds, which is almost 3GB
per hour.  It obviously does not manage to do this in our setup.

I don¹t believe the speed of the ssd to be the problem, running sync
manually only takes a few minutes to flush 800K dirty pages to disk.

With regards,

Jos


