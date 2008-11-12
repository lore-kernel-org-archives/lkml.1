Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYKLAlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYKLAlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYKLA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:58 -0500
Received: from kroah.org ([198.145.64.141]:42610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753885AbYKLA05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:57 -0500
Date: Tue, 11 Nov 2008 16:24:20 -0800
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
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>
Subject: [patch 41/49] KEYS: Make request key instantiate the per-user
	keyrings
Message-ID: <20081112002420.GP10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="keys-make-request-key-instantiate-the-per-user-keyrings.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 1f8f5cf6e4f038552a3e47b66085452c08556d71 upstream

Make request_key() instantiate the per-user keyrings so that it doesn't oops
if it needs to get hold of the user session keyring because there isn't a
session keyring in place.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Steve French <smfrench@gmail.com>
Tested-by: Rutger Nijlunsing <rutger.nijlunsing@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/internal.h     |    1 +
 security/keys/process_keys.c |    2 +-
 security/keys/request_key.c  |    4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -107,6 +107,7 @@ extern key_ref_t search_process_keyrings
 
 extern struct key *find_keyring_by_name(const char *name, bool skip_perm_check);
 
+extern int install_user_keyrings(struct task_struct *tsk);
 extern int install_thread_keyring(struct task_struct *tsk);
 extern int install_process_keyring(struct task_struct *tsk);
 
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -40,7 +40,7 @@ struct key_user root_key_user = {
 /*
  * install user and user session keyrings for a particular UID
  */
-static int install_user_keyrings(struct task_struct *tsk)
+int install_user_keyrings(struct task_struct *tsk)
 {
 	struct user_struct *user = tsk->user;
 	struct key *uid_keyring, *session_keyring;
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -74,6 +74,10 @@ static int call_sbin_request_key(struct 
 
 	kenter("{%d},{%d},%s", key->serial, authkey->serial, op);
 
+	ret = install_user_keyrings(tsk);
+	if (ret < 0)
+		goto error_alloc;
+
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 

-- 
