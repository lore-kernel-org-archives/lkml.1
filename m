Return-Path: <linux-kernel-owner+w=401wt.eu-S1764314AbXFBW7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764314AbXFBW7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763122AbXFBW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:59:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2717 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762381AbXFBW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:59:09 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Sat, 02 Jun 2007 15:59:05 -0700
Subject: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch plugs the extended fdmap into the kernel. At the moment, this
is done only through sys_dup2() and F_DUPFD.
The base value for the unsequential file descriptor allocation is (at the
moment) set to FD_UNSEQ_BASE (defined in asm-generic/fcntl.h):

#define FD_UNSEQ_BASE	(1U << 28)

The sys_dup2() system call (and the F_DUPFD ioclt) understand values from
FD_UNSEQ_BASE up, and use the unsequential fdmap in that case.
In sys_dup2(), if the FD_UNSEQ_ALLOC bit of "newfd" is set, the syscall will
allocate a new file descriptor inside the unsequential fdmap:

#define FD_UNSEQ_ALLOC	(1U << 30)

All the functions that deal with fd<->file* has been changed to make them
unsequential fdmap aware.
There is a new kernel function get_unused_fd_unseq() (and its locked version
__get_unused_fd_unseq()), that can be used to allocate file descriptors
inside the unsequential fdmap. At the moment, no one besides sys_dup2() and
F_DUPFD uses it, but it is possible to integrate it in other paths generating
new file descriptors.
It'd be possible to add a new O_UNSEQFD flag to open(2) and make sys_open()
to allocate the new descriptor inside the unsequential map.
So at the moment, to allocate a file descriptor in the unsequential map, you
can do something like:

	ufd = dup2(fd, FD_UNSEQ_ALLOC);
	close(fd);

and use "ufd" instead of "fd".
Verified and tested on a P4 HT and a dual Opteron using this test program:

http://www.xmailserver.org/extfd-test.c



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/include/linux/file.h
===================================================================
--- linux-2.6.mod.orig/include/linux/file.h	2007-06-02 15:34:26.000000000 -0700
+++ linux-2.6.mod/include/linux/file.h	2007-06-02 15:36:07.000000000 -0700
@@ -11,6 +11,12 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/types.h>
+#include <linux/fdmap.h>
+
+/*
+ * Initial size for the non sequential file descriptor arena
+ */
+#define FDMAP_UNSEQ_SIZE	64U
 
 /*
  * The default fd array needs to be at least BITS_PER_LONG,
@@ -50,9 +56,15 @@
    */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	int next_fd;
+	int fd_count;
 	struct embedded_fd_set close_on_exec_init;
 	struct embedded_fd_set open_fds_init;
 	struct file * fd_array[NR_OPEN_DEFAULT];
+
+	/*
+	 * Used for non-contiguous file descriptor allocations.
+	 */
+	struct fd_map *fmap;
 };
 
 #define files_fdtable(files) (rcu_dereference((files)->fdt))
@@ -77,22 +89,27 @@
 struct kmem_cache;
 
 extern int expand_files(struct files_struct *, int nr);
+extern struct fd_map *files_fdmap_alloc(struct files_struct *files,
+					unsigned int size);
+extern int __get_unused_fd_unseq(struct files_struct *files, int fd,
+				 unsigned long flags);
+extern int get_unused_fd_unseq(struct files_struct *files, int fd,
+			       unsigned long flags);
 extern void free_fdtable_rcu(struct rcu_head *rcu);
 extern void __init files_defer_init(void);
+extern struct file *fcheck_files(struct files_struct *files, unsigned int fd);
 
 static inline void free_fdtable(struct fdtable *fdt)
 {
 	call_rcu(&fdt->rcu, free_fdtable_rcu);
 }
 
-static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
+/*
+ * Must be called with files->lock held.
+ */
+static inline struct fd_map *files_fdmap(struct files_struct *files)
 {
-	struct file * file = NULL;
-	struct fdtable *fdt = files_fdtable(files);
-
-	if (fd < fdt->max_fds)
-		file = rcu_dereference(fdt->fd[fd]);
-	return file;
+	return files->fmap ? files->fmap: files_fdmap_alloc(files, 0);
 }
 
 /*
Index: linux-2.6.mod/fs/fcntl.c
===================================================================
--- linux-2.6.mod.orig/fs/fcntl.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/fs/fcntl.c	2007-06-02 15:36:07.000000000 -0700
@@ -28,22 +28,34 @@
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
 	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	if (flag)
-		FD_SET(fd, fdt->close_on_exec);
-	else
-		FD_CLR(fd, fdt->close_on_exec);
+	if (files->fmap && fdmap_fdof(files->fmap, fd))
+		fdmap_set_fdflags(files->fmap, fd, flag ? 0: FDMAP_F_CLOEXEC,
+				  flag ? FDMAP_F_CLOEXEC: 0);
+	else {
+		fdt = files_fdtable(files);
+		if (flag)
+			FD_SET(fd, fdt->close_on_exec);
+		else
+			FD_CLR(fd, fdt->close_on_exec);
+	}
 	spin_unlock(&files->file_lock);
 }
 
 static int get_close_on_exec(unsigned int fd)
 {
 	struct files_struct *files = current->files;
+	struct fd_map *fmap;
 	struct fdtable *fdt;
 	int res;
+
 	rcu_read_lock();
-	fdt = files_fdtable(files);
-	res = FD_ISSET(fd, fdt->close_on_exec);
+	fmap = rcu_dereference(files->fmap);
+	if (fmap && fdmap_fdof(fmap, fd))
+		res = (fdmap_get_fdflags(fmap, fd) & FDMAP_F_CLOEXEC) != 0;
+	else {
+		fdt = files_fdtable(files);
+		res = FD_ISSET(fd, fdt->close_on_exec);
+	}
 	rcu_read_unlock();
 	return res;
 }
@@ -62,11 +74,12 @@
 	int error;
 	struct fdtable *fdt;
 
-	error = -EINVAL;
 	if (orig_start >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
-		goto out;
-
+		return -EINVAL;
 repeat:
+	if (files->fd_count >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+		return -EMFILE;
+
 	fdt = files_fdtable(files);
 	/*
 	 * Someone might have closed fd's in the range
@@ -80,14 +93,13 @@
 	if (start < fdt->max_fds)
 		newfd = find_next_zero_bit(fdt->open_fds->fds_bits,
 					   fdt->max_fds, start);
-	
-	error = -EMFILE;
+
 	if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
-		goto out;
+		return -EMFILE;
 
 	error = expand_files(files, newfd);
 	if (error < 0)
-		goto out;
+		return error;
 
 	/*
 	 * If we needed to expand the fs array we
@@ -103,11 +115,9 @@
 	 */
 	if (start <= files->next_fd)
 		files->next_fd = newfd + 1;
+	files->fd_count++;
 
-	error = newfd;
-	
-out:
-	return error;
+	return newfd;
 }
 
 static int dupfd(struct file *file, unsigned int start)
@@ -117,18 +127,22 @@
 	int fd;
 
 	spin_lock(&files->file_lock);
-	fd = locate_fd(files, file, start);
-	if (fd >= 0) {
-		/* locate_fd() may have expanded fdtable, load the ptr */
-		fdt = files_fdtable(files);
-		FD_SET(fd, fdt->open_fds);
-		FD_CLR(fd, fdt->close_on_exec);
-		spin_unlock(&files->file_lock);
+	if (start >= FD_UNSEQ_BASE)
+		fd = __get_unused_fd_unseq(files, FDMAP_HINT_FDUP(start), 0);
+	else {
+		fd = locate_fd(files, file, start);
+		if (fd >= 0) {
+			/* locate_fd() may have expanded fdtable, load the ptr */
+			fdt = files_fdtable(files);
+			FD_SET(fd, fdt->open_fds);
+			FD_CLR(fd, fdt->close_on_exec);
+		}
+	}
+	spin_unlock(&files->file_lock);
+	if (likely(fd >= 0))
 		fd_install(fd, file);
-	} else {
-		spin_unlock(&files->file_lock);
+	else
 		fput(file);
-	}
 
 	return fd;
 }
@@ -136,7 +150,7 @@
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
 {
 	int err = -EBADF;
-	struct file * file, *tofree;
+	struct file * file, *tofree = NULL;
 	struct files_struct * files = current->files;
 	struct fdtable *fdt;
 
@@ -146,32 +160,52 @@
 	err = newfd;
 	if (newfd == oldfd)
 		goto out_unlock;
-	err = -EBADF;
-	if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
-		goto out_unlock;
-	get_file(file);			/* We are now finished with oldfd */
-
-	err = expand_files(files, newfd);
-	if (err < 0)
-		goto out_fput;
-
-	/* To avoid races with open() and dup(), we will mark the fd as
-	 * in-use in the open-file bitmap throughout the entire dup2()
-	 * process.  This is quite safe: do_close() uses the fd array
-	 * entry, not the bitmap, to decide what work needs to be
-	 * done.  --sct */
-	/* Doesn't work. open() might be there first. --AV */
+	if (newfd >= FD_UNSEQ_BASE) {
+		if (!(newfd & FD_UNSEQ_ALLOC)) {
+			if (files->fmap && fdmap_fdof(files->fmap, newfd))
+				tofree = fdmap_file_get(files->fmap, newfd);
+		}
+		if (!tofree) {
+			err = __get_unused_fd_unseq(files,
+				newfd & FD_UNSEQ_ALLOC ? FDMAP_HINT_ANY:
+						    FDMAP_HINT_EXACT(newfd), 0);
+			if (err < 0)
+				goto out_unlock;
+			newfd = err;
+		}
+		get_file(file);
+		fdmap_install(files->fmap, newfd, file);
+	} else {
+		err = -EBADF;
+		if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+			goto out_unlock;
+		get_file(file);		/* We are now finished with oldfd */
+
+		err = expand_files(files, newfd);
+		if (err < 0)
+			goto out_fput;
+
+		/* To avoid races with open() and dup(), we will mark the fd as
+		 * in-use in the open-file bitmap throughout the entire dup2()
+		 * process.  This is quite safe: do_close() uses the fd array
+		 * entry, not the bitmap, to decide what work needs to be
+		 * done.  --sct */
+		/* Doesn't work. open() might be there first. --AV */
 
-	/* Yes. It's a race. In user space. Nothing sane to do */
-	err = -EBUSY;
-	fdt = files_fdtable(files);
-	tofree = fdt->fd[newfd];
-	if (!tofree && FD_ISSET(newfd, fdt->open_fds))
-		goto out_fput;
-
-	rcu_assign_pointer(fdt->fd[newfd], file);
-	FD_SET(newfd, fdt->open_fds);
-	FD_CLR(newfd, fdt->close_on_exec);
+		/* Yes. It's a race. In user space. Nothing sane to do */
+		err = -EBUSY;
+		fdt = files_fdtable(files);
+		tofree = fdt->fd[newfd];
+		if (FD_ISSET(newfd, fdt->open_fds)) {
+			if (!tofree)
+				goto out_fput;
+		} else
+			files->fd_count++;
+
+		rcu_assign_pointer(fdt->fd[newfd], file);
+		FD_SET(newfd, fdt->open_fds);
+		FD_CLR(newfd, fdt->close_on_exec);
+	}
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
Index: linux-2.6.mod/fs/exec.c
===================================================================
--- linux-2.6.mod.orig/fs/exec.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/fs/exec.c	2007-06-02 15:36:07.000000000 -0700
@@ -783,6 +783,8 @@
 static void flush_old_files(struct files_struct * files)
 {
 	long j = -1;
+	unsigned int start, base;
+	unsigned long fset;
 	struct fdtable *fdt;
 
 	spin_lock(&files->file_lock);
@@ -807,6 +809,18 @@
 		spin_lock(&files->file_lock);
 
 	}
+	for (start = 0;;) {
+		if (!files->fmap)
+			break;
+		if (!fdmap_next_flag_set(files->fmap, FDMAP_BIT_CLOEXEC,
+					 &start, &base, &fset))
+			break;
+		spin_unlock(&files->file_lock);
+		for (; fset; base++, fset >>= 1)
+			if (fset & 1)
+				sys_close(base);
+		spin_lock(&files->file_lock);
+	}
 	spin_unlock(&files->file_lock);
 }
 
Index: linux-2.6.mod/kernel/exit.c
===================================================================
--- linux-2.6.mod.orig/kernel/exit.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/kernel/exit.c	2007-06-02 15:36:07.000000000 -0700
@@ -417,10 +417,18 @@
 
 EXPORT_SYMBOL(daemonize);
 
+static int files_fdmap_close(void *priv, struct file *file)
+{
+	filp_close(file, (struct files_struct *) priv);
+	cond_resched();
+	return 0;
+}
+
 static void close_files(struct files_struct * files)
 {
 	int i, j;
 	struct fdtable *fdt;
+	struct file *file;
 
 	j = 0;
 
@@ -438,7 +446,7 @@
 		set = fdt->open_fds->fds_bits[j++];
 		while (set) {
 			if (set & 1) {
-				struct file * file = xchg(&fdt->fd[i], NULL);
+				file = xchg(&fdt->fd[i], NULL);
 				if (file) {
 					filp_close(file, files);
 					cond_resched();
@@ -448,6 +456,8 @@
 			set >>= 1;
 		}
 	}
+	if (files->fmap)
+		fdmap_for_each_file(files->fmap, files_fdmap_close, files);
 }
 
 struct files_struct *get_files_struct(struct task_struct *task)
@@ -469,6 +479,8 @@
 
 	if (atomic_dec_and_test(&files->count)) {
 		close_files(files);
+		if (files->fmap)
+			fdmap_free(files->fmap);
 		/*
 		 * Free the fd and fdset arrays if we expanded them.
 		 * If the fdtable was embedded, pass files for freeing
Index: linux-2.6.mod/fs/open.c
===================================================================
--- linux-2.6.mod.orig/fs/open.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/fs/open.c	2007-06-02 15:36:07.000000000 -0700
@@ -861,10 +861,12 @@
 	int fd, error;
 	struct fdtable *fdt;
 
-  	error = -EMFILE;
 	spin_lock(&files->file_lock);
-
 repeat:
+	error = -EMFILE;
+	if (files->fd_count >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+		goto out;
+
 	fdt = files_fdtable(files);
 	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
 				files->next_fd);
@@ -881,18 +883,17 @@
 	if (error < 0)
 		goto out;
 
-	if (error) {
-		/*
-	 	 * If we needed to expand the fs array we
-		 * might have blocked - try again.
-		 */
-		error = -EMFILE;
+	/*
+	 * If we needed to expand the fs array we
+	 * might have blocked - try again.
+	 */
+	if (error)
 		goto repeat;
-	}
 
 	FD_SET(fd, fdt->open_fds);
 	FD_CLR(fd, fdt->close_on_exec);
 	files->next_fd = fd + 1;
+	files->fd_count++;
 #if 1
 	/* Sanity check */
 	if (fdt->fd[fd] != NULL) {
@@ -911,10 +912,17 @@
 
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
-	struct fdtable *fdt = files_fdtable(files);
-	__FD_CLR(fd, fdt->open_fds);
-	if (fd < files->next_fd)
-		files->next_fd = fd;
+	struct fdtable *fdt;
+
+	if (files->fmap && fdmap_fdof(files->fmap, fd)) {
+		fdmap_putfd(files->fmap, fd);
+	} else {
+		fdt = files_fdtable(files);
+		__FD_CLR(fd, fdt->open_fds);
+		if (fd < files->next_fd)
+			files->next_fd = fd;
+	}
+	files->fd_count--;
 }
 
 void fastcall put_unused_fd(unsigned int fd)
@@ -927,6 +935,116 @@
 
 EXPORT_SYMBOL(put_unused_fd);
 
+struct fd_map *files_fdmap_alloc(struct files_struct *files, unsigned int size)
+{
+	struct fd_map *fmap, *ofmap, *nfmap;
+
+	size = max(size, FDMAP_UNSEQ_SIZE);
+	ofmap = files->fmap;
+	if (ofmap)
+		size = max(size, 2 * ofmap->size);
+	spin_unlock(&files->file_lock);
+	fmap = fdmap_alloc(FD_UNSEQ_BASE, size, !ofmap);
+	spin_lock(&files->file_lock);
+	if (fmap) {
+		nfmap = files->fmap;
+		if (nfmap) {
+			if (ofmap == nfmap) {
+				fdmap_copy(fmap, nfmap, NULL, 0);
+				rcu_assign_pointer(files->fmap, fmap);
+				fdmap_free(nfmap);
+			} else {
+				fdmap_free(fmap);
+				fmap = nfmap;
+			}
+		} else
+			rcu_assign_pointer(files->fmap, fmap);
+	}
+	return fmap;
+}
+
+/**
+ * __get_unused_fd_unseq - Allocates a file descriptor inside the unsequential
+ *                         file descriptor map (locked)
+ *
+ * @files:  [in] Pointer the files_struct that hosts the unsequential file
+ *               descriptor map
+ * @fd:     [in] Hint value for the file descriptor allocation. See function
+ *               fdmap_newfd() description for the @fd values documentation
+ * @flags:  [in] Flags to be associated with the file descriptor
+ *
+ * Returns the allocated file descriptor, or a negative value in case of error.
+ * This function must be called while holding @files->lock. In case the file
+ * descriptor map should be resized, the held lock will be temporarly released
+ * (and re-acquired).
+ */
+int __get_unused_fd_unseq(struct files_struct *files, int fd,
+			  unsigned long flags)
+{
+	int nfd;
+	unsigned long mflags = 0;
+	struct fd_map *fmap;
+
+	/*
+	 * Map special open flags parameters to fdmap flags. TODO!!
+	 */
+
+repeat:
+	if (unlikely(files->fd_count >=
+		     current->signal->rlim[RLIMIT_NOFILE].rlim_cur))
+		return -EMFILE;
+	fmap = files_fdmap(files);
+	if (!fmap)
+		return -ENOMEM;
+	nfd = fdmap_newfd(fmap, fd, mflags);
+	if (unlikely(nfd == -EMFILE)) {
+		unsigned int size = 0, afd = abs(fd);
+
+		if (afd > FD_UNSEQ_BASE) {
+			size = afd - FD_UNSEQ_BASE;
+			size += size / 2;
+		}
+		if (!files_fdmap_alloc(files, size))
+			return -ENOMEM;
+		goto repeat;
+	}
+	files->fd_count++;
+	return nfd;
+}
+
+/**
+ * get_unused_fd_unseq - Allocates a file descriptor inside the unsequential
+ *                       file descriptor map (unlocked)
+ *
+ * This function is the unlocked counterpart of the __get_unused_fd_unseq()
+ * function.
+ */
+int get_unused_fd_unseq(struct files_struct *files, int fd,
+			 unsigned long flags)
+{
+	spin_lock(&files->file_lock);
+	fd = __get_unused_fd_unseq(files, fd, flags);
+	spin_unlock(&files->file_lock);
+	return fd;
+}
+
+struct file *fcheck_files(struct files_struct *files, unsigned int fd)
+{
+	struct file *file = NULL;
+	struct fd_map *fmap;
+	struct fdtable *fdt;
+
+	fmap = rcu_dereference(files->fmap);
+	if (fmap && fdmap_fdof(fmap, fd))
+		file = fdmap_file_get(fmap, fd);
+	else {
+		fdt = files_fdtable(files);
+		if (fd < fdt->max_fds)
+			file = rcu_dereference(fdt->fd[fd]);
+	}
+	return file;
+}
+
 /*
  * Install a file pointer in the fd array.
  *
@@ -945,9 +1063,13 @@
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
 	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	BUG_ON(fdt->fd[fd] != NULL);
-	rcu_assign_pointer(fdt->fd[fd], file);
+	if (files->fmap && fdmap_fdof(files->fmap, fd)) {
+		fdmap_install(files->fmap, fd, file);
+	} else {
+		fdt = files_fdtable(files);
+		BUG_ON(fdt->fd[fd] != NULL);
+		rcu_assign_pointer(fdt->fd[fd], file);
+	}
 	spin_unlock(&files->file_lock);
 }
 
@@ -1053,14 +1175,20 @@
 	int retval;
 
 	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	if (fd >= fdt->max_fds)
-		goto out_unlock;
-	filp = fdt->fd[fd];
-	if (!filp)
-		goto out_unlock;
-	rcu_assign_pointer(fdt->fd[fd], NULL);
-	FD_CLR(fd, fdt->close_on_exec);
+	if (files->fmap && fdmap_fdof(files->fmap, fd)) {
+		filp = fdmap_file_get(files->fmap, fd);
+		if (!filp)
+			goto out_unlock;
+	} else {
+		fdt = files_fdtable(files);
+		if (fd >= fdt->max_fds)
+			goto out_unlock;
+		filp = fdt->fd[fd];
+		if (!filp)
+			goto out_unlock;
+		rcu_assign_pointer(fdt->fd[fd], NULL);
+		FD_CLR(fd, fdt->close_on_exec);
+	}
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 	retval = filp_close(filp, files);
Index: linux-2.6.mod/kernel/fork.c
===================================================================
--- linux-2.6.mod.orig/kernel/fork.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/kernel/fork.c	2007-06-02 15:36:07.000000000 -0700
@@ -641,6 +641,8 @@
 
 	spin_lock_init(&newf->file_lock);
 	newf->next_fd = 0;
+	newf->fd_count = 0;
+	newf->fmap = NULL;
 	fdt = &newf->fdtab;
 	fdt->max_fds = NR_OPEN_DEFAULT;
 	fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
@@ -671,6 +673,27 @@
 		goto out;
 
 	spin_lock(&oldf->file_lock);
+repeat:
+	if (oldf->fmap) {
+		struct fd_map *ofmap;
+		unsigned int size, fcount;
+
+		ofmap = oldf->fmap;
+		size = ofmap->size;
+		spin_unlock(&oldf->file_lock);
+		newf->fmap = fdmap_alloc(FD_UNSEQ_BASE, size, 0);
+		if (!newf->fmap)
+			goto out_release;
+		spin_lock(&oldf->file_lock);
+		if (oldf->fmap != ofmap) {
+			fdmap_free(newf->fmap);
+			newf->fmap = NULL;
+			goto repeat;
+		}
+		fdmap_copy(newf->fmap, ofmap, &fcount, 1);
+		newf->fd_count = fcount;
+	}
+
 	old_fdt = files_fdtable(oldf);
 	new_fdt = files_fdtable(newf);
 	open_files = count_open_files(old_fdt);
@@ -709,6 +732,7 @@
 		struct file *f = *old_fds++;
 		if (f) {
 			get_file(f);
+			newf->fd_count++;
 		} else {
 			/*
 			 * The fd may be claimed in the fd bitmap but not yet
@@ -739,6 +763,8 @@
 	return newf;
 
 out_release:
+	if (newf->fmap)
+		fdmap_free(newf->fmap);
 	kmem_cache_free(files_cachep, newf);
 out:
 	return NULL;
Index: linux-2.6.mod/include/linux/init_task.h
===================================================================
--- linux-2.6.mod.orig/include/linux/init_task.h	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/include/linux/init_task.h	2007-06-02 15:36:07.000000000 -0700
@@ -28,7 +28,9 @@
 	.next_fd	= 0, 				\
 	.close_on_exec_init = { { 0, } }, 		\
 	.open_fds_init	= { { 0, } }, 			\
-	.fd_array	= { NULL, } 			\
+	.fd_array	= { NULL, }, 			\
+	.fd_count	= 0,				\
+	.fmap		= NULL				\
 }
 
 #define INIT_KIOCTX(name, which_mm) \
Index: linux-2.6.mod/kernel/kmod.c
===================================================================
--- linux-2.6.mod.orig/kernel/kmod.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/kernel/kmod.c	2007-06-02 15:36:07.000000000 -0700
@@ -155,6 +155,7 @@
 		fdt = files_fdtable(f);
 		FD_SET(0, fdt->open_fds);
 		FD_CLR(0, fdt->close_on_exec);
+		f->fd_count++;
 		spin_unlock(&f->file_lock);
 
 		/* and disallow core files too */
Index: linux-2.6.mod/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.mod.orig/include/asm-generic/fcntl.h	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/include/asm-generic/fcntl.h	2007-06-02 15:36:07.000000000 -0700
@@ -3,6 +3,17 @@
 
 #include <linux/types.h>
 
+/*
+ * Base for non sequential file descriptors
+ */
+#define FD_UNSEQ_BASE	(1U << 28)
+
+/*
+ * Speacial value for non sequential file descriptors, to tell to
+ * allocate a new non sequential value
+ */
+#define FD_UNSEQ_ALLOC	(1U << 30)
+
 /* open/fcntl - O_SYNC is only implemented on blocks devices and on files
    located on an ext2 file system */
 #define O_ACCMODE	00000003
Index: linux-2.6.mod/fs/proc/base.c
===================================================================
--- linux-2.6.mod.orig/fs/proc/base.c	2007-06-02 15:34:27.000000000 -0700
+++ linux-2.6.mod/fs/proc/base.c	2007-06-02 15:36:07.000000000 -0700
@@ -1384,10 +1384,11 @@
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *p = get_proc_task(inode);
-	unsigned int fd, tid, ino;
+	unsigned int fd, tid, ino, topfd;
 	int retval;
 	struct files_struct * files;
 	struct fdtable *fdt;
+	struct fd_map *fmap;
 
 	retval = -ENOENT;
 	if (!p)
@@ -1412,9 +1413,14 @@
 				goto out;
 			rcu_read_lock();
 			fdt = files_fdtable(files);
-			for (fd = filp->f_pos-2;
-			     fd < fdt->max_fds;
-			     fd++, filp->f_pos++) {
+			fmap = rcu_dereference(files->fmap);
+			fd = filp->f_pos - 2;
+			if (fd < fdt->max_fds || !fmap)
+				topfd = fdt->max_fds;
+			else
+				topfd = fdmap_topfd(fmap);
+rescan:
+			for (; fd < topfd; fd++, filp->f_pos++) {
 				char name[PROC_NUMBUF];
 				int len;
 
@@ -1425,13 +1431,19 @@
 				len = snprintf(name, sizeof(name), "%d", fd);
 				if (proc_fill_cache(filp, dirent, filldir,
 						    name, len, instantiate,
-						    p, &fd) < 0) {
-					rcu_read_lock();
-					break;
-				}
+						    p, &fd) < 0)
+					goto out_put_files;
 				rcu_read_lock();
 			}
+			fmap = rcu_dereference(files->fmap);
+			if (fmap && fd < fdmap_basefd(fmap)) {
+				fd = fdmap_basefd(fmap);
+				filp->f_pos = fd + 2;
+				topfd = fdmap_topfd(fmap);
+				goto rescan;
+			}
 			rcu_read_unlock();
+out_put_files:
 			put_files_struct(files);
 	}
 out:

