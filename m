Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZDWANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZDWANZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZDWANM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:13:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZDWANK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:13:10 -0400
Date: Wed, 22 Apr 2009 20:12:57 -0400
From: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423001257.GA16540@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the default mode for ext3 and btrfs, fsync() is both slow and
unnecessary for some important application use cases - at the same
time that it is absolutely required for correctness for other modes of
ext3, ext4, XFS, etc.  If applications could easilyl distinguish
between the two cases, they would be more likely to be correct and
fast.

How about an fpathconf() variable, something like _PC_ORDERED?  E.g.:

	/* Unoptimized example optional fsync() demo */
	write(fd);
	/* Only fsync() if we need it */
	if (fpath_conf(fd, _PC_ORDERED) != 1)
		fsync(fd);
	rename(tmp_path, new_path);

I know of two specific real-world cases in which this would
significantly improve performance: (a) fsync() before rename(), (b)
fsync() of the parent directory of a newly created file.  Case (b) is
particularly nasty when you have multiple threads creating files in
the same directory because the dir's i_mutex is held across fsync() -
file creates become limited to the speed of sequential fsync()s.

Conceptual libc patch below.

-VAL

diff --git a/sysdeps/unix/sysv/linux/pathconf.c b/sysdeps/unix/sysv/linux/pathconf.c
index db03529..5b64939 100644
--- a/sysdeps/unix/sysv/linux/pathconf.c
+++ b/sysdeps/unix/sysv/linux/pathconf.c
@@ -51,6 +51,9 @@ __pathconf (const char *file, int name)
     case _PC_CHOWN_RESTRICTED:
       return __statfs_chown_restricted (__statfs (file, &fsbuf), &fsbuf);
 
+    case _PC_ORDERED:
+      return __statfs_ordered (__statfs (file, &fsbuf), &fsbuf);
+
     default:
       return posix_pathconf (file, name);
     }
@@ -225,3 +228,44 @@ __statfs_chown_restricted (int result, const struct statfs *fsbuf)
 
   return retval;
 }
+
+
+/* Tells us if write operations are ordered with respect to each
+ * other.  Useful for skipping fsync in some cases.  Default is 0 -
+ * not ordered. */
+
+/* Used like: return statfs_ordered (__statfs (name, &buf), &buf); */
+long int
+__statfs_ordered (int result, const struct statfs *fsbuf)
+{
+  if (result < 0)
+    {
+      if (errno == ENOSYS)
+	/* Not possible, return the default value.  */
+	return 0;
+
+      /* Some error occured.  */
+      return -1;
+    }
+
+#define BTRFS_SUPER_MAGIC       0x9123683E
+  switch (fsbuf->f_type)
+    {
+    case BTRFS_SUPER_MAGIC:
+    case EXT2_SUPER_MAGIC:
+	    /* XXX Must distinguish between 2, 3, and 4 */
+    case REISERFS_SUPER_MAGIC:
+	    /* XXX Nasty hacking needed here to determine exact
+	     * journaling mode.  Options include parsing /proc/mounts,
+	     * defining an ioctl(), creating a generic VFS interface.
+	     * For demonstration purposes, assume the default mode,
+	     * which is ordered for each of these file systems.
+	     */
+	    return 1;
+    case XFS_SUPER_MAGIC:
+	    /* XXX XFS has a trillion options, is there one to do ordered mode? */
+	    return 0;
+    default:
+      return 0;
+    }
+}
diff --git a/bits/confname.h b/bits/confname.h
index 80b51ac..3d19902 100644
--- a/bits/confname.h
+++ b/bits/confname.h
@@ -39,6 +39,8 @@ enum
 #define	_PC_PIPE_BUF			_PC_PIPE_BUF
     _PC_CHOWN_RESTRICTED,
 #define	_PC_CHOWN_RESTRICTED		_PC_CHOWN_RESTRICTED
+    _PC_ORDERED,
+#define	_PC_ORDERED			_PC_ORDERED
     _PC_NO_TRUNC,
 #define	_PC_NO_TRUNC			_PC_NO_TRUNC
     _PC_VDISABLE,
diff --git a/conform/data/unistd.h-data b/conform/data/unistd.h-data
index b6effa0..7325ff5 100644
--- a/conform/data/unistd.h-data
+++ b/conform/data/unistd.h-data
@@ -248,6 +248,7 @@ constant _PC_MAX_CANON
 constant _PC_MAX_INPUT
 constant _PC_NAME_MAX
 constant _PC_NO_TRUNC
+constant _PC_ORDERED
 constant _PC_PATH_MAX
 constant _PC_PIPE_BUF
 constant _PC_PRIO_IO
diff --git a/posix/annexc.c b/posix/annexc.c
index df5913a..658bdc1 100644
--- a/posix/annexc.c
+++ b/posix/annexc.c
@@ -501,7 +501,7 @@ static const char *const unistd_syms[] =
   "F_OK", "NULL", "R_OK", "SEEK_CUR", "SEEK_END", "SEEK_SET", "STDERR_FILENO",
   "STDIN_FILENO", "STDOUT_FILENO", "W_OK", "X_OK",
   "_PC_ASYNC_IO", "_PC_CHOWN_RESTRICTED", "_PC_LINK_MAX", "_PC_MAX_CANON",
-  "_PC_MAX_INPUT", "_PC_NAME_MAX", "_PC_NO_TRUNC", "_PC_PATH_MAX",
+  "_PC_MAX_INPUT", "_PC_NAME_MAX", "_PC_NO_TRUNC", "_PC_PATH_MAX", "_PC_ORDERED",
   "_PC_PIPE_BUF", "_PC_PRIO_IO", "_PC_SYNC_IO", "_PC_VDISABLE",
   "_SC_AIO_LISTIO_MAX", "_SC_AIO_MAX", "_SC_AIO_PRIO_DELTA_MAX",
   "_SC_ARG_MAX", "_SC_ASYNCHRONOUS_IO", "_SC_CHILD_MAX", "_SC_CLK_TCK",
diff --git a/posix/fpathconf.c b/posix/fpathconf.c
index 840460b..d7f9a89 100644
--- a/posix/fpathconf.c
+++ b/posix/fpathconf.c
@@ -47,6 +47,7 @@ __fpathconf (fd, name)
     case _PC_PIPE_BUF:
     case _PC_SOCK_MAXBUF:
     case _PC_CHOWN_RESTRICTED:
+    case _PC_ORDERED:
     case _PC_NO_TRUNC:
     case _PC_VDISABLE:
       break;
diff --git a/posix/getconf.c b/posix/getconf.c
index 6184292..5995d60 100644
--- a/posix/getconf.c
+++ b/posix/getconf.c
@@ -81,6 +81,9 @@ static const struct conf vars[] =
 #ifdef _PC_CHOWN_RESTRICTED
     { "_POSIX_CHOWN_RESTRICTED", _PC_CHOWN_RESTRICTED, PATHCONF },
 #endif
+#ifdef _PC_ORDERED
+    { "_POSIX_ORDERED", _PC_ORDERED, PATHCONF },
+#endif
 #ifdef _PC_NO_TRUNC
     { "_POSIX_NO_TRUNC", _PC_NO_TRUNC, PATHCONF },
 #endif
diff --git a/sysdeps/posix/fpathconf.c b/sysdeps/posix/fpathconf.c
index 605cd17..c29fa6f 100644
--- a/sysdeps/posix/fpathconf.c
+++ b/sysdeps/posix/fpathconf.c
@@ -121,6 +121,13 @@ __fpathconf (fd, name)
       return -1;
 #endif
 
+    case _PC_ORDERED:
+#ifdef	_POSIX_ORDERED
+      return _POSIX_ORDERED;
+#else
+      return -1;
+#endif
+
     case _PC_NO_TRUNC:
 #ifdef	_POSIX_NO_TRUNC
       return _POSIX_NO_TRUNC;
diff --git a/sysdeps/posix/pathconf.c b/sysdeps/posix/pathconf.c
index 75c99ee..f9d84ab 100644
--- a/sysdeps/posix/pathconf.c
+++ b/sysdeps/posix/pathconf.c
@@ -117,6 +117,13 @@ __pathconf (const char *path, int name)
       return -1;
 #endif
 
+    case _PC_ORDERED:
+#ifdef	_POSIX_ORDERED
+    return _POSIX_ORDERED;
+#else
+      return -1;
+#endif
+
     case _PC_NO_TRUNC:
 #ifdef	_POSIX_NO_TRUNC
       return _POSIX_NO_TRUNC;
diff --git a/sysdeps/unix/sysv/linux/fpathconf.c b/sysdeps/unix/sysv/linux/fpathconf.c
index 2701c9e..51c43c4 100644
--- a/sysdeps/unix/sysv/linux/fpathconf.c
+++ b/sysdeps/unix/sysv/linux/fpathconf.c
@@ -48,6 +48,9 @@ __fpathconf (fd, name)
     case _PC_CHOWN_RESTRICTED:
       return __statfs_chown_restricted (__fstatfs (fd, &fsbuf), &fsbuf);
 
+    case _PC_ORDERED:
+      return __statfs_ordered (__fstatfs (fd, &fsbuf), &fsbuf);
+
     default:
       return posix_fpathconf (fd, name);
     }
diff --git a/sysdeps/unix/sysv/linux/pathconf.h b/sysdeps/unix/sysv/linux/pathconf.h
index 806adcc..1c0b513 100644
--- a/sysdeps/unix/sysv/linux/pathconf.h
+++ b/sysdeps/unix/sysv/linux/pathconf.h
@@ -37,3 +37,6 @@ extern long int __statfs_symlinks (int result, const struct statfs *fsbuf);
 /* Used like: return __statfs_chown_restricted (__statfs (name, &buf), &buf);*/
 extern long int __statfs_chown_restricted (int result,
 					   const struct statfs *fsbuf);
+
+/* Used like: return statfs_ordered (__statfs (name, &buf), &buf); */
+extern long int __statfs_ordered (int result, const struct statfs *fsbuf);

