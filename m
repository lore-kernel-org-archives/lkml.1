Return-Path: <linux-kernel-owner+w=401wt.eu-S935717AbXGRXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935717AbXGRXM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbXGRXMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:12:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:35671 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbXGRXMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EE6/YzcS4z5E/RixNtKmlFeBf1LvaGzRB200kx3DwaQtUtkAw9zuH8sOllDLAgK2wm/qjG8vCYNOCkopw0Q5MWD2RrFCs2hfUZLoEzUxK0389/aY+jOp/gJY313okZvWz9QIf44PCxgkZ7FwksXxotOwdBkLSYmnPhJ4dKF+CkI=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Memory leak in tpm_ascii_bios_measurements_open() fix.
Date: Thu, 19 Jul 2007 01:11:54 +0200
User-Agent: KMail/1.9.7
Cc: Seiji Munetoh <munetoh@jp.ibm.com>, Stefan Berger <stefanb@us.ibm.com>,
       Reiner Sailer <sailer@watson.ibm.com>, Kylene Hall <kjhall@us.ibm.com>,
       jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190111.55097.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ehlo,

Coverity found a memory leak in tpm_ascii_bios_measurements_open().

If "read_log(log)" fails, then we may leak 'log' and 
'log->bios_event_log'.

This patch should fix it, but please double check it. I don't know 
this code very well and the patch has only been compile tested.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/char/tpm/tpm_bios.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
index 4eba32b..4b26ce4 100644
--- a/drivers/char/tpm/tpm_bios.c
+++ b/drivers/char/tpm/tpm_bios.c
@@ -427,7 +427,7 @@ static int tpm_ascii_bios_measurements_open(struct inode *inode,
 		return -ENOMEM;
 
 	if ((err = read_log(log)))
-		return err;
+		goto out_free;
 
 	/* now register seq file */
 	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
@@ -435,10 +435,15 @@ static int tpm_ascii_bios_measurements_open(struct inode *inode,
 		seq = file->private_data;
 		seq->private = log;
 	} else {
-		kfree(log->bios_event_log);
-		kfree(log);
+		goto out_free;
 	}
+
+out:
 	return err;
+out_free:
+	kfree(log->bios_event_log);
+	kfree(log);
+	goto out;
 }
 
 const struct file_operations tpm_ascii_bios_measurements_ops = {


