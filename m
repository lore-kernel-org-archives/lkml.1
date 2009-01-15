Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbZAOUEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbZAOUEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763373AbZAOUA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:26 -0500
Received: from kroah.org ([198.145.64.141]:48755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761893AbZAOUAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:19 -0500
Date: Thu, 15 Jan 2009 11:57:27 -0800
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
Subject: [patch 07/94] CIFS: make sure that DFS pathnames are properly
	formed
Message-ID: <20090115195727.GG14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-make-sure-that-dfs-pathnames-are-properly-formed.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit c6fbba0546d3ead18d4a623e76e28bcbaa66a325 upstream.

The paths in a DFS request are supposed to only have a single preceding
backslash, but we are sending them with a double backslash. This is
exposing a bug in Windows where it also sends a path in the response
that has a double backslash.

The existing code that builds the mount option string however expects a
double backslash prefix in a couple of places when it tries to use the
path returned by build_path_from_dentry. Fix compose_mount_options to
expect properly formed DFS paths (single backslash at front).

Also clean up error handling in that function. There was a possible
NULL pointer dereference and situations where a partially built option
string would be returned.

Tested against Samba 3.0.28-ish server and Samba 3.3 and Win2k8.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_dfs_ref.c |   48 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -122,7 +122,7 @@ static char *compose_mount_options(const
 				   char **devname)
 {
 	int rc;
-	char *mountdata;
+	char *mountdata = NULL;
 	int md_len;
 	char *tkn_e;
 	char *srvIP = NULL;
@@ -136,10 +136,9 @@ static char *compose_mount_options(const
 	*devname = cifs_get_share_name(ref->node_name);
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
-		cERROR(1, ("%s: Failed to resolve server part of %s to IP",
-			  __func__, *devname));
-		mountdata = ERR_PTR(rc);
-		goto compose_mount_options_out;
+		cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
+			  __func__, *devname, rc));;
+		goto compose_mount_options_err;
 	}
 	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
 	 * assuming that we have 'unc=' and 'ip=' in
@@ -149,8 +148,8 @@ static char *compose_mount_options(const
 		strlen(ref->node_name) + 12;
 	mountdata = kzalloc(md_len+1, GFP_KERNEL);
 	if (mountdata == NULL) {
-		mountdata = ERR_PTR(-ENOMEM);
-		goto compose_mount_options_out;
+		rc = -ENOMEM;
+		goto compose_mount_options_err;
 	}
 
 	/* copy all options except of unc,ip,prefixpath */
@@ -197,18 +196,32 @@ static char *compose_mount_options(const
 
 	/* find & copy prefixpath */
 	tkn_e = strchr(ref->node_name + 2, '\\');
-	if (tkn_e == NULL) /* invalid unc, missing share name*/
-		goto compose_mount_options_out;
+	if (tkn_e == NULL) {
+		/* invalid unc, missing share name*/
+		rc = -EINVAL;
+		goto compose_mount_options_err;
+	}
 
+	/*
+	 * this function gives us a path with a double backslash prefix. We
+	 * require a single backslash for DFS. Temporarily increment fullpath
+	 * to put it in the proper form and decrement before freeing it.
+	 */
 	fullpath = build_path_from_dentry(dentry);
+	if (!fullpath) {
+		rc = -ENOMEM;
+		goto compose_mount_options_err;
+	}
+	++fullpath;
 	tkn_e = strchr(tkn_e + 1, '\\');
-	if (tkn_e || strlen(fullpath) - (ref->path_consumed)) {
+	if (tkn_e || (strlen(fullpath) - ref->path_consumed)) {
 		strncat(mountdata, &sep, 1);
 		strcat(mountdata, "prefixpath=");
 		if (tkn_e)
 			strcat(mountdata, tkn_e + 1);
-		strcat(mountdata, fullpath + (ref->path_consumed));
+		strcat(mountdata, fullpath + ref->path_consumed);
 	}
+	--fullpath;
 	kfree(fullpath);
 
 	/*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
@@ -217,6 +230,11 @@ static char *compose_mount_options(const
 compose_mount_options_out:
 	kfree(srvIP);
 	return mountdata;
+
+compose_mount_options_err:
+	kfree(mountdata);
+	mountdata = ERR_PTR(rc);
+	goto compose_mount_options_out;
 }
 
 
@@ -309,13 +327,19 @@ cifs_dfs_follow_mountpoint(struct dentry
 		goto out_err;
 	}
 
+	/*
+	 * The MSDFS spec states that paths in DFS referral requests and
+	 * responses must be prefixed by a single '\' character instead of
+	 * the double backslashes usually used in the UNC. This function
+	 * gives us the latter, so we must adjust the result.
+	 */
 	full_path = build_path_from_dentry(dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 		goto out_err;
 	}
 
-	rc = get_dfs_path(xid, ses , full_path, cifs_sb->local_nls,
+	rc = get_dfs_path(xid, ses , full_path + 1, cifs_sb->local_nls,
 		&num_referrals, &referrals,
 		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 

