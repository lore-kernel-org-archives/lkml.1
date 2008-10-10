Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYJJMJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYJJMJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJJMJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:09:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:4577 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYJJMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p5uPA0FuFyqjeRdCNLpqcuRP7IK1F70sYIyDBOHMNEzFEtVThPTZAV3ahdFe6A9Wel
         AqUGsWIcGpDA62pOx3QkaIEbaSQ9UQsKYY+v8/qo4XdEBeFirVm9z2WFUBNqjg1ZER2Z
         NkZuV3IcEgRu/tw2WEu4HQxt10HTai2rxzlbY=
From: Christian Pellegrin <chripell@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] max3100 driver
Date: Fri, 10 Oct 2008 14:08:58 +0200
Message-Id: <12236405383272-git-send-email-chripell@gmail.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <20080920012454.e40f03cc.akpm@linux-foundation.org>
References: <20080920012454.e40f03cc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch fixes a problem about PM in my code that I found when testing
patches that went in -mm. The full patch against the Linus tree can be
found at http://www.evolware.org/chri/paciugo/

---
diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
index 7a269a6..462d6a4 100644
--- a/drivers/serial/max3100.c
+++ b/drivers/serial/max3100.c
@@ -566,6 +566,7 @@ static void max3100_shutdown(struct uart_port *port)
 	if (s->workqueue) {
 		flush_workqueue(s->workqueue);
 		destroy_workqueue(s->workqueue);
+		s->workqueue = NULL;
 	}
 	if (s->irq)
 		free_irq(s->irq, s);
@@ -614,6 +615,7 @@ static int max3100_startup(struct uart_port *port)
 		dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
 		s->irq = 0;
 		destroy_workqueue(s->workqueue);
+		s->workqueue = NULL;
 		return -EBUSY;
 	}
 
@@ -884,7 +886,8 @@ static int max3100_resume(struct spi_device *spi)
 	enable_irq(s->irq);
 
 	s->conf_commit = 1;
-	max3100_dowork(s);
+	if (s->workqueue)
+		max3100_dowork(s);
 
 	return 0;
 }
