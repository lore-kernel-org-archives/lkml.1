Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZBDSjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZBDSjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZBDShI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:08 -0500
Received: from kroah.org ([198.145.64.141]:50960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758281AbZBDShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:04 -0500
Date: Wed, 4 Feb 2009 10:34:29 -0800
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
       alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 07/33] cifs: make sure we allocate enough storage for
	socket address
Message-ID: <20090204183429.GH13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-make-sure-we-allocate-enough-storage-for-socket-address.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit a9ac49d303f967be0dabd97cb722c4a13109c6c2 upstream.

cifs_mount declares a struct sockaddr on the stack and then casts it
to the proper address type. The storage allocated is fine for ipv4,
but is too small for ipv6 addresses. Declare it as
"struct sockaddr_storage" instead of struct sockaddr".

This bug was manifesting itself as oopses and address corruption when
mounting IPv6 addresses.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1356,7 +1356,7 @@ cifs_parse_mount_options(char *options, 
 }
 
 static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr *addr)
+cifs_find_tcp_session(struct sockaddr_storage *addr)
 {
 	struct list_head *tmp;
 	struct TCP_Server_Info *server;
@@ -1376,11 +1376,11 @@ cifs_find_tcp_session(struct sockaddr *a
 		if (server->tcpStatus == CifsNew)
 			continue;
 
-		if (addr->sa_family == AF_INET &&
+		if (addr->ss_family == AF_INET &&
 		    (addr4->sin_addr.s_addr !=
 		     server->addr.sockAddr.sin_addr.s_addr))
 			continue;
-		else if (addr->sa_family == AF_INET6 &&
+		else if (addr->ss_family == AF_INET6 &&
 			 memcmp(&server->addr.sockAddr6.sin6_addr,
 				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))
 			continue;
@@ -2036,7 +2036,7 @@ cifs_mount(struct super_block *sb, struc
 	int rc = 0;
 	int xid;
 	struct socket *csocket = NULL;
-	struct sockaddr addr;
+	struct sockaddr_storage addr;
 	struct sockaddr_in *sin_server = (struct sockaddr_in *) &addr;
 	struct sockaddr_in6 *sin_server6 = (struct sockaddr_in6 *) &addr;
 	struct smb_vol volume_info;
@@ -2048,7 +2048,7 @@ cifs_mount(struct super_block *sb, struc
 
 /* cFYI(1, ("Entering cifs_mount. Xid: %d with: %s", xid, mount_data)); */
 
-	memset(&addr, 0, sizeof(struct sockaddr));
+	memset(&addr, 0, sizeof(struct sockaddr_storage));
 	memset(&volume_info, 0, sizeof(struct smb_vol));
 	if (cifs_parse_mount_options(mount_data, devname, &volume_info)) {
 		rc = -EINVAL;
@@ -2078,9 +2078,9 @@ cifs_mount(struct super_block *sb, struc
 			rc = cifs_inet_pton(AF_INET6, volume_info.UNCip,
 					    &sin_server6->sin6_addr.in6_u);
 			if (rc > 0)
-				addr.sa_family = AF_INET6;
+				addr.ss_family = AF_INET6;
 		} else {
-			addr.sa_family = AF_INET;
+			addr.ss_family = AF_INET;
 		}
 
 		if (rc <= 0) {
@@ -2122,7 +2122,7 @@ cifs_mount(struct super_block *sb, struc
 
 	srvTcp = cifs_find_tcp_session(&addr);
 	if (!srvTcp) { /* create socket */
-		if (addr.sa_family == AF_INET6) {
+		if (addr.ss_family == AF_INET6) {
 			cFYI(1, ("attempting ipv6 connect"));
 			/* BB should we allow ipv6 on port 139? */
 			/* other OS never observed in Wild doing 139 with v6 */
@@ -2153,7 +2153,7 @@ cifs_mount(struct super_block *sb, struc
 		} else {
 			srvTcp->noblocksnd = volume_info.noblocksnd;
 			srvTcp->noautotune = volume_info.noautotune;
-			if (addr.sa_family == AF_INET6)
+			if (addr.ss_family == AF_INET6)
 				memcpy(&srvTcp->addr.sockAddr6, sin_server6,
 					sizeof(struct sockaddr_in6));
 			else

