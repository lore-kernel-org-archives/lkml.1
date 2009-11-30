Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZK3BJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZK3BJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZK3BJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:09:52 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:52107 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZK3BJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ODkUmYbH5Kx2bMqnI45VwoBOVvafSFF/gOJl6/NukAu/krrRChBMr8BzXoq+pcDV4R
         AKE4UB6T6U3EmGoo254SER5qjPdJRJ7jLfH8njm92mP+lfysk26UjHlcZ0vdBBHy+w5q
         eWUCH9L9C9Dwa6OOlc/IsIcukyUT9uDz63BII=
Date: Sun, 29 Nov 2009 17:09:53 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: aili@codeaurora.org, linux-kernel@vger.kernel.org
Subject: [RFC] PM_QOS api update to use handles 1/5
Message-ID: <20091130010953.GA4732@mgross-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm using this crazy email address because I have problems getting to
linux.intel.com from home, and my work at intel has changed a bit.

This is the first in a 5 part series that attempts to update PM_QOS to
use handles instead of named strings in its kernel api.  It seams that
some folks are using pm_qos on hot paths and the overhead of the list
walks and string compares is a problem.

Most of the changes came from aili@codeaurora.org, and I spent some time
cleaning up the API.

Also, I couldn't resist myself in renaming the API's a bit give the fact
that the signatures changed enough that I had to touch all the pm_qos
users anyway.  I changed *requirement* to *request* in keeping with the
way PM_QOS really only does best effort.  I've felt "requirement" is too
strong a word for the way it works.

If folks would rather me do the function re-naming in a separate patch
set we can do that too.


diffstat:
drivers/acpi/processor_idle.c          |    2=20
drivers/cpuidle/governors/ladder.c     |    2=20
drivers/cpuidle/governors/menu.c       |    2=20
drivers/net/e1000e/netdev.c            |   13 +-
drivers/net/igbvf/netdev.c             |    5=20
drivers/net/wireless/ipw2x00/ipw2100.c |   11 +
include/linux/pm_qos_params.h          |   14 +-
include/sound/pcm.h                    |    3=20
kernel/pm_qos_params.c                 |  186 ++++++++++++++---------------=
----
net/mac80211/mlme.c                    |    2=20
sound/core/pcm.c                       |    3=20
sound/core/pcm_native.c                |   12 +-
12 files changed, 117 insertions(+), 138 deletions(-)



Signed-off-by: mark gross <mgross@linux.intel.com>



---
 include/linux/pm_qos_params.h |   14 ++--
 kernel/pm_qos_params.c        |  186 ++++++++++++++++++-------------------=
----
 2 files changed, 90 insertions(+), 110 deletions(-)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index d74f75e..8ba440e 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -14,12 +14,14 @@
 #define PM_QOS_NUM_CLASSES 4
 #define PM_QOS_DEFAULT_VALUE -1
=20
-int pm_qos_add_requirement(int qos, char *name, s32 value);
-int pm_qos_update_requirement(int qos, char *name, s32 new_value);
-void pm_qos_remove_requirement(int qos, char *name);
+struct pm_qos_request_list;
=20
-int pm_qos_requirement(int qos);
+struct pm_qos_request_list *pm_qos_add_request(int pm_qos_class, s32 value=
);
+void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
+		s32 new_value);
+void pm_qos_remove_request(struct pm_qos_request_list *pm_qos_req);
=20
-int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
-int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
+int pm_qos_request(int pm_qos_class);
+int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
+int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifi=
er);
=20
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index dfdec52..c2659d0 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -2,7 +2,7 @@
  * This module exposes the interface to kernel space for specifying
  * QoS dependencies.  It provides infrastructure for registration of:
  *
- * Dependents on a QoS value : register requirements
+ * Dependents on a QoS value : register requests
  * Watchers of QoS value : get notified when target QoS value changes
  *
  * This QoS design is best effort based.  Dependents register their QoS ne=
eds.
@@ -14,14 +14,14 @@
  * timeout: usec <-- currently not used.
  * throughput: kbs (kilo byte / sec)
  *
- * There are lists of pm_qos_objects each one wrapping requirements, notif=
iers
+ * There are lists of pm_qos_objects each one wrapping requests, notifiers
  *
- * User mode requirements on a QOS parameter register themselves to the
+ * User mode requests on a QOS parameter register themselves to the
  * subsystem by opening the device node /dev/... and writing there request=
 to
  * the node.  As long as the process holds a file handle open to the node =
the
  * client continues to be accounted for.  Upon file release the usermode
- * requirement is removed and a new qos target is computed.  This way when=
 the
- * requirement that the application has is cleaned up when closes the file
+ * request is removed and a new qos target is computed.  This way when the
+ * request that the application has is cleaned up when closes the file
  * pointer or exits the pm_qos_object will get an opportunity to clean up.
  *
  * Mark Gross <mgross@linux.intel.com>
@@ -43,25 +43,25 @@
 #include <linux/uaccess.h>
=20
 /*
- * locking rule: all changes to requirements or notifiers lists
+ * locking rule: all changes to requests or notifiers lists
  * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
  * held, taken with _irqsave.  One lock to rule them all
  */
-struct requirement_list {
+struct pm_qos_request_list {
 	struct list_head list;
 	union {
 		s32 value;
 		s32 usec;
 		s32 kbps;
 	};
-	char *name;
+	int pm_qos_class;
 };
=20
 static s32 max_compare(s32 v1, s32 v2);
 static s32 min_compare(s32 v1, s32 v2);
=20
 struct pm_qos_object {
-	struct requirement_list requirements;
+	struct pm_qos_request_list requests;
 	struct blocking_notifier_head *notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
@@ -73,7 +73,7 @@ struct pm_qos_object {
 static struct pm_qos_object null_pm_qos;
 static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
 static struct pm_qos_object cpu_dma_pm_qos =3D {
-	.requirements =3D {LIST_HEAD_INIT(cpu_dma_pm_qos.requirements.list)},
+	.requests =3D {LIST_HEAD_INIT(cpu_dma_pm_qos.requests.list)},
 	.notifiers =3D &cpu_dma_lat_notifier,
 	.name =3D "cpu_dma_latency",
 	.default_value =3D 2000 * USEC_PER_SEC,
@@ -83,7 +83,7 @@ static struct pm_qos_object cpu_dma_pm_qos =3D {
=20
 static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
 static struct pm_qos_object network_lat_pm_qos =3D {
-	.requirements =3D {LIST_HEAD_INIT(network_lat_pm_qos.requirements.list)},
+	.requests =3D {LIST_HEAD_INIT(network_lat_pm_qos.requests.list)},
 	.notifiers =3D &network_lat_notifier,
 	.name =3D "network_latency",
 	.default_value =3D 2000 * USEC_PER_SEC,
@@ -94,8 +94,7 @@ static struct pm_qos_object network_lat_pm_qos =3D {
=20
 static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
 static struct pm_qos_object network_throughput_pm_qos =3D {
-	.requirements =3D
-		{LIST_HEAD_INIT(network_throughput_pm_qos.requirements.list)},
+	.requests =3D {LIST_HEAD_INIT(network_throughput_pm_qos.requests.list)},
 	.notifiers =3D &network_throughput_notifier,
 	.name =3D "network_throughput",
 	.default_value =3D 0,
@@ -136,31 +135,34 @@ static s32 min_compare(s32 v1, s32 v2)
 }
=20
=20
-static void update_target(int target)
+static void update_target(int pm_qos_class)
 {
 	s32 extreme_value;
-	struct requirement_list *node;
+	struct pm_qos_request_list *node;
 	unsigned long flags;
 	int call_notifier =3D 0;
=20
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	extreme_value =3D pm_qos_array[target]->default_value;
+	extreme_value =3D pm_qos_array[pm_qos_class]->default_value;
 	list_for_each_entry(node,
-			&pm_qos_array[target]->requirements.list, list) {
-		extreme_value =3D pm_qos_array[target]->comparitor(
+			&pm_qos_array[pm_qos_class]->requests.list, list) {
+		extreme_value =3D pm_qos_array[pm_qos_class]->comparitor(
 				extreme_value, node->value);
 	}
-	if (atomic_read(&pm_qos_array[target]->target_value) !=3D extreme_value) {
+	if (atomic_read(&pm_qos_array[pm_qos_class]->target_value) !=3D
+			extreme_value) {
 		call_notifier =3D 1;
-		atomic_set(&pm_qos_array[target]->target_value, extreme_value);
-		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
-			atomic_read(&pm_qos_array[target]->target_value));
+		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
+				extreme_value);
+		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
+			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
 	}
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
=20
 	if (call_notifier)
-		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
-			(unsigned long) extreme_value, NULL);
+		blocking_notifier_call_chain(
+				pm_qos_array[pm_qos_class]->notifiers,
+					(unsigned long) extreme_value, NULL);
 }
=20
 static int register_pm_qos_misc(struct pm_qos_object *qos)
@@ -186,125 +188,108 @@ static int find_pm_qos_object_by_minor(int minor)
 }
=20
 /**
- * pm_qos_requirement - returns current system wide qos expectation
+ * pm_qos_request - returns current system wide qos expectation
  * @pm_qos_class: identification of which qos value is requested
  *
  * This function returns the current target value in an atomic manner.
  */
-int pm_qos_requirement(int pm_qos_class)
+int pm_qos_request(int pm_qos_class)
 {
 	return atomic_read(&pm_qos_array[pm_qos_class]->target_value);
 }
-EXPORT_SYMBOL_GPL(pm_qos_requirement);
+EXPORT_SYMBOL_GPL(pm_qos_request);
=20
 /**
- * pm_qos_add_requirement - inserts new qos request into the list
+ * pm_qos_add_request - inserts new qos request into the list
  * @pm_qos_class: identifies which list of qos request to us
- * @name: identifies the request
  * @value: defines the qos request
  *
  * This function inserts a new entry in the pm_qos_class list of requested=
 qos
  * performance characteristics.  It recomputes the aggregate QoS expectati=
ons
- * for the pm_qos_class of parameters.
+ * for the pm_qos_class of parameters, and returns the pm_qos_request list
+ * element as a handle for use in updating and removal.  Call needs to save
+ * this handle for later use.
  */
-int pm_qos_add_requirement(int pm_qos_class, char *name, s32 value)
+struct pm_qos_request_list *pm_qos_add_request(int pm_qos_class, s32 value)
 {
-	struct requirement_list *dep;
+	struct pm_qos_request_list *dep;
 	unsigned long flags;
=20
-	dep =3D kzalloc(sizeof(struct requirement_list), GFP_KERNEL);
+	dep =3D kzalloc(sizeof(struct pm_qos_request_list), GFP_KERNEL);
 	if (dep) {
 		if (value =3D=3D PM_QOS_DEFAULT_VALUE)
 			dep->value =3D pm_qos_array[pm_qos_class]->default_value;
 		else
 			dep->value =3D value;
-		dep->name =3D kstrdup(name, GFP_KERNEL);
-		if (!dep->name)
-			goto cleanup;
+		dep->pm_qos_class =3D pm_qos_class;
=20
 		spin_lock_irqsave(&pm_qos_lock, flags);
 		list_add(&dep->list,
-			&pm_qos_array[pm_qos_class]->requirements.list);
+			&pm_qos_array[pm_qos_class]->requests.list);
 		spin_unlock_irqrestore(&pm_qos_lock, flags);
 		update_target(pm_qos_class);
-
-		return 0;
 	}
=20
-cleanup:
-	kfree(dep);
-	return -ENOMEM;
+	return dep;
 }
-EXPORT_SYMBOL_GPL(pm_qos_add_requirement);
+EXPORT_SYMBOL_GPL(pm_qos_add_request);
=20
 /**
- * pm_qos_update_requirement - modifies an existing qos request
- * @pm_qos_class: identifies which list of qos request to us
- * @name: identifies the request
+ * pm_qos_update_request - modifies an existing qos request
+ * @pm_qos_req : handle to list element holding a pm_qos request to use
  * @value: defines the qos request
  *
- * Updates an existing qos requirement for the pm_qos_class of parameters =
along
+ * Updates an existing qos request for the pm_qos_class of parameters along
  * with updating the target pm_qos_class value.
  *
- * If the named request isn't in the list then no change is made.
+ * Attempts are made to make this code callable on hot code paths.
  */
-int pm_qos_update_requirement(int pm_qos_class, char *name, s32 new_value)
+void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
+		s32 new_value)
 {
 	unsigned long flags;
-	struct requirement_list *node;
 	int pending_update =3D 0;
+	s32 temp;
+	s32 extreme_value;
=20
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	list_for_each_entry(node,
-		&pm_qos_array[pm_qos_class]->requirements.list, list) {
-		if (strcmp(node->name, name) =3D=3D 0) {
-			if (new_value =3D=3D PM_QOS_DEFAULT_VALUE)
-				node->value =3D
-				pm_qos_array[pm_qos_class]->default_value;
-			else
-				node->value =3D new_value;
-			pending_update =3D 1;
-			break;
-		}
-	}
+	if (new_value =3D=3D PM_QOS_DEFAULT_VALUE)
+		temp =3D pm_qos_array[pm_qos_req->pm_qos_class]->default_value;
+	else
+		temp =3D new_value;
+
+	pm_qos_req->value =3D temp;
+	if (temp !=3D pm_qos_req->value) {
+		pending_update =3D 1;
+
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
-		update_target(pm_qos_class);
-
-	return 0;
+		update_target(pm_qos_req->pm_qos_class);
 }
-EXPORT_SYMBOL_GPL(pm_qos_update_requirement);
+EXPORT_SYMBOL_GPL(pm_qos_update_request);
=20
 /**
- * pm_qos_remove_requirement - modifies an existing qos request
- * @pm_qos_class: identifies which list of qos request to us
- * @name: identifies the request
+ * pm_qos_remove_request - modifies an existing qos request
+ * @pm_qos_req: handle to request list element
  *
- * Will remove named qos request from pm_qos_class list of parameters and
- * recompute the current target value for the pm_qos_class.
+ * Will remove pm qos request from the list of requests and
+ * recompute the current target value for the pm_qos_class.  Call this
+ * on slow code paths.
  */
-void pm_qos_remove_requirement(int pm_qos_class, char *name)
+void pm_qos_remove_request(struct pm_qos_request_list *pm_qos_req)
 {
 	unsigned long flags;
-	struct requirement_list *node;
+	struct pm_qos_request_list *node;
 	int pending_update =3D 0;
+	int qos_class =3D pm_qos_req->pm_qos_class;
=20
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	list_for_each_entry(node,
-		&pm_qos_array[pm_qos_class]->requirements.list, list) {
-		if (strcmp(node->name, name) =3D=3D 0) {
-			kfree(node->name);
-			list_del(&node->list);
-			kfree(node);
-			pending_update =3D 1;
-			break;
-		}
-	}
+	list_del(&pm_qos_req->list);
+	kfree(pm_qos_req);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
-	if (pending_update)
-		update_target(pm_qos_class);
+	update_target(qos_class);
 }
-EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
+EXPORT_SYMBOL_GPL(pm_qos_remove_request);
=20
 /**
  * pm_qos_add_notifier - sets notification entry for changes to target val=
ue
@@ -314,7 +299,7 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
  * will register the notifier into a notification chain that gets called
  * upon changes to the pm_qos_class target value.
  */
- int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
+int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
 	int retval;
=20
@@ -344,22 +329,17 @@ int pm_qos_remove_notifier(int pm_qos_class, struct n=
otifier_block *notifier)
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
=20
-#define PID_NAME_LEN sizeof("process_1234567890")
-static char name[PID_NAME_LEN];
-
 static int pm_qos_power_open(struct inode *inode, struct file *filp)
 {
-	int ret;
 	long pm_qos_class;
=20
 	lock_kernel();
 	pm_qos_class =3D find_pm_qos_object_by_minor(iminor(inode));
+
 	if (pm_qos_class >=3D 0) {
-		filp->private_data =3D (void *)pm_qos_class;
-		sprintf(name, "process_%d", current->pid);
-		ret =3D pm_qos_add_requirement(pm_qos_class, name,
-					PM_QOS_DEFAULT_VALUE);
-		if (ret >=3D 0) {
+		filp->private_data =3D (void *) pm_qos_add_request(pm_qos_class,
+				PM_QOS_DEFAULT_VALUE);
+		if (filp->private_data) {
 			unlock_kernel();
 			return 0;
 		}
@@ -371,11 +351,10 @@ static int pm_qos_power_open(struct inode *inode, str=
uct file *filp)
=20
 static int pm_qos_power_release(struct inode *inode, struct file *filp)
 {
-	int pm_qos_class;
+	struct pm_qos_request_list *req;
=20
-	pm_qos_class =3D (long)filp->private_data;
-	sprintf(name, "process_%d", current->pid);
-	pm_qos_remove_requirement(pm_qos_class, name);
+	req =3D (struct pm_qos_request_list *)filp->private_data;
+	pm_qos_remove_request(req);
=20
 	return 0;
 }
@@ -384,15 +363,14 @@ static ssize_t pm_qos_power_write(struct file *filp, =
const char __user *buf,
 		size_t count, loff_t *f_pos)
 {
 	s32 value;
-	int pm_qos_class;
+	struct pm_qos_request_list *pm_qos_req;
=20
-	pm_qos_class =3D (long)filp->private_data;
 	if (count !=3D sizeof(s32))
 		return -EINVAL;
 	if (copy_from_user(&value, buf, sizeof(s32)))
 		return -EFAULT;
-	sprintf(name, "process_%d", current->pid);
-	pm_qos_update_requirement(pm_qos_class, name, value);
+	pm_qos_req =3D (struct pm_qos_request_list *)filp->private_data;
+	pm_qos_update_request(pm_qos_req, value);
=20
 	return  sizeof(s32);
 }
--=20
1.6.3.3


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksTG2EACgkQhK5OsmQOmSD1QQCePqMRrLG9LGMHEM/9jRgIlwXs
UsAAnj49eFiSv9+07p1rslDNJrEdTgrZ
=2zDd
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
