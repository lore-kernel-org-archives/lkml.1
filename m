Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXDUTEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXDUTEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXDUTEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:04:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:39830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXDUTEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:04:09 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Date: Sat, 21 Apr 2007 21:04:06 +0200
User-Agent: KMail/1.9.5
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704201840.07247.agruen@suse.de> <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com>
In-Reply-To: <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704212104.06349.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 21:17, Ulrich Drepper wrote:
> On 4/20/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> > The code also seems to stop at the first matching mount point. You can
> > have the same device mounted on the same mount point multiple times but
> > with different mount options, e.g., [...]
> 
> You can unfortunately do many stupid things.  That's the user's
> problem.  The point is that everything works fine in an environment
> which does not have such bogus mounts.

What I described is a supported feature, nothing more and nothing less. It's 
also relatively easy to handle this case correctly in glibc, e.g.,

--- a/sysdeps/unix/sysv/linux/internal_statvfs.c
+++ b/sysdeps/unix/sysv/linux/internal_statvfs.c
@@ -139,6 +139,7 @@ __statvfs_getflags (const char *name, in
 	      char *cp = mntbuf.mnt_opts;
 	      char *opt;
 
+	      result = 0;
 	      while ((opt = strsep (&cp, ",")) != NULL)
 		if (strcmp (opt, "ro") == 0)
 		  result |= ST_RDONLY;
@@ -157,9 +158,10 @@ __statvfs_getflags (const char *name, in
 		else if (strcmp (opt, "nodiratime") == 0)
 		  result |= ST_NODIRATIME;
 
-	      /* We can stop looking for more entries.  */
 	      success = true;
-	      break;
+	      /* Don't stop looking: the same device may be mounted several
+	         times with different options; in that case, the last entry
+		 is the topmost mount.  */
 	    }
 	}
       /* Maybe the kernel names for the filesystems changed or the

> > I gave a chroot example that showed that in the current implementation,
> > you can get pretty random clashes between mounts; there are other cases
> > with lazy unmounts as well. 
> 
> Irrelevant as well.  If you create chroot problems it's your problem.

There is no way to avoid these problems with chroots; it's not that anybody 
creates stupid problems on purpose.

The approach I'm proposing fixes these problems. It has a small disadvantage 
for statvfs / fstatvfs in some situations, which is due to the fact that the 
kernel doesn't offer a direct interface for querying the mount options of a 
file descriptor or path, and so glibc has to resort to messing 
with /proc/mounts. I don't see a nice way of fixing this without introducing 
[f]statvfs syscalls right now.

This is what POSIX says about statvfs / fstatvfs:
> It is unspecified whether all members of the statvfs structure have
> meaningful values on all file systems.

In my opinion, the advantage of not reporting bogus pathnames in /proc/mounts 
by far outweighs the problems is sometimes causes for fstatvfs(). Anyone 
relying on the information obtained from statvfs / fstatvfs is making false 
assumptions anyway, and in "normal setups" as you called them, nothing 
changes for fstatvfs and statvfs.

Andreas
