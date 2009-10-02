Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZJBB4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZJBB4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZJBB4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:56:16 -0400
Received: from kroah.org ([198.145.64.141]:33045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZJBBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:11 2009
Message-Id: <20091002012411.495368307@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Feng Kan <fkan@amcc.com>, Victor Gallardo <vgallardo@amcc.com>,
       Prodyut Hazarika <phazarika@amcc.com>, Stefan Roese <sr@denx.de>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [037/136] mtd: nand: fix ECC Correction bug for SMC ordering for NDFC driver
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=mtd-nand-fix-ecc-correction-bug-for-smc-ordering-for-ndfc-driver.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Feng Kan <fkan@amcc.com>

commit 76c23c32e3b3ad48e07e07897075ab19ae1ef117 upstream.

Fix ECC Correction bug where the byte offset location were double
fliped causing correction routine to toggle the wrong byte location
in the ECC segment. The ndfc_calculate_ecc routine change the order
of getting the ECC code.
        /* The NDFC uses Smart Media (SMC) bytes order */
        ecc_code[0] = p[2];
        ecc_code[1] = p[1];
        ecc_code[2] = p[3];
But in the Correction algorithm when calculating the byte offset
location, the b1 is used as the upper part of the address. Which
again reverse the order making the final byte offset address
location incorrect.
	byte_addr = (addressbits[b1] << 4) + addressbits[b0];
The order is change to read it in straight and let the correction
function to revert it to SMC order.

Signed-off-by: Feng Kan <fkan@amcc.com>
Acked-by: Victor Gallardo <vgallardo@amcc.com>
Acked-by: Prodyut Hazarika <phazarika@amcc.com>
Acked-by: Stefan Roese <sr@denx.de>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/ndfc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -102,8 +102,8 @@ static int ndfc_calculate_ecc(struct mtd
 	wmb();
 	ecc = in_be32(ndfc->ndfcbase + NDFC_ECC);
 	/* The NDFC uses Smart Media (SMC) bytes order */
-	ecc_code[0] = p[2];
-	ecc_code[1] = p[1];
+	ecc_code[0] = p[1];
+	ecc_code[1] = p[2];
 	ecc_code[2] = p[3];
 
 	return 0;


