Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYKJFUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYKJFUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:20:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYKJFTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:19:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:54611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYKJFTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:19:51 -0500
Message-ID: <4917C449.2080504@kernel.org>
Date: Mon, 10 Nov 2008 14:19:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: request to revert libata-convert-to-block-tagging patches
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Nov 2008 05:19:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

I went through libata-convert-to-block-tagging today and found several
issues.

1. libata internal data structure for command context (qc) allocation is
bound to tag allocation, which means that block layer tagging should be
enabled for all controllers which have can_queue > 1.

2. blk-tag offsets allocation for non-sync requests.  I'm not confident
this is safe.  Till now, if there was only single command in flight for
the port, it was guaranteed that the qc gets tag zero whether the device
is NCQ capable or not.  qc allocation is tied tightly with hardware
command slot allocation and I don't think it's wise to change this
assumption.

#1 is easy to fix but #2 requires either adding a spinlock or two atomic
variables to struct blk_queue_tag to keep the current behavior while
guaranteeing that tags are used in order.  Also, there's delay between
libata marks a request complete and the request actually gets completed
and the tag is freed.  If another request gets issued inbetween, the tag
number can't be guaranteed.  This can be worked around by re-mapping tag
number in libata depending on command type but, well then, it's worse
than the original implementation.

So, please revert the following commits.

43a49cbdf31e812c0d8f553d433b09b421f5d52c
e013e13bf605b9e6b702adffbe2853cfc60e7806
2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e

Thanks.

-- 
tejun
