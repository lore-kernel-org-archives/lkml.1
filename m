Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYHRTNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYHRTNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758920AbYHRTH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:07:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:37612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447AbYHRTH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:07:56 -0400
Date: Mon, 18 Aug 2008 11:45:40 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 57/60] usb-storage: automatically recognize bad residues
Message-ID: <20080818184540.GF29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-automatically-recognize-bad-residues.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 59f4ff2ecff4cef36378928cec891785b402e80c upstream

This patch (as1119b) will help to reduce the clutter of usb-storage's
unusual_devs file by automatically detecting some devices that need
the IGNORE_RESIDUE flag.  The idea is that devices should never return
a non-zero residue for an INQUIRY or a READ CAPACITY command unless
they failed to transfer all the requested data.  So if one of these
commands transfers a standard amount of data but there is a positive
residue, we know that the residue is bogus and we can set the flag.

This fixes the problems reported in Bugzilla #11125.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Matthew Frost <artusemrys@sbcglobal.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/transport.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
 
 	/* try to compute the actual residue, based on how much data
 	 * was really transferred and what the device tells us */
-	if (residue) {
-		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
+	if (residue && !(us->flags & US_FL_IGNORE_RESIDUE)) {
+
+		/* Heuristically detect devices that generate bogus residues
+		 * by seeing what happens with INQUIRY and READ CAPACITY
+		 * commands.
+		 */
+		if (bcs->Status == US_BULK_STAT_OK &&
+				scsi_get_resid(srb) == 0 &&
+					((srb->cmnd[0] == INQUIRY &&
+						transfer_length == 36) ||
+					(srb->cmnd[0] == READ_CAPACITY &&
+						transfer_length == 8))) {
+			us->flags |= US_FL_IGNORE_RESIDUE;
+
+		} else {
 			residue = min(residue, transfer_length);
 			scsi_set_resid(srb, max(scsi_get_resid(srb),
 			                                       (int) residue));

-- 
