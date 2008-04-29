Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbYD2Nj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbYD2Nj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYD2NjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:39:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:56963 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbYD2NjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Vs5slQBf7mYk9cGBtJaItnS65B1SxMUn8yzY8S5ZA3nYXyNitowDuq/RYoVovrzYBYL5gBNL4NEeckuPhL/ZKYLoyCtN21d/80sE4PKp/lCt/KPZvdSk5YCahPY54txjpw/2oXYJv1Cyr8KoSQssu+ujGqolURpBVmRSoTe3BoY=
Date: Tue, 29 Apr 2008 19:03:46 +0530
To: libc-alpha@sourceware.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Ulrich Drepper <drepper@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: [RFC PATCH 1/2] Union Mount: glibc readdir support
Message-ID: <20080429133346.GB9938@localhost.localdomain>
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

Enhance readdir to support union mounted directories.

readdir now caches the dirents obtained from readdir(2)/getdents(2)
to support duplicate elimination and whiteout suppression for union
mounted directories.

Signed-off-by: Nagabhushan B S <bsn.0007@gmail.com>
---
 sysdeps/unix/closedir.c  |   14 +++++++++
 sysdeps/unix/dirstream.h |   27 ++++++++++++++++++
 sysdeps/unix/opendir.c   |    4 ++
 sysdeps/unix/readdir.c   |   69 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 112 insertions(+), 2 deletions(-)

--- a/sysdeps/unix/closedir.c
+++ b/sysdeps/unix/closedir.c
@@ -32,6 +32,7 @@ int
 __closedir (DIR *dirp)
 {
   int fd;
+  struct union_dir_cache *temp = NULL;
 
   if (dirp == NULL)
     {
@@ -49,6 +50,19 @@ __closedir (DIR *dirp)
   __libc_lock_fini (dirp->lock);
 #endif
 
+  if (dirp->head != NULL)
+    {
+      while (dirp->head->next != NULL)
+        {
+	  temp = dirp->head->next;
+	  free (dirp->head);
+          dirp->head = temp;
+        }
+      free (dirp->head);
+      dirp->head = NULL;
+      dirp->current = NULL;
+    }
+
   free ((void *) dirp);
 
   return close_not_cancel (fd);
--- a/sysdeps/unix/dirstream.h
+++ b/sysdeps/unix/dirstream.h
@@ -16,6 +16,20 @@
    Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
    02111-1307 USA.  */
 
+#ifndef _UNION_DIR_CACHE
+#define _UNION_DIR_CACHE    1
+
+#include <limits.h>
+
+struct union_dir_cache
+{
+  char fname[NAME_MAX];
+  struct union_dir_cache *next;
+  struct union_dir_cache *prev;
+};
+
+#endif
+
 #ifndef	_DIRSTREAM_H
 #define	_DIRSTREAM_H	1
 
@@ -23,6 +37,14 @@
 
 #include <bits/libc-lock.h>
 
+#define DIR_FIRST_DIRENT	1
+#define DIR_UNION_MOUNTED	2
+#define DIR_DUP_ELIM_START	4
+
+#define IS_FIRST_DIRENT(dirp) (dirp->union_dir_status & DIR_FIRST_DIRENT)
+#define IS_DIR_UNION_MOUNTED(dirp) (dirp->union_dir_status & DIR_UNION_MOUNTED)
+#define IS_DUP_ELIM_STARTED(dirp) (dirp->union_dir_status & DIR_DUP_ELIM_START)
+
 /* Directory stream type.
 
    The miscellaneous Unix `readdir' implementations read directory data
@@ -40,6 +62,11 @@ struct __dirstream
 
     off_t filepos;		/* Position of next entry to read.  */
 
+    /* Cache of dirents to be used with union mounted directories */
+    struct union_dir_cache *head;
+    struct union_dir_cache *current;
+    unsigned char union_dir_status;
+
     /* Directory block.  */
     char data[0] __attribute__ ((aligned (__alignof__ (void*))));
   };
--- a/sysdeps/unix/opendir.c
+++ b/sysdeps/unix/opendir.c
@@ -202,6 +202,10 @@ __alloc_dir (int fd, bool close_fd, cons
   dirp->size = 0;
   dirp->offset = 0;
   dirp->filepos = 0;
+  dirp->head = NULL;
+  dirp->current = NULL;
+  dirp->union_dir_status = 1;
+  dirp->union_dir_pos = 0;
 
   return dirp;
 }
--- a/sysdeps/unix/readdir.c
+++ b/sysdeps/unix/readdir.c
@@ -38,6 +38,9 @@
 DIRENT_TYPE *
 __READDIR (DIR *dirp)
 {
+  int isdup;
+  struct union_dir_cache *temp = NULL;
+
   DIRENT_TYPE *dp;
   int saved_errno = errno;
 
@@ -108,8 +111,70 @@ __READDIR (DIR *dirp)
       dirp->filepos += reclen;
 #endif
 
-      /* Skip deleted files.  */
-    } while (dp->d_ino == 0);
+      if (IS_FIRST_DIRENT(dirp))
+        {
+          if (dp->d_type == DT_WHT && !strcmp (dp->d_name, "."))
+            dirp->union_dir_status |= DIR_UNION_MOUNTED;
+        }
+
+      if (IS_DIR_UNION_MOUNTED(dirp)  && !IS_FIRST_DIRENT(dirp))
+        {
+          /* Skip a file with 0 inode number, make sure that
+             it is not a whiteout type of file. We can get a "." whiteout
+             with inode number 0 at the beginning of each directory. */
+          if (dp->d_ino == 0 && dp->d_type != DT_WHT)
+            continue;
+
+          if (dp->d_type == DT_WHT && !strcmp (dp->d_name, "."))
+             dirp->union_dir_status |= DIR_DUP_ELIM_START;
+
+          isdup = 0;
+          if (IS_DUP_ELIM_STARTED(dirp))
+            {
+              /* Check if the dirent is already present in our cache */
+              temp = dirp->head;
+              while (temp)
+                {
+                  if (!strcmp (temp->fname, dp->d_name))
+                    {
+                      isdup = 1;
+                      break;
+                    }
+                  temp = temp->next;
+                }
+            }
+
+          if (isdup)
+            {
+              /* Found a duplicate, don't include it in dirent cache */
+              dp->d_ino = 0;
+              continue;
+            }
+
+          temp = (struct union_dir_cache *) malloc (sizeof (struct union_dir_cache));
+          temp->next = NULL;
+          temp->prev = NULL;
+
+
+          if (!dirp->head)    /* Reading this dir first time.  */
+            {
+              dirp->head = temp;
+              dirp->current = temp;
+            }
+          else
+            {
+              dirp->current->next = temp;
+              temp->prev = dirp->current;
+              dirp->current = dirp->current->next;
+            }
+
+          strcpy(dirp->current->fname, dp->d_name);
+
+        }
+	dirp->union_dir_status &= ~DIR_FIRST_DIRENT;
+
+     /* Skip deleted files.  */
+    } while (dp->d_ino == 0 || dp->d_type == DT_WHT);
 
 #ifndef NOT_IN_libc
   __libc_lock_unlock (dirp->lock);
