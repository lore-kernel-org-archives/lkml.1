Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbXLABEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbXLABEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758695AbXLABD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:03:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673AbXLABD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:03:27 -0500
Date: Fri, 30 Nov 2007 17:02:26 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [RFC] kobject: the new functions in use
Message-ID: <20071201010226.GD4745@kroah.com>
References: <20071201010038.GB4745@kroah.com> <20071201010123.GC4745@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201010123.GC4745@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an example of a number of different places in the kernel that
have been converted from the older kobject functions to the new
versions.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/char_dev.c      |    6 ++----
 kernel/module.c    |   14 ++++++--------
 kernel/params.c    |    6 ++----
 kernel/user.c      |    9 ++++-----
 mm/slub.c          |    9 ++++-----
 net/bridge/br_if.c |   10 +++-------
 6 files changed, 21 insertions(+), 33 deletions(-)

--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -510,9 +510,8 @@ struct cdev *cdev_alloc(void)
 {
 	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
 	if (p) {
-		p->kobj.ktype = &ktype_cdev_dynamic;
 		INIT_LIST_HEAD(&p->list);
-		kobject_init(&p->kobj);
+		kobject_init_ng(&p->kobj, &ktype_cdev_dynamic);
 	}
 	return p;
 }
@@ -529,8 +528,7 @@ void cdev_init(struct cdev *cdev, const 
 {
 	memset(cdev, 0, sizeof *cdev);
 	INIT_LIST_HEAD(&cdev->list);
-	cdev->kobj.ktype = &ktype_cdev_default;
-	kobject_init(&cdev->kobj);
+	kobject_init_ng(&cdev->kobj, &ktype_cdev_default);
 	cdev->ops = fops;
 }
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1218,18 +1218,16 @@ int mod_sysfs_init(struct module *mod)
 		err = -EINVAL;
 		goto out;
 	}
-	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
-	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->name);
-	if (err)
-		goto out;
-	mod->mkobj.kobj.kset = module_kset;
-	mod->mkobj.kobj.ktype = &module_ktype;
 	mod->mkobj.mod = mod;
 
-	kobject_init(&mod->mkobj.kobj);
+	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
+	mod->mkobj.kobj.kset = module_kset;
+	err = kobject_init_and_add(&mod->mkobj.kobj, &module_ktype, NULL,
+				   "%s", mod->name);
+	if (err)
+		kobject_put(&mod->mkobj.kobj);
 
 	/* delay uevent until full sysfs population */
-	err = kobject_add(&mod->mkobj.kobj);
 out:
 	return err;
 }
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -561,11 +561,9 @@ static void __init kernel_param_sysfs_se
 
 	mk->mod = THIS_MODULE;
 	mk->kobj.kset = module_kset;
-	mk->kobj.ktype = &module_ktype;
-	kobject_set_name(&mk->kobj, name);
-	kobject_init(&mk->kobj);
-	ret = kobject_add(&mk->kobj);
+	ret = kobject_init_and_add(&mk->kobj, &module_ktype, NULL, "%s", name);
 	if (ret) {
+		kobject_put(&mk->kobj);
 		printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
 		      "error number %d\n", name, ret);
 		printk(KERN_ERR	"The system will be unstable now.\n");
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -181,13 +181,12 @@ static int uids_user_create(struct user_
 	int error;
 
 	memset(kobj, 0, sizeof(struct kobject));
-	kobj->ktype = &uids_ktype;
 	kobj->kset = uids_kset;
-	kobject_init(kobj);
-	kobject_set_name(&up->kobj, "%d", up->uid);
-	error = kobject_add(kobj);
-	if (error)
+	error = kobject_init_and_add(kobj, &uids_ktype, NULL, "%d", up->uid);
+	if (error) {
+		kobject_put(kobj);
 		goto done;
+	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 done:
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4021,13 +4021,12 @@ static int sysfs_slab_add(struct kmem_ca
 		name = create_unique_id(s);
 	}
 
-	kobject_set_name(&s->kobj, name);
 	s->kobj.kset = slab_kset;
-	s->kobj.ktype = &slab_ktype;
-	kobject_init(&s->kobj);
-	err = kobject_add(&s->kobj);
-	if (err)
+	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, name);
+	if (err) {
+		kobject_put(&s->kobj);
 		return err;
+	}
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -258,12 +258,6 @@ static struct net_bridge_port *new_nbp(s
 	p->state = BR_STATE_DISABLED;
 	br_stp_port_timer_init(p);
 
-	kobject_init(&p->kobj);
-	kobject_set_name(&p->kobj, SYSFS_BRIDGE_PORT_ATTR);
-	p->kobj.ktype = &brport_ktype;
-	p->kobj.parent = &(dev->dev.kobj);
-	p->kobj.kset = NULL;
-
 	return p;
 }
 
@@ -379,7 +373,8 @@ int br_add_if(struct net_bridge *br, str
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
-	err = kobject_add(&p->kobj);
+	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
+				   SYSFS_BRIDGE_PORT_ATTR);
 	if (err)
 		goto err0;
 
@@ -416,6 +411,7 @@ err2:
 	br_fdb_delete_by_port(br, p, 1);
 err1:
 	kobject_del(&p->kobj);
+	return err;
 err0:
 	kobject_put(&p->kobj);
 	return err;
