Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZBLHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZBLHC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 02:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZBLHCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 02:02:47 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:49008 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBLHCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:02:46 -0500
Date: Thu, 12 Feb 2009 00:02:10 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: alex.williamson@hp.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090212070210.GB6916@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	alex.williamson@hp.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <20090211202601.GC3402@ldl.fc.hp.com> <20090211223903.GA21100@suse.de> <20090212025655.GA6916@ldl.fc.hp.com> <20090212030227.GA4859@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212030227.GA4859@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Wed, Feb 11, 2009 at 07:56:55PM -0700, Alex Chiang wrote:
> > * Greg KH <gregkh@suse.de>:
> > > On Wed, Feb 11, 2009 at 01:26:01PM -0700, Alex Chiang wrote:
> > > > Give a better clue about where we might be creating duplicate
> > > > files by displaying the parent's name as well.
> > > > 
> > > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > > > ---
> > > > It would be nice to get a full path, but simply printing out the
> > > > parent is cheap and more useful than what we have now.
> > > 
> > > What happens if you don't have a parent?  will this oops if you are
> > > creating a duplicate device in the root of the sysfs tree?
> > 
> > We won't oops because if you attempt to create a device in the
> > root of the sysfs tree with a NULL parent, then we say that your
> > parent is sysfs_root:
> > 
> > int sysfs_create_dir(struct kobject * kobj)
> > {
> > 	...
> >         if (kobj->parent)
> > 		parent_sd = kobj->parent->sd;
> > 	else
> > 		parent_sd = &sysfs_root;
> > 	...
> > 
> > But I do notice that we're not giving sysfs_root a name, so if
> > you do hit the WARN for a duplicate entry in sysfs_root, you get
> > a blank string for the location of the duplicate.
> > 
> > How about this instead?
> > 
> > From: Alex Chiang <achiang@hp.com>
> > 
> > sysfs: give sysfs_root a proper name; display parent in duplicate entry WARN
> > 
> > Name sysfs_root "/".
> > 
> > Make sysfs_add_one tell you _where_ you're attempting to create a
> > duplicate file to help debug.
> > 
> > Giving sysfs_root a proper name covers the case when trying to
> > create multiple entries with the same name in the root of the
> > sysfs tree.
> > 
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > Still would be nicer to get a full path.
> 
> It would, and you _almost_ might be able to get it, but it might take
> some work.  We do store the last sysfs file accessed, and can compute
> the path of that as we have a struct file * to play with.  You could
> walk the tree of devices backwards to reconstruct the full path to
> emulate this if you want to.
> 
> > I think that in the context of a sysfs WARN, claiming that you're
> > trying to create a duplicate file in "/" really means "/sys" and
> > shouldn't be confusing. Sample output:
> 
> While you and I mount sysfs at /sys/ and it is the "expected" place for
> it to be, we shouldn't just assume that is where it is in the
> filesystem, especially as I don't where the container people are placing
> sysfs.
> 
> > sysfs: duplicate filename 'alex' can not be created in /
> > 
> > This maybe wants to be 2 patches, and I can split it up that way
> > if you prefer.
> 
> Sure, that would probably be best.

Here's v3.

Seems like 1 patch makes sense because the logical change is that
sysfs_add_one() now displays the full sysfs path to a duplicate
entry. The fact that it relies on a helper function is an
implementation detail. ;)

I tested it by hacking up a kernel to create duplicate entries in
both sysfs_root, as well as creating duplicate entries under a
random sysfs directory.

Examples:

-----------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:488 sysfs_add_one+0xe0/0x100()
sysfs: cannot create duplicate filename '/alex'

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:488 sysfs_add_one+0xe0/0x100()
Hardware name: server rx6600                   
sysfs: cannot create duplicate filename '/bus/pci/slots/5/alex'

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
The strcat(strcat()) is a little ugly, but concise and accurate.

Without the memset, I get all sorts of stack garbage when the
path is finally printed out.

 dir.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..73d34a0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -434,6 +434,27 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_pathname - return full path to sysfs dirent
+ *	@sd: sysfs_dirent whose path we want
+ *	@path: caller allocated buffer
+ *
+ *	Gives the name "/" to the sysfs_root entry; any path returned
+ *	is relative to wherever sysfs is mounted.
+ *
+ *	XXX: does no error checking on @path; assumes caller did something
+ *	     sane, like char path[PATH_MAX]
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
@@ -458,8 +479,15 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	int ret;
 
 	ret = __sysfs_add_one(acxt, sd);
-	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
+	if (ret == -EEXIST) {
+		char path[PATH_MAX];
+		memset(path, 0, PATH_MAX);
+		WARN(1, KERN_WARNING
+		     "sysfs: cannot create duplicate filename '%s'\n",
+		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
+			    sd->s_name));
+	}
+
 	return ret;
 }
 
