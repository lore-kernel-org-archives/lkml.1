Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYJRTNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYJRTNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYJRTEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:40 -0400
Received: from mail.suse.de ([195.135.220.2]:38450 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYJRTEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:39 -0400
Date: Sat, 18 Oct 2008 11:47:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 10/26] libata: always do follow-up SRST if hardreset
	returned -EAGAIN
Message-ID: <20081018184746.GK301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-always-do-follow-up-srst-if-hardreset-returned-eagain.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 5dbfc9cb59d4ad75199949d7dd8a8c6d7bc518df upstream

As an optimization, follow-up SRST used to be skipped if
classification wasn't requested even when hardreset requested it via
-EAGAIN.  However, some hardresets can't wait for device readiness and
skipping SRST can cause timeout or other failures during revalidation.
Always perform follow-up SRST if hardreset returns -EAGAIN.  This
makes reset paths more predictable and thus less error-prone.

While at it, move hardreset error checking such that it's done right
after hardreset is finished.  This simplifies followup SRST condition
check a bit and makes the reset path easier to modify.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2050,18 +2050,12 @@ static int ata_do_reset(struct ata_link 
 }
 
 static int ata_eh_followup_srst_needed(struct ata_link *link,
-				       int rc, int classify,
-				       const unsigned int *classes)
+				       int rc, const unsigned int *classes)
 {
 	if ((link->flags & ATA_LFLAG_NO_SRST) || ata_link_offline(link))
 		return 0;
-	if (rc == -EAGAIN) {
-		if (classify)
-			return 1;
-		rc = 0;
-	}
-	if (rc != 0)
-		return 0;
+	if (rc == -EAGAIN)
+		return 1;
 	if (sata_pmp_supported(link->ap) && ata_is_host_link(link))
 		return 1;
 	return 0;
@@ -2174,9 +2168,11 @@ int ata_eh_reset(struct ata_link *link, 
 			ehc->i.flags |= ATA_EHI_DID_SOFTRESET;
 
 		rc = ata_do_reset(link, reset, classes, deadline);
+		if (rc && rc != -EAGAIN)
+			goto fail;
 
 		if (reset == hardreset &&
-		    ata_eh_followup_srst_needed(link, rc, classify, classes)) {
+		    ata_eh_followup_srst_needed(link, rc, classes)) {
 			/* okay, let's do follow-up softreset */
 			reset = softreset;
 
@@ -2191,10 +2187,6 @@ int ata_eh_reset(struct ata_link *link, 
 			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
 			rc = ata_do_reset(link, reset, classes, deadline);
 		}
-
-		/* -EAGAIN can happen if we skipped followup SRST */
-		if (rc && rc != -EAGAIN)
-			goto fail;
 	} else {
 		if (verbose)
 			ata_link_printk(link, KERN_INFO, "no reset method "

-- 
