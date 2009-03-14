Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZCNBYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZCNBYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZCNBTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:54 -0400
Received: from kroah.org ([198.145.64.141]:34839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752684AbZCNBTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:33 2009
Message-Id: <20090314011033.090722418@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:49 -0700
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
Subject: [patch 012/114] [CIFS] Fix oops in cifs_strfromUCS_le mounting to servers which do not specify their OS
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=fix-oops-in-cifs_strfromucs_le-mounting-to-servers-which-do-not-specify-their-os.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit 69765529d701c838df19ea1f5ad2f33a528261ae upstream.

Fixes kernel bug #10451 http://bugzilla.kernel.org/show_bug.cgi?id=10451

Certain NAS appliances do not set the operating system or network operating system
fields in the session setup response on the wire.  cifs was oopsing on the unexpected
zero length response fields (when trying to null terminate a zero length field).

This fixes the oops.

Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/CHANGES |    2 ++
 fs/cifs/sess.c  |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/CHANGES
+++ b/fs/cifs/CHANGES
@@ -1,3 +1,5 @@
+Fix oops in cifs_dfs_ref.c when prefixpath is not reachable when using DFS.
+
 Version 1.55
 ------------
 Various fixes to make delete of open files behavior more predictable
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -228,7 +228,7 @@ static int decode_unicode_ssetup(char **
 
 	kfree(ses->serverOS);
 	/* UTF-8 string will not grow more than four times as big as UCS-16 */
-	ses->serverOS = kzalloc(4 * len, GFP_KERNEL);
+	ses->serverOS = kzalloc((4 * len) + 2 /* trailing null */, GFP_KERNEL);
 	if (ses->serverOS != NULL)
 		cifs_strfromUCS_le(ses->serverOS, (__le16 *)data, len, nls_cp);
 	data += 2 * (len + 1);
@@ -241,7 +241,7 @@ static int decode_unicode_ssetup(char **
 		return rc;
 
 	kfree(ses->serverNOS);
-	ses->serverNOS = kzalloc(4 * len, GFP_KERNEL); /* BB this is wrong length FIXME BB */
+	ses->serverNOS = kzalloc((4 * len) + 2 /* trailing null */, GFP_KERNEL);
 	if (ses->serverNOS != NULL) {
 		cifs_strfromUCS_le(ses->serverNOS, (__le16 *)data, len,
 				   nls_cp);


