Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZF1MH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZF1MH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZF1MHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:07:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50028 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF1MHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:07:13 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <20090626143652.GB6281@localdomain.by>
	<20090626144949.GA24173@suse.de>
	<20090626232339.GD3858@localdomain.by>
	<m18wjeqven.fsf@fess.ebiederm.org>
	<20090627093932.GB3342@localdomain.by>
	<1246147018.24693.97.camel@yio.site>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jun 2009 05:07:10 -0700
In-Reply-To: <1246147018.24693.97.camel@yio.site> (Kay Sievers's message of "Sun\, 28 Jun 2009 01\:56\:58 +0200")
Message-ID: <m17hyw1s0h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, gregkh@suse.de, sergey.senozhatsky@mail.by
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Sat, 2009-06-27 at 12:39 +0300, Sergey Senozhatsky wrote:
>
>> > >> Or something along those lines, I can't remember the exact reasoning
>> > >> this early in the morning.
>> > >> 
>> > >> Kay, do you remember?
>
> Hmm, yes, I think there was only something to work around during the
> transition from the static name array, which is gone now. At least I
> can't see anything we need to care about with the current code.
>
>> Sorry, correct one.
>> 
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index b512b74..3ab224b 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -215,7 +215,6 @@ static int kobject_add_internal(struct kobject *kobj)
>>  int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>>  				  va_list vargs)
>>  {
>> -	const char *old_name = kobj->name;
>
> I guess, that would leak an allocated name, when it is set several times
> in a row? Something like this?

But setting a kobject's name several times in a row is a bug.  You
need to call kobject_rename if you are going to change the name.

So how about we fix the driver core not to do that.  Stop treating fmt
as a flag, and make it clear kobject_add should not be passed a name.

I really hate DWIM functions there is no maintaining them.

Something like this patch:

 block/blk-sysfs.c          |    6 ++++-
 block/elevator.c           |    4 ++-
 drivers/base/core.c        |   10 ++++++---
 drivers/firmware/memmap.c  |    3 +-
 drivers/md/md.c            |    5 +++-
 drivers/net/iseries_veth.c |    4 +--
 drivers/uio/uio.c          |    9 +++-----
 include/linux/kobject.h    |    3 --
 lib/kobject.c              |   46 ++++++++++++++-------------------------------
 9 files changed, 43 insertions(+), 47 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..92da396 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -215,11 +215,9 @@ static int kobject_add_internal(struct kobject *kobj)
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	const char *old_name = kobj->name;
 	char *s;
 
-	if (kobj->name && !fmt)
-		return 0;
+	BUG_ON(kobj->name);
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
 	if (!kobj->name)
@@ -229,7 +227,6 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 	while ((s = strchr(kobj->name, '/')))
 		s[0] = '!';
 
-	kfree(old_name);
 	return 0;
 }
 
@@ -296,20 +293,6 @@ error:
 }
 EXPORT_SYMBOL(kobject_init);
 
-static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
-			    const char *fmt, va_list vargs)
-{
-	int retval;
-
-	retval = kobject_set_name_vargs(kobj, fmt, vargs);
-	if (retval) {
-		printk(KERN_ERR "kobject: can not set name properly!\n");
-		return retval;
-	}
-	kobj->parent = parent;
-	return kobject_add_internal(kobj);
-}
-
 /**
  * kobject_add - the main kobject add function
  * @kobj: the kobject to add
@@ -335,15 +318,14 @@ static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
  * kobject_uevent() with the UEVENT_ADD parameter to ensure that
  * userspace is properly notified of this kobject's creation.
  */
-int kobject_add(struct kobject *kobj, struct kobject *parent,
-		const char *fmt, ...)
+int kobject_add(struct kobject *kobj, struct kobject *parent)
 {
-	va_list args;
-	int retval;
-
 	if (!kobj)
 		return -EINVAL;
 
+	if (!kobj->name)
+		return -EINVAL;
+
 	if (!kobj->state_initialized) {
 		printk(KERN_ERR "kobject '%s' (%p): tried to add an "
 		       "uninitialized object, something is seriously wrong.\n",
@@ -351,11 +333,8 @@ int kobject_add(struct kobject *kobj, struct kobject *parent,
 		dump_stack();
 		return -EINVAL;
 	}
-	va_start(args, fmt);
-	retval = kobject_add_varg(kobj, parent, fmt, args);
-	va_end(args);
-
-	return retval;
+	kobj->parent = parent;
+	return kobject_add_internal(kobj);
 }
 EXPORT_SYMBOL(kobject_add);
 
@@ -379,9 +358,12 @@ int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
 	kobject_init(kobj, ktype);
 
 	va_start(args, fmt);
-	retval = kobject_add_varg(kobj, parent, fmt, args);
+	retval = kobject_set_name(kobj, fmt, args);
 	va_end(args);
 
+	if (!retval)
+		retval = kobject_add(kobj, parent);
+
 	return retval;
 }
 EXPORT_SYMBOL_GPL(kobject_init_and_add);
@@ -653,7 +635,9 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 	if (!kobj)
 		return NULL;
 
-	retval = kobject_add(kobj, parent, "%s", name);
+	retval = kobject_set_name(kobj, "%s", name);
+	if (!retval)
+		retval = kobject_add(kobj, parent);
 	if (retval) {
 		printk(KERN_WARNING "%s: kobject_add error: %d\n",
 		       __func__, retval);
@@ -798,7 +782,7 @@ static struct kset *kset_create(const char *name,
 	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
 	if (!kset)
 		return NULL;
-	retval = kobject_set_name(&kset->kobj, name);
+	retval = kobject_set_name(&kset->kobj, "%s", name);
 	if (retval) {
 		kfree(kset);
 		return NULL;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 58ae8e0..de5f5d1 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -83,8 +83,7 @@ static inline const char *kobject_name(const struct kobject *kobj)
 
 extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *kobj,
-				    struct kobject *parent,
-				    const char *fmt, ...);
+				    struct kobject *parent);
 extern int __must_check kobject_init_and_add(struct kobject *kobj,
 					     struct kobj_type *ktype,
 					     struct kobject *parent,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b1cd040..64f7270 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -433,7 +433,11 @@ int blk_register_queue(struct gendisk *disk)
 	if (ret)
 		return ret;
 
-	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
+	ret = kobj_set_name(&q->kobj, "%s", "queue");
+	if (ret < 0)
+		return ret;
+
+	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj));
 	if (ret < 0)
 		return ret;
 
diff --git a/block/elevator.c b/block/elevator.c
index ca86192..f26dca0 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -903,7 +903,9 @@ int elv_register_queue(struct request_queue *q)
 	struct elevator_queue *e = q->elevator;
 	int error;
 
-	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
+	error = kobject_set_name(&e->kobj, "%s", "iosched");
+	if (!error)
+		error = kobject_add(&e->kobj, &q->kobj);
 	if (!error) {
 		struct elv_fs_entry *attr = e->elevator_type->elevator_attrs;
 		if (attr) {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7ecb193..f0cfa8a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -625,7 +625,12 @@ static struct kobject *get_device_parent(struct device *dev,
 		if (!k)
 			return NULL;
 		k->kset = &dev->class->p->class_dirs;
-		retval = kobject_add(k, parent_kobj, "%s", dev->class->name);
+		retval = kobject_set_name(k, "%s", dev->class->name);
+		if (retval < 0) {
+			kobject_put(k);
+			return NULL;
+		}
+		retval = kobject_add(k, parent_kobj);
 		if (retval < 0) {
 			kobject_put(k);
 			return NULL;
@@ -900,8 +905,7 @@ int device_add(struct device *dev)
 		set_dev_node(dev, dev_to_node(parent));
 
 	/* first, register with generic layer. */
-	/* we require the name to be set before, and pass NULL */
-	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
+	error = kobject_add(&dev->kobj, dev->kobj.parent);
 	if (error)
 		goto Error;
 
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index d5ea8a6..161a165 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -224,7 +224,8 @@ static int __init memmap_init(void)
 
 	list_for_each_entry(entry, &map_entries, list) {
 		entry->kobj.kset = memmap_kset;
-		if (kobject_add(&entry->kobj, NULL, "%d", i++))
+		if (kobject_set_name(&entry->kobj, "%d", i++) ||
+		    kobject_add(&entry->kobj, NULL))
 			kobject_put(&entry->kobj);
 	}
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 09be637..2f9fa72 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1575,7 +1575,10 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
 
-	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
+	if ((err = kobject_set_name(&rdev->kobj, "dev-%s", b)))
+		goto fail;
+
+	if ((err = kobject_add(&rdev->kobj, &mddev->kobj)))
 		goto fail;
 
 	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index e44215c..a024c24 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -1089,8 +1089,8 @@ static struct net_device *veth_probe_one(int vlan,
 		return NULL;
 	}
 
-	kobject_init(&port->kobject, &veth_port_ktype);
-	if (0 != kobject_add(&port->kobject, &dev->dev.kobj, "veth_port"))
+	if (kobject_init_and_add(&port->kobject, &veth_port_ktype,
+				 &dev->dev.kobj, "%s", "veth_port")
 		veth_error("Failed adding port for %s to sysfs.\n", dev->name);
 
 	veth_info("%s attached to iSeries vlan %d (LPAR map = 0x%.4X)\n",
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 03efb06..7c53bb9 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -303,10 +303,10 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		map = kzalloc(sizeof(*map), GFP_KERNEL);
 		if (!map)
 			goto err_map;
-		kobject_init(&map->kobj, &map_attr_type);
 		map->mem = mem;
 		mem->map = map;
-		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
+		ret = kobject_init_and_add(&map->kobj, &map_attr_type,
+					   idev->map_dir, "map%d", mi);
 		if (ret)
 			goto err_map;
 		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
@@ -328,11 +328,10 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		portio = kzalloc(sizeof(*portio), GFP_KERNEL);
 		if (!portio)
 			goto err_portio;
-		kobject_init(&portio->kobj, &portio_attr_type);
 		portio->port = port;
 		port->portio = portio;
-		ret = kobject_add(&portio->kobj, idev->portio_dir,
-							"port%d", pi);
+		ret = kobject_init_and_add(&portio->kobj, &portio_attr_type,
+					   idev->portio_dir, "port%d", pi);
 		if (ret)
 			goto err_portio;
 		ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
