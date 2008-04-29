Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYD2Nk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYD2Nk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbYD2NkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:40:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:59296 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYD2NkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=QtZclaO0i5g85ieLIg3iEDvXxMx3LQUZey6EM0G+LObnzckn7XbFxvrH4n7X3yGngGKltdljeTeOsqCXa3KS/r4mH6n6jwBpWgCQSDWi4ZTvPG0tSfmr5e8HYK+mYgLlYzVntahInP467LqJl3Ue/RQVz22w3nYNbZxEGyMGK4E=
Date: Tue, 29 Apr 2008 19:04:40 +0530
To: libc-alpha@sourceware.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Ulrich Drepper <drepper@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: [RFC PATCH 2/2] Union Mount: glibc seekdir support
Message-ID: <20080429133440.GC9938@localhost.localdomain>
References: <20080429133201.GA9938@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429133201.GA9938@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: bsn.0007@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seekdir support for union mounted directory.

seekdir, telldir and rewinddir  now work on the dirent cache maintained
by readdir.

Signed-off-by: Nagabhushan B S <bsn.0007@gmail.com>
---
 sysdeps/unix/dirstream.h                 |    9 +++++++--
 sysdeps/unix/readdir.c                   |   21 ++++++++++++++++++---
 sysdeps/unix/rewinddir.c                 |   16 ++++++++++++----
 sysdeps/unix/seekdir.c                   |   26 ++++++++++++++++++++++----
 sysdeps/unix/sysv/linux/i386/readdir64.c |    2 ++
 sysdeps/unix/telldir.c                   |    5 ++++-
 6 files changed, 65 insertions(+), 14 deletions(-)

--- a/sysdeps/unix/dirstream.h
+++ b/sysdeps/unix/dirstream.h
@@ -19,11 +19,15 @@
 #ifndef _UNION_DIR_CACHE
 #define _UNION_DIR_CACHE    1
 
-#include <limits.h>
+#include <dirent.h>
+
+#ifndef CACHE_DIRENT_TYPE
+#define CACHE_DIRENT_TYPE struct dirent
+#endif
 
 struct union_dir_cache
 {
-  char fname[NAME_MAX];
+  CACHE_DIRENT_TYPE dp;
   struct union_dir_cache *next;
   struct union_dir_cache *prev;
 };
@@ -66,6 +70,7 @@ struct __dirstream
     struct union_dir_cache *head;
     struct union_dir_cache *current;
     unsigned char union_dir_status;
+    off_t union_dir_pos;
 
     /* Directory block.  */
     char data[0] __attribute__ ((aligned (__alignof__ (void*))));
--- a/sysdeps/unix/readdir.c
+++ b/sysdeps/unix/readdir.c
@@ -48,6 +48,21 @@ __READDIR (DIR *dirp)
   __libc_lock_lock (dirp->lock);
 #endif
 
+  /* If union mounted directory, check if we can return dirent from cache */
+  if (dirp->head && dirp->current->next)
+    {
+      dirp->current = dirp->current->next;
+      while (dirp->current && dirp->current->dp.d_type == DT_WHT)
+        dirp->current = dirp->current->next;
+
+      if (dirp->current) {
+        dirp->union_dir_pos = dirp->current->dp.d_off;
+#ifndef NOT_IN_libc
+        __libc_lock_unlock (dirp->lock);
+#endif
+        return &dirp->current->dp;
+      }
+    }
   do
     {
       size_t reclen;
@@ -135,7 +150,7 @@ __READDIR (DIR *dirp)
               temp = dirp->head;
               while (temp)
                 {
-                  if (!strcmp (temp->fname, dp->d_name))
+                  if (!strcmp (temp->dp.d_name, dp->d_name))
                     {
                       isdup = 1;
                       break;
@@ -168,8 +183,8 @@ __READDIR (DIR *dirp)
               dirp->current = dirp->current->next;
             }
 
-          strcpy(dirp->current->fname, dp->d_name);
-
+          memcpy(&dirp->current->dp, dp, sizeof(DIRENT_TYPE));
+          dirp->current->dp.d_off = ++dirp->union_dir_pos;
         }
 	dirp->union_dir_status &= ~DIR_FIRST_DIRENT;
 
--- a/sysdeps/unix/rewinddir.c
+++ b/sysdeps/unix/rewinddir.c
@@ -29,9 +29,17 @@ rewinddir (dirp)
      DIR *dirp;
 {
   __libc_lock_lock (dirp->lock);
-  (void) __lseek (dirp->fd, (off_t) 0, SEEK_SET);
-  dirp->filepos = 0;
-  dirp->offset = 0;
-  dirp->size = 0;
+  if (dirp->head)
+    {
+      dirp->current = dirp->head;
+      dirp->union_dir_pos = dirp->current->dp.d_off;
+    }
+  else
+    {
+      (void) __lseek (dirp->fd, (off_t) 0, SEEK_SET);
+      dirp->filepos = 0;
+      dirp->offset = 0;
+      dirp->size = 0;
+    }
   __libc_lock_unlock (dirp->lock);
 }
--- a/sysdeps/unix/seekdir.c
+++ b/sysdeps/unix/seekdir.c
@@ -30,9 +30,27 @@ seekdir (dirp, pos)
      long int pos;
 {
   __libc_lock_lock (dirp->lock);
-  (void) __lseek (dirp->fd, pos, SEEK_SET);
-  dirp->size = 0;
-  dirp->offset = 0;
-  dirp->filepos = pos;
+  if (dirp->head) /* union mounted directory */
+    {
+      if (pos == 0)
+        dirp->current = dirp->head;
+      else
+        {
+          dirp->current = dirp->head;
+          while (dirp->current->next && pos != 1)
+            {
+              dirp->current = dirp->current->next;
+              pos--;
+            }
+        }
+      dirp->union_dir_pos = dirp->current->dp.d_off;
+    }
+  else
+    {
+      (void) __lseek (dirp->fd, pos, SEEK_SET);
+      dirp->size = 0;
+      dirp->offset = 0;
+      dirp->filepos = pos;
+    }
   __libc_lock_unlock (dirp->lock);
 }
--- a/sysdeps/unix/sysv/linux/i386/readdir64.c
+++ b/sysdeps/unix/sysv/linux/i386/readdir64.c
@@ -16,6 +16,7 @@
    Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307 USA.  */
 
+#define CACHE_DIRENT_TYPE struct dirent64
 #define __READDIR __readdir64
 #define __GETDENTS __getdents64
 #define DIRENT_TYPE struct dirent64
@@ -34,6 +35,7 @@ versioned_symbol (libc, __readdir64, rea
 
 #include <sysdeps/unix/sysv/linux/i386/olddirent.h>
 
+#define CACHE_DIRENT_TYPE struct __old_dirent64
 #define __READDIR attribute_compat_text_section __old_readdir64
 #define __GETDENTS __old_getdents64
 #define DIRENT_TYPE struct __old_dirent64
--- a/sysdeps/unix/telldir.c
+++ b/sysdeps/unix/telldir.c
@@ -24,5 +24,8 @@
 long int
 telldir (DIR *dirp)
 {
-  return dirp->filepos;
+  if (dirp->head)          /* union mounted directory  */
+    return dirp->union_dir_pos;
+  else
+    return dirp->filepos;
 }
