Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYIDOIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYIDOIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYIDOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:07:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35005 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYIDOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:07:50 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080904132804.GA14709@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com> <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com>
Message-Id: <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Sep 2008 16:06:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> Are you going to revert the change forcing CL_SLAVE for
> !capable(CAP_SYS_ADMIN)?  I don't think we want that - I think that
> *within* a set of user mounts, propagation should be safe, right?
> 
> Will you be able to do this soon?  If not, should we just do the part
> returning -EPERM when turning a shared mount into a user mount? 

OK, let's do that first and the tricky part (propagation vs. user
mounts) later.  Will push after I've tested it.

> Because I think that would then be ready for testing in -mm, and would
> love to see it tested.
> 
> Were you going to push a patch to mount to do the user mounts, or
> put sample code in Documentation, git log, or under samples/?

I've got a patch against util-linux-ng, but Karel doesn't want to take
it (understandibly) until the kernel patches have made it into
mainline.

Here it is, if you want to play with it.

Thanks,
Miklos
----

Subject: util-linux-ng: unprivileged mounts support

From: Miklos Szeredi <mszeredi@suse.cz>

This is an experimental patch for supporing unprivileged mounts and
umounts.  The following features are added:

1) If mount/umount are suid, first try without privileges.

This is done by forking, dropping privileges in child, and redirecting
stderr to /dev/null.  If this succeeds, then parent exits with zero
exit code.  Otherwise parent continues normally (with privileges).
This isn't perfect, because the wrong error message will be printed if
mount/umount failed not because of insufficient privileges, but some
other error (e.g. mountpoint busy).

2) Support user mounts in kernel.

If /etc/mtab is a symlink (to /proc/mounts if it's been set up
correctly), then change fsuid for the duration of the mount syscall
and use the MS_SETOWNER flag.  Old kernels will simply ignore this,
and everything will work as before.  Kernels with the unprivileged
mounts patches will set the owner of the mount, and the relevant line
in /proc/PID/mounts will contain a "user=XYZ" option, making this
backward compatible with /etc/mtab.

3) Root can force a specific user for a mount with "-ouser=XYZ".  This
has worked previously as well, but that was probably just accidental
(the option was copied verbatim to /etc/mtab).

4) Add support for "submnt" and "nosubmnt" options.  These can be used
to allow or prohibit unprivileged submounting of a user mount.

Example:

root# mount --bind -ouser=xyz /home/xyz /home/xyz
xyz> mount --bind ~/foo ~/bar
xyz> umount ~/bar

Changes since last version:

 - rename options:  'nomnt' -> 'nosubmnt', 'mnt' -> 'submnt'
 - change error message for EMFILE
 - fix bug in handling 'user' option in /etc/fstab
 - default to 'nosubmnt' for fstab based user mounts, for backward
   compatibility

Todo:

 - proper error reporting for unprivileged mounts and umounts
 - ./configure magic for non-linux systems

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 configure.ac            |    5 +
 mount/Makefile.am       |    4 +
 mount/fsprobe.h         |    1 
 mount/fstab.c           |    2 
 mount/fstab.h           |    1 
 mount/mount.c           |  174 ++++++++++++++++++++++++++++++++++++++++++------
 mount/mount_constants.h |    6 +
 mount/umount.c          |   39 +++++++++-
 8 files changed, 209 insertions(+), 23 deletions(-)

Index: util-linux-ng/configure.ac
===================================================================
--- util-linux-ng.orig/configure.ac	2008-09-04 15:51:56.000000000 +0200
+++ util-linux-ng/configure.ac	2008-09-04 15:52:06.000000000 +0200
@@ -139,6 +139,11 @@ fi
 UTIL_CHECK_LIB(util, openpty)
 UTIL_CHECK_LIB(termcap, tgetnum)
 
+UTIL_CHECK_LIB(cap, cap_get_proc)
+if test $have_cap = no; then
+   AC_MSG_ERROR([libcap is required for mount]);
+fi
+
 AC_ARG_WITH([fsprobe],
   [AS_HELP_STRING([--with-fsprobe], [library to guess filesystems (blkid|volume_id), default is blkid])],
   [], [with_fsprobe=blkid]
Index: util-linux-ng/mount/Makefile.am
===================================================================
--- util-linux-ng.orig/mount/Makefile.am	2008-09-04 15:51:46.000000000 +0200
+++ util-linux-ng/mount/Makefile.am	2008-09-04 15:52:06.000000000 +0200
@@ -69,6 +69,10 @@ mount_LDADD += $(SELINUX_LIBS)
 mount_static_LDADD = $(SELINUX_LIBS_STATIC)
 endif
 
+if HAVE_CAP
+mount_LDADD += -lcap
+endif
+
 if HAVE_VOLUME_ID
 utils_common += fsprobe_volumeid.c
 swapon_SOURCES += ../lib/linux_version.c ../lib/blkdev.c
Index: util-linux-ng/mount/fsprobe.h
===================================================================
--- util-linux-ng.orig/mount/fsprobe.h	2008-09-04 15:51:46.000000000 +0200
+++ util-linux-ng/mount/fsprobe.h	2008-09-04 15:52:06.000000000 +0200
@@ -33,6 +33,7 @@ struct mountargs {
 	const char *type;
 	int flags;
 	void *data;
+	uid_t uid;
 };
 
 extern int fsprobe_known_fstype_in_procfs(const char *type);
Index: util-linux-ng/mount/fstab.c
===================================================================
--- util-linux-ng.orig/mount/fstab.c	2008-09-04 15:51:46.000000000 +0200
+++ util-linux-ng/mount/fstab.c	2008-09-04 15:52:06.000000000 +0200
@@ -52,7 +52,7 @@ mtab_does_not_exist(void) {
 	return var_mtab_does_not_exist;
 }
 
-static int
+int
 mtab_is_a_symlink(void) {
 	get_mtab_info();
 	return var_mtab_is_a_symlink;
Index: util-linux-ng/mount/fstab.h
===================================================================
--- util-linux-ng.orig/mount/fstab.h	2008-09-04 15:51:46.000000000 +0200
+++ util-linux-ng/mount/fstab.h	2008-09-04 15:52:06.000000000 +0200
@@ -2,6 +2,7 @@
 #define MOUNT_FSTAB_H
 
 #include "mount_mntent.h"
+int mtab_is_a_symlink(void);
 int mtab_is_writable(void);
 int mtab_does_not_exist(void);
 void reset_mtab_info(void);
Index: util-linux-ng/mount/mount.c
===================================================================
--- util-linux-ng.orig/mount/mount.c	2008-09-04 15:51:56.000000000 +0200
+++ util-linux-ng/mount/mount.c	2008-09-04 15:52:06.000000000 +0200
@@ -19,6 +19,8 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/mount.h>
+#include <sys/fsuid.h>
+#include <sys/capability.h>
 
 #include <mntent.h>
 
@@ -101,7 +103,7 @@ struct opt_map {
 #define MS_USER		0x20000000
 #define MS_OWNER	0x10000000
 #define MS_GROUP	0x08000000
-#define MS_COMMENT	0x02000000
+#define MS_COMMENT	0x04000000
 #define MS_LOOP		0x00010000
 
 /* Options that we keep the mount system call from seeing.  */
@@ -113,10 +115,10 @@ struct opt_map {
 #define MS_PROPAGATION  (MS_SHARED|MS_SLAVE|MS_UNBINDABLE|MS_PRIVATE)
 
 /* Options that we make ordinary users have by default.  */
-#define MS_SECURE	(MS_NOEXEC|MS_NOSUID|MS_NODEV)
+#define MS_SECURE	(MS_NOEXEC|MS_NOSUID|MS_NODEV|MS_NOSUBMNT)
 
 /* Options that we make owner-mounted devices have by default */
-#define MS_OWNERSECURE	(MS_NOSUID|MS_NODEV)
+#define MS_OWNERSECURE	(MS_NOSUID|MS_NODEV|MS_NOSUBMNT)
 
 static const struct opt_map opt_map[] = {
   { "defaults",	0, 0, 0		},	/* default options */
@@ -176,6 +178,8 @@ static const struct opt_map opt_map[] =
 					  to mtime/ctime */
 #endif
   { "nofail",	0, 0, MS_COMMENT},	/* Do not fail if ENOENT on dev */
+  { "submnt",	0, 1, MS_NOSUBMNT},	/* permit unprivileged submounts */
+  { "nosubmnt",0, 0, MS_NOSUBMNT},	/* no unprivileged submounts */
   { NULL,	0, 0, 0		}
 };
 
@@ -359,7 +363,7 @@ append_context(const char *optname, char
  * For the options uid= and gid= replace user or group name by its value.
  */
 static inline void
-parse_opt(char *opt, int *mask, char **extra_opts) {
+parse_opt(char *opt, int *mask, char **extra_opts, char **user) {
 	const struct opt_map *om;
 
 	for (om = opt_map; om->opt != NULL; om++)
@@ -404,6 +408,11 @@ parse_opt(char *opt, int *mask, char **e
 			return;
 		}
 	}
+	if (strncmp(opt, "user=", 5) == 0) {
+		free(*user);
+		*user = xstrdup(opt + 5);
+		return;
+	}
 
 #ifdef HAVE_LIBSELINUX
 	if (strncmp(opt, "context=", 8) == 0 && *(opt+8)) {
@@ -425,7 +434,7 @@ parse_opt(char *opt, int *mask, char **e
 /* Take -o options list and compute 4th and 5th args to mount(2).  flags
    gets the standard options (indicated by bits) and extra_opts all the rest */
 static void
-parse_opts (const char *options, int *flags, char **extra_opts) {
+parse_opts (const char *options, int *flags, char **extra_opts, char **user) {
 	*flags = 0;
 	*extra_opts = NULL;
 
@@ -448,7 +457,7 @@ parse_opts (const char *options, int *fl
 			/* end of option item or last item */
 			if (*p == '\0' || *(p+1) == '\0') {
 				if (!parse_string_opt(opt))
-					parse_opt(opt, flags, extra_opts);
+					parse_opt(opt, flags, extra_opts, user);
 				opt = NULL;
 			}
 		}
@@ -519,6 +528,7 @@ create_mtab (void) {
 	struct my_mntent mnt;
 	int flags;
 	mntFILE *mfp;
+	char *user = NULL;
 
 	lock_mtab();
 
@@ -532,11 +542,11 @@ create_mtab (void) {
 	/* Find the root entry by looking it up in fstab */
 	if ((fstab = getfs_by_dir ("/")) || (fstab = getfs_by_dir ("root"))) {
 		char *extra_opts;
-		parse_opts (fstab->m.mnt_opts, &flags, &extra_opts);
+		parse_opts (fstab->m.mnt_opts, &flags, &extra_opts, &user);
 		mnt.mnt_dir = "/";
 		mnt.mnt_fsname = fsprobe_get_devname(fstab->m.mnt_fsname);
 		mnt.mnt_type = fstab->m.mnt_type;
-		mnt.mnt_opts = fix_opts_string (flags, extra_opts, NULL);
+		mnt.mnt_opts = fix_opts_string (flags, extra_opts, user);
 		mnt.mnt_freq = mnt.mnt_passno = 0;
 		free(extra_opts);
 
@@ -560,6 +570,39 @@ create_mtab (void) {
 	reset_mtab_info();
 }
 
+static int set_fsuid(uid_t uid, uid_t *olduid)
+{
+	cap_t cap;
+	int res;
+
+	cap = cap_get_proc();
+	if (!cap) {
+		die(EX_FAIL, _("mount: failed to get capabilities: %s"),
+		    strerror(errno));
+	}
+
+	res = setfsuid(uid);
+	if (olduid)
+		*olduid = res;
+
+	if (setfsuid(uid) != uid) {
+		error(_("mount: failed to set user"));
+		errno = EPERM;
+		return -1;
+	}
+
+	res = cap_set_proc(cap);
+	if (res == -1) {
+		die(EX_FAIL, _("mount: failed to restore capabilities"),
+		    strerror(errno));
+	}
+
+	if (verbose > 2)
+		printf(_("mount: fsuid set to %i\n"), uid);
+
+	return 0;
+}
+
 /* count successful mount system calls */
 static int mountcount = 0;
 
@@ -571,16 +614,33 @@ static int mountcount = 0;
 static int
 do_mount_syscall (struct mountargs *args) {
 	int flags = args->flags;
+	uid_t olduid = 0;
+	int res;
 
 	if ((flags & MS_MGC_MSK) == 0)
 		flags |= MS_MGC_VAL;
 
+	if (args->flags & MS_SETUSER) {
+		if (set_fsuid(args->uid, &olduid) == -1)
+			return -1;
+	}
+
 	if (verbose > 2)
 		printf("mount: mount(2) syscall: source: \"%s\", target: \"%s\", "
 			"filesystemtype: \"%s\", mountflags: %d, data: %s\n",
 			args->spec, args->node, args->type, flags, (char *) args->data);
+	res = mount(args->spec, args->node, args->type, flags, args->data);
+
+	if (args->flags & MS_SETUSER) {
+		int errno_save = errno;
+
+		if (set_fsuid(olduid, NULL) == -1)
+			die(EX_FAIL, _("mount: failed to restore fsuid"));
+
+		errno = errno_save;
+	}
 
-	return mount (args->spec, args->node, args->type, flags, args->data);
+	return res;
 }
 
 /*
@@ -702,6 +762,31 @@ guess_fstype_by_devname(const char *devn
    return type;
 }
 
+static int get_user(const char *user, uid_t *uid)
+{
+	char *e;
+	long val;
+	int res;
+
+	if (!user[0])
+		return -1;
+
+	val = strtoul(user, &e, 10);
+	if (!e[0]) {
+		if (val < 0 || (long) (uid_t) val != val)
+			return -1;
+
+		*uid = val;
+	} else {
+		struct passwd *pw = getpwnam(user);
+		if (pw == NULL)
+			return -1;
+
+		*uid = pw->pw_uid;
+	}
+	return 0;
+}
+
 /*
  * guess_fstype_and_mount()
  *	Mount a single file system. Guess the type when unknown.
@@ -711,8 +796,22 @@ guess_fstype_by_devname(const char *devn
  */
 static int
 guess_fstype_and_mount(const char *spec, const char *node, const char **types,
-		       int flags, char *mount_opts, int *special, int *status) {
-   struct mountargs args = { spec, node, NULL, flags & ~MS_NOSYS, mount_opts };
+		       int flags, char *mount_opts, int *special, int *status,
+		       char *user) {
+   struct mountargs args = { spec, node, NULL, flags & ~MS_NOSYS, mount_opts};
+
+   /*
+    * Only set user for the mount if /etc/mtab is a symlink.  Otherwise
+    * user could add submounts without modifying mtab, and so cause
+    * confusion.
+    */
+   args.flags &= ~MS_SETUSER;
+   if (user != NULL && mtab_is_a_symlink()) {
+	   if (get_user(user, &args.uid) != 0)
+		   return 1;
+
+	   args.flags |= MS_SETUSER;
+   }
 
    if (*types && strcasecmp (*types, "auto") == 0)
       *types = NULL;
@@ -766,6 +865,9 @@ guess_fstype_and_mount(const char *spec,
 static void
 suid_check(const char *spec, const char *node, int *flags, char **user) {
   if (suid) {
+      if (*user != NULL)
+	      die (EX_USAGE, _("mount: only root can set user"));
+
       /*
        * MS_OWNER: Allow owners to mount when fstab contains
        * the owner option.  Note that this should never be used
@@ -1067,7 +1169,7 @@ try_mount_one (const char *spec0, const
   char *extra_opts;		/* written in mtab */
   char *mount_opts;		/* actually used on system call */
   const char *opts, *spec, *node, *types;
-  char *user = 0;
+  char *user = NULL;
   int loop = 0;
   const char *loopdev = 0, *loopfile = 0;
   struct stat statbuf;
@@ -1088,7 +1190,7 @@ try_mount_one (const char *spec0, const
   types = types1 = xstrdup(types0);
   opts = opts1 = xstrdup(opts0);
 
-  parse_opts (opts, &flags, &extra_opts);
+  parse_opts (opts, &flags, &extra_opts, &user);
   extra_opts1 = extra_opts;
 
   /* quietly succeed for fstab entries that don't get mounted automatically */
@@ -1139,7 +1241,7 @@ mount_retry:
 
   if (!fake) {
     mnt5_res = guess_fstype_and_mount (spec, node, &types, flags & ~MS_NOSYS,
-				       mount_opts, &special, &status);
+				       mount_opts, &special, &status, user);
 
     if (special) {
       block_signals (SIG_UNBLOCK);
@@ -1278,7 +1380,8 @@ mount_retry:
       break;
     }
     case EMFILE:
-      error (_("mount table full")); break;
+      error (_("maximum number of user mounts exceeded,\n"
+	       "        see: /proc/sys/fs/max_user_mounts\n")); break;
     case EIO:
       error (_("mount: %s: can't read superblock"), spec); break;
     case ENODEV:
@@ -2014,10 +2117,43 @@ main(int argc, char *argv[]) {
 	}
 
 	if (getuid () != geteuid ()) {
-		suid = 1;
-		if (types || options || readwrite || nomtab || mount_all ||
-		    fake || mounttype || (argc + specseen) != 1)
-			die (EX_USAGE, _("mount: only root can do that"));
+		int pid;
+
+		pid = fork();
+		if (pid == -1) {
+			die(EX_SYSERR, _("mount: cannot fork: %s"),
+			    strerror(errno));
+		} else if (pid == 0) {
+			/*
+			 * Child will continue as normal, but first it
+			 * drops privileges, and redirects stderr to
+			 * /dev/null, because we will retry any error
+			 * with the suid privileges.
+			 */
+
+			if (verbose > 1)
+				printf(_("mount: trying without privileges...\n"));
+
+			if(setgid(getgid()) == -1 ||
+			   setuid(getuid()) == -1)
+				exit(1);
+
+			dup2(open("/dev/null", O_WRONLY), 2);
+		} else {
+			int st;
+
+			wait(&st);
+			if (WIFEXITED(st) && WEXITSTATUS(st) == 0)
+				exit(0);
+
+			suid = 1;
+			if (types || options || readwrite || nomtab ||
+			    mount_all || fake || mounttype ||
+			    (argc + specseen) != 1)
+				die (EX_USAGE, _("mount: only root can do that"));
+			if (verbose > 1)
+				printf(_("mount: retrying with privileges...\n"));
+		}
 	}
 
 	atexit(unlock_mtab);
Index: util-linux-ng/mount/mount_constants.h
===================================================================
--- util-linux-ng.orig/mount/mount_constants.h	2008-09-04 15:51:46.000000000 +0200
+++ util-linux-ng/mount/mount_constants.h	2008-09-04 15:52:06.000000000 +0200
@@ -56,6 +56,12 @@
 #ifndef MS_SHARED
 #define MS_SHARED	(1<<20)	/* 1048576 Shared*/
 #endif
+#ifndef MS_SETUSER
+#define MS_SETUSER	(1<<24)
+#endif
+#ifndef MS_NOSUBMNT
+#define MS_NOSUBMNT	(1<<25)
+#endif
 /*
  * Magic mount flag number. Had to be or-ed to the flag values.
  */
Index: util-linux-ng/mount/umount.c
===================================================================
--- util-linux-ng.orig/mount/umount.c	2008-09-04 15:51:56.000000000 +0200
+++ util-linux-ng/mount/umount.c	2008-09-04 15:52:06.000000000 +0200
@@ -643,9 +643,42 @@ main (int argc, char *argv[]) {
 		}
 
 	if (getuid () != geteuid ()) {
-		suid = 1;
-		if (all || types || nomtab || force || remount)
-			die (2, _("umount: only root can do that"));
+		int pid;
+
+		pid = fork();
+		if (pid == -1) {
+			die(EX_SYSERR, _("umount: cannot fork: %s"),
+			    strerror(errno));
+		} else if (pid == 0) {
+			/*
+			 * Child will continue as normal, but first it
+			 * drops privileges, and redirects stderr to
+			 * /dev/null, because we will retry any error
+			 * with the suid privileges.
+			 */
+
+			if (verbose)
+				printf(_("umount: trying without privileges...\n"));
+
+			if(setgid(getgid()) == -1 ||
+			   setuid(getuid()) == -1)
+				exit(1);
+
+			dup2(open("/dev/null", O_WRONLY), 2);
+		} else {
+			int st;
+
+			wait(&st);
+			if (WIFEXITED(st) && WEXITSTATUS(st) == 0)
+				exit(0);
+
+			suid = 1;
+			if (all || types || nomtab || force || remount)
+				die (2, _("umount: only root can do that"));
+
+			if (verbose)
+				printf(_("umount: retrying with privileges...\n"));
+		}
 	}
 
 	argc -= optind;
