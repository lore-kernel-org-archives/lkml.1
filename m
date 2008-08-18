Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYHRJo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYHRJo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYHRJos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:44:48 -0400
Received: from ozlabs.org ([203.10.76.45]:52762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYHRJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:44:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Date: Mon, 18 Aug 2008 19:43:22 +1000
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com> <87hc9kxpp8.fsf@basil.nowhere.org> <20080818034851.GB30843@kroah.com>
In-Reply-To: <20080818034851.GB30843@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181943.23034.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 13:48:51 Greg KH wrote:
> On Sun, Aug 17, 2008 at 05:53:07AM +0200, Andi Kleen wrote:
> > Greg KH <greg@kroah.com> writes:
> > >> No!
> > >
> > > What you are doing here is wrong, trying to create two files with the
> > > same name.  You just should not be doing that at all, it's that simple.
> > > Fix the broken code/link order, don't paper it over in the sysfs layer.
> >
> > Sorry, but relying on link order for anything is a mistake. It is subtle
> > and fragile and just means it'll eventually break again because it's
> > near impossible to properly maintain.
>
> We rely on link order for all sorts of things, this isn't new at all.

Sure, but this code should be rewritten to check if the directory exists,
rather assuming it based on "previous prefix was the same".

It's relying on a horribly undocumented assumption, and it broke.

We need to change kernel_param_sysfs_setup() to do something
like "kobject_find(module_kset, name)" and only allocate a new mk if that
fails.  Then we need to change the code to allow appending, like below.

diff -r e92a03313dc7 kernel/params.c
--- a/kernel/params.c	Mon Aug 18 14:16:00 2008 +1000
+++ b/kernel/params.c	Mon Aug 18 18:52:20 2008 +1000
@@ -384,6 +384,7 @@ struct param_attribute
 
 struct module_param_attrs
 {
+	unsigned int num;
 	struct attribute_group grp;
 	struct param_attribute attrs[0];
 };
@@ -434,69 +435,86 @@ static ssize_t param_attr_store(struct m
 
 #ifdef CONFIG_SYSFS
 /*
- * param_sysfs_setup - setup sysfs support for one module or KBUILD_MODNAME
+ * add_sysfs_param - add a parameter to sysfs
+ * @mp: pointer to previous module_param_attrs, or NULL.
  * @mk: struct module_kobject (contains parent kobject)
- * @kparam: array of struct kernel_param, the actual parameter definitions
- * @num_params: number of entries in array
- * @name_skip: offset where the parameter name start in kparam[].name. Needed for built-in "modules"
+ * @kparam: the actual parameter definition to add to sysfs
+ * @name: name of parameter
  *
- * Create a kobject for a (per-module) group of parameters, and create files
- * in sysfs. A pointer to the param_kobject is returned on success,
- * NULL if there's no parameter to export, or other ERR_PTR(err).
+ * Create a kobject if for a (per-module) parameter if mp NULL, and
+ * create file in sysfs.  Returns an error on out of memory.  Always cleans up
+ * if there's an error.
  */
-static __modinit struct module_param_attrs *
-param_sysfs_setup(struct module_kobject *mk,
-		  struct kernel_param *kparam,
-		  unsigned int num_params,
-		  unsigned int name_skip)
+static __modinit int add_sysfs_param(struct module_param_attrs **mp,
+				     struct module_kobject *mk,
+				     struct kernel_param *kp,
+				     const char *name)
 {
-	struct module_param_attrs *mp;
-	unsigned int valid_attrs = 0;
-	unsigned int i, size[2];
-	struct param_attribute *pattr;
-	struct attribute **gattr;
-	int err;
+	struct module_param_attrs *new;
+	struct attribute **attrs;
+	int err, num;
 
-	for (i=0; i<num_params; i++) {
-		if (kparam[i].perm)
-			valid_attrs++;
+	if (kp->perm == 0)
+		return 0;
+
+	if (!*mp) {
+		num = 0;
+		attrs = NULL;
+	} else {
+		num = (*mp)->num;
+		attrs = (*mp)->grp.attrs;
+		/* FIXME: This isn't safe, they could be holding ref right now. */
+		sysfs_remove_group(&mk->kobj, &(*mp)->grp);
 	}
 
-	if (!valid_attrs)
-		return NULL;
+	/* Enlarge. */
+	new = krealloc(*mp, sizeof(**mp) + sizeof((*mp)->attrs[0]) * (num+1), GFP_KERNEL);
+	if (!new) {
+		err = -ENOMEM;
+		goto fail;
+	}
+	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
+	if (!attrs) {
+		err = -ENOMEM;
+		goto fail_free_new;
+	}
 
-	size[0] = ALIGN(sizeof(*mp) +
-			valid_attrs * sizeof(mp->attrs[0]),
-			sizeof(mp->grp.attrs[0]));
-	size[1] = (valid_attrs + 1) * sizeof(mp->grp.attrs[0]);
+	/* Sysfs wants everything zeroed. */
+	memset(new, 0, sizeof(**mp));
+	memset(&new->attrs[num], 0, sizeof(new->attrs[num]));
+	memset(&attrs[num], 0, sizeof(attrs[num]));
+	new->grp.name = "parameters";
+	new->grp.attrs = attrs;
 
-	mp = kzalloc(size[0] + size[1], GFP_KERNEL);
-	if (!mp)
-		return ERR_PTR(-ENOMEM);
+	/* Tack new one on the end. */
+	new->attrs[num].param = kp;
+	new->attrs[num].mattr.show = param_attr_show;
+	new->attrs[num].mattr.store = param_attr_store;
+	new->attrs[num].mattr.attr.name = (char *)name;
+	new->attrs[num].mattr.attr.mode = kp->perm;
+	new->num = num+1;
 
-	mp->grp.name = "parameters";
-	mp->grp.attrs = (void *)mp + size[0];
+	/* Fix up all the pointers, since krealloc can move us */
+	for (num = 0; num < new->num; num++)
+		new->grp.attrs[num] = &new->attrs[num].mattr.attr;
+	new->grp.attrs[num] = NULL;
 
-	pattr = &mp->attrs[0];
-	gattr = &mp->grp.attrs[0];
-	for (i = 0; i < num_params; i++) {
-		struct kernel_param *kp = &kparam[i];
-		if (kp->perm) {
-			pattr->param = kp;
-			pattr->mattr.show = param_attr_show;
-			pattr->mattr.store = param_attr_store;
-			pattr->mattr.attr.name = (char *)&kp->name[name_skip];
-			pattr->mattr.attr.mode = kp->perm;
-			*(gattr++) = &(pattr++)->mattr.attr;
-		}
-	}
-	*gattr = NULL;
+	/* New param group? */
+	err = sysfs_create_group(&mk->kobj, &new->grp);
+	if (err)
+		goto fail_free_attrs;
 
-	if ((err = sysfs_create_group(&mk->kobj, &mp->grp))) {
-		kfree(mp);
-		return ERR_PTR(err);
-	}
-	return mp;
+	*mp = new;
+	return 0;
+
+fail_free_attrs:
+	kfree(attrs);
+fail_free_new:
+	kfree(new);
+fail:
+	kfree(*mp);
+	*mp = NULL;
+	return err;
 }
 
 #ifdef CONFIG_MODULES
@@ -513,13 +531,15 @@ int module_param_sysfs_setup(struct modu
 			     struct kernel_param *kparam,
 			     unsigned int num_params)
 {
-	struct module_param_attrs *mp;
+	int i, err;
 
-	mp = param_sysfs_setup(&mod->mkobj, kparam, num_params, 0);
-	if (IS_ERR(mp))
-		return PTR_ERR(mp);
-
-	mod->param_attrs = mp;
+	mod->param_attrs = NULL;
+	for (i = 0; i < num_params; i++) {
+		err = add_sysfs_param(&mod->param_attrs, &mod->mkobj, &kparam[i],
+				      kparam[i].name);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -552,7 +572,8 @@ static void __init kernel_param_sysfs_se
 					    unsigned int name_skip)
 {
 	struct module_kobject *mk;
-	int ret;
+	struct module_param_attrs *mp = NULL;
+	int i, ret;
 
 	mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
 	BUG_ON(!mk);
@@ -567,8 +588,12 @@ static void __init kernel_param_sysfs_se
 		printk(KERN_ERR	"The system will be unstable now.\n");
 		return;
 	}
-	param_sysfs_setup(mk, kparam, num_params, name_skip);
-	kobject_uevent(&mk->kobj, KOBJ_ADD);
+
+	for (i = 0; i < num_params; i++)
+		add_sysfs_param(&mp, mk, &kparam[i], kparam[i].name + name_skip);
+
+	if (mp)
+		kobject_uevent(&mk->kobj, KOBJ_ADD);
 }
 
 /*
