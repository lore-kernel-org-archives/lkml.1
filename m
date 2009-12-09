Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZLITo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZLITo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZLITox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:44:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61495 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbZLITox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:from:date:mime-version:content-disposition:message-id
         :content-type:content-transfer-encoding;
        b=dn6x0Ag9b9ytIKO8HcE/4/ZD6M2C2mv24XyTS3UKv5xXDZCOIwO0C9DRigetgwuR88
         eIDOPyzcCNGZJeS7Iu1W/CQvBwp3zzFo02D5cUtYa5z2tnhZNzqkpSIYgQYO+cE024ym
         wffTQO0ENWyDxQUDGXNjzuzPRQtwzxbt5zOsQ=
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
From: Corrado Zoccolo <czoccolo@gmail.com>
Date: Wed, 9 Dec 2009 20:45:16 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <4b1ffe39.0f1abc0a.19c7.05d2@mx.google.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 8:05 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Dec 09 2009, Jeff Moyer wrote:
>> OK.  Can we put a comment in there and change the initialization to
>> cfq_slice_sync * 10?
>
> Agree, that would be MUCH easier to understand.
>
Sure, we can put a comment there, but I don't like hardcoding a constant that depends on how the formula is computed (what if the formula is changed, 
and it doesn't depend on cfq_slice_sync any more, or if cfq_slice_sync changes dynamically?).
When I wrote it, what I really meant was exactly what you read in the C code (assume the last delayed sync happened 1 second ago). Then, the effect 
would be to start with a queue depth of 10 with the current formula, but even if we change the formula, 1 second is still meaningful (while 10 
*cfq_slice_sync, that has the same value, becomes misleading). So my proposed fix is just:

>From f06cd83b45b3a7ee13ae7322197b610085dc70dd Mon Sep 17 00:00:00 2001
From: Corrado Zoccolo <corrado@localhost.(none)>
Date: Wed, 9 Dec 2009 20:40:16 +0100
Subject: [PATCH] cfq-iosched: commenting non-obvious initialization

Added a comment to explain the initialization of last_delayed_sync.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 98b15b9..69ecee7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3759,6 +3759,10 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
+	/*
+	 * we optimistically start assuming sync ops weren't delayed in last
+	 * second, in order to have larger depth for async operations.
+	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
 	INIT_RCU_HEAD(&cfqd->rcu);
 	return cfqd;
-- 
1.6.2.5



