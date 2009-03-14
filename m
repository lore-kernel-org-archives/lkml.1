Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbZCNBlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbZCNBlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZCNBU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:59 -0400
Received: from kroah.org ([198.145.64.141]:35336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbZCNBUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:39 2009
Message-Id: <20090314011039.859419404@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:34 -0700
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
       alan@lxorguk.ukuu.org.uk, Robert Hancock <hancockrwd@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 057/114] libata: Dont trust current capacity values in identify words 57-58
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=libata-don-t-trust-current-capacity-values-in-identify-words-57-58.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Hancock <hancockrwd@gmail.com>

commit 968e594afdbc40b4270f9d4032ae8350475749d6 upstream.

Hanno Böck reported a problem where an old Conner CP30254 240MB hard drive
was reported as 1.1TB in capacity by libata:

http://lkml.org/lkml/2009/2/13/134

This was caused by libata trusting the drive's reported current capacity in
sectors in identify words 57 and 58 if the drive does not support LBA and the
current CHS translation values appear valid. Unfortunately it seems older
ATA specs were vague about what this field should contain and a number of drives
used values with wrong byte order or that were totally bogus. There's no
unique information that it conveys and so we can just calculate the number
of sectors from the reported current CHS values.

While we're at it, clean up this function to use named constants for the
identify word values.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1251,14 +1251,16 @@ static u64 ata_id_n_sectors(const u16 *i
 {
 	if (ata_id_has_lba(id)) {
 		if (ata_id_has_lba48(id))
-			return ata_id_u64(id, 100);
+			return ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 		else
-			return ata_id_u32(id, 60);
+			return ata_id_u32(id, ATA_ID_LBA_CAPACITY);
 	} else {
 		if (ata_id_current_chs_valid(id))
-			return ata_id_u32(id, 57);
+			return id[ATA_ID_CUR_CYLS] * id[ATA_ID_CUR_HEADS] *
+			       id[ATA_ID_CUR_SECTORS];
 		else
-			return id[1] * id[3] * id[6];
+			return id[ATA_ID_CYLS] * id[ATA_ID_HEADS] *
+			       id[ATA_ID_SECTORS];
 	}
 }
 


