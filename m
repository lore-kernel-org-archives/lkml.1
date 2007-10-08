Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXJHScG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXJHScG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXJHSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:31:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53272 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXJHSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:31:54 -0400
Date: Mon, 8 Oct 2007 11:06:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 08/12] NLM: Fix a circular lock dependency in lockd
Message-ID: <20071008180629.GI7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nlm-fix-a-circular-lock-dependency-in-lockd.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 255129d1e9ca0ed3d69d5517fae3e03d7ab4b806 in upstream.

The problem is that the garbage collector for the 'host' structures
nlm_gc_hosts(), holds nlm_host_mutex while calling down to
nlmsvc_mark_resources, which, eventually takes the file->f_mutex.

We cannot therefore call nlmsvc_lookup_host() from within
nlmsvc_create_block, since the caller will already hold file->f_mutex, so
the attempt to grab nlm_host_mutex may deadlock.

Fix the problem by calling nlmsvc_lookup_host() outside the file->f_mutex.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/lockd/svclock.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -171,19 +171,14 @@ found:
  * GRANTED_RES message by cookie, without having to rely on the client's IP
  * address. --okir
  */
-static inline struct nlm_block *
-nlmsvc_create_block(struct svc_rqst *rqstp, struct nlm_file *file,
-		struct nlm_lock *lock, struct nlm_cookie *cookie)
+static struct nlm_block *
+nlmsvc_create_block(struct svc_rqst *rqstp, struct nlm_host *host,
+		    struct nlm_file *file, struct nlm_lock *lock,
+		    struct nlm_cookie *cookie)
 {
 	struct nlm_block	*block;
-	struct nlm_host		*host;
 	struct nlm_rqst		*call = NULL;
 
-	/* Create host handle for callback */
-	host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
-	if (host == NULL)
-		return NULL;
-
 	call = nlm_alloc_call(host);
 	if (call == NULL)
 		return NULL;
@@ -366,6 +361,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			struct nlm_lock *lock, int wait, struct nlm_cookie *cookie)
 {
 	struct nlm_block	*block = NULL;
+	struct nlm_host		*host;
 	int			error;
 	__be32			ret;
 
@@ -377,6 +373,10 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 				(long long)lock->fl.fl_end,
 				wait);
 
+	/* Create host handle for callback */
+	host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
+	if (host == NULL)
+		return nlm_lck_denied_nolocks;
 
 	/* Lock file against concurrent access */
 	mutex_lock(&file->f_mutex);
@@ -385,7 +385,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 	 */
 	block = nlmsvc_lookup_block(file, lock);
 	if (block == NULL) {
-		block = nlmsvc_create_block(rqstp, file, lock, cookie);
+		block = nlmsvc_create_block(rqstp, nlm_get_host(host), file,
+				lock, cookie);
 		ret = nlm_lck_denied_nolocks;
 		if (block == NULL)
 			goto out;
@@ -449,6 +450,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 out:
 	mutex_unlock(&file->f_mutex);
 	nlmsvc_release_block(block);
+	nlm_release_host(host);
 	dprintk("lockd: nlmsvc_lock returned %u\n", ret);
 	return ret;
 }
@@ -477,10 +479,15 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
 
 	if (block == NULL) {
 		struct file_lock *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+		struct nlm_host	*host;
 
 		if (conf == NULL)
 			return nlm_granted;
-		block = nlmsvc_create_block(rqstp, file, lock, cookie);
+		/* Create host handle for callback */
+		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
+		if (host == NULL)
+			return nlm_lck_denied_nolocks;
+		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
 		if (block == NULL) {
 			kfree(conf);
 			return nlm_granted;

-- 
