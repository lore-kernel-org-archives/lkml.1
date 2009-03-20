Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZCTSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZCTSc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbZCTScS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:32:18 -0400
Received: from exc01vs1.exchange.cysonet.com ([85.158.200.82]:38286 "EHLO
	exc01vs1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbZCTScR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:32:17 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 14:32:17 EDT
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Fri, 20 Mar 2009 19:26:06 +0100
Subject: Page Cache writeback too slow,   SSD/noop scheduler/ext2
From: Jos Houtman <jos@hyves.nl>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C5E99E4E.C0E0%jos@hyves.nl>
Thread-Topic: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Thread-Index: AcmpfTHn4SEn3CUtJ0mwkgr/mpVpUAADCMzZ
In-Reply-To: <C5E989F1.C0C7%jos@hyves.nl>
Mime-version: 1.0
Content-type: text/plain;
	charset="ISO-8859-1"
Content-transfer-encoding: 8BIT
X-OriginalArrivalTime: 20 Mar 2009 18:26:06.0561 (UTC) FILETIME=[556D4D10:01C9A989]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have hit a problem where the page-cache writeback algorithm is not
keeping up.
When memory gets low this will result in very irregular performance drops.

Our setup is as follows:
30 x Quad core machine with 64GB ram.
These are single purpose machines running MySQL.
Kernel version: 2.6.28.7
A dedicated SSD drive for the ext2 database partition
Noop scheduler for the ssd drive.


The current hypothesis is as follows:
The wk_update function does not write enough dirty pages, which allows the
number of dirty pages to grow to the dirty_background limit.
When memory is low,  Œbackground_writeout() comes around and Œforcefully¹
writes dirty pages to disk.
This forced write fills the disk queue and starves read calls that MySQL is
trying to do: basically killing performance  for a few seconds.
This pattern repeats as soon as the cleared memory is filled again.

Decreasing the dirty_writeback_centisecs to 100 doesn¹t help

I don¹t know why this is, but I did some preliminary tracing using systemtap
and it seems that the majority of times wk_update calls decides to do
nothing.

Doubling /sys/block/sdb/queue/nr_requests  to 256, seems to help abit:  the
nr_dirty pages is increasing more slowly.
But I am unsure of side-effects and am afraid of increasing the starvation
problem for mysql.


I¹am very much willing to work on this issue and see it fixed, but would
like to tap into the knowledge of people here.
So: 
* Have more people seen this or simular issues?
* Is the hypothesis above a viable one?
* Suggestions/pointers for further research and statistics I should measure
to improve the understanding of this problem.



With regards,

Jos

