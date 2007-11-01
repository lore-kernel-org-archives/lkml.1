Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbXKATSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbXKATSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXKATSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:18:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXKATSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:18:34 -0400
Subject: Re: [PATCH] [sysfs]: make readlink result shorter when the symlink
	and its target shared some base sysfs subdirectory
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Denis Cheng <crquan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3ae72650711011159u53a48ce0ge118427c2107be01@mail.gmail.com>
References: <1193826860-6166-1-git-send-email-crquan@gmail.com>
	 <20071031143441.GA7128@suse.de>
	 <3ae72650711011159u53a48ce0ge118427c2107be01@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 20:20:52 +0100
Message-Id: <1193944852.2860.29.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX183iy2y/UfMh4hszjWNwpGknxMjbqM58YRdaOC
 hlSowZFPirzRW3KgX8FWbgPX+dYEToZSD1zJOH/0K31oftzJax
 fwDrBBXIv1EKBXc/fLLuqKohfDc3dxG
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 19:59 +0100, Kay Sievers wrote:
> On Oct 31, 2007 3:34 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Oct 31, 2007 at 06:34:20PM +0800, Denis Cheng wrote:
> > > this is especially useful after /sys/slab introduced, for example:
> > >
> > > $ ls -l /sys/slab/mm_struct
> > > lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> :0000448
> > >
> > > instead of:
> > >
> > > $ ls -l /sys/slab/mm_struct
> > > lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> ../slab/:0000448
> > >
> > > Signed-off-by: Denis Cheng <crquan@gmail.com>
> >
> > As pretty as this change is, it's not really necessary, right?
> >
> > Is there any other place in /sys that would benefit from this?
> 
> Yeah:
>   ep_81 -> ../../../../../devices/pci0000:00/0000:00:1d.0/usb2/2-0:1.0/usb_endpoint/usbdev2.1_ep81
> 
> just becomes:
>   ep_81 -> usb_endpoint/usbdev1.1_ep81
> 
> which is nice. The current logic always goes back down to the root of sysfs
> and moves forward to the target, which in this case prepends the pointless:
>   "../../../../../devices/pci0000:00/0000:00:1d.0/usb2/2-0:1.0/" to
> the target string.

Here is what I get when reading all symlinks in the current kernel:
   $ for i in $(find /sys/ -type l); do readlink $i; done | wc
   1044    1047   37826

And with the optimized relative link targets:
   $ for i in $(find /sys/ -type l); do readlink $i; done | wc
   1044    1047   33584

It 's more than 4kb less of "../" + redundant directory names. :)

Here is a bit simpler patch, that also removes more code from the kernel
than it adds, and does the optimized link targets. Maybe it adds more
bugs than it removes too. :)

Thanks,
Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sysfs: create optimal relative symlink targets

Instead of walking from the source down to the root of sysfs, and back
to the target, we stop at the first directory the source and the target
share.

This link:
  /devices/pci0000:00/0000:00:1d.7/usb1/1-0:1.0/ep_81

pointed to:
  ../../../../../devices/pci0000:00/0000:00:1d.0/usb2/2-0:1.0/usb_endpoint/usbdev2.1_ep81

now it just points to:
  usb_endpoint/usbdev1.1_ep81

Thanks to Denis Cheng for bringing this up, and sending the initial patch.

CC: Denis Cheng <crquan@gmail.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 symlink.c |   88 +++++++++++++++++++++++++++++---------------------------------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 3eac20c..5f66c44 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,39 +19,6 @@
 
 #include "sysfs.h"
 
-static int object_depth(struct sysfs_dirent *sd)
-{
-	int depth = 0;
-
-	for (; sd->s_parent; sd = sd->s_parent)
-		depth++;
-
-	return depth;
-}
-
-static int object_path_length(struct sysfs_dirent * sd)
-{
-	int length = 1;
-
-	for (; sd->s_parent; sd = sd->s_parent)
-		length += strlen(sd->s_name) + 1;
-
-	return length;
-}
-
-static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
-{
-	--length;
-	for (; sd->s_parent; sd = sd->s_parent) {
-		int cur = strlen(sd->s_name);
-
-		/* back up enough to print this bus id with '/' */
-		length -= cur;
-		strncpy(buffer + length, sd->s_name, cur);
-		*(buffer + --length) = '/';
-	}
-}
-
 /**
  *	sysfs_create_link - create symlink between two objects.
  *	@kobj:	object whose directory we're creating the link in.
@@ -112,7 +79,6 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	return error;
 }
 
-
 /**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
@@ -124,24 +90,54 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(kobj->sd, name);
 }
 
-static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
-				 struct sysfs_dirent * target_sd, char *path)
+static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
+				 struct sysfs_dirent *target_sd, char *path)
 {
-	char * s;
-	int depth, size;
+	struct sysfs_dirent *base, *sd;
+	char *s = path;
+	int len = 0;
+
+	/* go up to the root, stop at the base */
+	base = parent_sd;
+	while (base->s_parent) {
+		sd = target_sd->s_parent;
+		while (sd->s_parent && base != sd)
+			sd = sd->s_parent;
+
+		if (base == sd)
+			break;
+
+		strcpy(s, "../");
+		s += 3;
+		base = base->s_parent;
+	}
+
+	/* determine end of target string for reverse fillup */
+	sd = target_sd;
+	while (sd->s_parent && sd != base) {
+		len += strlen(sd->s_name) + 1;
+		sd = sd->s_parent;
+	}
 
-	depth = object_depth(parent_sd);
-	size = object_path_length(target_sd) + depth * 3 - 1;
-	if (size > PATH_MAX)
+	/* check limits */
+	if (len < 2)
+		return -EINVAL;
+	len--;
+	if ((s - path) + len > PATH_MAX)
 		return -ENAMETOOLONG;
 
-	pr_debug("%s: depth = %d, size = %d\n", __FUNCTION__, depth, size);
+	/* reverse fillup of target string from target to base */
+	sd = target_sd;
+	while (sd->s_parent && sd != base) {
+		int slen = strlen(sd->s_name);
 
-	for (s = path; depth--; s += 3)
-		strcpy(s,"../");
+		len -= slen;
+		strncpy(s + len, sd->s_name, slen);
+		if (len)
+			s[--len] = '/';
 
-	fill_object_path(target_sd, path, size);
-	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
+		sd = sd->s_parent;
+	}
 
 	return 0;
 }


