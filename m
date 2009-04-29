Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbZD2WXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbZD2WXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbZD2WVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:12 -0400
Received: from kroah.org ([198.145.64.141]:40232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbZD2WVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:23 2009
Message-Id: <20090429220923.770520966@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:06 -0700
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
       alan@lxorguk.ukuu.org.uk, Sridhar Vinay <vinaysridhar@in.ibm.com>,
       Shirish Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 07/58] CIFS: Fix memory overwrite when saving nativeFileSystem field during mount
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0022-CIFS-Fix-memory-overwrite-when-saving-nativeFileSys.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/cifs/CHANGES   |    3 +++
 fs/cifs/connect.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/CHANGES
+++ b/fs/cifs/CHANGES
@@ -1,4 +1,7 @@
 Fix oops in cifs_dfs_ref.c when prefixpath is not reachable when using DFS.
+Fix "redzone overwritten" bug in cifs_put_tcon (CIFSTcon may allocate too
+little memory for the "nativeFileSystem" field returned by the server
+during mount).
 
 Version 1.54
 ------------
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3549,7 +3549,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 			    BCC(smb_buffer_response)) {
 				kfree(tcon->nativeFileSystem);
 				tcon->nativeFileSystem =
-				    kzalloc(length + 2, GFP_KERNEL);
+				    kzalloc(2*(length + 1), GFP_KERNEL);
 				if (tcon->nativeFileSystem)
 					cifs_strfromUCS_le(
 						tcon->nativeFileSystem,


