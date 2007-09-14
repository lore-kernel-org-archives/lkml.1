Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXINLZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXINLZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXINLZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:25:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:33782 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXINLZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:25:20 -0400
Date: Fri, 14 Sep 2007 13:25:19 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Some driver core and kobject minor patches
Message-ID: <20070914132519.587d7a35@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070913233751.GA10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 16:37:51 -0700,
Greg KH <greg@kroah.com> wrote:

> Kay pointed out to me the other day that we are dragging around 20 bytes
> in every struct kobject and in every struct device to contain a name
> string that can be dynamically allocated instead.  For small device
> names (the majority), this savings can add up, especially with a lot of
> individual devices.
> 
> So, I started out by getting rid of the static array in the kobject
> structure, as we already were dynamically allocating space if it was
> needed.
> 
> Of course, this required a number of other minor cleanups through the
> code tree to handle places where we were incorrectly directly accessing
> the kobject name instead of using the "proper" function.  I also got
> sidetracked by a few driver core and kobject.h cleanups of macros that
> are no longer needed, or functions that no longer need to be global
> (they were never exported, so we don't have to worry about that mess...)
> 
> And I added a change to trigger a warning if we add an attribute to
> sysfs that we have already had created, to help the SCSI developers out
> with their driver model reworks.
> 
> So, here's a series of 11 patches that I've added to my tree, and will
> send to Linus when 2.6.24 is opened up.
> 
> Any review comments are appreciated.  The full diffstat is below showing
> that overall, we did get rid of more code than was added.

Neat. We can get rid of even more stuff if we remove the removed
functions from the Documentation as well.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 Documentation/kobject.txt |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

--- linux-2.6.orig/Documentation/kobject.txt
+++ linux-2.6/Documentation/kobject.txt
@@ -54,7 +54,6 @@ embedded in larger data structures and r
 
 struct kobject {
 	const char		* k_name;
-	char			name[KOBJ_NAME_LEN];
 	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		* parent;
@@ -223,18 +222,15 @@ decl_subsys(devices, &ktype_device, &dev
 is equivalent to doing:
 
 struct kset devices_subsys = {
-     .kobj = {
-	   .name = "devices",
-     },
      .ktype = &ktype_devices,
      .uevent_ops = &device_uevent_ops,
 };
-
+kobject_set_name(&devices_subsys, name);
 
 The objects that are registered with a subsystem that use the
 subsystem's default list must have their kset ptr set properly. These
 objects may have embedded kobjects or ksets. The
-following helpers make setting the kset easier:
+following helper makes setting the kset easier:
 
 
 kobj_set_kset_s(obj,subsys)
@@ -242,22 +238,9 @@ kobj_set_kset_s(obj,subsys)
 - Assumes that obj->kobj exists, and is a struct kobject.
 - Sets the kset of that kobject to the kset <subsys>.
 
-
-kset_set_kset_s(obj,subsys)
-
-- Assumes that obj->kset exists, and is a struct kset.
-- Sets the kset of the embedded kobject to the kset <subsys>.
-
-subsys_set_kset(obj,subsys)
-
-- Assumes obj->subsys exists, and is a struct subsystem.
-- Sets obj->subsys.kset.kobj.kset to the subsystem's embedded kset.
-
 void subsystem_init(struct kset *s);
 int subsystem_register(struct kset *s);
 void subsystem_unregister(struct kset *s);
-struct kset *subsys_get(struct kset *s);
-void kset_put(struct kset *s);
 
 These are just wrappers around the respective kset_* functions.
 
