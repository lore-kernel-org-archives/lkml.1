Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbXKBRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbXKBRBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXKBRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:01:25 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45953 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753843AbXKBRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:01:24 -0400
Date: Fri, 2 Nov 2007 11:01:23 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/10] 9p: tranport interface changes for in-kernel server
Message-ID: <20071102170123.GE16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in-kernel 9P server support to the transport interface.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 fs/9p/v9fs.c               |    2 +-
 include/net/9p/transport.h |   31 ++++++++++++++++++++++++++++---
 net/9p/mux.c               |    6 +++---
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index eeca7c7..c8bc530 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -210,7 +210,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		goto error;
 	}
 
-	trans = v9ses->trans->create(dev_name, v9ses->options);
+	trans = v9ses->trans->create_client(dev_name, v9ses->options);
 	if (IS_ERR(trans)) {
 		retval = PTR_ERR(trans);
 		trans = NULL;
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index b8eecc9..785595a 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -47,23 +47,48 @@ struct p9_trans {
 	void *aux;
 	void *priv;	/* transport specific */
 
-	/* The function schedules sending the data from the 'tc'
+	/* If client, the function schedules sending the data from the 'tc'
 	   over the transport. If the 'rc' is set, the response is
 	   read in it and the 'cb' is called.
+
+	   If server, when a request arrives p9_trans_req is allocated and
+	   the request content is stored in 'tc'. The transport sets 'cb'
+	   and 'cba' values. The server stores the response in the 'rc'
+	   fcall (or allocates one if NULL) and calls 'cb'.
+	   The server is responsible of freeing the req as well as req->tc
+	   and req->rc once the response is sent.
+	   The transport is allowed to call the request function with NULL
+	   value for 'req' if it's status ('err') is changed.
 	*/
 	void (*request)(struct p9_trans *trans, struct p9_trans_req *req);
 
-	/* If the request is not sent down the wire, don't send it. */
+	/* If client and the request is not sent down the wire, don't send it.
+	   If server, inform the transport that the server won't respond to
+	   that request. Returns error code, zero if successful.
+	*/
 	int (*cancel)(struct p9_trans *trans, struct p9_trans_req *req);
 	void (*destroy)(struct p9_trans *trans);
 };
 
+struct p9_trans_listener {
+	int err;
+	void *taux;	/* transport specific */
+	void *aux;	/* user set */
+
+	/* The newtrans callback is set by the user of the listener
+	   When there is a new incoming connection, newcann is called
+	   with p9_trans that represents it */
+	void (*newtrans)(struct p9_trans_listener *, struct p9_trans *);
+	void (*destroy)(struct p9_trans_listener *);
+};
+
 struct p9_trans_module {
 	struct list_head list;
 	char *name;		/* name of transport */
 	int maxsize;		/* max message size of transport */
 	int def;		/* this transport should be default */
-	struct p9_trans * (*create)(const char *devname, char *options);
+	struct p9_trans *(*create_client)(const char *devname, char *options);
+	struct p9_trans_listener *(*create_listener)(char *options);
 };
 
 void v9fs_register_trans(struct p9_trans_module *m);
diff --git a/net/9p/mux.c b/net/9p/mux.c
index 8a40a2e..3b0ed2c 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -157,21 +157,21 @@ static struct p9_trans_module p9_tcp_trans = {
 	.name = "tcp",
 	.maxsize = MAX_SOCK_BUF,
 	.def = 1,
-	.create = p9fd_create_tcp_client,
+	.create_client = p9fd_create_tcp_client,
 };
 
 static struct p9_trans_module p9_unix_trans = {
 	.name = "unix",
 	.maxsize = MAX_SOCK_BUF,
 	.def = 0,
-	.create = p9fd_create_unix_client,
+	.create_client = p9fd_create_unix_client,
 };
 
 static struct p9_trans_module p9_fd_trans = {
 	.name = "fd",
 	.maxsize = MAX_SOCK_BUF,
 	.def = 0,
-	.create = p9fd_create_fd_client,
+	.create_client = p9fd_create_fd_client,
 };
 
 /**
