Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYLCUVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYLCUVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYLCT5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:37 -0500
Received: from kroah.org ([198.145.64.141]:56495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754461AbYLCT5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:36 -0500
Date: Wed, 3 Dec 2008 11:55:58 -0800
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
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 076/104] cifs: Fix check for tcon seal setting and fix oops
	on failed mount from earlier patch
Message-ID: <20081203195558.GY8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-check-for-tcon-seal-setting-and-fix-oops-on-failed-mount-from-earlier-patch.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit ab3f992983062440b4f37c666dac66d987902d91 upstream

set tcon->ses earlier

If the inital tree connect fails, we'll end up calling cifs_put_smb_ses
with a NULL pointer. Fix it by setting the tcon->ses earlier.

Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/connect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2256,16 +2256,18 @@ cifs_mount(struct super_block *sb, struc
 			cFYI(1, ("Found match on UNC path"));
 			/* existing tcon already has a reference */
 			cifs_put_smb_ses(pSesInfo);
+			if (tcon->seal != volume_info.seal)
+				cERROR(1, ("transport encryption setting "
+					   "conflicts with existing tid"));
 		} else {
 			tcon = tconInfoAlloc();
 			if (tcon == NULL) {
 				rc = -ENOMEM;
 				goto mount_fail_check;
 			}
+			tcon->ses = pSesInfo;
 
 			/* check for null share name ie connect to dfs root */
-
-			/* BB check if works for exactly length 3 strings */
 			if ((strchr(volume_info.UNC + 3, '\\') == NULL)
 			    && (strchr(volume_info.UNC + 3, '/') == NULL)) {
 				/* rc = connect_to_dfs_path(...) */
@@ -2283,7 +2285,6 @@ cifs_mount(struct super_block *sb, struc
 			if (rc)
 				goto mount_fail_check;
 			tcon->seal = volume_info.seal;
-			tcon->ses = pSesInfo;
 			write_lock(&cifs_tcp_ses_lock);
 			list_add(&tcon->tcon_list, &pSesInfo->tcon_list);
 			write_unlock(&cifs_tcp_ses_lock);

