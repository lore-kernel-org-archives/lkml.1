Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZGNTPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZGNTPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZGNTP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:15:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbZGNTP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:15:28 -0400
Date: Tue, 14 Jul 2009 14:07:27 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fixes for 2.6.31-rc3
Message-ID: <20090714190727.GA7735@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull three dlm fixes from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

One fixes a socket leak people have been reporting, another fix for a posix
lock regression from several releases ago, and a warning removal.  Full
patches included for review.
Thanks,
Dave

Casey Dahlin (1):
      dlm: free socket in error exit path

David Teigland (1):
      dlm: fix plock use-after-free

Steven Whitehouse (1):
      dlm: Fix uninitialised variable warning in lock.c

 fs/dlm/lock.c     |    2 +-
 fs/dlm/lowcomms.c |    4 +++-
 fs/dlm/plock.c    |   17 ++++++++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)



commit a89d63a159b1ba5833be2bef00adf8ad8caac8be
Author: Casey Dahlin <cdahlin@redhat.com>
Date:   Tue Jul 14 12:17:51 2009 -0500

    dlm: free socket in error exit path
    
    In the tcp_connect_to_sock() error exit path, the socket
    allocated at the top of the function was not being freed.
    
    Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index cdb580a..618a60f 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -902,7 +902,7 @@ static void tcp_connect_to_sock(struct connection *con)
 	int result = -EHOSTUNREACH;
 	struct sockaddr_storage saddr, src_addr;
 	int addr_len;
-	struct socket *sock;
+	struct socket *sock = NULL;
 
 	if (con->nodeid == 0) {
 		log_print("attempt to connect sock 0 foiled");
@@ -962,6 +962,8 @@ out_err:
 	if (con->sock) {
 		sock_release(con->sock);
 		con->sock = NULL;
+	} else if (sock) {
+		sock_release(sock);
 	}
 	/*
 	 * Some errors are fatal and this list might need adjusting. For other

commit c78a87d0a1fc885dfdbe21fd5e07787691dfb068
Author: David Teigland <teigland@redhat.com>
Date:   Thu Jun 18 13:20:24 2009 -0500

    dlm: fix plock use-after-free
    
    Fix a regression from the original addition of nfs lock support
    586759f03e2e9031ac5589912a51a909ed53c30a.  When a synchronous
    (non-nfs) plock completes, the waiting thread will wake up and
    free the op struct.  This races with the user thread in
    dev_write() which goes on to read the op's callback field to
    check if the lock is async and needs a callback.  This check
    can happen on the freed op.  The fix is to note the callback
    value before the op can be freed.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 894a32d..16f682e 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -353,7 +353,7 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 {
 	struct dlm_plock_info info;
 	struct plock_op *op;
-	int found = 0;
+	int found = 0, do_callback = 0;
 
 	if (count != sizeof(info))
 		return -EINVAL;
@@ -366,21 +366,24 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 
 	spin_lock(&ops_lock);
 	list_for_each_entry(op, &recv_list, list) {
-		if (op->info.fsid == info.fsid && op->info.number == info.number &&
+		if (op->info.fsid == info.fsid &&
+		    op->info.number == info.number &&
 		    op->info.owner == info.owner) {
+			struct plock_xop *xop = (struct plock_xop *)op;
 			list_del_init(&op->list);
-			found = 1;
-			op->done = 1;
 			memcpy(&op->info, &info, sizeof(info));
+			if (xop->callback)
+				do_callback = 1;
+			else
+				op->done = 1;
+			found = 1;
 			break;
 		}
 	}
 	spin_unlock(&ops_lock);
 
 	if (found) {
-		struct plock_xop *xop;
-		xop = (struct plock_xop *)op;
-		if (xop->callback)
+		if (do_callback)
 			dlm_plock_callback(op);
 		else
 			wake_up(&recv_wq);

commit a566a6b11c86147fe9fc9db7ab15f9eecca3e862
Author: Steven Whitehouse <swhiteho@redhat.com>
Date:   Mon Jun 15 08:26:48 2009 +0100

    dlm: Fix uninitialised variable warning in lock.c
    
      CC [M]  fs/dlm/lock.o
    fs/dlm/lock.c: In function ‘find_rsb’:
    fs/dlm/lock.c:438: warning: ‘r’ may be used uninitialized in this function
    
    Since r is used on the error path to set r_ret, set it to NULL.
    
    Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 205ec95..eb507c4 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -435,7 +435,7 @@ static int search_rsb(struct dlm_ls *ls, char *name, int len, int b,
 static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 		    unsigned int flags, struct dlm_rsb **r_ret)
 {
-	struct dlm_rsb *r, *tmp;
+	struct dlm_rsb *r = NULL, *tmp;
 	uint32_t hash, bucket;
 	int error = -EINVAL;
 
