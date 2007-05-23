Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbXEWJ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbXEWJ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbXEWJ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:59:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:53164 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342AbXEWJ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=K3/pJY+7V3WHrqtrwGLjFgkVFqxuljxqakm6rzpucXQcjm9Ya59lLCjtKjfTqLLROdjhiI85wiCq8bYY2zD31iD2bbhvPBL4pq9qx3yIQ5mdRu9S1eqtUY/38bVXTT8PalpbNbOSN5lKLkZQ++QJMS9hu+8Ce4aQLURPR9QpijQ=
Message-ID: <4654105C.5030908@gmail.com>
Date: Wed, 23 May 2007 11:58:52 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] libata: -ENODEV during prereset isn't an error
References: <20070523064408.GA29593@linux-sh.org> <4653F62C.4070700@gmail.com> <20070523083026.GA29851@linux-sh.org> <46540981.9080603@gmail.com> <20070523094858.GA30352@linux-sh.org>
In-Reply-To: <20070523094858.GA30352@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During prereset, -ENODEV return from ata_wait_ready() is not an error.
This causes unnecessary bug message on controllers which uses 0xff to
indicate empty port.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---

This one is for 2.6.22 too.  Thanks.

 libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a6de57e..79f2175 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3368,7 +3368,7 @@ int ata_std_prereset(struct ata_port *ap
 	 */
 	if (!(ap->flags & ATA_FLAG_SKIP_D2H_BSY) && !ata_port_offline(ap)) {
 		rc = ata_wait_ready(ap, deadline);
-		if (rc) {
+		if (rc && rc != -ENODEV) {
 			ata_port_printk(ap, KERN_WARNING, "device not ready "
 					"(errno=%d), forcing hardreset\n", rc);
 			ehc->i.action |= ATA_EH_HARDRESET;
