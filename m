Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZBLRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZBLRiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbZBLRii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:38:38 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32821 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbZBLRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:38:37 -0500
Date: Thu, 12 Feb 2009 10:38:35 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, arjan@linux.intel.com,
       alex.williamson@hp.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090212173835.GB20654@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>, arjan@linux.intel.com,
	alex.williamson@hp.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <20090211202601.GC3402@ldl.fc.hp.com> <20090211223903.GA21100@suse.de> <20090212025655.GA6916@ldl.fc.hp.com> <20090212030227.GA4859@suse.de> <20090212070210.GB6916@ldl.fc.hp.com> <ac3eb2510902120105u17f5a0f9q13a228b9ff6ff3d4@mail.gmail.com> <20090212160257.GA18786@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212160257.GA18786@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Thu, Feb 12, 2009 at 10:05:23AM +0100, Kay Sievers wrote:
> > On Thu, Feb 12, 2009 at 08:02, Alex Chiang <achiang@hp.com> wrote:
> > 
> > > sysfs: sysfs_add_one WARNs with full path to duplicate filename
> > >
> > > As a debugging aid, it can be useful to know the full path to a
> > > duplicate file being created in sysfs.
> > 
> > >        ret = __sysfs_add_one(acxt, sd);
> > > -       WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
> > > -                      "can not be created\n", sd->s_name);
> > > +       if (ret == -EEXIST) {
> > > +               char path[PATH_MAX];
> > 
> > Isn't that 4k on the stack, and a bit large to put there?
> 
> I agree, that's not ok.  Alex, care to redo this?

Here's v4. Adding Arjan to cc because I realized this may cause
problems for kerneloops.org.

If we're displaying a full path now to something like:

	/sys/bus/pci/devices/.../foo

Then the "..." will highly likely be different on every machine
(even though the programming error is still the same).

Is this patch going to cause major heartburn?

Maybe it's more trouble than it's worth... :-/

Thanks.

/ac

From: Alex Chiang <achiang@hp.com>

sysfs: sysfs_add_one WARNs with full path to duplicate filename

As a debugging aid, it can be useful to know the full path to a
duplicate file being created in sysfs.

We now will display warnings such as:

	sysfs: cannot create duplicate filename '/foo'

when attempting to create multiple files named 'foo' in the sysfs
root, or:

	sysfs: cannot create duplicate filename '/bus/pci/slots/5/foo'

when attempting to create multiple files named 'foo' under a
given directory in sysfs.

The path displayed is always a relative path to sysfs_root. The
leading '/' in the path name refers to the sysfs_root mount
point, and should not be confused with the "real" '/'.

Thanks to Alex Williamson for essentially writing sysfs_pathname.

Cc: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 dir.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)
---
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..ed33361 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -434,6 +434,26 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_pathname - return full path to sysfs dirent
+ *	@sd: sysfs_dirent whose path we want
+ *	@path: caller allocated buffer
+ *
+ *	Gives the name "/" to the sysfs_root entry; any path returned
+ *	is relative to wherever sysfs is mounted.
+ *
+ *	XXX: does no error checking on @path size
+ */
+static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
+{
+	if (sd->s_parent) {
+		sysfs_pathname(sd->s_parent, path);
+		strcat(path, "/");
+	}
+	strcat(path, sd->s_name);
+	return path;
+}
+
+/**
  *	sysfs_add_one - add sysfs_dirent to parent
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
@@ -458,8 +478,15 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	int ret;
 
 	ret = __sysfs_add_one(acxt, sd);
-	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
+	if (ret == -EEXIST) {
+		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
+		WARN(1, KERN_WARNING
+		     "sysfs: cannot create duplicate filename '%s'\n",
+		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
+			    sd->s_name));
+		kfree(path);
+	}
+
 	return ret;
 }
 
