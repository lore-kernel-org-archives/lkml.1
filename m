Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbYEFUer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbYEFUer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763710AbYEFUeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:34:11 -0400
Received: from mx1.riseup.net ([204.13.164.18]:39134 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbYEFUeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:34:06 -0400
Date: Tue, 6 May 2008 22:33:54 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] DLM: Convert connections_lock in a mutex
Message-ID: <20080506203354.GB27656@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Patrick Caulfield <pcaulfie@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distributed Lock Manager: The semaphore connections_lock is used as a
mutex. Convert it to the mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 7c1e5e5..adda877 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -138,7 +138,7 @@ static struct workqueue_struct *recv_workqueue;
 static struct workqueue_struct *send_workqueue;
 
 static DEFINE_IDR(connections_idr);
-static DECLARE_MUTEX(connections_lock);
+static DEFINE_MUTEX(connections_lock);
 static int max_nodeid;
 static struct kmem_cache *con_cache;
 
@@ -205,9 +205,9 @@ static struct connection *nodeid2con(int nodeid, gfp_t allocation)
 {
 	struct connection *con;
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	con = __nodeid2con(nodeid, allocation);
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 
 	return con;
 }
@@ -218,15 +218,15 @@ static struct connection *assoc2con(int assoc_id)
 	int i;
 	struct connection *con;
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	for (i=0; i<=max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con && con->sctp_assoc == assoc_id) {
-			up(&connections_lock);
+			mutex_unlock(&connections_lock);
 			return con;
 		}
 	}
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 	return NULL;
 }
 
@@ -381,7 +381,7 @@ static void sctp_init_failed(void)
 	int i;
 	struct connection *con;
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	for (i=1; i<=max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (!con)
@@ -393,7 +393,7 @@ static void sctp_init_failed(void)
 			}
 		}
 	}
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 }
 
 /* Something happened to an association */
@@ -1417,7 +1417,7 @@ void dlm_lowcomms_stop(void)
 	/* Set all the flags to prevent any
 	   socket activity.
 	*/
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	for (i = 0; i <= max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con) {
@@ -1426,11 +1426,11 @@ void dlm_lowcomms_stop(void)
 				con->sock->sk->sk_user_data = NULL;
 		}
 	}
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 
 	work_stop();
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	clean_writequeues();
 
 	for (i = 0; i <= max_nodeid; i++) {
@@ -1443,7 +1443,7 @@ void dlm_lowcomms_stop(void)
 		}
 	}
 	max_nodeid = 0;
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 	kmem_cache_destroy(con_cache);
 	idr_init(&connections_idr);
 }

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

    I am incapable of conceiving infinity, and yet I do not accept finity
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
