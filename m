Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZBHVne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZBHVne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZBHVnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:43:24 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55138 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZBHVnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:43:23 -0500
Date: Sun, 8 Feb 2009 22:43:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: james.smart@emulex.com, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/6] drivers/scsi: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0902082242290.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/scsi/lpfc/lpfc_els.c        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a8f30bd..a730248 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5258,6 +5258,7 @@ lpfc_send_els_event(struct lpfc_vport *vport,
 			sizeof(struct lpfc_name));
 		break;
 	default:
+		kfree(els_data);
 		return;
 	}
 	memcpy(els_data->wwpn, &ndlp->nlp_portname, sizeof(struct lpfc_name));
