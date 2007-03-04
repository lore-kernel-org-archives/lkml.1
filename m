Return-Path: <linux-kernel-owner+w=401wt.eu-S1751354AbXCDA4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbXCDA4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 19:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXCDA4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 19:56:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:63917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXCDA4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 19:56:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=UjDyUiWJScTxzhL3kTMQt+zADHF5XLaG2LrGpuxBFqW/uLyjBVhYKmqjasMVccjK4DGY8gpEPjGJq0MJtfM7HktoefJJPu8kxAxfZWNh0G4pRZdnPuj1uPFEi1Twe8VhhcJGdNcHVxoK9cjfVrzFHzGqQqaIZVyqmHpWSVIrAz8=
Date: Sun, 4 Mar 2007 01:56:45 +0100
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH 1/2] uevent: improve error checking and handling
Message-ID: <20070304005645.GA26367@zenigma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
From: Eric Rannaud <eric.rannaud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: uevent: improve error checking and handling
From: Eric Rannaud <eric.rannaud@gmail.com>

	add_uevent_var() is used w/o checking for its return value, even though
	it is possible for those calls to return -ENOMEM.

Signed-off-by: Eric Rannaud <eric.rannaud@gmail.com>
---

 drivers/base/core.c |   93 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 59 insertions(+), 34 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index cf2a398..3a52332 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -162,18 +162,25 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 
 	/* add the major/minor if present */
 	if (MAJOR(dev->devt)) {
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "MAJOR=%u", MAJOR(dev->devt));
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "MINOR=%u", MINOR(dev->devt));
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"MAJOR=%u", MAJOR(dev->devt));
+		if (retval)
+			return retval;
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"MINOR=%u", MINOR(dev->devt));
+		if (retval)
+			return retval;
 	}
 
-	if (dev->driver)
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "DRIVER=%s", dev->driver->name);
+	if (dev->driver) {
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"DRIVER=%s", dev->driver->name);
+		if (retval)
+			return retval;
+	}
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if (dev->class) {
@@ -186,29 +193,41 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 			const char *path;
 
 			path = kobject_get_path(&parent->kobj, GFP_KERNEL);
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVPATH=%s", path);
+			retval = add_uevent_var(envp, num_envp, &i,
+						buffer, buffer_size, &length,
+						"PHYSDEVPATH=%s", path);
 			kfree(path);
-
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVBUS=%s", parent->bus->name);
-
-			if (parent->driver)
-				add_uevent_var(envp, num_envp, &i,
-					       buffer, buffer_size, &length,
-					       "PHYSDEVDRIVER=%s", parent->driver->name);
+			if (retval)
+				return retval;
+
+			retval = add_uevent_var(envp, num_envp, &i,
+						buffer, buffer_size, &length,
+						"PHYSDEVBUS=%s", parent->bus->name);
+			if (retval)
+				return retval;
+
+			if (parent->driver) {
+				retval = add_uevent_var(envp, num_envp, &i,
+							buffer, buffer_size, &length,
+							"PHYSDEVDRIVER=%s", parent->driver->name);
+				if (retval)
+					return retval;
+			}
 		}
 	} else if (dev->bus) {
-		add_uevent_var(envp, num_envp, &i,
-			       buffer, buffer_size, &length,
-			       "PHYSDEVBUS=%s", dev->bus->name);
-
-		if (dev->driver)
-			add_uevent_var(envp, num_envp, &i,
-				       buffer, buffer_size, &length,
-				       "PHYSDEVDRIVER=%s", dev->driver->name);
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"PHYSDEVBUS=%s", dev->bus->name);
+		if (retval)
+			return retval;
+
+		if (dev->driver) {
+			retval = add_uevent_var(envp, num_envp, &i,
+						buffer, buffer_size, &length,
+						"PHYSDEVDRIVER=%s", dev->driver->name);
+			if (retval)
+				return retval;
+		}
 	}
 #endif
 
@@ -222,27 +241,33 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 	if (dev->bus && dev->bus->uevent) {
 		/* have the bus specific function add its stuff */
 		retval = dev->bus->uevent(dev, envp, num_envp, buffer, buffer_size);
-		if (retval)
+		if (retval) {
 			pr_debug ("%s: bus uevent() returned %d\n",
 				  __FUNCTION__, retval);
+			goto out;
+		}
 	}
 
 	if (dev->class && dev->class->dev_uevent) {
 		/* have the class specific function add its stuff */
 		retval = dev->class->dev_uevent(dev, envp, num_envp, buffer, buffer_size);
-		if (retval)
+		if (retval) {
 			pr_debug("%s: class uevent() returned %d\n",
 				 __FUNCTION__, retval);
+			goto out;
+		}
 	}
 
 	if (dev->type && dev->type->uevent) {
 		/* have the device type specific fuction add its stuff */
 		retval = dev->type->uevent(dev, envp, num_envp, buffer, buffer_size);
-		if (retval)
+		if (retval) {
 			pr_debug("%s: dev_type uevent() returned %d\n",
 				 __FUNCTION__, retval);
+			goto out;
+		}
 	}
-
+out:
 	return retval;
 }
 

