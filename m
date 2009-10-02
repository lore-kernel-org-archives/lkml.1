Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZJBBdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZJBBdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZJBBc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:59 -0400
Received: from kroah.org ([198.145.64.141]:33052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbZJBBc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:11 2009
Message-Id: <20091002012411.706424817@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Krill <ben@codiert.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [038/136] mtd: ofpart: Check availability of reg property instead of name property
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=mtd-ofpart-check-availability-of-reg-property-instead-of-name-property.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Krill <ben@codiert.org>

commit ebd5a74db74ee2db833d43ea35108a4be9cab42f upstream.

The previous implementation breaks the dts binding "mtd-physmap.txt". This
implementation fixes the issue by checking the availability of the reg
property instead of the name property.

Signed-off-by: Benjamin Krill <ben@codiert.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ofpart.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -46,21 +46,12 @@ int __devinit of_mtd_parse_partitions(st
 		const u32 *reg;
 		int len;
 
-		/* check if this is a partition node */
-		partname = of_get_property(pp, "name", &len);
-		if (strcmp(partname, "partition") != 0) {
+		reg = of_get_property(pp, "reg", &len);
+		if (!reg) {
 			nr_parts--;
 			continue;
 		}
 
-		reg = of_get_property(pp, "reg", &len);
-		if (!reg || (len != 2 * sizeof(u32))) {
-			of_node_put(pp);
-			dev_err(dev, "Invalid 'reg' on %s\n", node->full_name);
-			kfree(*pparts);
-			*pparts = NULL;
-			return -EINVAL;
-		}
 		(*pparts)[i].offset = reg[0];
 		(*pparts)[i].size = reg[1];
 
@@ -75,6 +66,14 @@ int __devinit of_mtd_parse_partitions(st
 		i++;
 	}
 
+	if (!i) {
+		of_node_put(pp);
+		dev_err(dev, "No valid partition found on %s\n", node->full_name);
+		kfree(*pparts);
+		*pparts = NULL;
+		return -EINVAL;
+	}
+
 	return nr_parts;
 }
 EXPORT_SYMBOL(of_mtd_parse_partitions);


