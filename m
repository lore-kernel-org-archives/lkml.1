Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYIITsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYIITsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYIITsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:48:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:55678 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIITsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=AykkJr6WUe/lvr0Oqrfjzgm8xe5LEPsvzU2n0W9Nl8TfpDTV4k//cIaOZhpznKxtXy
         B/QiQxRQnoEHRQv35keAEm3Y81vGGgEXi3NZJYikxWq0psKb9XvoEhorNZaoxtW8aym+
         jgrg9BC71hGA93QlVY7ZCJuULc7W1zhnwaQ8E=
Message-ID: <48C6D301.305@gmail.com>
Date: Tue, 09 Sep 2008 21:48:17 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mpjohn@us.ibm.com, paulus@samba.org
Subject: [PATCH] [CELL] oprofile: test for flag instead of negative on unsigned
References: <48C685F6.8020108@gmail.com>
In-Reply-To: <48C685F6.8020108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi arch/powerpc/oprofile/cell/vma_map.c +46

And you'll find this comment in vma_map_lookup():

Default the offset to the physical address + a flag value.
Addresses of dynamically generated code can't be found in the vma
map.  For those addresses the flagged value will be sent on to
the user space tools so they can be reported rather than just
thrown away.

Returned is the flag value 0x10000000 + vma when not found.

The test for negative overlay_tbl_offset does not work
because it is unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
index fff6666..41e0c22 100644
--- a/arch/powerpc/oprofile/cell/vma_map.c
+++ b/arch/powerpc/oprofile/cell/vma_map.c
@@ -229,7 +229,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 	 */
 	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
 					    aSpu, &grd_val);
-	if (overlay_tbl_offset < 0) {
+	if (overlay_tbl_offset >= 0x10000000) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Error finding SPU overlay table\n",
 		       __func__, __LINE__);
