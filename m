Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065Ab0AZT27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0AZT27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001Ab0AZT27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:28:59 -0500
Received: from kroah.org ([198.145.64.141]:33566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab0AZT26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:28:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:24 2010
Message-Id: <20100126191623.898160039@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tamas Vincze <tom@vincze.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Doug Thompson <dougthompson@xmission.com>
Subject: [01/11] edac: i5000_edac critical fix panic out of bounds
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tamas Vincze <tom@vincze.org>

commit 118f3e1afd5534c15f9701f33514186cfc841a27 upstream.

EDAC MC0: INTERNAL ERROR: channel-b out of range (4 >= 4)
Kernel panic - not syncing: EDAC MC0: Uncorrected Error  (XEN) Domain 0 crashed: 'noreboot' set - not rebooting.

This happens because FERR_NF_FBD bit 28 is not updated on i5000.  Due to
that, both bits 28 and 29 may be equal to one, returning channel = 3.  As
this value is invalid, EDAC core generates the panic.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14568

Signed-off-by: Tamas Vincze <tom@vincze.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/i5000_edac.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -566,7 +566,13 @@ static void i5000_process_nonfatal_error
 		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
-		channel = branch;
+
+		/*
+		 * According with i5000 datasheet, bit 28 has no significance
+		 * for errors M4Err-M12Err and M17Err-M21Err, on FERR_NF_FBD
+		 */
+		channel = branch & 2;
+
 		bank = NREC_BANK(info->nrecmema);
 		rank = NREC_RANK(info->nrecmema);
 		rdwr = NREC_RDWR(info->nrecmema);


