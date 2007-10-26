Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbXJZPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbXJZPwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXJZPwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:52:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXJZPwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:52:43 -0400
Date: Fri, 26 Oct 2007 08:50:58 -0700
From: Greg KH <greg@kroah.com>
To: Amit Shah <amitshah@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Message-ID: <20071026155058.GC23016@kroah.com>
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> On 2.6.24-rc1, I get this for all my eth interfaces:
> 
> [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

I sent out the patch below for comments, yet no one did :(

Can you try it out and let me know if it works for you or not?

thanks,

greg k-h

------------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: kobject: check for duplicate names in kobject_rename

This should catch any duplicate names before we try to tell sysfs to
rename the object.  This happens a lot with older versions of udev and
the network rename scripts.

Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/kobject.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -308,6 +308,19 @@ int kobject_rename(struct kobject * kobj
 	if (!kobj->parent)
 		return -EINVAL;
 
+	/* see if this name is already in use */
+	if (kobj->kset) {
+		struct kobject *temp_kobj;
+		temp_kobj = kset_find_obj(kobj->kset, new_name);
+		if (temp_kobj) {
+			printk(KERN_WARNING "kobject '%s' can not be renamed "
+			       "to '%s' as '%s' is already in existance.\n",
+			       kobject_name(kobj), new_name, new_name);
+			kobject_put(temp_kobj);
+			return -EINVAL;
+		}
+	}
+
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
 	if (!devpath) {
 		error = -ENOMEM;
