Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbZBNBpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbZBNBpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763387AbZBNBQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:54 -0500
Received: from kroah.org ([198.145.64.141]:50709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761894AbZBNBQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:42 -0500
Date: Fri, 13 Feb 2009 17:13:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 43/48] ide/libata: fix ata_id_is_cfa() (take 4)
Message-ID: <20090214011347.GR17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-libata-fix-ata_id_is_cfa.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 2999b58b795ad81f10e34bdbbfd2742172f247e4 upstream.

When checking for the CFA feature set support, ata_id_is_cfa() tests bit 2 in
word 82 of the identify data instead the word 83;  it also checks the ATA/PI
version support in the word 80 (which the CompactFlash specifications have as
reserved), this having no slightest chance to work on the modern CF cards that
don't have 0x848A in the word 0...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ata.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -731,12 +731,17 @@ static inline int ata_id_current_chs_val
 
 static inline int ata_id_is_cfa(const u16 *id)
 {
-	if (id[ATA_ID_CONFIG] == 0x848A)	/* Standard CF */
+	if (id[ATA_ID_CONFIG] == 0x848A)	/* Traditional CF */
 		return 1;
-	/* Could be CF hiding as standard ATA */
-	if (ata_id_major_version(id) >= 3 &&
-	    id[ATA_ID_COMMAND_SET_1] != 0xFFFF &&
-	   (id[ATA_ID_COMMAND_SET_1] & (1 << 2)))
+	/*
+	 * CF specs don't require specific value in the word 0 anymore and yet
+	 * they forbid to report the ATA version in the word 80 and require the
+	 * CFA feature set support to be indicated in the word 83 in this case.
+	 * Unfortunately, some cards only follow either of this requirements,
+	 * and while those that don't indicate CFA feature support need some
+	 * sort of quirk list, it seems impractical for the ones that do...
+	 */
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC004) == 0x4004)
 		return 1;
 	return 0;
 }

