Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXKBRFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXKBRFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXKBRFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:05:30 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45970 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754029AbXKBRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:05:29 -0400
Date: Fri, 2 Nov 2007 11:05:27 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/10] 9p: sysfs support for in-kenel servers
Message-ID: <20071102170527.GH16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs support for 9P servers.
Every server type is represented as a directory in /sys/fs/9p/srv. Initially
there is a single file in the directory -- 'clone'. Reading from the clone
file creates a new instance of the file server and returns its id. Each
instance is represented as a directory in /sys/fs/9p/srv/<file server>/. The
file server instance can be controlled by the 'ctl' file in its directory.
Currently the ctl file accepts the following commands:

	listen-add <trans> <options>
	listen-del <trans> <options>
	destroy

Example:
	echo 'listen-add tcp port=564' > /sys/fs/9p/srv/ramfs/0/ctl

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 include/net/9p/srv.h |   24 +++-
 net/9p/srv.c         |  386 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 405 insertions(+), 5 deletions(-)

diff --git a/include/net/9p/srv.h b/include/net/9p/srv.h
index 72d011e..a81ae8f 100644
--- a/include/net/9p/srv.h
+++ b/include/net/9p/srv.h
@@ -69,11 +69,17 @@ struct p9srv {
 	void			(*wstat)(struct p9srv_req *);
 
 	/* implementation specific */
+	int			id;
 	atomic_t		refcount;
 	spinlock_t		lock;		/* covers all srv fields */
+	unsigned long		status;
 	struct list_head	conn_list;	/* all connections for srv */
 	struct list_head	req_list;	/* requests not yet worked on */
 	struct list_head	workreq_list;	/* requests being worked on */
+	struct kobject		kobj;
+	struct list_head	srv_list;	/* all servers of a type */
+	struct list_head	lis_list;	/* all listeners for the srv */
+	struct work_struct	shutwork;
 };
 
 struct p9srv_conn {
@@ -90,6 +96,16 @@ struct p9srv_conn {
 	wait_queue_head_t	reset_wqueue;
 };
 
+struct p9srv_type {
+	spinlock_t		lock;
+	char			*name;
+	int			nextid;
+	struct kobject		kobj;
+	struct list_head	srv_list;	/* all servers of a type */
+	struct list_head	stype_list;	/* all server types */
+	struct p9srv*		(*create)(void);
+};
+
 enum {
 	/* connection status values */
 	Reset = 1,		/* resetting */
@@ -149,11 +165,11 @@ extern char *Enotfound;
 extern char *Eopen;
 extern char *Eexist;
 extern char *Enotempty;
-
+extern struct kset p9srv_subsys;
 
 struct p9srv *p9srv_srv_create(void);
 void p9srv_srv_stop(struct p9srv *srv);
-void p9srv_srv_destroy(struct p9srv *srv);
+void p9srv_srv_shutdown(struct p9srv *srv);
 void p9srv_srv_start(struct p9srv *srv);
 void p9srv_respond(struct p9srv_req *req, struct p9_fcall *rc);
 void p9srv_respond_error(struct p9srv_req *req, char *ename, int ecode);
@@ -165,5 +181,9 @@ void p9srv_conn_destroy(struct p9srv_conn *conn);
 struct p9srv_fid *p9srv_fid_find(struct p9srv_fidpool *fp, u32 fid);
 void p9srv_fid_incref(struct p9srv_fid *fid);
 void p9srv_fid_decref(struct p9srv_fid *fid);
+struct p9srv_type *p9srv_type_register(char *name, struct p9srv *(*create)(void));
+void p9srv_type_unregister(char *name);
+int p9srv_listener_add(struct p9srv *, char *, char *);
+int p9srv_listener_del(struct p9srv *, char *, char *);
 
 #endif
diff --git a/net/9p/srv.c b/net/9p/srv.c
index 855ac70..e0c359b 100644
--- a/net/9p/srv.c
+++ b/net/9p/srv.c
@@ -37,6 +37,18 @@ struct p9srv_fidpool {
 	struct hlist_head	hash[FID_HTABLE_SIZE];
 };
 
+struct p9srv_listener {
+	struct p9_trans_listener	*listener;
+	char				*name;
+	char				*options;
+	struct list_head		lis_list;
+};
+
+enum {
+	/* p9srv status */
+	Shutdown = 1,
+};
+
 enum {
 	/* p9srv_req status */
 	Respond = 1,
@@ -45,6 +57,8 @@ enum {
 };
 
 struct workqueue_struct *p9srv_wq;
+static DEFINE_SPINLOCK(p9srv_type_lock);
+static LIST_HEAD(p9srv_type_list);
 
 char *Eunknownfid = "unknown fid";
 EXPORT_SYMBOL(Eunknownfid);
@@ -78,9 +92,12 @@ char *Eexist = "file or directory already exists";
 EXPORT_SYMBOL(Eexist);
 char *Enotempty = "directory not empty";
 EXPORT_SYMBOL(Enotempty);
+decl_subsys_name(p9srv, srv, NULL, NULL);
+EXPORT_SYMBOL(p9srv_subsys);
 
 static void p9srv_srv_ref(struct p9srv *srv);
 static void p9srv_srv_unref(struct p9srv *srv);
+static void p9srv_shut_work(struct work_struct *work);
 static void p9srv_conn_reset(struct p9srv_conn *conn, struct p9srv_req *vreq);
 static void p9srv_conn_respond(struct p9srv_req *req);
 static struct p9srv_fidpool *p9srv_fidpool_create(void);
@@ -109,6 +126,14 @@ static void p9srv_stat(struct p9srv_req *);
 static void p9srv_wstat(struct p9srv_req *);
 static void p9srv_preq_work(struct work_struct *work);
 static void p9srv_conn_request(struct p9_trans *, struct p9_trans_req *req);
+static void p9srv_type_release(struct kobject *);
+static ssize_t p9srv_type_show(struct kobject *, struct attribute *, char *);
+static ssize_t p9srv_type_store(struct kobject *, struct attribute *,
+	const char *, size_t);
+static void p9srv_srv_release(struct kobject *);
+static ssize_t p9srv_srv_show(struct kobject *, struct attribute *, char *);
+static ssize_t p9srv_srv_store(struct kobject *, struct attribute *,
+	const char *, size_t);
 
 static void (*p9srv_fcall[])(struct p9srv_req *) = {
 	p9srv_version,		/* Tversion */
@@ -144,6 +169,36 @@ static void (*p9srv_fcall_post[])(struct p9srv_req *) = {
 	NULL,			/* Twstat */
 };
 
+static struct sysfs_ops p9srv_type_ops = {
+	.show = p9srv_type_show,
+	.store = p9srv_type_store,
+};
+
+static struct kobj_type p9srv_type_ktype = {
+	.release = p9srv_type_release,
+	.sysfs_ops = &p9srv_type_ops,
+};
+
+static struct attribute p9srv_clone_attr = {
+	.name = "clone",
+	.mode = 0444,
+};
+
+static struct sysfs_ops p9srv_srv_ops = {
+	.show = p9srv_srv_show,
+	.store = p9srv_srv_store,
+};
+
+static struct kobj_type p9srv_srv_ktype = {
+	.release = p9srv_srv_release,
+	.sysfs_ops = &p9srv_srv_ops,
+};
+
+static struct attribute p9srv_ctl_attr = {
+	.name = "ctl",
+	.mode = 0644,
+};
+
 struct p9srv *p9srv_srv_create(void)
 {
 	struct p9srv *srv;
@@ -156,10 +211,14 @@ struct p9srv *p9srv_srv_create(void)
 
 	memset(srv, 0, sizeof(struct p9srv));
 	spin_lock_init(&srv->lock);
+	srv->id = -1;
 	atomic_set(&srv->refcount, 1);
+	srv->status = 0;
 	INIT_LIST_HEAD(&srv->conn_list);
 	INIT_LIST_HEAD(&srv->req_list);
 	INIT_LIST_HEAD(&srv->workreq_list);
+	INIT_LIST_HEAD(&srv->lis_list);
+	INIT_WORK(&srv->shutwork, p9srv_shut_work);
 
 	/* the values below may be overwritten by the creator */
 	srv->msize = 65536 + P9_IOHDRSZ;
@@ -171,12 +230,32 @@ struct p9srv *p9srv_srv_create(void)
 }
 EXPORT_SYMBOL(p9srv_srv_create);
 
-void p9srv_srv_destroy(struct p9srv *srv)
+void p9srv_srv_shutdown(struct p9srv *srv)
 {
-	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
+	struct p9srv_listener *slis, *stmp;
+	LIST_HEAD(lis_list);
+
+	if (test_and_set_bit(Shutdown, &srv->status))
+		return;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "srv %p\n", srv);
+	spin_lock(&srv->lock);
+	list_for_each_entry_safe(slis, stmp, &srv->lis_list, lis_list) {
+		list_move(&slis->lis_list, &lis_list);
+	}
+	spin_unlock(&srv->lock);
+
+	list_for_each_entry_safe(slis, stmp, &lis_list, lis_list) {
+		list_del(&slis->lis_list);
+		(*slis->listener->destroy)(slis->listener);
+		kfree(slis);
+	}
+
+	sysfs_remove_file(&srv->kobj, &p9srv_ctl_attr);
+	kobject_unregister(&srv->kobj);
 	p9srv_srv_unref(srv);
 }
-EXPORT_SYMBOL(p9srv_srv_destroy);
+EXPORT_SYMBOL(p9srv_srv_shutdown);
 
 void p9srv_srv_ref(struct p9srv *srv)
 {
@@ -200,6 +279,14 @@ void p9srv_srv_unref(struct p9srv *srv)
 	}
 }
 
+static void p9srv_shut_work(struct work_struct *work)
+{
+	struct p9srv *srv;
+
+	srv = container_of(work, struct p9srv, shutwork);
+	p9srv_srv_shutdown(srv);
+}
+
 void p9srv_srv_start(struct p9srv *srv)
 {
 	P9_DPRINTK(P9SRV_DEBUG_SRV, "%p\n", srv);
@@ -366,6 +453,289 @@ void p9srv_req_unref(struct p9srv_req *req)
 }
 EXPORT_SYMBOL(p9srv_req_unref);
 
+struct p9srv_type *p9srv_type_register(char *name,
+	struct p9srv *(*create)(void))
+{
+	int err;
+	struct p9srv_type *ret, *stype;
+
+	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&ret->lock);
+	ret->name = name;
+	ret->nextid = 0;
+	INIT_LIST_HEAD(&ret->srv_list);
+	INIT_LIST_HEAD(&ret->stype_list);
+	ret->create = create;
+
+	spin_lock(&p9srv_type_lock);
+	list_for_each_entry(stype, &p9srv_type_list, stype_list) {
+		if (strcmp(name, stype->name) == 0) {
+			spin_unlock(&p9srv_type_lock);
+			kfree(ret);
+			return ERR_PTR(-EEXIST);
+		}
+	}
+
+	list_add_tail(&ret->stype_list, &p9srv_type_list);
+	spin_unlock(&p9srv_type_lock);
+
+	kobject_init(&ret->kobj);
+	kobject_set_name(&ret->kobj, "%s", name);
+	ret->kobj.parent = &p9srv_subsys.kobj;
+	ret->kobj.ktype = &p9srv_type_ktype;
+	err = kobject_add(&ret->kobj);
+	if (err)
+		goto error;
+
+	err = sysfs_create_file(&ret->kobj, &p9srv_clone_attr);
+	if (err)
+		goto error;
+
+	return ret;
+
+error:
+	kobject_unregister(&ret->kobj);
+	/* kfree ??? */
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9srv_type_register);
+
+void p9srv_type_unregister(char *name)
+{
+	struct p9srv_type *stype;
+
+	spin_lock(&p9srv_type_lock);
+	list_for_each_entry(stype, &p9srv_type_list, stype_list) {
+		if (strcmp(name, stype->name) == 0) {
+			list_del(&stype->stype_list);
+			spin_unlock(&p9srv_type_lock);
+			sysfs_remove_file(&stype->kobj, &p9srv_clone_attr);
+			kobject_unregister(&stype->kobj);
+			/* kfree ??? */
+			return;
+		}
+	}
+	spin_unlock(&p9srv_type_lock);
+}
+EXPORT_SYMBOL(p9srv_type_unregister);
+
+static void p9srv_type_release(struct kobject *kobj)
+{
+}
+
+static ssize_t p9srv_type_show(struct kobject *kobj, struct attribute *attr,
+	char *buf)
+{
+	int err;
+	struct p9srv_type *stype;
+	struct p9srv *srv;
+
+	stype = container_of(kobj, struct p9srv_type, kobj);
+	srv = (*stype->create)();
+	if (IS_ERR(srv))
+		return PTR_ERR(srv);
+
+	spin_lock(&stype->lock);
+	srv->id = stype->nextid++;
+	list_add_tail(&srv->srv_list, &stype->srv_list);
+	spin_unlock(&stype->lock);
+
+	kobject_init(&srv->kobj);
+	kobject_set_name(&srv->kobj, "%d", srv->id);
+	srv->kobj.parent = &stype->kobj;
+	srv->kobj.ktype = &p9srv_srv_ktype;
+	err = kobject_add(&srv->kobj);
+	if (err)
+		goto error;
+
+	err = sysfs_create_file(&srv->kobj, &p9srv_ctl_attr);
+	if (err)
+		goto error;
+
+	return snprintf(buf, PAGE_SIZE, "%d", srv->id);
+
+error:
+	spin_lock(&stype->lock);
+	list_del(&srv->srv_list);
+	spin_unlock(&stype->lock);
+	kobject_unregister(&srv->kobj);
+	/* kfree ??? */
+	return err;
+}
+
+static ssize_t p9srv_type_store(struct kobject *kobj, struct attribute *attr,
+	const char *buf, size_t buflen)
+{
+	return -EPERM;
+}
+
+static void p9srv_srv_release(struct kobject *kobj)
+{
+}
+
+static ssize_t p9srv_srv_show(struct kobject *kobj, struct attribute *attr,
+	char *buf)
+{
+	struct p9srv *srv;
+
+	srv = container_of(kobj, struct p9srv, kobj);
+	return snprintf(buf, PAGE_SIZE, "%d\n", srv->id);
+}
+
+static ssize_t p9srv_srv_store(struct kobject *kobj, struct attribute *attr,
+	const char *buf, size_t buflen)
+{
+	int n, err;
+	char *args[7];
+	char *p, *ep;
+	struct p9srv *srv;
+
+	srv = container_of(kobj, struct p9srv, kobj);
+	if (test_bit(Shutdown, &srv->status))
+		return -ENOENT;
+
+	p = (char *) buf;
+	ep = (char *) buf + buflen - 1;
+	while (*ep == '\n')
+		ep--;
+
+	ep++;
+	*ep = '\0';
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "buf '%s'\n", p);
+	for(n = 0; n < ARRAY_SIZE(args) && p < ep; n++) {
+		args[n] = p;
+		p = strchr(p, ' ');
+		if (!p)
+			break;
+
+		*p = '\0';
+		p++;
+	}
+
+	while (*args[n] == '\0')
+		n--;
+
+	n++;
+	if (n == 0)
+		return -EINVAL;
+
+	if (strcmp(args[0], "listen-add") == 0) {
+		if (n == 2)
+			args[2] = NULL;
+		else if (n < 2 || n > 3)
+			return -EINVAL;
+
+		err = p9srv_listener_add(srv, args[1], args[2]);
+		if (err)
+			return err;
+	} else if (strcmp(args[0], "listen-del") == 0) {
+		if (n == 2)
+			args[2] = NULL;
+		else if (n < 2 || n > 3)
+			return -EINVAL;
+
+		err = p9srv_listener_del(srv, args[1], args[2]);
+		if (err)
+			return err;
+	} else if (strcmp(args[0], "shutdown") == 0) {
+		/* we can't call p9srv_shutdown directly because
+		   kobject_unregister will wait for the kobject
+		   that we hold to be freed (and that won't happen) */
+		queue_work(p9srv_wq, &srv->shutwork);
+	} else {
+		return -EINVAL;
+	}
+
+	return buflen;
+}
+
+static void p9srv_newtrans(struct p9_trans_listener *l, struct p9_trans *trans)
+{
+	struct p9srv *srv;
+
+	srv = l->aux;
+	if (!trans) {
+		P9_DPRINTK(P9SRV_DEBUG_SRV, "listener err %d\n", l->err);
+		return;
+	}
+
+	if (test_bit(Shutdown, &srv->status)) {
+		(*trans->destroy)(trans);
+		return;
+	}
+
+	p9srv_conn_create(srv, trans);
+}
+
+
+int p9srv_listener_add(struct p9srv *srv, char *lname, char *options)
+{
+	substring_t tname;
+	struct p9_trans_module *tmod;
+	struct p9_trans_listener *lis;
+	struct p9srv_listener *slis;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "listener '%s' options '%s'\n",
+		lname, options);
+	tname.from = lname;
+	tname.to = lname + strlen(lname);
+	tmod = v9fs_match_trans(&tname);
+	if (!tmod)
+		return -ENOENT;
+
+	lis = tmod->create_listener(options);
+	if (IS_ERR(lis))
+		return PTR_ERR(lis);
+
+	lis->newtrans = p9srv_newtrans;
+	lis->aux = srv;
+
+	slis = kmalloc(sizeof(*slis) + strlen(lname) + strlen(options) + 2,
+		GFP_KERNEL);
+	if (!slis) {
+		(*lis->destroy)(lis);
+		return -ENOMEM;
+	}
+
+	slis->listener = lis;
+	slis->name = (char *) slis + sizeof(*slis);
+	slis->options = slis->name + strlen(lname) + 1;
+	strcpy(slis->name, lname);
+	strcpy(slis->options, options);
+	INIT_LIST_HEAD(&slis->lis_list);
+	spin_lock(&srv->lock);
+	list_add_tail(&slis->lis_list, &srv->lis_list);
+	spin_unlock(&srv->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(p9srv_listener_add);
+
+int p9srv_listener_del(struct p9srv *srv, char *lname, char *options)
+{
+	struct p9srv_listener *slis;
+
+	P9_DPRINTK(P9SRV_DEBUG_SRV, "listener '%s' options '%s'\n",
+		lname, options);
+	spin_lock(&srv->lock);
+	list_for_each_entry(slis, &srv->lis_list, lis_list) {
+		if (!strcmp(lname, slis->name) &&
+					!strcmp(options, slis->options)) {
+			list_del(&slis->lis_list);
+			spin_unlock(&srv->lock);
+			(*slis->listener->destroy)(slis->listener);
+			kfree(slis);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL(p9srv_listener_del);
+
 static void p9srv_version(struct p9srv_req *req)
 {
 	int msize;
@@ -1258,17 +1628,27 @@ void p9srv_conn_respond(struct p9srv_req *req)
 
 static int __init p9srv_init(void)
 {
+	int err;
+
 	p9srv_wq = create_workqueue("9psrv");
 	if (!p9srv_wq) {
 		printk(KERN_WARNING "9psrv: creating workqueue failed\n");
 		return -ENOMEM;
 	}
 
+	kobj_set_kset_s(&p9srv_subsys, p9_subsys);
+	err = subsystem_register(&p9srv_subsys);
+	if (err) {
+		destroy_workqueue(p9srv_wq);
+		return err;
+	}
+
 	return 0;
 }
 
 static void __exit p9srv_exit(void)
 {
+	subsystem_unregister(&p9srv_subsys);
 	destroy_workqueue(p9srv_wq);
 	p9srv_wq = NULL;
 }
