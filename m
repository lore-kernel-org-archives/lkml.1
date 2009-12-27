Return-Path: <linux-kernel-owner+w=401wt.eu-S1751195AbZL0Urp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbZL0Urp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZL0Uro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:47:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34663 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZL0Uro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NbM/uZ9UJPXg4Ax67Xxg+SsYH8D1VgXq/q132SCk0nebDUqnqQwPhyU3K3cidFthT3
         VpvtVpS01jerY/vQpJfy86QNbyVfvO5PT3DQMff/LMzO+WZQzmPuf/xXEF5EH4XMI1ms
         RiRF8m3Akp2mMQySe+lEAubXsa3lX2j+CiWis=
Message-ID: <4B37C89B.3030904@gmail.com>
Date: Sun, 27 Dec 2009 21:50:35 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Tim Waugh <tim@cyberelk.net>, linux-parport@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] paride: test off by one
References: <4B3772CA.80505@gmail.com>
In-Reply-To: <4B3772CA.80505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (j++ < PX_SPIN)' j reaches PX_SPIN + 1 after the loop. This is
probably unlikely to produce a problem.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
If you want this, this is probably better:

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 8866ca3..71acf4e 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -341,11 +341,11 @@ static int pcd_wait(struct pcd_unit *cd, int go, int stop, char *fun, char *msg)
 	       && (j++ < PCD_SPIN))
 		udelay(PCD_DELAY);
 
-	if ((r & (IDE_ERR & stop)) || (j >= PCD_SPIN)) {
+	if ((r & (IDE_ERR & stop)) || (j > PCD_SPIN)) {
 		s = read_reg(cd, 7);
 		e = read_reg(cd, 1);
 		p = read_reg(cd, 2);
-		if (j >= PCD_SPIN)
+		if (j > PCD_SPIN)
 			e |= 0x100;
 		if (fun)
 			printk("%s: %s %s: alt=0x%x stat=0x%x err=0x%x"
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index ea54ea3..60fd50c 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -391,11 +391,11 @@ static int pf_wait(struct pf_unit *pf, int go, int stop, char *fun, char *msg)
 	       && (j++ < PF_SPIN))
 		udelay(PF_SPIN_DEL);
 
-	if ((r & (STAT_ERR & stop)) || (j >= PF_SPIN)) {
+	if ((r & (STAT_ERR & stop)) || (j > PF_SPIN)) {
 		s = read_reg(pf, 7);
 		e = read_reg(pf, 1);
 		p = read_reg(pf, 2);
-		if (j >= PF_SPIN)
+		if (j > PF_SPIN)
 			e |= 0x100;
 		if (fun)
 			printk("%s: %s %s: alt=0x%x stat=0x%x err=0x%x"
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 1e4006e..bc5825f 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -274,11 +274,11 @@ static int pt_wait(struct pt_unit *tape, int go, int stop, char *fun, char *msg)
 	       && (j++ < PT_SPIN))
 		udelay(PT_SPIN_DEL);
 
-	if ((r & (STAT_ERR & stop)) || (j >= PT_SPIN)) {
+	if ((r & (STAT_ERR & stop)) || (j > PT_SPIN)) {
 		s = read_reg(pi, 7);
 		e = read_reg(pi, 1);
 		p = read_reg(pi, 2);
-		if (j >= PT_SPIN)
+		if (j > PT_SPIN)
 			e |= 0x100;
 		if (fun)
 			printk("%s: %s %s: alt=0x%x stat=0x%x err=0x%x"
