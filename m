Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbZAALJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbZAALJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 06:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZAALJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 06:09:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:62591 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbZAALJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 06:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sASpwdCtrv7rwtQrsc52Y0fDUvtBkeq2BCV37R19r9TOMu6NA+yPpfKwxmQPtsd1Ns
         SGl5L63SQyplQV3qiFq0NjyKS2yfetovrtFMisqbktuzuw8PQAi2iF4H5dF/qqyn7njd
         Bt4EZwNvxOy437Ye2EEine6QjwfV3XLQulavE=
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH] s3cmci: Fix hangup in do_pio_write()
Date: Thu,  1 Jan 2009 13:09:04 +0200
Message-Id: <1230808144-11166-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the regression what was added by commit
088a78af978d0c8e339071a9b2bca1f4cb368f30 "s3cmci: Support transfers
which are not multiple of 32 bits."

fifo_free() now returns amount of available space in FIFO buffer in
bytes. But do_pio_write() writes to FIFO 32-bit words. Condition for
return from cycle is (fifo_free() == 0), but when fifo has 1..3 bytes of
free space then this condition will never be true and system hangs.

This patch changes condition in the while() to (fifo_free() > 3).

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/mmc/host/s3cmci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index fd6b5b8..9778deb 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -329,7 +329,7 @@ static void do_pio_write(struct s3cmci_host *host)
 
 	to_ptr = host->base + host->sdidata;
 
-	while ((fifo = fifo_free(host))) {
+	while ((fifo = fifo_free(host)) > 3) {
 		if (!host->pio_bytes) {
 			res = get_data_buffer(host, &host->pio_bytes,
 							&host->pio_ptr);
-- 
1.5.6.5

