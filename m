Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYGNUUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYGNUUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYGNUUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:20:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbYGNUUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:20:06 -0400
Date: Mon, 14 Jul 2008 15:14:28 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: dlm patches for 2.6.27
Message-ID: <20080714201428.GC11644@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the pending dlm patches for 2.6.27.  They are all trivial and
have been in linux-next for quite a while.  All but the one from me have
appeared on the list already, so I'm just putting a log of all below.

Dave


commit 18c60c0a3b16fc7d6a55497a228602ad8509f838
Author: Benny Halevy <bhalevy@panasas.com>
Date:   Mon Jun 30 19:59:14 2008 +0300

    dlm: fix uninitialized variable for search_rsb_list callers
    
    gcc 4.3.0 correctly emits the following warning.
    search_rsb_list does not *r_ret if no dlm_rsb is found
    and _search_rsb may pass the uninitialized value upstream
    on the error path when both calls to search_rsb_list
    return non-zero error.
    
    The fix sets *r_ret to NULL on search_rsb_list's not-found path.
    
    Signed-off-by: Benny Halevy <bhalevy@panasas.com>
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 7ba9586..724ddac 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -363,6 +363,7 @@ static int search_rsb_list(struct list_head *head, char *name, int len,
 		if (len == r->res_length && !memcmp(name, r->res_name, len))
 			goto found;
 	}
+	*r_ret = NULL;
 	return -EBADR;
 
  found:

commit 311f6fc77c51926dbdfbeab0a5d88d70f01fa3f4
Author: Masatake YAMATO <yamato@redhat.com>
Date:   Fri Jun 27 08:35:03 2008 -0500

    dlm: release socket on error
    
    It seems that `sock' allocated by sock_create_kern in
    tcp_connect_to_sock() of dlm/fs/lowcomms.c is not released if
    dlm_nodeid_to_addr an error.
    
    Acked-by: Christine Caulfield <ccaulfie@redhat.com>
    Signed-off-by: Masatake YAMATO <yamato@redhat.com>
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 637018c..3962262 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -891,8 +891,10 @@ static void tcp_connect_to_sock(struct connection *con)
 		goto out_err;
 
 	memset(&saddr, 0, sizeof(saddr));
-	if (dlm_nodeid_to_addr(con->nodeid, &saddr))
+	if (dlm_nodeid_to_addr(con->nodeid, &saddr)) {
+		sock_release(sock);
 		goto out_err;
+	}
 
 	sock->sk->sk_user_data = con;
 	con->rx_action = receive_from_sock;

commit 329fc4c37212588091b64bdf09afaeb18642aae2
Author: David Teigland <teigland@redhat.com>
Date:   Tue May 20 12:18:10 2008 -0500

    dlm: fix basts for granted CW waiting PR/CW
    
    The fix in commit 3650925893469ccb03dbcc6a440c5d363350f591 was addressing
    the case of a granted PR lock with waiting PR and CW locks.  It's a
    special case that requires forcing a CW bast.  However, that forced CW
    bast was incorrectly applying to a second condition where the granted
    lock was CW.  So, the holder of a CW lock could receive an extraneous CW
    bast instead of a PR bast.  This fix narrows the original special case to
    what was intended.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 2d3d102..7ba9586 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1782,7 +1782,8 @@ static void grant_pending_locks(struct dlm_rsb *r)
 
 	list_for_each_entry_safe(lkb, s, &r->res_grantqueue, lkb_statequeue) {
 		if (lkb->lkb_bastfn && lock_requires_bast(lkb, high, cw)) {
-			if (cw && high == DLM_LOCK_PR)
+			if (cw && high == DLM_LOCK_PR &&
+			    lkb->lkb_grmode == DLM_LOCK_PR)
 				queue_bast(r, lkb, DLM_LOCK_CW);
 			else
 				queue_bast(r, lkb, high);

commit 254ae43ab8d7877c980fca3636624e0777a70fa4
Author: Masatake YAMATO <yamato@redhat.com>
Date:   Wed May 28 14:45:10 2008 +0900

    dlm: check for null in device_write
    
    If `device_write' method is called via "dlm-control",
    file->private_data is NULL. (See ctl_device_open() in
    user.c. ) Through proc->flags is read.
    
    Signed-off-by: Masatake YAMATO <yamato@redhat.com>
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index ebbcf38..1aa76b3 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -538,7 +538,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 
 	/* do we really need this? can a write happen after a close? */
 	if ((kbuf->cmd == DLM_USER_LOCK || kbuf->cmd == DLM_USER_UNLOCK) &&
-	    test_bit(DLM_PROC_FLAGS_CLOSING, &proc->flags))
+	    (proc && test_bit(DLM_PROC_FLAGS_CLOSING, &proc->flags)))
 		return -EINVAL;
 
 	sigfillset(&allsigs);
