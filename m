Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXD0TOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXD0TOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXD0TOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:14:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:50569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbXD0S5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Tourrilhes <jt@hpl.hp.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/46] Driver core: notify userspace of network device renames
Date: Fri, 27 Apr 2007 11:53:27 -0700
Message-Id: <11777000852694-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000814075-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Tourrilhes <jt@hpl.hp.com>

Provide rename event for when we rename network devices.

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c        |   30 ++++++++++++++++++++++++++++++
 net/core/net-sysfs.c |   11 +++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index bbbfab4..db1d237 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -311,13 +311,43 @@ EXPORT_SYMBOL(kobject_set_name);
 int kobject_rename(struct kobject * kobj, const char *new_name)
 {
 	int error = 0;
+	const char *devpath = NULL;
+	char *devpath_string = NULL;
+	char *envp[2];
 
 	kobj = kobject_get(kobj);
 	if (!kobj)
 		return -EINVAL;
 	if (!kobj->parent)
 		return -EINVAL;
+
+	devpath = kobject_get_path(kobj, GFP_KERNEL);
+	if (!devpath) {
+		error = -ENOMEM;
+		goto out;
+	}
+	devpath_string = kmalloc(strlen(devpath) + 15, GFP_KERNEL);
+	if (!devpath_string) {
+		error = -ENOMEM;
+		goto out;
+	}
+	sprintf(devpath_string, "DEVPATH_OLD=%s", devpath);
+	envp[0] = devpath_string;
+	envp[1] = NULL;
+	/* Note : if we want to send the new name alone, not the full path,
+	 * we could probably use kobject_name(kobj); */
+
 	error = sysfs_rename_dir(kobj, kobj->parent->dentry, new_name);
+
+	/* This function is mostly/only used for network interface.
+	 * Some hotplug package track interfaces by their name and
+	 * therefore want to know when the name is changed by the user. */
+	if (!error)
+		kobject_uevent_env(kobj, KOBJ_MOVE, envp);
+
+out:
+	kfree(devpath_string);
+	kfree(devpath);
 	kobject_put(kobj);
 
 	return error;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 221a64a..e441ec7 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -424,6 +424,17 @@ static int netdev_uevent(struct device *d, char **envp,
 	if ((size <= 0) || (i >= num_envp))
 		return -ENOMEM;
 
+	/* pass ifindex to uevent.
+	 * ifindex is useful as it won't change (interface name may change)
+	 * and is what RtNetlink uses natively. */
+	envp[i++] = buf;
+	n = snprintf(buf, size, "IFINDEX=%d", dev->ifindex) + 1;
+	buf += n;
+	size -= n;
+
+	if ((size <= 0) || (i >= num_envp))
+		return -ENOMEM;
+
 	envp[i] = NULL;
 	return 0;
 }
-- 
1.5.1.2

