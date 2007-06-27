Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbXF0LTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbXF0LTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbXF0LSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:18:54 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:50057 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbXF0LSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:18:52 -0400
X-Greylist: delayed 1886 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 07:18:52 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Wed, 27 Jun 2007 11:47:23 +0100 (BST)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net, ldm@flatcap.org
Subject: [2.6 PATCH] Fix LDM for new field in the VOL5 VBLK.
Message-ID: <Pine.LNX.4.64.0706271138220.18280@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus/Andrew,

Please apply the below patch to the LDM driver.  It fixes LDM for people 
using Vista who have disabled drive letter assignment from one or more 
volumes.  Doing this introduces a so far unknown field in the LDM database 
in the VOL5 VBLK structure which causes the LDM driver to fail to parse 
the VBLK structure and hence LDM fails to parse the disk altogether.  This 
patch teaches the driver about this field.

Thanks got to Ashton Mills <amills@iinet.com.au> for reporting the problem 
and working with me on getting it fixed.  It is now working for him.  And 
hopefully this time I will not break the patch before sending the email 
off...  (-;

Please apply to 2.6.22 if not too late yet...

Thanks!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

---
Teach LDM about a new field encountered with Windows Vista.

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
CC: Richard Russon <ldm@flatcap.org>

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 99873a2..e7dd1d4 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -677,15 +677,24 @@ static bool ldm_create_data_partitions (struct parsed_partitions *pp,
  * Return:  -1 Error, the calculated offset exceeded the size of the buffer
  *           n OK, a range-checked offset into buffer
  */
-static int ldm_relative (const u8 *buffer, int buflen, int base, int offset)
+static int ldm_relative(const u8 *buffer, int buflen, int base, int offset)
 {
 
 	base += offset;
-	if ((!buffer) || (offset < 0) || (base > buflen))
+	if (!buffer || offset < 0 || base > buflen) {
+		if (!buffer)
+			ldm_error("!buffer");
+		if (offset < 0)
+			ldm_error("offset (%d) < 0", offset);
+		if (base > buflen)
+			ldm_error("base (%d) > buflen (%d)", base, buflen);
 		return -1;
-	if ((base + buffer[base]) >= buflen)
+	}
+	if (base + buffer[base] >= buflen) {
+		ldm_error("base (%d) + buffer[base] (%d) >= buflen (%d)", base,
+				buffer[base], buflen);
 		return -1;
-
+	}
 	return buffer[base] + offset + 1;
 }
 
@@ -1054,60 +1063,98 @@ static bool ldm_parse_prt3(const u8 *buffer, int buflen, struct vblk *vb)
  * Return:  'true'   @vb contains a Volume VBLK
  *          'false'  @vb contents are not defined
  */
-static bool ldm_parse_vol5 (const u8 *buffer, int buflen, struct vblk *vb)
+static bool ldm_parse_vol5(const u8 *buffer, int buflen, struct vblk *vb)
 {
-	int r_objid, r_name, r_vtype, r_child, r_size, r_id1, r_id2, r_size2;
-	int r_drive, len;
+	int r_objid, r_name, r_vtype, r_disable_drive_letter, r_child, r_size;
+	int r_id1, r_id2, r_size2, r_drive, len;
 	struct vblk_volu *volu;
 
-	BUG_ON (!buffer || !vb);
-
-	r_objid  = ldm_relative (buffer, buflen, 0x18, 0);
-	r_name   = ldm_relative (buffer, buflen, 0x18, r_objid);
-	r_vtype  = ldm_relative (buffer, buflen, 0x18, r_name);
-	r_child  = ldm_relative (buffer, buflen, 0x2E, r_vtype);
-	r_size   = ldm_relative (buffer, buflen, 0x3E, r_child);
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_ID1)
-		r_id1 = ldm_relative (buffer, buflen, 0x53, r_size);
-	else
+	BUG_ON(!buffer || !vb);
+	r_objid = ldm_relative(buffer, buflen, 0x18, 0);
+	if (r_objid < 0) {
+		ldm_error("r_objid %d < 0", r_objid);
+		return false;
+	}
+	r_name = ldm_relative(buffer, buflen, 0x18, r_objid);
+	if (r_name < 0) {
+		ldm_error("r_name %d < 0", r_name);
+		return false;
+	}
+	r_vtype = ldm_relative(buffer, buflen, 0x18, r_name);
+	if (r_vtype < 0) {
+		ldm_error("r_vtype %d < 0", r_vtype);
+		return false;
+	}
+	r_disable_drive_letter = ldm_relative(buffer, buflen, 0x18, r_vtype);
+	if (r_disable_drive_letter < 0) {
+		ldm_error("r_disable_drive_letter %d < 0",
+				r_disable_drive_letter);
+		return false;
+	}
+	r_child = ldm_relative(buffer, buflen, 0x2D, r_disable_drive_letter);
+	if (r_child < 0) {
+		ldm_error("r_child %d < 0", r_child);
+		return false;
+	}
+	r_size = ldm_relative(buffer, buflen, 0x3D, r_child);
+	if (r_size < 0) {
+		ldm_error("r_size %d < 0", r_size);
+		return false;
+	}
+	if (buffer[0x12] & VBLK_FLAG_VOLU_ID1) {
+		r_id1 = ldm_relative(buffer, buflen, 0x52, r_size);
+		if (r_id1 < 0) {
+			ldm_error("r_id1 %d < 0", r_id1);
+			return false;
+		}
+	} else
 		r_id1 = r_size;
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_ID2)
-		r_id2 = ldm_relative (buffer, buflen, 0x53, r_id1);
-	else
+	if (buffer[0x12] & VBLK_FLAG_VOLU_ID2) {
+		r_id2 = ldm_relative(buffer, buflen, 0x52, r_id1);
+		if (r_id2 < 0) {
+			ldm_error("r_id2 %d < 0", r_id2);
+			return false;
+		}
+	} else
 		r_id2 = r_id1;
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_SIZE)
-		r_size2 = ldm_relative (buffer, buflen, 0x53, r_id2);
-	else
+	if (buffer[0x12] & VBLK_FLAG_VOLU_SIZE) {
+		r_size2 = ldm_relative(buffer, buflen, 0x52, r_id2);
+		if (r_size2 < 0) {
+			ldm_error("r_size2 %d < 0", r_size2);
+			return false;
+		}
+	} else
 		r_size2 = r_id2;
-
-	if (buffer[0x12] & VBLK_FLAG_VOLU_DRIVE)
-		r_drive = ldm_relative (buffer, buflen, 0x53, r_size2);
-	else
+	if (buffer[0x12] & VBLK_FLAG_VOLU_DRIVE) {
+		r_drive = ldm_relative(buffer, buflen, 0x52, r_size2);
+		if (r_drive < 0) {
+			ldm_error("r_drive %d < 0", r_drive);
+			return false;
+		}
+	} else
 		r_drive = r_size2;
-
 	len = r_drive;
-	if (len < 0)
+	if (len < 0) {
+		ldm_error("len %d < 0", len);
 		return false;
-
+	}
 	len += VBLK_SIZE_VOL5;
-	if (len != BE32 (buffer + 0x14))
+	if (len > BE32(buffer + 0x14)) {
+		ldm_error("len %d > BE32(buffer + 0x14) %d", len,
+				BE32(buffer + 0x14));
 		return false;
-
+	}
 	volu = &vb->vblk.volu;
-
-	ldm_get_vstr (buffer + 0x18 + r_name,  volu->volume_type,
-		sizeof (volu->volume_type));
-	memcpy (volu->volume_state, buffer + 0x19 + r_vtype,
-			sizeof (volu->volume_state));
-	volu->size = ldm_get_vnum (buffer + 0x3E + r_child);
-	volu->partition_type = buffer[0x42 + r_size];
-	memcpy (volu->guid, buffer + 0x43 + r_size,  sizeof (volu->guid));
+	ldm_get_vstr(buffer + 0x18 + r_name, volu->volume_type,
+			sizeof(volu->volume_type));
+	memcpy(volu->volume_state, buffer + 0x18 + r_disable_drive_letter,
+			sizeof(volu->volume_state));
+	volu->size = ldm_get_vnum(buffer + 0x3D + r_child);
+	volu->partition_type = buffer[0x41 + r_size];
+	memcpy(volu->guid, buffer + 0x42 + r_size, sizeof(volu->guid));
 	if (buffer[0x12] & VBLK_FLAG_VOLU_DRIVE) {
-		ldm_get_vstr (buffer + 0x53 + r_size,  volu->drive_hint,
-			sizeof (volu->drive_hint));
+		ldm_get_vstr(buffer + 0x52 + r_size, volu->drive_hint,
+				sizeof(volu->drive_hint));
 	}
 	return true;
 }
diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
index d2e6a30..80f63b5 100644
--- a/fs/partitions/ldm.h
+++ b/fs/partitions/ldm.h
@@ -68,7 +68,7 @@ struct parsed_partitions;
 #define VBLK_SIZE_DSK3		12
 #define VBLK_SIZE_DSK4		45
 #define VBLK_SIZE_PRT3		28
-#define VBLK_SIZE_VOL5		59
+#define VBLK_SIZE_VOL5		58
 
 /* component types */
 #define COMP_STRIPE		0x01		/* Stripe-set */
