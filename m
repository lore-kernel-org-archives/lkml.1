Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbYDYJy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbYDYJy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbYDYJys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:54:48 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50706 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758086AbYDYJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:54:47 -0400
Date: Fri, 25 Apr 2008 18:54:44 +0900 (JST)
Message-Id: <20080425.185444.115924172.ryov@valinux.co.jp>
To: s-uchida@ap.jp.nec.com, vtaras@openvz.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       axboe@kernel.dk, tom-sugawara@ap.jp.nec.com, m-takahashi@ex.jp.nec.com,
       devel@openvz.org
Subject: Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O bandwidth
 controlling subsystem for CGroups based on CFQ
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
References: <008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>
	<6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com>
	<005d01c89559$9e538200$dafa8600$@jp.nec.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I report benchmark results of the following I/O bandwidth controllers.

  From:	Vasily Tarasov <vtaras@openvz.org>
  Subject: [RFC][PATCH 0/9] cgroups: block: cfq: I/O bandwidth
           controlling subsystem for CGroups based on CFQ
  Date: Fri, 15 Feb 2008 01:53:34 -0500

  From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
  Subject: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O bandwidth
           controlling subsystem for CGroups based on CFQ
  Date: Thu, 3 Apr 2008 16:09:12 +0900

The test procedure is as follows:
  o Prepare 3 partitions sdc2, sdc3 and sdc4.
  o Run 100 processes issuing random direct I/O with 4KB data on each
    partitions.
  o Run 3 tests:
    #1 issuing read I/O only.
    #2 issuing write I/O only.
    #3 sdc2 and sdc3 are read, sdc4 is write.
  o Count up the number of I/Os which have done in 60 seconds.

Unfortunately, both bandwidth controllers didn't work as I expected,
On the test #3, the write I/O ate up the bandwidth regardless of the
specified priority level.

                          Vasily's scheduler
               The number of I/Os (percentage to total I/Os)
   ---------------------------------------------------------------------
  | partition     |     sdc2     |     sdc3     |     sdc4     | total  |
  | priority      |  7(highest)  |      4       |  0(lowest)   |  I/Os  |
  |---------------+--------------+--------------+--------------|--------|
  | #1 read       |  3620(35.6%) |  3474(34.2%) |  3065(30.2%) |  10159 |
  | #2 write      | 21985(36.6%) | 19274(32.1%) | 18856(31.4%) |  60115 |
  | #3 read&write |  5571( 7.5%) |  3253( 4.4%) | 64977(88.0%) |  73801 |
   ---------------------------------------------------------------------

                          Satoshi's scheduler
               The number of I/Os (percentage to total I/O)
   ---------------------------------------------------------------------
  | partition     |     sdc2     |     sdc3     |     sdc4     | total  |
  | priority      |  0(highest)  |      4       |  7(lowest)   |  I/Os  |
  |---------------+--------------+--------------+--------------|--------|
  | #1 read       |  4523(47.8%) |  3733(39.5%) |  1204(12.7%) |   9460 |
  | #2 write      | 65202(59.0%) | 35603(32.2%) |  9673( 8.8%) | 110478 |
  | #3 read&write |  5328(23.0%) |  4153(17.9%) | 13694(59.1%) |  23175 |
   ---------------------------------------------------------------------

I'd like to see other benchmark results if anyone has.

Thanks,
Ryo Tsuruta
