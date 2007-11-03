Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbXKCDpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbXKCDpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 23:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbXKCDpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 23:45:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35007 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbXKCDpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 23:45:36 -0400
Date: Fri, 2 Nov 2007 20:48:12 -0700
From: Greg KH <greg@kroah.com>
To: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] 9p: sysfs support for in-kenel servers
Message-ID: <20071103034812.GC16234@kroah.com>
References: <20071102170527.GH16063@ionkov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102170527.GH16063@ionkov.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 11:05:27AM -0600, Latchesar Ionkov wrote:
> Sysfs support for 9P servers.
> Every server type is represented as a directory in /sys/fs/9p/srv. Initially
> there is a single file in the directory -- 'clone'. Reading from the clone
> file creates a new instance of the file server and returns its id. Each
> instance is represented as a directory in /sys/fs/9p/srv/<file server>/. The
> file server instance can be controlled by the 'ctl' file in its directory.
> Currently the ctl file accepts the following commands:
> 
> 	listen-add <trans> <options>
> 	listen-del <trans> <options>
> 	destroy
> 
> Example:
> 	echo 'listen-add tcp port=564' > /sys/fs/9p/srv/ramfs/0/ctl

Traditionally sysfs has not been used for "configuration" stuff like
this, as that is what configfs is for.

Also, a sysfs file that causes an action to happen just by reading the
file is not a safe thing to have.  Lots of scripts have been known to
just walk the whole sysfs tree and open and read everything they can for
no real good reason.  So you should seriously reconsider this kind of
interaction.


> +static struct attribute p9srv_clone_attr = {
> +	.name = "clone",
> +	.mode = 0444,
> +};

What's wrong with the __ATTR macro?  Using a "raw" struct attribute
seems a bit odd here.

> +static struct sysfs_ops p9srv_srv_ops = {
> +	.show = p9srv_srv_show,
> +	.store = p9srv_srv_store,
> +};
> +
> +static struct kobj_type p9srv_srv_ktype = {
> +	.release = p9srv_srv_release,
> +	.sysfs_ops = &p9srv_srv_ops,
> +};
> +
> +static struct attribute p9srv_ctl_attr = {
> +	.name = "ctl",
> +	.mode = 0644,
> +};

Same here.

> +struct p9srv_type *p9srv_type_register(char *name,
> +	struct p9srv *(*create)(void))
> +{
> +	int err;
> +	struct p9srv_type *ret, *stype;
> +
> +	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
> +	if (!ret)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_init(&ret->lock);
> +	ret->name = name;
> +	ret->nextid = 0;
> +	INIT_LIST_HEAD(&ret->srv_list);
> +	INIT_LIST_HEAD(&ret->stype_list);
> +	ret->create = create;
> +
> +	spin_lock(&p9srv_type_lock);
> +	list_for_each_entry(stype, &p9srv_type_list, stype_list) {
> +		if (strcmp(name, stype->name) == 0) {
> +			spin_unlock(&p9srv_type_lock);
> +			kfree(ret);
> +			return ERR_PTR(-EEXIST);
> +		}
> +	}
> +
> +	list_add_tail(&ret->stype_list, &p9srv_type_list);
> +	spin_unlock(&p9srv_type_lock);
> +
> +	kobject_init(&ret->kobj);
> +	kobject_set_name(&ret->kobj, "%s", name);
> +	ret->kobj.parent = &p9srv_subsys.kobj;
> +	ret->kobj.ktype = &p9srv_type_ktype;
> +	err = kobject_add(&ret->kobj);
> +	if (err)
> +		goto error;
> +
> +	err = sysfs_create_file(&ret->kobj, &p9srv_clone_attr);
> +	if (err)
> +		goto error;
> +
> +	return ret;
> +
> +error:
> +	kobject_unregister(&ret->kobj);
> +	/* kfree ??? */

Yes, otherwise you just leaked memory :)

> +	return ERR_PTR(err);
> +}
> +EXPORT_SYMBOL(p9srv_type_register);
> +
> +void p9srv_type_unregister(char *name)
> +{
> +	struct p9srv_type *stype;
> +
> +	spin_lock(&p9srv_type_lock);
> +	list_for_each_entry(stype, &p9srv_type_list, stype_list) {
> +		if (strcmp(name, stype->name) == 0) {
> +			list_del(&stype->stype_list);
> +			spin_unlock(&p9srv_type_lock);
> +			sysfs_remove_file(&stype->kobj, &p9srv_clone_attr);
> +			kobject_unregister(&stype->kobj);
> +			/* kfree ??? */
> +			return;
> +		}
> +	}
> +	spin_unlock(&p9srv_type_lock);
> +}
> +EXPORT_SYMBOL(p9srv_type_unregister);
> +
> +static void p9srv_type_release(struct kobject *kobj)
> +{
> +}

{sigh}

Yes, the kernel complains if you do not have a release function for your
kobject, but did you think that just providing an empty function is
somehow the proper thing to do here?

It wants you to do something in the release function, like free the
memory of the object.  Not just provide empty functions to try to shut
it up...

Please fix this.

> +static ssize_t p9srv_type_show(struct kobject *kobj, struct attribute *attr,
> +	char *buf)
> +{
> +	int err;
> +	struct p9srv_type *stype;
> +	struct p9srv *srv;
> +
> +	stype = container_of(kobj, struct p9srv_type, kobj);
> +	srv = (*stype->create)();

Again, creating stuff in a show function is not a good idea.

> +	if (IS_ERR(srv))
> +		return PTR_ERR(srv);
> +
> +	spin_lock(&stype->lock);
> +	srv->id = stype->nextid++;
> +	list_add_tail(&srv->srv_list, &stype->srv_list);
> +	spin_unlock(&stype->lock);
> +
> +	kobject_init(&srv->kobj);
> +	kobject_set_name(&srv->kobj, "%d", srv->id);
> +	srv->kobj.parent = &stype->kobj;
> +	srv->kobj.ktype = &p9srv_srv_ktype;
> +	err = kobject_add(&srv->kobj);
> +	if (err)
> +		goto error;
> +
> +	err = sysfs_create_file(&srv->kobj, &p9srv_ctl_attr);
> +	if (err)
> +		goto error;
> +
> +	return snprintf(buf, PAGE_SIZE, "%d", srv->id);
> +
> +error:
> +	spin_lock(&stype->lock);
> +	list_del(&srv->srv_list);
> +	spin_unlock(&stype->lock);
> +	kobject_unregister(&srv->kobj);
> +	/* kfree ??? */

Well, no, not if your release function frees the memory, otherwise it is
still present the way the code is written today...

But watch out, you are going here if kobject_add() fails, in which case,
kobject_unregister makes no sense as the kobject was never properly
added.

> +static ssize_t p9srv_type_store(struct kobject *kobj, struct attribute *attr,
> +	const char *buf, size_t buflen)
> +{
> +	return -EPERM;
> +}
> +
> +static void p9srv_srv_release(struct kobject *kobj)
> +{
> +}

Again with the empty release :(


>  static int __init p9srv_init(void)
>  {
> +	int err;
> +
>  	p9srv_wq = create_workqueue("9psrv");
>  	if (!p9srv_wq) {
>  		printk(KERN_WARNING "9psrv: creating workqueue failed\n");
>  		return -ENOMEM;
>  	}
>  
> +	kobj_set_kset_s(&p9srv_subsys, p9_subsys);

This macro is now gone away in the next -mm release :)

thanks,

greg k-h
