Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXEaXIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXEaXIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXEaXI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:08:26 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:6140 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXEaXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IOMtO/Yp2mxncOGRkXzLA6lOPmXXCSI3t/b3HoLOgEZYcFpT7TOQda3feBQjL/uZaBHXOB9T7lypoahcyluWbnvbhDSORFbwKPGGtW1XWkOAwDxeSnqX/0vDpwEOPUuQxbZ9/VROV7jVCj86QNY+m24uwzgHg2N3eyjNFTosmzM=
Message-ID: <524f69650705311608l5433dedj4ec4f903e9af3ce4@mail.gmail.com>
Date: Thu, 31 May 2007 18:08:23 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] support larger cifs network reads
Cc: linux-cifs-client@lists.samba.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With Samba 3.0.26pre it is now possible for a cifs client (one which
supports the newest Unix/Posix cifs extensions) to request up to
almost 8MB at a time on a cifs read request.

A patch for the cifs client to support larger reads follows.  In this
patch, using very large reads is not the default behavior, since it
would require larger buffer allocations for the large cifs request
buffers, but in the future when cifs can demultiplex reads to a page
list in the cifs_demultiplex_thread (without having to copy to a large
temporary buffer) this will be even more useful.

diff --git a/fs/cifs/README b/fs/cifs/README
index 4d01697..6ad722b 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -301,8 +301,19 @@ A partial list of the supported mount op
 		during the local client kernel build will be used.
 		If server does not support Unicode, this parameter is
 		unused.
-  rsize		default read size (usually 16K)
-  wsize		default write size (usually 16K, 32K is often better over GigE)
+  rsize		default read size (usually 16K). The client currently
+		can not use rsize larger than CIFSMaxBufSize. CIFSMaxBufSize
+		defaults to 16K and may be changed (from 8K to the maximum
+		kmalloc size allowed by your kernel) at module install time
+		for cifs.ko. Setting CIFSMaxBufSize to a very large value
+		will cause cifs to use more memory and may reduce performance
+		in some cases.  To use rsize greater than 127K (the original
+		cifs protocol maximum) also requires that the server support
+		a new Unix Capability flag (for very large read) which some
+		newer servers (e.g. Samba 3.0.26 or later) do. rsize can be
+		set from a minimum of 2048 to a maximum of 8388608 (depending
+		on the value of CIFSMaxBufSize)
+  wsize		default write size (default 57344)
 		maximum wsize currently allowed by CIFS is 57344 (14 4096 byte
 		pages)
   rw		mount the network share read-write (note that the
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d38c69b..8c4365d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -732,10 +732,21 @@ cifs_init_request_bufs(void)
 	/* Buffer size can not be smaller than 2 * PATH_MAX since maximum
 	Unicode path name has to fit in any SMB/CIFS path based frames */
 		CIFSMaxBufSize = 8192;
-	} else if (CIFSMaxBufSize > 1024*127) {
-		CIFSMaxBufSize = 1024 * 127;
 	} else {
-		CIFSMaxBufSize &= 0x1FE00; /* Round size to even 512 byte mult*/
+		if (CIFSMaxBufSize + MAX_CIFS_HDR_SIZE > KMALLOC_MAX_SIZE) {
+			CIFSMaxBufSize = KMALLOC_MAX_SIZE - MAX_CIFS_HDR_SIZE;
+			cERROR(1,("CIFSMaxBufSize too large, resetting to %ld",
+				   KMALLOC_MAX_SIZE));
+		}
+		
+		/* The length field is 3 bytes, but for time being we use only
+		 *  23 of the available 24 length bits */
+		if (CIFSMaxBufSize > 8388608) {
+			CIFSMaxBufSize = 8388608;
+			cERROR(1,
+				("CIFSMaxBufSize set to protocol max 8388608"));
+		} else	/* round buffer size to even 512 byte multiple */
+			CIFSMaxBufSize &= 0x7FFE00;
 	}
 /*	cERROR(1,("CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize)); */
 	cifs_req_cachep = kmem_cache_create("cifs_request",
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index d619ca7..6e6cda0 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1885,15 +1885,19 @@ typedef struct {
 #define CIFS_UNIX_POSIX_PATHNAMES_CAP   0x00000010 /* Allow POSIX
path chars  */
 #define CIFS_UNIX_POSIX_PATH_OPS_CAP    0x00000020 /* Allow new POSIX
path based
 						      calls including posix open
-						      and posix unlink */
+						      and posix unlink */
+#define CIFS_UNIX_LARGE_READ_CAP        0x00000040 /* support reads >128K (up
+						      to 0xFFFF00 */				
+#define CIFS_UNIX_LARGE_WRITE_CAP       0x00000080
+
 #ifdef CONFIG_CIFS_POSIX
 /* Can not set pathnames cap yet until we send new posix create SMB since
    otherwise server can treat such handles opened with older ntcreatex
    (by a new client which knows how to send posix path ops)
    as non-posix handles (can affect write behavior with byte range locks.
    We can add back in POSIX_PATH_OPS cap when Posix Create/Mkdir finished */
-/* #define CIFS_UNIX_CAP_MASK              0x0000003b */
-#define CIFS_UNIX_CAP_MASK              0x0000001b
+/* #define CIFS_UNIX_CAP_MASK              0x000000fb */
+#define CIFS_UNIX_CAP_MASK              0x000000db
 #else
 #define CIFS_UNIX_CAP_MASK              0x00000013
 #endif /* CONFIG_CIFS_POSIX */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f4e9266..0ba0d09 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1650,19 +1650,19 @@ void reset_cifs_unix_caps(int xid, struc
 		}
 		
 		cap &= CIFS_UNIX_CAP_MASK;
-		if(vol_info && vol_info->no_psx_acl)
+		if (vol_info && vol_info->no_psx_acl)
 			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
-		else if(CIFS_UNIX_POSIX_ACL_CAP & cap) {
+		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cFYI(1,("negotiated posix acl support"));
 			if(sb)
 				sb->s_flags |= MS_POSIXACL;
 		}

-		if(vol_info && vol_info->posix_paths == 0)
+		if (vol_info && vol_info->posix_paths == 0)
 			cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
-		else if(cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
+		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cFYI(1,("negotiate posix pathnames"));
-			if(sb)
+			if (sb)
 				CIFS_SB(sb)->mnt_cifs_flags |=
 					CIFS_MOUNT_POSIX_PATHS;
 		}
@@ -1670,21 +1670,32 @@ void reset_cifs_unix_caps(int xid, struc
 		/* We might be setting the path sep back to a different
 		form if we are reconnecting and the server switched its
 		posix path capability for this share */	
-		if(sb && (CIFS_SB(sb)->prepathlen > 0))
+		if (sb && (CIFS_SB(sb)->prepathlen > 0))
 			CIFS_SB(sb)->prepath[0] = CIFS_DIR_SEP(CIFS_SB(sb));
+
+		if (sb && (CIFS_SB(sb)->rsize > 127 * 1024)) {
+			if ((cap & CIFS_UNIX_LARGE_READ_CAP) == 0) {
+				CIFS_SB(sb)->rsize = 127 * 1024;
+			}
+		}
+		
 	
 		cFYI(1,("Negotiate caps 0x%x",(int)cap));
 #ifdef CONFIG_CIFS_DEBUG2
-		if(cap & CIFS_UNIX_FCNTL_CAP)
+		if (cap & CIFS_UNIX_FCNTL_CAP)
 			cFYI(1,("FCNTL cap"));
-		if(cap & CIFS_UNIX_EXTATTR_CAP)
+		if (cap & CIFS_UNIX_EXTATTR_CAP)
 			cFYI(1,("EXTATTR cap"));
-		if(cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
+		if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
 			cFYI(1,("POSIX path cap"));
-		if(cap & CIFS_UNIX_XATTR_CAP)
+		if (cap & CIFS_UNIX_XATTR_CAP)
 			cFYI(1,("XATTR cap"));
-		if(cap & CIFS_UNIX_POSIX_ACL_CAP)
+		if (cap & CIFS_UNIX_POSIX_ACL_CAP)
 			cFYI(1,("POSIX ACL cap"));
+		if (cap & CIFS_UNIX_LARGE_READ_CAP)
+			cFYI(1,("very large read cap"));
+		if (cap & CIFS_UNIX_LARGE_WRITE_CAP)
+			cFYI(1,("very large write cap"));
 #endif /* CIFS_DEBUG2 */
 		if (CIFSSMBSetFSUnixInfo(xid, tcon, cap)) {
 			cFYI(1,("setting capabilities failed"));
@@ -1935,7 +1946,8 @@ cifs_mount(struct super_block *sb, struc
 			cERROR(1,("rsize %d too large, using MaxBufSize",
 				volume_info.rsize));
 			cifs_sb->rsize = CIFSMaxBufSize;
-		} else if((volume_info.rsize) && (volume_info.rsize <= CIFSMaxBufSize))
+		} else if ((volume_info.rsize) &&
+				(volume_info.rsize <= CIFSMaxBufSize))
 			cifs_sb->rsize = volume_info.rsize;
 		else /* default */
 			cifs_sb->rsize = CIFSMaxBufSize;
@@ -2116,7 +2128,9 @@ cifs_mount(struct super_block *sb, struc
 		/* tell server which Unix caps we support */
 		if (tcon->ses->capabilities & CAP_UNIX)
 			reset_cifs_unix_caps(xid, tcon, sb, &volume_info);
-		
+		else if(cifs_sb->rsize > (1024 * 127)) {
+			cifs_sb->rsize = 1024 * 127;
+		}
 		if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
 			cifs_sb->wsize = min(cifs_sb->wsize,
 					     (tcon->ses->server->maxBuf -





-- 
Thanks,

Steve
