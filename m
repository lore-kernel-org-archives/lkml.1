Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYLCUSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYLCUSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYLCTy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:59 -0500
Received: from kroah.org ([198.145.64.141]:60536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751558AbYLCTy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:58 -0500
Date: Wed, 3 Dec 2008 11:53:36 -0800
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
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 073/104] cifs: minor cleanup to cifs_mount
Message-ID: <20081203195336.GV8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-minor-cleanup-to-cifs_mount.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit d82c2df54e2f7e447476350848d8eccc8d2fe46a upstream

Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/connect.c |   74 ++++++++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1357,7 +1357,6 @@ cifs_find_tcp_session(struct sockaddr *a
 	list_for_each(tmp, &cifs_tcp_ses_list) {
 		server = list_entry(tmp, struct TCP_Server_Info,
 				    tcp_ses_list);
-
 		/*
 		 * the demux thread can exit on its own while still in CifsNew
 		 * so don't accept any sockets in that state. Since the
@@ -1378,6 +1377,7 @@ cifs_find_tcp_session(struct sockaddr *a
 
 		++server->srv_count;
 		write_unlock(&cifs_tcp_ses_lock);
+		cFYI(1, ("Existing tcp session with server found"));
 		return server;
 	}
 	write_unlock(&cifs_tcp_ses_lock);
@@ -2063,9 +2063,7 @@ cifs_mount(struct super_block *sb, struc
 	}
 
 	srvTcp = cifs_find_tcp_session(&addr);
-	if (srvTcp) {
-		cFYI(1, ("Existing tcp session with server found"));
-	} else {	/* create socket */
+	if (!srvTcp) { /* create socket */
 		if (addr.sa_family == AF_INET6) {
 			cFYI(1, ("attempting ipv6 connect"));
 			/* BB should we allow ipv6 on port 139? */
@@ -2272,44 +2270,40 @@ mount_fail_check:
 			cifs_put_smb_ses(pSesInfo);
 		else
 			cifs_put_tcp_session(srvTcp);
-	} else {
-		atomic_inc(&tcon->useCount);
-		cifs_sb->tcon = tcon;
-		tcon->ses = pSesInfo;
-
-		/* do not care if following two calls succeed - informational */
-		if (!tcon->ipc) {
-			CIFSSMBQFSDeviceInfo(xid, tcon);
-			CIFSSMBQFSAttributeInfo(xid, tcon);
-		}
+		goto out;
+	}
+	atomic_inc(&tcon->useCount);
+	cifs_sb->tcon = tcon;
+	tcon->ses = pSesInfo;
+
+	/* do not care if following two calls succeed - informational */
+	if (!tcon->ipc) {
+		CIFSSMBQFSDeviceInfo(xid, tcon);
+		CIFSSMBQFSAttributeInfo(xid, tcon);
+	}
 
-		/* tell server which Unix caps we support */
-		if (tcon->ses->capabilities & CAP_UNIX)
-			/* reset of caps checks mount to see if unix extensions
-			   disabled for just this mount */
-			reset_cifs_unix_caps(xid, tcon, sb, &volume_info);
-		else
-			tcon->unix_ext = 0; /* server does not support them */
+	/* tell server which Unix caps we support */
+	if (tcon->ses->capabilities & CAP_UNIX)
+		/* reset of caps checks mount to see if unix extensions
+		   disabled for just this mount */
+		reset_cifs_unix_caps(xid, tcon, sb, &volume_info);
+	else
+		tcon->unix_ext = 0; /* server does not support them */
 
-		/* convert forward to back slashes in prepath here if needed */
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == 0)
-			convert_delimiter(cifs_sb->prepath,
-					  CIFS_DIR_SEP(cifs_sb));
-
-		if ((tcon->unix_ext == 0) && (cifs_sb->rsize > (1024 * 127))) {
-			cifs_sb->rsize = 1024 * 127;
-			cFYI(DBG2,
-				("no very large read support, rsize now 127K"));
-		}
-		if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
-			cifs_sb->wsize = min(cifs_sb->wsize,
-					     (tcon->ses->server->maxBuf -
-					      MAX_CIFS_HDR_SIZE));
-		if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
-			cifs_sb->rsize = min(cifs_sb->rsize,
-					     (tcon->ses->server->maxBuf -
-					      MAX_CIFS_HDR_SIZE));
-	}
+	/* convert forward to back slashes in prepath here if needed */
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) == 0)
+		convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
+
+	if ((tcon->unix_ext == 0) && (cifs_sb->rsize > (1024 * 127))) {
+		cifs_sb->rsize = 1024 * 127;
+		cFYI(DBG2, ("no very large read support, rsize now 127K"));
+	}
+	if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
+		cifs_sb->wsize = min(cifs_sb->wsize,
+			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
+	if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
+		cifs_sb->rsize = min(cifs_sb->rsize,
+			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 
 	/* volume_info.password is freed above when existing session found
 	(in which case it is not needed anymore) but when new sesion is created

