Return-Path: <linux-kernel-owner+w=401wt.eu-S1763843AbZCaXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763843AbZCaXVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbZCaXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:18 -0400
Received: from sous-sol.org ([216.99.217.87]:33098 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757275AbZCaXUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:13 -0400
Message-Id: <20090331231553.020951064@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Steve French <sfrench@us.ibm.com>,
       Sridhar Vinay <vinaysridhar@in.ibm.com>,
       Shirish Pargaonkar <shirishp@us.ibm.com>
Subject: [patch 22/45] CIFS: Fix memory overwrite when saving nativeFileSystem field during mount
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=cifs-fix-memory-overwrite-when-saving-nativefilesystem-field-during-mount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Steve French <sfrench@us.ibm.com>

upstream commit: b363b3304bcf68c4541683b2eff70b29f0446a5b

CIFS can allocate a few bytes to little for the nativeFileSystem field
during tree connect response processing during mount.  This can result
in a "Redzone overwritten" message to be logged.

Signed-off-by: Sridhar Vinay <vinaysridhar@in.ibm.com>
Acked-by: Shirish Pargaonkar <shirishp@us.ibm.com>
CC: Stable <stable@kernel.org>
Signed-off-by: Steve French <sfrench@us.ibm.com>
[chrisw: minor backport to CHANGES file]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/cifs/CHANGES   |    3 +++
 fs/cifs/connect.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/CHANGES
+++ b/fs/cifs/CHANGES
@@ -7,6 +7,9 @@ are authenticated as guest, as reconnect
 user's smb session.  This fix allows cifs to mount multiple times to the
 same server with different userids without risking invalidating earlier
 established security contexts.
+Fix "redzone overwritten" bug in cifs_put_tcon (CIFSTcon may allocate too
+little memory for the "nativeFileSystem" field returned by the server
+during mount). 
 
 Version 1.56
 ------------
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3667,7 +3667,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 			    BCC(smb_buffer_response)) {
 				kfree(tcon->nativeFileSystem);
 				tcon->nativeFileSystem =
-				    kzalloc(length + 2, GFP_KERNEL);
+				    kzalloc(2*(length + 1), GFP_KERNEL);
 				if (tcon->nativeFileSystem)
 					cifs_strfromUCS_le(
 						tcon->nativeFileSystem,

