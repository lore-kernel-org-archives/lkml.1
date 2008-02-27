Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYB0Oig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYB0Oig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbYB0Oi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:38:27 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:12756 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbYB0Oi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:38:26 -0500
Date: Wed, 27 Feb 2008 15:38:23 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <20080227153823.3f93510c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0802271438170.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
	<20080220063834.GA22708@kroah.com>
	<Pine.LNX.4.64.0802251341160.4430@axis700.grange>
	<20080226201619.GA10343@kroah.com>
	<Pine.LNX.4.64.0802271222530.5059@axis700.grange>
	<20080227124748.2e89e628@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0802271328300.5059@axis700.grange>
	<20080227142103.1dd42f8f@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0802271438170.5059@axis700.grange>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 14:46:05 +0100 (CET),
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Wed, 27 Feb 2008, Cornelia Huck wrote:
> 
> > On Wed, 27 Feb 2008 13:33:13 +0100 (CET),
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 
> > > You mean the kernel panic without CONFIG_SYSFS_DEPRECATED? No, 
> > > unfortunately is doesn't.
> > 
> > Hm, dev->kobj.parent may be NULL in cleanup_device_parent(). Does this
> > one help?
> 
> Yes, this one does. 

Great, thanks for testing!

> But Greg's original idea, that disabling 
> CONFIG_SYSFS_DEPRECATED would eliminate one of the warnings doesn't hold, 
> all three of them are still there (after your patches):

I'm afraid I can't help there, as this looks PCI-related...

Greg: Attached are the fixes against your tree with proper description
and s-o-b.


Driver core: Fix cleanup when failing device_add().

-Don't call cleanup_device_parent() if we didn't call setup_parent().
-dev->kobj.parent may be NULL when cleanup_device_parent() is called,
 so we need to handle glue_dir == NULL in cleanup_glue_dir().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -622,7 +622,8 @@ static struct kobject *get_device_parent
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
 	/* see if we live in a "glue" directory */
-	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
+	if (!glue_dir || !dev->class ||
+	    glue_dir->kset != &dev->class->class_dirs)
 		return;
 
 	kobject_put(glue_dir);
@@ -781,7 +782,7 @@ int device_add(struct device *dev)
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
 		error = -EINVAL;
-		goto Error;
+		goto Done;
 	}
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
