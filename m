Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXH1T3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXH1T3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbXH1TOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:14:50 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:52002 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762085AbXH1TOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:14:44 -0400
X-Greylist: delayed 1348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 15:14:43 EDT
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lguest@ozlabs.org, v9fs-developer@lists.sourceforge.net,
       kvm-devel@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@opteron (none)>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [RFC] 9p: Make transports dynamic
Date: Tue, 28 Aug 2007 13:52:37 -0500
Message-Id: <11883271601227-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
In-Reply-To: <11883271601857-git-send-email-ericvh@gmail.com>
References: <11883271601857-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@opteron.(none)>

This patch abstracts out the interfaces to underlying transports so that
new transports can be added as modules.  This should also allow kernel
configuration of transports without ifdef-hell.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 Documentation/filesystems/9p.txt |    8 +-
 fs/9p/v9fs.c                     |  149 +++++++-------
 fs/9p/v9fs.h                     |   15 +--
 fs/9p/vfs_super.c                |   19 +--
 include/net/9p/client.h          |    4 +-
 include/net/9p/conn.h            |    4 +-
 include/net/9p/transport.h       |   25 ++-
 net/9p/Kconfig                   |   10 +
 net/9p/Makefile                  |    5 +-
 net/9p/client.c                  |    2 +-
 net/9p/mux.c                     |    4 +-
 net/9p/trans_fd.c                |  419 ++++++++++++++++++++++++--------------
 12 files changed, 379 insertions(+), 285 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index cda6905..1a5f50d 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -35,12 +35,12 @@ For remote file server:
 
 For Plan 9 From User Space applications (http://swtch.com/plan9)
 
-	mount -t 9p `namespace`/acme /mnt/9 -o proto=unix,uname=$USER
+	mount -t 9p `namespace`/acme /mnt/9 -o trans=unix,uname=$USER
 
 OPTIONS
 =======
 
-  proto=name	select an alternative transport.  Valid options are
+  trans=name	select an alternative transport.  Valid options are
   		currently:
  			unix - specifying a named pipe mount point
  			tcp  - specifying a normal TCP/IP connection
@@ -68,9 +68,9 @@ OPTIONS
 			0x40 = display transport debug
 			0x80 = display allocation debug
 
-  rfdno=n	the file descriptor for reading with proto=fd
+  rfdno=n	the file descriptor for reading with trans=fd
 
-  wfdno=n	the file descriptor for writing with proto=fd
+  wfdno=n	the file descriptor for writing with trans=fd
 
   maxdata=n	the number of bytes to use for 9p packet payload (msize)
 
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 0a7068e..08d880f 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -37,18 +37,58 @@
 #include "v9fs_vfs.h"
 
 /*
+ * Dynamic Transport Registration Routines
+ *
+ */
+
+static LIST_HEAD(v9fs_trans_list);
+static struct p9_trans_module *v9fs_default_trans;
+
+/**
+ * v9fs_register_trans - register a new transport with 9p
+ * @m - structure describing the transport module and entry points
+ *
+ */
+void v9fs_register_trans(struct p9_trans_module *m)
+{
+	list_add_tail(&m->list, &v9fs_trans_list);
+	if (m->def)
+		v9fs_default_trans = m;
+}
+EXPORT_SYMBOL(v9fs_register_trans);
+
+/**
+ * v9fs_match_trans - match transport versus registered transports
+ * @arg: string identifying transport
+ *
+ */
+static struct p9_trans_module *v9fs_match_trans(const substring_t *name)
+{
+	struct list_head *p;
+	struct p9_trans_module *t = NULL;
+
+	list_for_each(p, &v9fs_trans_list) {
+		t = list_entry(p, struct p9_trans_module, list);
+		if (strncmp(t->name, name->from, name->to-name->from) == 0) {
+			P9_DPRINTK(P9_DEBUG_TRANS, "trans=%s\n", t->name);
+			break;
+		}
+	}
+	return t;
+}
+
+/*
   * Option Parsing (code inspired by NFS code)
-  *
+  *  NOTE: each transport will parse its own options
   */
 
 enum {
 	/* Options that take integer arguments */
-	Opt_debug, Opt_port, Opt_msize, Opt_uid, Opt_gid, Opt_afid,
-	Opt_rfdno, Opt_wfdno,
+	Opt_debug, Opt_msize, Opt_uid, Opt_gid, Opt_afid,
 	/* String options */
-	Opt_uname, Opt_remotename,
+	Opt_uname, Opt_remotename, Opt_trans,
 	/* Options that take no arguments */
-	Opt_legacy, Opt_nodevmap, Opt_unix, Opt_tcp, Opt_fd, Opt_pci,
+	Opt_legacy, Opt_nodevmap,
 	/* Cache options */
 	Opt_cache_loose,
 	/* Error token */
@@ -57,24 +97,13 @@ enum {
 
 static match_table_t tokens = {
 	{Opt_debug, "debug=%x"},
-	{Opt_port, "port=%u"},
 	{Opt_msize, "msize=%u"},
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_afid, "afid=%u"},
-	{Opt_rfdno, "rfdno=%u"},
-	{Opt_wfdno, "wfdno=%u"},
 	{Opt_uname, "uname=%s"},
 	{Opt_remotename, "aname=%s"},
-	{Opt_unix, "proto=unix"},
-	{Opt_tcp, "proto=tcp"},
-	{Opt_fd, "proto=fd"},
-#ifdef CONFIG_PCI_9P
-	{Opt_pci, "proto=pci"},
-#endif
-	{Opt_tcp, "tcp"},
-	{Opt_unix, "unix"},
-	{Opt_fd, "fd"},
+	{Opt_trans, "trans=%s"},
 	{Opt_legacy, "noextend"},
 	{Opt_nodevmap, "nodevmap"},
 	{Opt_cache_loose, "cache=loose"},
@@ -82,12 +111,6 @@ static match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-extern struct p9_transport *p9pci_trans_create(void);
-
-/*
- *  Parse option string.
- */
-
 /**
  * v9fs_parse_options - parse mount options into session structure
  * @options: options string passed from mount
@@ -95,23 +118,21 @@ extern struct p9_transport *p9pci_trans_create(void);
  *
  */
 
-static void v9fs_parse_options(char *options, struct v9fs_session_info *v9ses)
+static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 {
-	char *p;
+	char *options = v9ses->options;
 	substring_t args[MAX_OPT_ARGS];
+	char *p;
 	int option;
 	int ret;
 
 	/* setup defaults */
-	v9ses->port = V9FS_PORT;
-	v9ses->maxdata = 9000;
-	v9ses->proto = PROTO_TCP;
+	v9ses->maxdata = 8192;
 	v9ses->extended = 1;
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
-	v9ses->rfdno = ~0;
-	v9ses->wfdno = ~0;
 	v9ses->cache = 0;
+	v9ses->trans = v9fs_default_trans;
 
 	if (!options)
 		return;
@@ -135,9 +156,6 @@ static void v9fs_parse_options(char *options, struct v9fs_session_info *v9ses)
 			p9_debug_level = option;
 #endif
 			break;
-		case Opt_port:
-			v9ses->port = option;
-			break;
 		case Opt_msize:
 			v9ses->maxdata = option;
 			break;
@@ -150,23 +168,8 @@ static void v9fs_parse_options(char *options, struct v9fs_session_info *v9ses)
 		case Opt_afid:
 			v9ses->afid = option;
 			break;
-		case Opt_rfdno:
-			v9ses->rfdno = option;
-			break;
-		case Opt_wfdno:
-			v9ses->wfdno = option;
-			break;
-		case Opt_tcp:
-			v9ses->proto = PROTO_TCP;
-			break;
-		case Opt_unix:
-			v9ses->proto = PROTO_UNIX;
-			break;
-		case Opt_pci:
-			v9ses->proto = PROTO_PCI;
-			break;
-		case Opt_fd:
-			v9ses->proto = PROTO_FD;
+		case Opt_trans:
+			v9ses->trans = v9fs_match_trans(&args[0]);
 			break;
 		case Opt_uname:
 			match_strcpy(v9ses->name, &args[0]);
@@ -201,7 +204,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		  const char *dev_name, char *data)
 {
 	int retval = -EINVAL;
-	struct p9_transport *trans;
+	struct p9_trans *trans = NULL;
 	struct p9_fid *fid;
 
 	v9ses->name = __getname();
@@ -217,39 +220,30 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	strcpy(v9ses->name, V9FS_DEFUSER);
 	strcpy(v9ses->remotename, V9FS_DEFANAME);
 
-	v9fs_parse_options(data, v9ses);
-
-	switch (v9ses->proto) {
-	case PROTO_TCP:
-		trans = p9_trans_create_tcp(dev_name, v9ses->port);
-		break;
-	case PROTO_UNIX:
-		trans = p9_trans_create_unix(dev_name);
-		*v9ses->remotename = 0;
-		break;
-	case PROTO_FD:
-		trans = p9_trans_create_fd(v9ses->rfdno, v9ses->wfdno);
-		*v9ses->remotename = 0;
-		break;
-#ifdef CONFIG_PCI_9P
-	case PROTO_PCI:
-		trans = p9pci_trans_create();
-		*v9ses->remotename = 0;
-		break;
-#endif
-	default:
-		printk(KERN_ERR "v9fs: Bad mount protocol %d\n", v9ses->proto);
-		retval = -ENOPROTOOPT;
+	v9ses->options = kstrdup(data, GFP_KERNEL);
+	v9fs_parse_options(v9ses);
+
+	if ((v9ses->trans == NULL) && !list_empty(&v9fs_trans_list))
+		v9ses->trans = list_first_entry(&v9fs_trans_list,
+		 struct p9_trans_module, list);
+
+	if (v9ses->trans == NULL) {
+		retval = -EPROTONOSUPPORT;
+		P9_DPRINTK(P9_DEBUG_ERROR,
+				"No transport defined or default transport\n");
 		goto error;
-	};
+	}
 
+	trans = v9ses->trans->create(dev_name, v9ses->options);
 	if (IS_ERR(trans)) {
 		retval = PTR_ERR(trans);
 		trans = NULL;
 		goto error;
 	}
+	if ((v9ses->maxdata+P9_IOHDRSZ) > v9ses->trans->maxsize)
+		v9ses->maxdata = v9ses->trans->maxsize-P9_IOHDRSZ;
 
-	v9ses->clnt = p9_client_create(trans, v9ses->maxdata + P9_IOHDRSZ,
+	v9ses->clnt = p9_client_create(trans, v9ses->maxdata+P9_IOHDRSZ,
 		v9ses->extended);
 
 	if (IS_ERR(v9ses->clnt)) {
@@ -290,6 +284,7 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 
 	__putname(v9ses->name);
 	__putname(v9ses->remotename);
+	kfree(v9ses->options);
 }
 
 /**
@@ -311,7 +306,7 @@ extern int v9fs_error_init(void);
 static int __init init_v9fs(void)
 {
 	printk(KERN_INFO "Installing v9fs 9p2000 file system support\n");
-
+	/* TODO: Setup list of registered trasnport modules */
 	return register_filesystem(&v9fs_fs_type);
 }
 
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index abc4b16..7eb135c 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -31,31 +31,20 @@ struct v9fs_session_info {
 	unsigned int maxdata;
 	unsigned char extended;	/* set to 1 if we are using UNIX extensions */
 	unsigned char nodev;	/* set to 1 if no disable device mapping */
-	unsigned short port;	/* port to connect to */
 	unsigned short debug;	/* debug level */
-	unsigned short proto;	/* protocol to use */
 	unsigned int afid;	/* authentication fid */
-	unsigned int rfdno;	/* read file descriptor number */
-	unsigned int wfdno;	/* write file descriptor number */
 	unsigned int cache;	/* cache mode */
 
+	char *options;		/* copy of mount options */
 	char *name;		/* user name to mount as */
 	char *remotename;	/* name of remote hierarchy being mounted */
 	unsigned int uid;	/* default uid/muid for legacy support */
 	unsigned int gid;	/* default gid for legacy support */
-
+	struct p9_trans_module *trans; /* 9p transport */
 	struct p9_client *clnt;	/* 9p client */
 	struct dentry *debugfs_dir;
 };
 
-/* possible values of ->proto */
-enum {
-	PROTO_TCP,
-	PROTO_UNIX,
-	PROTO_FD,
-	PROTO_PCI,
-};
-
 /* possible values of ->cache */
 /* eventually support loose, tight, time, session, default always none */
 enum {
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index ba90437..bb0cef9 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -216,24 +216,7 @@ static int v9fs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct v9fs_session_info *v9ses = mnt->mnt_sb->s_fs_info;
 
-	if (v9ses->debug != 0)
-		seq_printf(m, ",debug=%x", v9ses->debug);
-	if (v9ses->port != V9FS_PORT)
-		seq_printf(m, ",port=%u", v9ses->port);
-	if (v9ses->maxdata != 9000)
-		seq_printf(m, ",msize=%u", v9ses->maxdata);
-	if (v9ses->afid != ~0)
-		seq_printf(m, ",afid=%u", v9ses->afid);
-	if (v9ses->proto == PROTO_UNIX)
-		seq_puts(m, ",proto=unix");
-	if (v9ses->extended == 0)
-		seq_puts(m, ",noextend");
-	if (v9ses->nodev == 1)
-		seq_puts(m, ",nodevmap");
-	seq_printf(m, ",name=%s", v9ses->name);
-	seq_printf(m, ",aname=%s", v9ses->remotename);
-	seq_printf(m, ",uid=%u", v9ses->uid);
-	seq_printf(m, ",gid=%u", v9ses->gid);
+	seq_printf(m, "%s", v9ses->options);
 	return 0;
 }
 
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index d65ed7c..0adafdb 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -29,7 +29,7 @@ struct p9_client {
 	spinlock_t lock; /* protect client structure */
 	int msize;
 	unsigned char dotu;
-	struct p9_transport *trans;
+	struct p9_trans *trans;
 	struct p9_conn *conn;
 
 	struct p9_idpool *fidpool;
@@ -52,7 +52,7 @@ struct p9_fid {
 	struct list_head dlist;	/* list of all fids attached to a dentry */
 };
 
-struct p9_client *p9_client_create(struct p9_transport *trans, int msize,
+struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 								int dotu);
 void p9_client_destroy(struct p9_client *clnt);
 void p9_client_disconnect(struct p9_client *clnt);
diff --git a/include/net/9p/conn.h b/include/net/9p/conn.h
index 583b6a2..756d878 100644
--- a/include/net/9p/conn.h
+++ b/include/net/9p/conn.h
@@ -42,8 +42,8 @@ struct p9_req;
  */
 typedef void (*p9_conn_req_callback)(struct p9_req *req, void *a);
 
-struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
-	unsigned char *dotu);
+struct p9_conn *p9_conn_create(struct p9_trans *trans, int msize,
+							unsigned char *dotu);
 void p9_conn_destroy(struct p9_conn *);
 int p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc, struct p9_fcall **rc);
 
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 462d422..7c68b3e 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -26,24 +26,29 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
-enum p9_transport_status {
+enum p9_trans_status {
 	Connected,
 	Disconnected,
 	Hung,
 };
 
-struct p9_transport {
-	enum p9_transport_status status;
+struct p9_trans {
+	enum p9_trans_status status;
 	void *priv;
+	int (*write) (struct p9_trans *, void *, int);
+	int (*read) (struct p9_trans *, void *, int);
+	void (*close) (struct p9_trans *);
+	unsigned int (*poll)(struct p9_trans *, struct poll_table_struct *);
+};
 
-	int (*write) (struct p9_transport *, void *, int);
-	int (*read) (struct p9_transport *, void *, int);
-	void (*close) (struct p9_transport *);
-	unsigned int (*poll)(struct p9_transport *, struct poll_table_struct *);
+struct p9_trans_module {
+	struct list_head list;
+	char *name;		/* name of transport */
+	int maxsize;		/* max message size of transport */
+	int def;		/* this transport should be default */
+	struct p9_trans * (*create)(const char *devname, char *options);
 };
 
-struct p9_transport *p9_trans_create_tcp(const char *addr, int port);
-struct p9_transport *p9_trans_create_unix(const char *addr);
-struct p9_transport *p9_trans_create_fd(int rfd, int wfd);
+void v9fs_register_trans(struct p9_trans_module *m);
 
 #endif /* NET_9P_TRANSPORT_H */
diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index 66821cd..09566ae 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -13,6 +13,16 @@ menuconfig NET_9P
 
 	  If unsure, say N.
 
+config NET_9P_FD
+	depends on NET_9P
+	default y if NET_9P
+	tristate "9P File Descriptor Transports (Experimental)"
+	help
+	  This builds support for file descriptor transports for 9p
+	  which includes support for TCP/IP, named pipes, or passed
+	  file descriptors.  TCP/IP is the default transport for 9p,
+	  so if you are going to use 9p, you'll likely want this.  
+
 config NET_9P_DEBUG
 	bool "Debug information"
 	depends on NET_9P
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 85b3a78..7b2a67a 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,8 +1,8 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
+obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 
 9pnet-objs := \
 	mod.o \
-	trans_fd.o \
 	mux.o \
 	client.o \
 	conv.o \
@@ -11,3 +11,6 @@ obj-$(CONFIG_NET_9P) := 9pnet.o
 	util.o \
 
 9pnet-$(CONFIG_SYSCTL) += sysctl.o
+
+9pnet_fd-objs := \
+	trans_fd.o \
diff --git a/net/9p/client.c b/net/9p/client.c
index cb17075..e161012 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -38,7 +38,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt);
 static void p9_fid_destroy(struct p9_fid *fid);
 static struct p9_stat *p9_clone_stat(struct p9_stat *st, int dotu);
 
-struct p9_client *p9_client_create(struct p9_transport *trans, int msize,
+struct p9_client *p9_client_create(struct p9_trans *trans, int msize,
 								   int dotu)
 {
 	int err, n;
diff --git a/net/9p/mux.c b/net/9p/mux.c
index 5d70558..934e2ea 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -71,7 +71,7 @@ struct p9_conn {
 	struct p9_mux_poll_task *poll_task;
 	int msize;
 	unsigned char *extended;
-	struct p9_transport *trans;
+	struct p9_trans *trans;
 	struct p9_idpool *tagpool;
 	int err;
 	wait_queue_head_t equeue;
@@ -271,7 +271,7 @@ static void p9_mux_poll_stop(struct p9_conn *m)
  * @msize - maximum message size
  * @extended - pointer to the extended flag
  */
-struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
+struct p9_conn *p9_conn_create(struct p9_trans *trans, int msize,
 				    unsigned char *extended)
 {
 	int i, n;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index fd636e9..30269a4 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -5,7 +5,7 @@
  *
  *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
  *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004-2005 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2004-2007 by Eric Van Hensbergen <ericvh@gmail.com>
  *  Copyright (C) 1997-2002 by Ron Minnich <rminnich@sarnoff.com>
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -36,160 +36,114 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <linux/file.h>
+#include <linux/parser.h>
 #include <net/9p/9p.h>
 #include <net/9p/transport.h>
 
 #define P9_PORT 564
+#define MAX_SOCK_BUF (64*1024)
+
+
+struct p9_fd_opts {
+	int rfd;
+	int wfd;
+	u16 port;
+};
 
 struct p9_trans_fd {
 	struct file *rd;
 	struct file *wr;
 };
 
-static int p9_socket_open(struct p9_transport *trans, struct socket *csocket);
-static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd);
-static int p9_fd_read(struct p9_transport *trans, void *v, int len);
-static int p9_fd_write(struct p9_transport *trans, void *v, int len);
-static unsigned int p9_fd_poll(struct p9_transport *trans,
-						struct poll_table_struct *pt);
-static void p9_fd_close(struct p9_transport *trans);
-
-struct p9_transport *p9_trans_create_tcp(const char *addr, int port)
-{
-	int err;
-	struct p9_transport *trans;
-	struct socket *csocket;
-	struct sockaddr_in sin_server;
-
-	csocket = NULL;
-	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	sin_server.sin_family = AF_INET;
-	sin_server.sin_addr.s_addr = in_aton(addr);
-	sin_server.sin_port = htons(port);
-	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
-
-	if (!csocket) {
-		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
-		err = -EIO;
-		goto error;
-	}
-
-	err = csocket->ops->connect(csocket,
-				    (struct sockaddr *)&sin_server,
-				    sizeof(struct sockaddr_in), 0);
-	if (err < 0) {
-		P9_EPRINTK(KERN_ERR,
-			"p9_trans_tcp: problem connecting socket to %s\n",
-			addr);
-		goto error;
-	}
-
-	err = p9_socket_open(trans, csocket);
-	if (err < 0)
-		goto error;
+/*
+  * Option Parsing (code inspired by NFS code)
+  *  - a little lazy - parse all fd-transport options
+  */
 
-	return trans;
+enum {
+	/* Options that take integer arguments */
+	Opt_port, Opt_rfdno, Opt_wfdno,
+};
 
-error:
-	if (csocket)
-		sock_release(csocket);
+static match_table_t tokens = {
+	{Opt_port, "port=%u"},
+	{Opt_rfdno, "rfdno=%u"},
+	{Opt_wfdno, "wfdno=%u"},
+};
 
-	kfree(trans);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL(p9_trans_create_tcp);
+/**
+ * v9fs_parse_options - parse mount options into session structure
+ * @options: options string passed from mount
+ * @v9ses: existing v9fs session information
+ *
+ */
 
-struct p9_transport *p9_trans_create_unix(const char *addr)
+static void parse_opts(char *options, struct p9_fd_opts *opts)
 {
-	int err;
-	struct socket *csocket;
-	struct sockaddr_un sun_server;
-	struct p9_transport *trans;
-
-	csocket = NULL;
-	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	int ret;
 
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
+	opts->port = P9_PORT;
+	opts->rfd = ~0;
+	opts->wfd = ~0;
 
-	if (strlen(addr) > UNIX_PATH_MAX) {
-		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
-			addr);
-		err = -ENAMETOOLONG;
-		goto error;
-	}
+	if (!options)
+		return;
 
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
-	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
-	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
-			sizeof(struct sockaddr_un) - 1, 0);
-	if (err < 0) {
-		P9_EPRINTK(KERN_ERR,
-			"p9_trans_unix: problem connecting socket: %s: %d\n",
-			addr, err);
-		goto error;
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+		token = match_token(p, tokens, args);
+		ret = match_int(&args[0], &option);
+		if (ret < 0) {
+			P9_DPRINTK(P9_DEBUG_ERROR,
+			 "integer field, but no integer?\n");
+			continue;
+		}
+		switch (token) {
+		case Opt_port:
+			opts->port = option;
+			break;
+		case Opt_rfdno:
+			opts->rfd = option;
+			break;
+		case Opt_wfdno:
+			opts->wfd = option;
+			break;
+		default:
+			continue;
+		}
 	}
-
-	err = p9_socket_open(trans, csocket);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	if (csocket)
-		sock_release(csocket);
-
-	kfree(trans);
-	return ERR_PTR(err);
 }
-EXPORT_SYMBOL(p9_trans_create_unix);
 
-struct p9_transport *p9_trans_create_fd(int rfd, int wfd)
+static int p9_fd_open(struct p9_trans *trans, int rfd, int wfd)
 {
-	int err;
-	struct p9_transport *trans;
+	struct p9_trans_fd *ts = kmalloc(sizeof(struct p9_trans_fd),
+					   GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
 
-	if (rfd == ~0 || wfd == ~0) {
-		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
-		return ERR_PTR(-ENOPROTOOPT);
+	ts->rd = fget(rfd);
+	ts->wr = fget(wfd);
+	if (!ts->rd || !ts->wr) {
+		if (ts->rd)
+			fput(ts->rd);
+		if (ts->wr)
+			fput(ts->wr);
+		kfree(ts);
+		return -EIO;
 	}
 
-	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	err = p9_fd_open(trans, rfd, wfd);
-	if (err < 0)
-		goto error;
-
-	return trans;
+	trans->priv = ts;
+	trans->status = Connected;
 
-error:
-	kfree(trans);
-	return ERR_PTR(err);
+	return 0;
 }
-EXPORT_SYMBOL(p9_trans_create_fd);
 
-static int p9_socket_open(struct p9_transport *trans, struct socket *csocket)
+static int p9_socket_open(struct p9_trans *trans, struct socket *csocket)
 {
 	int fd, ret;
 
@@ -212,30 +166,6 @@ static int p9_socket_open(struct p9_transport *trans, struct socket *csocket)
 	return 0;
 }
 
-static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd)
-{
-	struct p9_trans_fd *ts = kmalloc(sizeof(struct p9_trans_fd),
-					   GFP_KERNEL);
-	if (!ts)
-		return -ENOMEM;
-
-	ts->rd = fget(rfd);
-	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
-			fput(ts->rd);
-		if (ts->wr)
-			fput(ts->wr);
-		kfree(ts);
-		return -EIO;
-	}
-
-	trans->priv = ts;
-	trans->status = Connected;
-
-	return 0;
-}
-
 /**
  * p9_fd_read- read from a fd
  * @v9ses: session information
@@ -243,7 +173,7 @@ static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd)
  * @len: size of receive buffer
  *
  */
-static int p9_fd_read(struct p9_transport *trans, void *v, int len)
+static int p9_fd_read(struct p9_trans *trans, void *v, int len)
 {
 	int ret;
 	struct p9_trans_fd *ts = NULL;
@@ -270,7 +200,7 @@ static int p9_fd_read(struct p9_transport *trans, void *v, int len)
  * @len: size of send buffer
  *
  */
-static int p9_fd_write(struct p9_transport *trans, void *v, int len)
+static int p9_fd_write(struct p9_trans *trans, void *v, int len)
 {
 	int ret;
 	mm_segment_t oldfs;
@@ -297,7 +227,7 @@ static int p9_fd_write(struct p9_transport *trans, void *v, int len)
 }
 
 static unsigned int
-p9_fd_poll(struct p9_transport *trans, struct poll_table_struct *pt)
+p9_fd_poll(struct p9_trans *trans, struct poll_table_struct *pt)
 {
 	int ret, n;
 	struct p9_trans_fd *ts = NULL;
@@ -341,7 +271,7 @@ end:
  * @trans: private socket structure
  *
  */
-static void p9_fd_close(struct p9_transport *trans)
+static void p9_fd_close(struct p9_trans *trans)
 {
 	struct p9_trans_fd *ts;
 
@@ -361,3 +291,182 @@ static void p9_fd_close(struct p9_transport *trans)
 	kfree(ts);
 }
 
+static struct p9_trans *p9_trans_create_tcp(const char *addr, char *args)
+{
+	int err;
+	struct p9_trans *trans;
+	struct socket *csocket;
+	struct sockaddr_in sin_server;
+	struct p9_fd_opts opts;
+
+	parse_opts(args, &opts);
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	sin_server.sin_family = AF_INET;
+	sin_server.sin_addr.s_addr = in_aton(addr);
+	sin_server.sin_port = htons(opts.port);
+	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
+
+	if (!csocket) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
+		err = -EIO;
+		goto error;
+	}
+
+	err = csocket->ops->connect(csocket,
+				    (struct sockaddr *)&sin_server,
+				    sizeof(struct sockaddr_in), 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_tcp: problem connecting socket to %s\n",
+			addr);
+		goto error;
+	}
+
+	err = p9_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+
+static struct p9_trans *p9_trans_create_unix(const char *addr, char *args)
+{
+	int err;
+	struct socket *csocket;
+	struct sockaddr_un sun_server;
+	struct p9_trans *trans;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	if (strlen(addr) > UNIX_PATH_MAX) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
+			addr);
+		err = -ENAMETOOLONG;
+		goto error;
+	}
+
+	sun_server.sun_family = PF_UNIX;
+	strcpy(sun_server.sun_path, addr);
+	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
+	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
+			sizeof(struct sockaddr_un) - 1, 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_unix: problem connecting socket: %s: %d\n",
+			addr, err);
+		goto error;
+	}
+
+	err = p9_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+
+static struct p9_trans *p9_trans_create_fd(const char *name, char *args)
+{
+	int err;
+	struct p9_trans *trans;
+	struct p9_fd_opts opts;
+
+	parse_opts(args, &opts);
+
+	if (opts.rfd == ~0 || opts.wfd == ~0) {
+		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
+		return ERR_PTR(-ENOPROTOOPT);
+	}
+
+	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	err = p9_fd_open(trans, opts.rfd, opts.wfd);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	kfree(trans);
+	return ERR_PTR(err);
+}
+
+static struct p9_trans_module p9_tcp_trans = {
+	.name = "tcp",
+	.maxsize = MAX_SOCK_BUF,
+	.def = 1,
+	.create = p9_trans_create_tcp,
+};
+
+static struct p9_trans_module p9_unix_trans = {
+	.name = "unix",
+	.maxsize = MAX_SOCK_BUF,
+	.def = 0,
+	.create = p9_trans_create_unix,
+};
+
+static struct p9_trans_module p9_fd_trans = {
+	.name = "fd",
+	.maxsize = MAX_SOCK_BUF,
+	.def = 0,
+	.create = p9_trans_create_fd,
+};
+
+static int __init p9_trans_fd_init(void)
+{
+	v9fs_register_trans(&p9_tcp_trans);
+	v9fs_register_trans(&p9_unix_trans);
+	v9fs_register_trans(&p9_fd_trans);
+
+	return 1;
+}
+
+static void __exit p9_trans_fd_exit(void) {
+	printk(KERN_ERR "Removal of 9p transports not implemented\n");
+	BUG();
+}
+
+module_init(p9_trans_fd_init);
+module_exit(p9_trans_fd_exit);
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.0.2.gfbe3d-dirty

