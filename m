Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317Ab0B0Rf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:35:27 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62575 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab0B0RfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KvEhslUVsPDtrICDTDT5hxi2yjq23TD3mr4EkEhNfzRXLeUqBsF9J+3iEoM/tX27zJ
         jlsTr0RG+dKCIbYPNrjbtSAnxClAxp+QETccjRRqTVUVb5B5iBUouxDwKqvuS2gxQtiT
         G4LeiaU2Xmp3+w6IlnopE+sKINp5yd/y7ZMN8=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] blktrace: perform cleanup after setup error
Date: Sat, 27 Feb 2010 20:35:13 +0300
Message-Id: <1267292113-12900-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently even if BLKTRACESETUP ioctl has failed user must call
BLKTRACETEARDOWN to be shure what all staff was cleaned, which
is contr-intuitive.
Let's setup ioctl make necessery cleanup by it self.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 kernel/trace/blktrace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d9d6206..07f945a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -540,9 +540,10 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (ret)
 		return ret;
 
-	if (copy_to_user(arg, &buts, sizeof(buts)))
+	if (copy_to_user(arg, &buts, sizeof(buts))) {
+		blk_trace_remove(q);
 		return -EFAULT;
-
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(blk_trace_setup);
-- 
1.6.6

