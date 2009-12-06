Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZLGAMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZLGAMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZLGAM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:29 -0500
Received: from kroah.org ([198.145.64.141]:34164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbZLGAM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:41 2009
Message-Id: <20091207000641.522137060@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [006/119] CIFS: Duplicate data on appending to some Samba servers
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=cifs-duplicate-data-on-appending-to-some-samba-servers.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit cea62343956c24452700c06cf028b72414c58a74 upstream.

SMB writes are sent with a starting offset and length. When the server
supports the newer SMB trans2 posix open (rather than using the SMB
NTCreateX) a file can be opened with SMB_O_APPEND flag, and for that
case Samba server assumes that the offset sent in SMBWriteX is unneeded
since the write should go to the end of the file - which can cause
problems if the write was cached (since the beginning part of a
page could be written twice by the client mm).  Jeff suggested that
masking the flag on posix open on the client is easiest for the time
being. Note that recent Samba server also had an unrelated problem with
SMB NTCreateX and append (see samba bugzilla bug number 6898) which
should not affect current Linux clients (unless cifs Unix Extensions
are disabled).

The cifs client did not send the O_APPEND flag on posix open
before 2.6.29 so the fix is unneeded on early kernels.

In the future, for the non-cached case (O_DIRECT, and forcedirectio mounts)
it would be possible and useful to send O_APPEND on posix open (for Windows
case: FILE_APPEND_DATA but not FILE_WRITE_DATA on SMB NTCreateX) but for
cached writes although the vfs sets the offset to end of file it
may fragment a write across pages - so we can't send O_APPEND on
open (could result in sending part of a page twice).

Reviewed-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dir.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -212,8 +212,6 @@ int cifs_posix_open(char *full_path, str
 		posix_flags |= SMB_O_EXCL;
 	if (oflags & O_TRUNC)
 		posix_flags |= SMB_O_TRUNC;
-	if (oflags & O_APPEND)
-		posix_flags |= SMB_O_APPEND;
 	if (oflags & O_SYNC)
 		posix_flags |= SMB_O_SYNC;
 	if (oflags & O_DIRECTORY)


