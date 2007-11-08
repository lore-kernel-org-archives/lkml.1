Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXKHC1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXKHC1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXKHC10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:27:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:21342 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbXKHC10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UISZZdD9XlaDt2j2B0iysnJjQe4t84Q9LFY0nHRa2gct/bMkztTuYgvjQrbpMy75rf/fxtHLMZsk3olLxp001BPXIYHn9Bo9QugE+u8VQ/LqpTXNRWJUxaM1c2IzJqA+5EwCQoAMahL/YFfS0raov1DmW0v/Nj4ufvaQYMrskgc=
Message-ID: <47327404.9010008@gmail.com>
Date: Thu, 08 Nov 2007 11:27:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Osterlund <petero2@telia.com>, gregkh@suse.de
CC: Thomas Maier <balagi@justmail.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] pktcdvd: fix BUG caused by sysfs module reference semantics
 change
References: <20071105092018.GD5359@kernel.dk> <Pine.LNX.4.64.0711052312410.5445@quad.localdomain> <47302E9F.6020708@gmail.com> <op.t1d2aurziudtyh@master> <Pine.LNX.4.64.0711062229490.5800@quad.localdomain> <4731269B.6010509@gmail.com> <Pine.LNX.4.64.0711072303080.6991@quad.localdomain>
In-Reply-To: <Pine.LNX.4.64.0711072303080.6991@quad.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pkt_setup_dev() expects module reference to be held on invocation.
This used to be true for sysfs callbacks but not anymore.  Test and
grab module reference around pkt_setup_dev() in
class_pktcdvd_store_add().

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Peter Osterlund <petero2@telia.com>
---
Greg, can you please push this patch through your tree? 
Thanks a lot.

 drivers/block/pktcdvd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a8130a4..a5ee213 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -358,10 +358,19 @@ static ssize_t class_pktcdvd_store_add(struct class *c, const char *buf,
 					size_t count)
 {
 	unsigned int major, minor;
+
 	if (sscanf(buf, "%u:%u", &major, &minor) == 2) {
+		/* pkt_setup_dev() expects caller to hold reference to self */
+		if (!try_module_get(THIS_MODULE))
+			return -ENODEV;
+
 		pkt_setup_dev(MKDEV(major, minor), NULL);
+
+		module_put(THIS_MODULE);
+
 		return count;
 	}
+
 	return -EINVAL;
 }
 
