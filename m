Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbZJQGlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbZJQGlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZJQGlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:41:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39190 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZJQGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:41:44 -0400
Date: Sat, 17 Oct 2009 08:41:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/14] drivers/ata/libata: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170841270.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test on qc is needed, then the derefernce
should be after the NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/ata/libata-core.c           |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b525a09..d02c95c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4919,10 +4919,11 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
  */
 void ata_qc_free(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
+	struct ata_port *ap;
 	unsigned int tag;
 
 	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
+	ap = qc->ap;
 
 	qc->flags = 0;
 	tag = qc->tag;
@@ -4934,11 +4935,13 @@ void ata_qc_free(struct ata_queued_cmd *qc)
 
 void __ata_qc_complete(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
-	struct ata_link *link = qc->dev->link;
+	struct ata_port *ap;
+	struct ata_link *link;
 
 	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
 	WARN_ON_ONCE(!(qc->flags & ATA_QCFLAG_ACTIVE));
+	ap = qc->ap;
+	link = qc->dev->link;
 
 	if (likely(qc->flags & ATA_QCFLAG_DMAMAP))
 		ata_sg_clean(qc);
