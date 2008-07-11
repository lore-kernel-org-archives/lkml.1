Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYGKLO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYGKLO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYGKLOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:14:16 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53959 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295AbYGKLOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:14:15 -0400
Date: Fri, 11 Jul 2008 20:14:11 +0900 (JST)
Message-Id: <20080711.201411.193712771.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org
Subject: Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.3.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is the dm-ioband version 1.3.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

- Can be applied to the kernel 2.6.26-rc5-mm3.
- Changes from 1.2.0 (posted on Jul 4, 2008):
  - I/O smoothing take #2
    This feature makes I/O requests of each group issued smoothly.
    Once a certain group has used up its tokens, all I/O requests to
    the group will be blocked until all the other groups used up
    theirs. This feature is to minimize this blocking time and to
    issue I/O requests at a constant rate according to the weight,
    without decreasing throughput.
    We have tested various ideas to achieve this feature and we have
    chosen the most effective ways as follows:
      - Shorten the epoch period of dm-ioband, each of which every
        ioband group will get new tokens. On the other hand, the
        leftover tokens for the past few epochs can be taken over to
        the next epoch so that it can keep the fairness between the
        groups even when the I/O loads of some groups are changing.
      - Make a new epoch immediately when a group with large weight
        used up its tokens even though there remain a lot of in-flight
        I/Os.
        To gain the throughput, dm-ioband will recharge tokens to all
        the groups without waiting their I/O completion if possible.
      - Make the I/O requests which user process have just made
        be handled ahead of the blocked I/O requests, since it
        would make sense that you assume the groups which issued
        these blocked I/O requests will have small weights.
      - Make the number of I/O requests which can be queued in dm-ioband
        smaller, so it will prevents all the I/O request of each
	group from being issued at the same time when a new epoch
	gets made.
- TODO
  - Implementing cgroup support for dm-ioband is in progress. This
    feature makes it be able to handle asynchronous I/O requests properly.

I added a new benchmark result on the dm-ioband webpage. This result
shows that dm-ioband can control a bandwidth even when an unbalanced
I/O load is applied.
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/partition3.html

Thanks,
Ryo Tsuruta
Linux Block I/O Bandwidth Control Project
http://people.valinux.co.jp/~ryov/bwctl/
