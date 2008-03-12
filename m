Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYCLS1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYCLS1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYCLS1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:27:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYCLS1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:27:38 -0400
Subject: [RFC] correct flags to f_mode conversion in __dentry_open
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: alan <alan@redhat.com>, aviro@redhat.com, drepper@redhat.com,
       hch@infradead.org, sds@tycho.nsa.gov, jmorris@namei.org
Content-Type: text/plain
Date: Wed, 12 Mar 2008 14:25:27 -0400
Message-Id: <1205346327.5297.232.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently tried to add an SELinux BUG_ON in the case where the kernel
made a permission request for no permissions and was able to stumble
over it with something as simple as

open("/dev/null", 3);

Notice that 3 == (O_RDWR | O_WRONLY)

First question, is 3 ever a valid flag from from userspace to sys_open?
I see in the comments proceeding do_filp_open()

/*
 * Note that while the flag value (low two bits) for sys_open means:
 *      00 - read-only
 *      01 - write-only
 *      10 - read-write
 *      11 - special
 * it is changed into
 *      00 - no permissions needed
 *      01 - read-permission
 *      10 - write-permission
 *      11 - read-write
 * for the internal routines (ie open_namei()/follow_link() etc). 00 is
 * used by symlinks.
 */

Where someone indicated that 11 is 'special.'  Does 'special' really
mean invalid?  And how should 'special' map to FMODE_*?

I also see that do_filp_open() does the mapping like:
        if ((namei_flags+1) & O_ACCMODE)
                namei_flags++;
and on another code path __dentry_open() is doing a similar mapping:
       f->f_mode = ((flags+1) & O_ACCMODE) | FMODE_LSEEK |
                               FMODE_PREAD | FMODE_PWRITE;

The issue at hand is that the pass through do_filp_open() with flags = 3
will result in the lower two bits still being 11 and SELinux will test
for RDWR.  But the pass through __dentry_open will result in an f_mode
of 00 and will result in SELinux hitting my new (not yet in kernel)
BUG_ON() since 11 was mapped to 00.

What is this mapping supposed to be?  What is 'special' supposed to
mean?  I added the following patch which makes the __dentry_open()
conversion more like the do_filp_open() conversion and my machine seems
to be working well and surviving/acting as the way I expected.  What
does 11 really mean and should it really always be mapped to (FMODE_READ
| FMODE_WRITE) or should it continue to get mapped to 'no permission?'

-Eric

---

diff --git a/fs/open.c b/fs/open.c
index 5419853..6e04926 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -736,10 +736,14 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 {
 	struct inode *inode;
 	int error;
+	mode_t f_mode;
+
+	f_mode = flags & O_ACCMODE;
+	if ((f_mode+1) & O_ACCMODE)
+		f_mode++;
 
 	f->f_flags = flags;
-	f->f_mode = ((flags+1) & O_ACCMODE) | FMODE_LSEEK |
-				FMODE_PREAD | FMODE_PWRITE;
+	f->f_mode = f_mode | FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
 		error = get_write_access(inode);


