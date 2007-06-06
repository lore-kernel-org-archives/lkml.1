Return-Path: <linux-kernel-owner+w=401wt.eu-S936474AbXFFWbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936474AbXFFWbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936168AbXFFWal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:41 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1319 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935834AbXFFWai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:30:38 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 06 Jun 2007 15:30:31 -0700
Subject: [patch 2/8] fdmap v2 - implements sequential and non-sequential fd allocations using fdmap
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169036.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the kernel use the fdmap allocator for sequential (legacy)
and non-sequential file descriptor allocations. It consolidates all scattered
fdtable internal members accesses into fdmap.{c,h}.
Semantics of sequential file descriptor allocations remains unchanged. They
are still performed in the same way the current fdtable bitmap does.
As far as non-sequential file descriptor allocations goes, we do not allow
F_DUPFD to allocate a file descriptor inside the non-sequential area.
The sys_dup2() system call has been changed to allow over-writing an already
allocated file descriptor inside the non-sequential area. It cannot be used
(sys_dup2()) to allocate a new file descriptor in the non-sequential area.
The base for the non-sequential area is randomly chosen. On top of that,
being FIFO, it's not even easy to predict after the application run for a while.
A simple test program for sys_nonseqfd(), sys_socket2() and O_NONSEQFD is
availble here (verified and tested on a P4 HT and a dual Opteron):

http://www.xmailserver.org/extfd-test.c



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/include/linux/file.h
===================================================================
--- linux-2.6.mod.orig/include/linux/file.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/linux/file.h	2007-06-06 12:48:28.000000000 -0700
@@ -11,52 +11,53 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/types.h>
+#include <linux/fdmap.h>
 
 /*
- * The default fd array needs to be at least BITS_PER_LONG,
- * as this is the granularity returned by copy_fdset().
+ * Initial size for the non sequential file descriptor arena
  */
-#define NR_OPEN_DEFAULT BITS_PER_LONG
+#define FDMAP_NONSEQ_SIZE	64U
 
 /*
- * The embedded_fd_set is a small fd_set,
- * suitable for most tasks (which open <= BITS_PER_LONG files)
+ * Base for non sequential file descriptors
  */
-struct embedded_fd_set {
-	unsigned long fds_bits[1];
-};
+#define FDMAP_NONSEQ_BASE	(1U << 28)
 
-struct fdtable {
-	unsigned int max_fds;
-	struct file ** fd;      /* current fd array */
-	fd_set *close_on_exec;
-	fd_set *open_fds;
-	struct rcu_head rcu;
-	struct fdtable *next;
-};
+#define FDMAP_RANDOM_BITS	20
+
+/*
+ * The default fd array needs to be at least BITS_PER_LONG,
+ * as this is the granularity returned by copy_fdset().
+ */
+#define NR_OPEN_DEFAULT BITS_PER_LONG
 
 /*
  * Open file table structure
  */
 struct files_struct {
-  /*
-   * read mostly part
-   */
+	/*
+	 * read mostly part
+	 */
 	atomic_t count;
-	struct fdtable *fdt;
-	struct fdtable fdtab;
-  /*
-   * written part on a separate cache line in SMP
-   */
+	/*
+	 * Used for legacy (sequential) file descriptor allocations.
+	 */
+	struct fd_map *lfmap;
+	/*
+	 * Used for non-sequential file descriptor allocations.
+	 */
+	struct fd_map *fmap;
+
+	struct fd_map lfmap_embed;
+	/*
+	 * written part on a separate cache line in SMP
+	 */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
-	int next_fd;
-	struct embedded_fd_set close_on_exec_init;
-	struct embedded_fd_set open_fds_init;
-	struct file * fd_array[NR_OPEN_DEFAULT];
+	int fd_count;
+	struct list_head fdmap_slots[NR_OPEN_DEFAULT];
+	unsigned long fdmap_map[FDMAP_BMP_LONGS(NR_OPEN_DEFAULT)];
 };
 
-#define files_fdtable(files) (rcu_dereference((files)->fdt))
-
 extern struct kmem_cache *filp_cachep;
 
 extern void FASTCALL(__fput(struct file *));
@@ -73,25 +74,63 @@
 extern void FASTCALL(set_close_on_exec(unsigned int fd, int flag));
 extern void put_filp(struct file *);
 extern int get_unused_fd(void);
+extern void __put_unused_fd(unsigned int fd);
 extern void FASTCALL(put_unused_fd(unsigned int fd));
 struct kmem_cache;
 
-extern int expand_files(struct files_struct *, int nr);
-extern void free_fdtable_rcu(struct rcu_head *rcu);
-extern void __init files_defer_init(void);
-
-static inline void free_fdtable(struct fdtable *fdt)
+extern void init_files_struct(struct files_struct *newf);
+extern struct fd_map *files_fdmap_alloc(struct files_struct *files,
+					struct fd_map **pfmap,
+					unsigned int size);
+extern int __alloc_nonseq_fd(struct files_struct *files, unsigned long flags);
+extern int alloc_nonseq_fd(struct files_struct *files, unsigned long flags);
+extern unsigned int gen_nonseqfd_base(void);
+
+/**
+ * nonseq_files_fdmap - Must be called with @files->file_lock held. It forces
+ *                      the creation the the non-sequential file descriptor map,
+ *                      if not present.
+ *
+ * @files:  [in] Pointer to the struct files_struct from where the map has to
+ *               be retrieved
+ *
+ */
+static inline struct fd_map *nonseq_files_fdmap(struct files_struct *files)
 {
-	call_rcu(&fdt->rcu, free_fdtable_rcu);
+	struct fd_map *fmap = files->fmap;
+	if (unlikely(!fmap))
+		fmap = files_fdmap_alloc(files, &files->fmap, 0);
+	return fmap;
 }
 
-static inline struct file * fcheck_files(struct files_struct *files, unsigned int fd)
+/**
+ * files_free_fdmap - Frees the non-sequential file descriptor map, if it is
+ *                    not the files-embedded one (files->lfmap_embed)
+ *
+ * @files:  [in] Pointer to the struct files_struct
+ * @fmap:   [in] File descriptor map to be freed
+ *
+ */
+static inline void files_free_fdmap(struct files_struct *files,
+				    struct fd_map *fmap)
 {
-	struct file * file = NULL;
-	struct fdtable *fdt = files_fdtable(files);
+	if (fmap != &files->lfmap_embed)
+		fdmap_free(fmap);
+}
 
-	if (fd < fdt->max_fds)
-		file = rcu_dereference(fdt->fd[fd]);
+static inline struct file *fcheck_files(struct files_struct *files,
+					unsigned int fd)
+{
+	struct file *file = NULL;
+	struct fd_map *fmap;
+	fmap = rcu_dereference(files->lfmap);
+	if (fdmap_fdof(fmap, fd))
+		file = fdmap_file_get(fmap, fd);
+	else {
+		fmap = rcu_dereference(files->fmap);
+		if (fmap && fdmap_fdof(fmap, fd))
+			file = fdmap_file_get(fmap, fd);
+	}
 	return file;
 }
 
@@ -105,6 +144,7 @@
 struct task_struct;
 
 struct files_struct *get_files_struct(struct task_struct *);
+void free_files_struct(struct files_struct *files);
 void FASTCALL(put_files_struct(struct files_struct *fs));
 void reset_files_struct(struct task_struct *, struct files_struct *);
 
Index: linux-2.6.mod/fs/fcntl.c
===================================================================
--- linux-2.6.mod.orig/fs/fcntl.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/fcntl.c	2007-06-06 12:48:03.000000000 -0700
@@ -26,24 +26,28 @@
 void fastcall set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
-	struct fdtable *fdt;
+	struct fd_map *fmap;
+
 	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	if (flag)
-		FD_SET(fd, fdt->close_on_exec);
-	else
-		FD_CLR(fd, fdt->close_on_exec);
+	fmap = files->lfmap;
+	if (!fdmap_fdof(fmap, fd))
+		fmap = files->fmap;
+	fdmap_set_fdflags(fmap, fd, flag ? 0: FDMAP_F_CLOEXEC,
+			  flag ? FDMAP_F_CLOEXEC: 0);
 	spin_unlock(&files->file_lock);
 }
 
 static int get_close_on_exec(unsigned int fd)
 {
 	struct files_struct *files = current->files;
-	struct fdtable *fdt;
+	struct fd_map *fmap;
 	int res;
+
 	rcu_read_lock();
-	fdt = files_fdtable(files);
-	res = FD_ISSET(fd, fdt->close_on_exec);
+	fmap = rcu_dereference(files->lfmap);
+	if (!fdmap_fdof(fmap, fd))
+		fmap = rcu_dereference(files->fmap);
+	res = (fdmap_get_fdflags(fmap, fd) & FDMAP_F_CLOEXEC) != 0;
 	rcu_read_unlock();
 	return res;
 }
@@ -54,81 +58,41 @@
  * file_lock held for write.
  */
 
-static int locate_fd(struct files_struct *files, 
-			    struct file *file, unsigned int orig_start)
+static int locate_fd(struct files_struct *files, unsigned int start)
 {
-	unsigned int newfd;
-	unsigned int start;
-	int error;
-	struct fdtable *fdt;
-
-	error = -EINVAL;
-	if (orig_start >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
-		goto out;
-
-repeat:
-	fdt = files_fdtable(files);
-	/*
-	 * Someone might have closed fd's in the range
-	 * orig_start..fdt->next_fd
-	 */
-	start = orig_start;
-	if (start < files->next_fd)
-		start = files->next_fd;
-
-	newfd = start;
-	if (start < fdt->max_fds)
-		newfd = find_next_zero_bit(fdt->open_fds->fds_bits,
-					   fdt->max_fds, start);
-	
-	error = -EMFILE;
-	if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
-		goto out;
-
-	error = expand_files(files, newfd);
-	if (error < 0)
-		goto out;
-
-	/*
-	 * If we needed to expand the fs array we
-	 * might have blocked - try again.
-	 */
-	if (error)
-		goto repeat;
+	int fd;
+	unsigned int size;
 
-	/*
-	 * We reacquired files_lock, so we are safe as long as
-	 * we reacquire the fdtable pointer and use it while holding
-	 * the lock, no one can free it during that time.
-	 */
-	if (start <= files->next_fd)
-		files->next_fd = newfd + 1;
+	if (start >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+		return -EINVAL;
+	if (files->fd_count >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+		return -EMFILE;
+	if (unlikely(start >= fdmap_topfd(files->lfmap))) {
+		size = start - fdmap_basefd(files->lfmap);
+		size = 2 * min(size, (unsigned int) NR_OPEN / 2);
+		if (!files_fdmap_alloc(files, &files->lfmap, size))
+			return -ENOMEM;
+	}
+	fd = fdmap_newfd_seq(files->lfmap, start,
+			     current->signal->rlim[RLIMIT_NOFILE].rlim_cur, 0);
+	if (likely(fd >= 0))
+		files->fd_count++;
 
-	error = newfd;
-	
-out:
-	return error;
+	return fd;
 }
 
 static int dupfd(struct file *file, unsigned int start)
 {
-	struct files_struct * files = current->files;
-	struct fdtable *fdt;
+	struct files_struct *files = current->files;
 	int fd;
 
 	spin_lock(&files->file_lock);
-	fd = locate_fd(files, file, start);
-	if (fd >= 0) {
-		/* locate_fd() may have expanded fdtable, load the ptr */
-		fdt = files_fdtable(files);
-		FD_SET(fd, fdt->open_fds);
-		FD_CLR(fd, fdt->close_on_exec);
-		spin_unlock(&files->file_lock);
+	fd = locate_fd(files, start);
+	spin_unlock(&files->file_lock);
+	if (fd >= 0)
 		fd_install(fd, file);
-	} else {
-		spin_unlock(&files->file_lock);
+	else
 		fput(file);
-	}
 
 	return fd;
 }
@@ -136,9 +100,9 @@
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
 {
 	int err = -EBADF;
-	struct file * file, *tofree;
-	struct files_struct * files = current->files;
-	struct fdtable *fdt;
+	unsigned int size;
+	struct file *file, *tofree = NULL;
+	struct files_struct *files = current->files;
 
 	spin_lock(&files->file_lock);
 	if (!(file = fcheck(oldfd)))
@@ -147,31 +111,40 @@
 	if (newfd == oldfd)
 		goto out_unlock;
 	err = -EBADF;
-	if (newfd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+	if (newfd < current->signal->rlim[RLIMIT_NOFILE].rlim_cur) {
+		/*
+		 * We need to get the file* here, since files_fdmap_alloc()
+		 * may temporarly release the lock.
+		 */
+		get_file(file);
+		if (unlikely(newfd >= fdmap_topfd(files->lfmap))) {
+			size = 2 * min(newfd - fdmap_basefd(files->lfmap),
+				       (unsigned int) NR_OPEN / 2);
+			err = -ENOMEM;
+			if (!files_fdmap_alloc(files, &files->lfmap, size))
+				goto out_fput;
+		}
+		tofree = fdmap_file_get(files->lfmap, newfd);
+		err = fdmap_newfd(files->lfmap, newfd, 0);
+		if (err != (int) newfd) {
+			/*
+			 * There's a window inside which a file descriptor can
+			 * result as allocated, but the stored file* is NULL.
+			 * We return -EBUSY in such case.
+			 */
+			if (err != -EBUSY || !tofree)
+				goto out_fput;
+		} else
+			files->fd_count++;
+		fdmap_install(files->lfmap, newfd, file);
+	} else if (files->fmap && fdmap_fdof(files->fmap, newfd)) {
+		tofree = fdmap_file_get(files->fmap, newfd);
+		if (!tofree)
+			goto out_unlock;
+		get_file(file);
+		fdmap_install(files->fmap, newfd, file);
+	} else
 		goto out_unlock;
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
-
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
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
Index: linux-2.6.mod/fs/exec.c
===================================================================
--- linux-2.6.mod.orig/fs/exec.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/exec.c	2007-06-06 12:48:03.000000000 -0700
@@ -780,36 +780,37 @@
  * so that a new one can be started
  */
 
-static void flush_old_files(struct files_struct * files)
+static void flush_fdmap_files(struct files_struct *files,
+			      struct fd_map **pfmap)
 {
-	long j = -1;
-	struct fdtable *fdt;
+	unsigned int start, base;
+	unsigned long fset;
+	struct fd_map *fmap;
 
 	spin_lock(&files->file_lock);
-	for (;;) {
-		unsigned long set, i;
-
-		j++;
-		i = j * __NFDBITS;
-		fdt = files_fdtable(files);
-		if (i >= fdt->max_fds)
+	for (start = 0;;) {
+		fmap = *pfmap;
+		if (!fmap)
+			break;
+		if (!fdmap_next_flag_set(fmap, FDMAP_BIT_CLOEXEC, 1,
+					 &start, &base, &fset))
 			break;
-		set = fdt->close_on_exec->fds_bits[j];
-		if (!set)
-			continue;
-		fdt->close_on_exec->fds_bits[j] = 0;
 		spin_unlock(&files->file_lock);
-		for ( ; set ; i++,set >>= 1) {
-			if (set & 1) {
-				sys_close(i);
-			}
-		}
+		for (; fset; base++, fset >>= 1)
+			if (fset & 1)
+				sys_close(base);
 		spin_lock(&files->file_lock);
-
 	}
 	spin_unlock(&files->file_lock);
 }
 
+static void flush_old_files(struct files_struct * files)
+{
+	flush_fdmap_files(files, &files->lfmap);
+	if (files->fmap)
+		flush_fdmap_files(files, &files->fmap);
+}
+
 void get_task_comm(char *buf, struct task_struct *tsk)
 {
 	/* buf must be at least sizeof(tsk->comm) in size */
Index: linux-2.6.mod/kernel/exit.c
===================================================================
--- linux-2.6.mod.orig/kernel/exit.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/kernel/exit.c	2007-06-06 12:48:03.000000000 -0700
@@ -417,37 +417,18 @@
 
 EXPORT_SYMBOL(daemonize);
 
-static void close_files(struct files_struct * files)
+static int files_fdmap_close(void *priv, struct file *file, int fd)
 {
-	int i, j;
-	struct fdtable *fdt;
-
-	j = 0;
+	filp_close(file, (struct files_struct *) priv);
+	cond_resched();
+	return 0;
+}
 
-	/*
-	 * It is safe to dereference the fd table without RCU or
-	 * ->file_lock because this is the last reference to the
-	 * files structure.
-	 */
-	fdt = files_fdtable(files);
-	for (;;) {
-		unsigned long set;
-		i = j * __NFDBITS;
-		if (i >= fdt->max_fds)
-			break;
-		set = fdt->open_fds->fds_bits[j++];
-		while (set) {
-			if (set & 1) {
-				struct file * file = xchg(&fdt->fd[i], NULL);
-				if (file) {
-					filp_close(file, files);
-					cond_resched();
-				}
-			}
-			i++;
-			set >>= 1;
-		}
-	}
+static void close_files(struct files_struct * files)
+{
+	fdmap_for_each_file(files->lfmap, 1, files_fdmap_close, files);
+	if (files->fmap)
+		fdmap_for_each_file(files->fmap, 1, files_fdmap_close, files);
 }
 
 struct files_struct *get_files_struct(struct task_struct *task)
@@ -463,23 +444,28 @@
 	return files;
 }
 
-void fastcall put_files_struct(struct files_struct *files)
+void free_files_struct(struct files_struct *files)
 {
-	struct fdtable *fdt;
+	struct fd_map *fmap;
 
-	if (atomic_dec_and_test(&files->count)) {
-		close_files(files);
-		/*
-		 * Free the fd and fdset arrays if we expanded them.
-		 * If the fdtable was embedded, pass files for freeing
-		 * at the end of the RCU grace period. Otherwise,
-		 * you can free files immediately.
-		 */
-		fdt = files_fdtable(files);
-		if (fdt != &files->fdtab)
-			kmem_cache_free(files_cachep, files);
-		free_fdtable(fdt);
-	}
+	close_files(files);
+	if (files->fmap)
+		fdmap_free(files->fmap);
+	fmap = files->lfmap;
+	/*
+	 * If this is not the embedded fdmap, we can free it
+	 * immediately. Otherwise it will be freed by the fdmap
+	 * RCU cleanup code.
+	 */
+	if (fmap != &files->lfmap_embed)
+		kmem_cache_free(files_cachep, files);
+	fdmap_free(fmap);
+}
+
+void fastcall put_files_struct(struct files_struct *files)
+{
+	if (atomic_dec_and_test(&files->count))
+		free_files_struct(files);
 }
 
 EXPORT_SYMBOL(put_files_struct);
Index: linux-2.6.mod/fs/open.c
===================================================================
--- linux-2.6.mod.orig/fs/open.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/open.c	2007-06-06 12:48:03.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/syscalls.h>
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
+#include <linux/random.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -857,51 +858,26 @@
  */
 int get_unused_fd(void)
 {
-	struct files_struct * files = current->files;
+	struct files_struct *files = current->files;
 	int fd, error;
-	struct fdtable *fdt;
 
-  	error = -EMFILE;
 	spin_lock(&files->file_lock);
-
 repeat:
-	fdt = files_fdtable(files);
-	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
-				files->next_fd);
-
-	/*
-	 * N.B. For clone tasks sharing a files structure, this test
-	 * will limit the total number of files that can be opened.
-	 */
-	if (fd >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
-		goto out;
-
-	/* Do we need to expand the fd array or fd set?  */
-	error = expand_files(files, fd);
-	if (error < 0)
-		goto out;
-
-	if (error) {
-		/*
-	 	 * If we needed to expand the fs array we
-		 * might have blocked - try again.
-		 */
-		error = -EMFILE;
+	error = -EMFILE;
+	if (unlikely(files->fd_count >=
+		     current->signal->rlim[RLIMIT_NOFILE].rlim_cur))
+		goto out;
+	fd = fdmap_newfd_seq(files->lfmap, 0,
+			     current->signal->rlim[RLIMIT_NOFILE].rlim_cur, 0);
+	if (unlikely(fd == -ENOSPC)) {
+		error = -ENOMEM;
+		if (!files_fdmap_alloc(files, &files->lfmap, 0))
+			goto out;
 		goto repeat;
 	}
-
-	FD_SET(fd, fdt->open_fds);
-	FD_CLR(fd, fdt->close_on_exec);
-	files->next_fd = fd + 1;
-#if 1
-	/* Sanity check */
-	if (fdt->fd[fd] != NULL) {
-		printk(KERN_WARNING "get_unused_fd: slot %d not NULL!\n", fd);
-		fdt->fd[fd] = NULL;
-	}
-#endif
+	if (likely(fd >= 0))
+		files->fd_count++;
 	error = fd;
-
 out:
 	spin_unlock(&files->file_lock);
 	return error;
@@ -909,24 +885,99 @@
 
 EXPORT_SYMBOL(get_unused_fd);
 
-static void __put_unused_fd(struct files_struct *files, unsigned int fd)
+void __put_unused_fd(unsigned int fd)
 {
-	struct fdtable *fdt = files_fdtable(files);
-	__FD_CLR(fd, fdt->open_fds);
-	if (fd < files->next_fd)
-		files->next_fd = fd;
+	struct files_struct *files = current->files;
+	if (fdmap_fdof(files->lfmap, fd))
+		fdmap_putfd(files->lfmap, fd);
+	else if (files->fmap)
+		fdmap_putfd(files->fmap, fd);
+	files->fd_count--;
 }
 
 void fastcall put_unused_fd(unsigned int fd)
 {
 	struct files_struct *files = current->files;
 	spin_lock(&files->file_lock);
-	__put_unused_fd(files, fd);
+	__put_unused_fd(fd);
 	spin_unlock(&files->file_lock);
 }
 
 EXPORT_SYMBOL(put_unused_fd);
 
+/**
+ * __alloc_nonseq_fd - Allocates a file descriptor inside the non-sequential
+ *                     file descriptor map (locked)
+ *
+ * @files:  [in] Pointer the files_struct that hosts the non-sequential file
+ *               descriptor map
+ * @flags:  [in] Flags to be associated with the file descriptor
+ *
+ * Returns the allocated file descriptor, or a negative value in case of error.
+ * This function must be called while holding @files->file_lock. In case the file
+ * descriptor map should be resized, the held lock will be temporarly released
+ * (and re-acquired).
+ */
+int __alloc_nonseq_fd(struct files_struct *files, unsigned long flags)
+{
+	int fd;
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
+	fmap = nonseq_files_fdmap(files);
+	if (!fmap)
+		return -ENOMEM;
+	fd = fdmap_newfd(fmap, -1, mflags);
+	if (unlikely(fd == -ENOSPC)) {
+		if (!files_fdmap_alloc(files, &files->fmap, 0))
+			return -ENOMEM;
+		goto repeat;
+	}
+	if (likely(fd >= 0))
+		files->fd_count++;
+	return fd;
+}
+
+/**
+ * alloc_nonseq_fd - Allocates a file descriptor inside the non-sequential
+ *                   file descriptor map (unlocked)
+ *
+ * This function is the unlocked counterpart of the __alloc_nonseq_fd()
+ * function.
+ */
+int alloc_nonseq_fd(struct files_struct *files, unsigned long flags)
+{
+	int fd;
+
+	spin_lock(&files->file_lock);
+	fd = __alloc_nonseq_fd(files, flags);
+	spin_unlock(&files->file_lock);
+	return fd;
+}
+
+/**
+ * gen_nonseqfd_base - Allocates a random base for non-sequential file
+ *                     descriptors
+ *
+ */
+unsigned int gen_nonseqfd_base(void)
+{
+	unsigned int rndb = get_random_int();
+
+	/*
+	 * I'm getting the lower bits here. Should we use upper ones?
+	 */
+	return FDMAP_NONSEQ_BASE + (rndb & ((1U << FDMAP_RANDOM_BITS) - 1));
+}
+
 /*
  * Install a file pointer in the fd array.
  *
@@ -943,11 +994,12 @@
 void fastcall fd_install(unsigned int fd, struct file * file)
 {
 	struct files_struct *files = current->files;
-	struct fdtable *fdt;
+
 	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	BUG_ON(fdt->fd[fd] != NULL);
-	rcu_assign_pointer(fdt->fd[fd], file);
+	if (fdmap_fdof(files->lfmap, fd))
+		fdmap_install(files->lfmap, fd, file);
+	else if (files->fmap)
+		fdmap_install(files->fmap, fd, file);
 	spin_unlock(&files->file_lock);
 }
 
@@ -1047,21 +1099,18 @@
  */
 asmlinkage long sys_close(unsigned int fd)
 {
-	struct file * filp;
+	struct file *filp = NULL;
 	struct files_struct *files = current->files;
-	struct fdtable *fdt;
 	int retval;
 
 	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	if (fd >= fdt->max_fds)
-		goto out_unlock;
-	filp = fdt->fd[fd];
+	if (fdmap_fdof(files->lfmap, fd))
+		filp = fdmap_file_get(files->lfmap, fd);
+	else if (files->fmap && fdmap_fdof(files->fmap, fd))
+		filp = fdmap_file_get(files->fmap, fd);
 	if (!filp)
 		goto out_unlock;
-	rcu_assign_pointer(fdt->fd[fd], NULL);
-	FD_CLR(fd, fdt->close_on_exec);
-	__put_unused_fd(files, fd);
+	__put_unused_fd(fd);
 	spin_unlock(&files->file_lock);
 	retval = filp_close(filp, files);
 
Index: linux-2.6.mod/kernel/fork.c
===================================================================
--- linux-2.6.mod.orig/kernel/fork.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/kernel/fork.c	2007-06-06 12:48:03.000000000 -0700
@@ -614,43 +614,53 @@
 	return 0;
 }
 
-static int count_open_files(struct fdtable *fdt)
-{
-	int size = fdt->max_fds;
-	int i;
-
-	/* Find the last open fd */
-	for (i = size/(8*sizeof(long)); i > 0; ) {
-		if (fdt->open_fds->fds_bits[--i])
-			break;
-	}
-	i = (i+1) * 8 * sizeof(long);
-	return i;
-}
-
 static struct files_struct *alloc_files(void)
 {
 	struct files_struct *newf;
-	struct fdtable *fdt;
 
 	newf = kmem_cache_alloc(files_cachep, GFP_KERNEL);
-	if (!newf)
-		goto out;
+	if (newf)
+		init_files_struct(newf);
 
-	atomic_set(&newf->count, 1);
+	return newf;
+}
 
-	spin_lock_init(&newf->file_lock);
-	newf->next_fd = 0;
-	fdt = &newf->fdtab;
-	fdt->max_fds = NR_OPEN_DEFAULT;
-	fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
-	fdt->open_fds = (fd_set *)&newf->open_fds_init;
-	fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&fdt->rcu);
-	fdt->next = NULL;
-	rcu_assign_pointer(newf->fdt, fdt);
+static int dup_fdmap(spinlock_t *lock, struct fd_map **psfmap,
+		     unsigned int topfd, int ranbase, struct fd_map **pdfmap,
+		     unsigned int *fcount)
+	__releases(*lock)
+	__acquires(*lock)
+{
+	unsigned int size, base;
+	struct fd_map *ofmap, *fmap = NULL;
+
+repeat:
+	*fcount = 0;
+	ofmap = *psfmap;
+	if (!ofmap)
+		goto out;
+	if (!topfd)
+		topfd = fdmap_top_open_fd(ofmap) + 1;
+	size = topfd - fdmap_basefd(ofmap);
+	if (ranbase)
+		base = gen_nonseqfd_base();
+	else
+		base = fdmap_basefd(ofmap);
+	spin_unlock(lock);
+	fmap = fdmap_alloc(base, size, 0);
+	spin_lock(lock);
+	if (!fmap)
+		goto out;
+	if (unlikely(*psfmap != ofmap)) {
+		fdmap_free(fmap);
+		topfd = 0;
+		fmap = NULL;
+		goto repeat;
+	}
+	fdmap_copy(fmap, ofmap, fcount, FDMAP_CPF_FORKMODE);
+	rcu_assign_pointer(*pdfmap, fmap);
 out:
-	return newf;
+	return fmap || !ofmap ? 0: -ENOMEM;
 }
 
 /*
@@ -660,86 +670,39 @@
  */
 static struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 {
+	unsigned int topfd, fcount;
 	struct files_struct *newf;
-	struct file **old_fds, **new_fds;
-	int open_files, size, i;
-	struct fdtable *old_fdt, *new_fdt;
 
 	*errorp = -ENOMEM;
 	newf = alloc_files();
 	if (!newf)
 		goto out;
-
 	spin_lock(&oldf->file_lock);
-	old_fdt = files_fdtable(oldf);
-	new_fdt = files_fdtable(newf);
-	open_files = count_open_files(old_fdt);
-
-	/*
-	 * Check whether we need to allocate a larger fd array and fd set.
-	 * Note: we're not a clone task, so the open count won't change.
-	 */
-	if (open_files > new_fdt->max_fds) {
-		new_fdt->max_fds = 0;
-		spin_unlock(&oldf->file_lock);
-		spin_lock(&newf->file_lock);
-		*errorp = expand_files(newf, open_files-1);
-		spin_unlock(&newf->file_lock);
-		if (*errorp < 0)
+	topfd = fdmap_top_open_fd(oldf->lfmap) + 1;
+	if (topfd <= fdmap_topfd(newf->lfmap))
+		fdmap_copy(newf->lfmap, oldf->lfmap, &fcount,
+			   FDMAP_CPF_FORKMODE);
+	else {
+		*errorp = dup_fdmap(&oldf->file_lock, &oldf->lfmap, topfd, 0,
+				    &newf->lfmap, &fcount);
+		if (*errorp)
 			goto out_release;
-		new_fdt = files_fdtable(newf);
-		/*
-		 * Reacquire the oldf lock and a pointer to its fd table
-		 * who knows it may have a new bigger fd table. We need
-		 * the latest pointer.
-		 */
-		spin_lock(&oldf->file_lock);
-		old_fdt = files_fdtable(oldf);
 	}
-
-	old_fds = old_fdt->fd;
-	new_fds = new_fdt->fd;
-
-	memcpy(new_fdt->open_fds->fds_bits,
-		old_fdt->open_fds->fds_bits, open_files/8);
-	memcpy(new_fdt->close_on_exec->fds_bits,
-		old_fdt->close_on_exec->fds_bits, open_files/8);
-
-	for (i = open_files; i != 0; i--) {
-		struct file *f = *old_fds++;
-		if (f) {
-			get_file(f);
-		} else {
-			/*
-			 * The fd may be claimed in the fd bitmap but not yet
-			 * instantiated in the files array if a sibling thread
-			 * is partway through open().  So make sure that this
-			 * fd is available to the new process.
-			 */
-			FD_CLR(open_files - i, new_fdt->open_fds);
-		}
-		rcu_assign_pointer(*new_fds++, f);
+	newf->fd_count = fcount;
+	if (oldf->fmap) {
+		*errorp = dup_fdmap(&oldf->file_lock, &oldf->fmap, 0, 1,
+				    &newf->fmap, &fcount);
+		if (*errorp)
+			goto out_release;
+		newf->fd_count += fcount;
 	}
 	spin_unlock(&oldf->file_lock);
 
-	/* compute the remainder to be cleared */
-	size = (new_fdt->max_fds - open_files) * sizeof(struct file *);
-
-	/* This is long word aligned thus could use a optimized version */ 
-	memset(new_fds, 0, size); 
-
-	if (new_fdt->max_fds > open_files) {
-		int left = (new_fdt->max_fds-open_files)/8;
-		int start = open_files / (8 * sizeof(unsigned long));
-
-		memset(&new_fdt->open_fds->fds_bits[start], 0, left);
-		memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
-	}
-
 	return newf;
 
 out_release:
-	kmem_cache_free(files_cachep, newf);
+	spin_unlock(&oldf->file_lock);
+	free_files_struct(newf);
 out:
 	return NULL;
 }
Index: linux-2.6.mod/include/linux/init_task.h
===================================================================
--- linux-2.6.mod.orig/include/linux/init_task.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/linux/init_task.h	2007-06-06 12:48:03.000000000 -0700
@@ -9,27 +9,10 @@
 #include <linux/ipc.h>
 #include <linux/pid_namespace.h>
 
-#define INIT_FDTABLE \
-{							\
-	.max_fds	= NR_OPEN_DEFAULT, 		\
-	.fd		= &init_files.fd_array[0], 	\
-	.close_on_exec	= (fd_set *)&init_files.close_on_exec_init, \
-	.open_fds	= (fd_set *)&init_files.open_fds_init, 	\
-	.rcu		= RCU_HEAD_INIT, 		\
-	.next		= NULL,		 		\
-}
-
-#define INIT_FILES \
-{ 							\
-	.count		= ATOMIC_INIT(1), 		\
-	.fdt		= &init_files.fdtab, 		\
-	.fdtab		= INIT_FDTABLE,			\
-	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock), \
-	.next_fd	= 0, 				\
-	.close_on_exec_init = { { 0, } }, 		\
-	.open_fds_init	= { { 0, } }, 			\
-	.fd_array	= { NULL, } 			\
-}
+/*
+ * We do the real "init_files" initialization inside fs/file_table.c:files_init()
+ */
+#define INIT_FILES { }
 
 #define INIT_KIOCTX(name, which_mm) \
 {							\
Index: linux-2.6.mod/kernel/kmod.c
===================================================================
--- linux-2.6.mod.orig/kernel/kmod.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/kernel/kmod.c	2007-06-06 12:48:03.000000000 -0700
@@ -146,17 +146,18 @@
 
 	/* Install input pipe when needed */
 	if (sub_info->stdin) {
+		int fd;
 		struct files_struct *f = current->files;
-		struct fdtable *fdt;
 		/* no races because files should be private here */
 		sys_close(0);
-		fd_install(0, sub_info->stdin);
 		spin_lock(&f->file_lock);
-		fdt = files_fdtable(f);
-		FD_SET(0, fdt->open_fds);
-		FD_CLR(0, fdt->close_on_exec);
+		fd = fdmap_newfd(f->lfmap, 0, 0);
+		BUG_ON(fd < 0);
+		f->fd_count++;
 		spin_unlock(&f->file_lock);
 
+		fd_install(0, sub_info->stdin);
+
 		/* and disallow core files too */
 		current->signal->rlim[RLIMIT_CORE] = (struct rlimit){0, 0};
 	}
Index: linux-2.6.mod/fs/proc/base.c
===================================================================
--- linux-2.6.mod.orig/fs/proc/base.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/proc/base.c	2007-06-06 12:48:03.000000000 -0700
@@ -1384,10 +1384,10 @@
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *p = get_proc_task(inode);
-	unsigned int fd, tid, ino;
+	unsigned int fd, tid, ino, topfd;
 	int retval;
 	struct files_struct * files;
-	struct fdtable *fdt;
+	struct fd_map *lfmap, *fmap;
 
 	retval = -ENOENT;
 	if (!p)
@@ -1411,10 +1411,15 @@
 			if (!files)
 				goto out;
 			rcu_read_lock();
-			fdt = files_fdtable(files);
-			for (fd = filp->f_pos-2;
-			     fd < fdt->max_fds;
-			     fd++, filp->f_pos++) {
+			lfmap = rcu_dereference(files->lfmap);
+			fmap = rcu_dereference(files->fmap);
+			fd = filp->f_pos - 2;
+			if (fd < fdmap_topfd(lfmap) || !fmap)
+				topfd = fdmap_topfd(lfmap);
+			else
+				topfd = fdmap_topfd(fmap);
+rescan:
+			for (; fd < topfd; fd++, filp->f_pos++) {
 				char name[PROC_NUMBUF];
 				int len;
 
@@ -1425,13 +1430,19 @@
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
Index: linux-2.6.mod/fs/file.c
===================================================================
--- linux-2.6.mod.orig/fs/file.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/file.c	2007-06-06 12:48:03.000000000 -0700
@@ -18,239 +18,67 @@
 #include <linux/rcupdate.h>
 #include <linux/workqueue.h>
 
-struct fdtable_defer {
-	spinlock_t lock;
-	struct work_struct wq;
-	struct fdtable *next;
-};
-
-/*
- * We use this list to defer free fdtables that have vmalloced
- * sets/arrays. By keeping a per-cpu list, we avoid having to embed
- * the work_struct in fdtable itself which avoids a 64 byte (i386) increase in
- * this per-task structure.
- */
-static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
-
-static inline void * alloc_fdmem(unsigned int size)
-{
-	if (size <= PAGE_SIZE)
-		return kmalloc(size, GFP_KERNEL);
-	else
-		return vmalloc(size);
-}
-
-static inline void free_fdarr(struct fdtable *fdt)
-{
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
-		kfree(fdt->fd);
-	else
-		vfree(fdt->fd);
-}
-
-static inline void free_fdset(struct fdtable *fdt)
-{
-	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
-		kfree(fdt->open_fds);
-	else
-		vfree(fdt->open_fds);
-}
-
-static void free_fdtable_work(struct work_struct *work)
-{
-	struct fdtable_defer *f =
-		container_of(work, struct fdtable_defer, wq);
-	struct fdtable *fdt;
-
-	spin_lock_bh(&f->lock);
-	fdt = f->next;
-	f->next = NULL;
-	spin_unlock_bh(&f->lock);
-	while(fdt) {
-		struct fdtable *next = fdt->next;
-		vfree(fdt->fd);
-		free_fdset(fdt);
-		kfree(fdt);
-		fdt = next;
-	}
-}
-
-void free_fdtable_rcu(struct rcu_head *rcu)
+static void files_embedd_fdmap_free(void *priv, struct fd_map *fmap)
 {
-	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
-	struct fdtable_defer *fddef;
-
-	BUG_ON(!fdt);
-
-	if (fdt->max_fds <= NR_OPEN_DEFAULT) {
-		/*
-		 * This fdtable is embedded in the files structure and that
-		 * structure itself is getting destroyed.
-		 */
-		kmem_cache_free(files_cachep,
-				container_of(fdt, struct files_struct, fdtab));
-		return;
-	}
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
-		kfree(fdt->fd);
-		kfree(fdt->open_fds);
-		kfree(fdt);
-	} else {
-		fddef = &get_cpu_var(fdtable_defer_list);
-		spin_lock(&fddef->lock);
-		fdt->next = fddef->next;
-		fddef->next = fdt;
-		/* vmallocs are handled from the workqueue context */
-		schedule_work(&fddef->wq);
-		spin_unlock(&fddef->lock);
-		put_cpu_var(fdtable_defer_list);
-	}
+	kmem_cache_free(files_cachep, priv);
 }
 
-/*
- * Expand the fdset in the files_struct.  Called with the files spinlock
- * held for write.
- */
-static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
+void init_files_struct(struct files_struct *newf)
 {
-	unsigned int cpy, set;
-
-	BUG_ON(nfdt->max_fds < ofdt->max_fds);
-	if (ofdt->max_fds == 0)
-		return;
-
-	cpy = ofdt->max_fds * sizeof(struct file *);
-	set = (nfdt->max_fds - ofdt->max_fds) * sizeof(struct file *);
-	memcpy(nfdt->fd, ofdt->fd, cpy);
-	memset((char *)(nfdt->fd) + cpy, 0, set);
-
-	cpy = ofdt->max_fds / BITS_PER_BYTE;
-	set = (nfdt->max_fds - ofdt->max_fds) / BITS_PER_BYTE;
-	memcpy(nfdt->open_fds, ofdt->open_fds, cpy);
-	memset((char *)(nfdt->open_fds) + cpy, 0, set);
-	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
-	memset((char *)(nfdt->close_on_exec) + cpy, 0, set);
-}
+	struct fd_map *fmap;
 
-static struct fdtable * alloc_fdtable(unsigned int nr)
-{
-	struct fdtable *fdt;
-	char *data;
+	atomic_set(&newf->count, 1);
 
-	/*
-	 * Figure out how many fds we actually want to support in this fdtable.
-	 * Allocation steps are keyed to the size of the fdarray, since it
-	 * grows far faster than any of the other dynamic data. We try to fit
-	 * the fdarray into comfortable page-tuned chunks: starting at 1024B
-	 * and growing in powers of two from there on.
-	 */
-	nr /= (1024 / sizeof(struct file *));
-	nr = roundup_pow_of_two(nr + 1);
-	nr *= (1024 / sizeof(struct file *));
-	if (nr > NR_OPEN)
-		nr = NR_OPEN;
-
-	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL);
-	if (!fdt)
-		goto out;
-	fdt->max_fds = nr;
-	data = alloc_fdmem(nr * sizeof(struct file *));
-	if (!data)
-		goto out_fdt;
-	fdt->fd = (struct file **)data;
-	data = alloc_fdmem(max_t(unsigned int,
-				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
-	if (!data)
-		goto out_arr;
-	fdt->open_fds = (fd_set *)data;
-	data += nr / BITS_PER_BYTE;
-	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
-	fdt->next = NULL;
-
-	return fdt;
-
-out_arr:
-	free_fdarr(fdt);
-out_fdt:
-	kfree(fdt);
-out:
-	return NULL;
+	spin_lock_init(&newf->file_lock);
+	newf->fd_count = 0;
+	newf->fmap = NULL;
+	fmap = &newf->lfmap_embed;
+	fmap->slots = newf->fdmap_slots;
+	fmap->map = newf->fdmap_map;
+	fdmap_init_map(fmap, 0, NR_OPEN_DEFAULT, 1);
+	fdmap_set_freecb(fmap, files_embedd_fdmap_free, newf);
+	rcu_assign_pointer(newf->lfmap, fmap);
 }
 
-/*
- * Expand the file descriptor table.
- * This function will allocate a new fdtable and both fd array and fdset, of
- * the given size.
- * Return <0 error code on error; 1 on successful completion.
- * The files->file_lock should be held on entry, and will be held on exit.
- */
-static int expand_fdtable(struct files_struct *files, int nr)
+struct fd_map *files_fdmap_alloc(struct files_struct *files,
+				 struct fd_map **pfmap, unsigned int size)
 	__releases(files->file_lock)
 	__acquires(files->file_lock)
 {
-	struct fdtable *new_fdt, *cur_fdt;
+	unsigned int base, msize, nsize;
+	struct fd_map *fmap, *ofmap, *nfmap;
+
+repeat:
+	assert_spin_locked(&files->file_lock);
 
+	msize = max(size, FDMAP_NONSEQ_SIZE);
+	ofmap = *pfmap;
+	if (ofmap) {
+		nsize = 2 * min(ofmap->size, (unsigned int) NR_OPEN / 2);
+		msize = max(msize, nsize);
+		base = fdmap_basefd(ofmap);
+	} else
+		base = gen_nonseqfd_base();
+	msize = min(msize, (unsigned int) NR_OPEN);
 	spin_unlock(&files->file_lock);
-	new_fdt = alloc_fdtable(nr);
+	fmap = fdmap_alloc(base, msize, !ofmap);
 	spin_lock(&files->file_lock);
-	if (!new_fdt)
-		return -ENOMEM;
-	/*
-	 * Check again since another task may have expanded the fd table while
-	 * we dropped the lock
-	 */
-	cur_fdt = files_fdtable(files);
-	if (nr >= cur_fdt->max_fds) {
-		/* Continue as planned */
-		copy_fdtable(new_fdt, cur_fdt);
-		rcu_assign_pointer(files->fdt, new_fdt);
-		if (cur_fdt->max_fds > NR_OPEN_DEFAULT)
-			free_fdtable(cur_fdt);
-	} else {
-		/* Somebody else expanded, so undo our attempt */
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+	if (fmap) {
+		nfmap = *pfmap;
+		if (nfmap) {
+			if (ofmap == nfmap) {
+				fdmap_copy(fmap, nfmap, NULL, 0);
+				rcu_assign_pointer(*pfmap, fmap);
+				files_free_fdmap(files, nfmap);
+			} else {
+				fdmap_free(fmap);
+				if (fdmap_size(nfmap) < msize)
+					goto repeat;
+				fmap = nfmap;
+			}
+		} else
+			rcu_assign_pointer(*pfmap, fmap);
 	}
-	return 1;
-}
-
-/*
- * Expand files.
- * This function will expand the file structures, if the requested size exceeds
- * the current capacity and there is room for expansion.
- * Return <0 error code on error; 0 when nothing done; 1 when files were
- * expanded and execution may have blocked.
- * The files->file_lock should be held on entry, and will be held on exit.
- */
-int expand_files(struct files_struct *files, int nr)
-{
-	struct fdtable *fdt;
-
-	fdt = files_fdtable(files);
-	/* Do we need to expand? */
-	if (nr < fdt->max_fds)
-		return 0;
-	/* Can we expand? */
-	if (nr >= NR_OPEN)
-		return -EMFILE;
-
-	/* All good, so we try */
-	return expand_fdtable(files, nr);
-}
-
-static void __devinit fdtable_defer_list_init(int cpu)
-{
-	struct fdtable_defer *fddef = &per_cpu(fdtable_defer_list, cpu);
-	spin_lock_init(&fddef->lock);
-	INIT_WORK(&fddef->wq, free_fdtable_work);
-	fddef->next = NULL;
+	return fmap;
 }
 
-void __init files_defer_init(void)
-{
-	int i;
-	for_each_possible_cpu(i)
-		fdtable_defer_list_init(i);
-}
Index: linux-2.6.mod/fs/file_table.c
===================================================================
--- linux-2.6.mod.orig/fs/file_table.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/file_table.c	2007-06-06 12:48:03.000000000 -0700
@@ -298,6 +298,7 @@
 	files_stat.max_files = n; 
 	if (files_stat.max_files < NR_FILE)
 		files_stat.max_files = NR_FILE;
-	files_defer_init();
+	fdmap_module_init();
+	init_files_struct(init_task.files);
 	percpu_counter_init(&nr_files, 0);
 } 
Index: linux-2.6.mod/fs/proc/array.c
===================================================================
--- linux-2.6.mod.orig/fs/proc/array.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/proc/array.c	2007-06-06 12:48:03.000000000 -0700
@@ -160,7 +160,7 @@
 {
 	struct group_info *group_info;
 	int g;
-	struct fdtable *fdt = NULL;
+	struct fd_map *fmap = NULL;
 
 	rcu_read_lock();
 	buffer += sprintf(buffer,
@@ -182,11 +182,11 @@
 
 	task_lock(p);
 	if (p->files)
-		fdt = files_fdtable(p->files);
+		fmap = rcu_dereference(p->files->lfmap);
 	buffer += sprintf(buffer,
 		"FDSize:\t%d\n"
 		"Groups:\t",
-		fdt ? fdt->max_fds : 0);
+		fmap ? fdmap_topfd(fmap): 0);
 	rcu_read_unlock();
 
 	group_info = p->group_info;
Index: linux-2.6.mod/security/selinux/hooks.c
===================================================================
--- linux-2.6.mod.orig/security/selinux/hooks.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/security/selinux/hooks.c	2007-06-06 12:48:03.000000000 -0700
@@ -1729,14 +1729,55 @@
 extern struct vfsmount *selinuxfs_mount;
 extern struct dentry *selinux_null;
 
+static void flush_unauthorized_fdmap(spinlock_t *lock, struct fd_map **pfmap,
+				     struct file *devnull)
+{
+	int perm;
+	unsigned int start, base;
+	unsigned long fset;
+	struct file *file, *nfile;
+
+	spin_lock(lock);
+	for (start = 0;;) {
+		if (!*pfmap)
+			break;
+		if (!fdmap_next_flag_set(*pfmap, FDMAP_BIT_BUSYSLOT, 0,
+					 &start, &base, &fset))
+			break;
+		for (; fset; base++, fset >>= 1) {
+			if (!(fset & 1))
+				continue;
+			file = fcheck(base);
+			if (!file)
+				continue;
+			spin_unlock(lock);
+			perm = file_has_perm(current,
+					     file,
+					     file_to_av(file));
+			spin_lock(lock);
+			nfile = fcheck(base);
+			if (!devnull || !perm || file != nfile) {
+				__put_unused_fd(base);
+				spin_unlock(lock);
+			} else {
+				spin_unlock(lock);
+				get_file(devnull);
+				fd_install(base, devnull);
+			}
+			fput(nfile);
+			fput(file);
+			spin_lock(lock);
+		}
+	}
+	spin_unlock(lock);
+}
+
 /* Derived from fs/exec.c:flush_old_files. */
 static inline void flush_unauthorized_files(struct files_struct * files)
 {
 	struct avc_audit_data ad;
-	struct file *file, *devnull = NULL;
+	struct file *file, *devnull;
 	struct tty_struct *tty;
-	struct fdtable *fdt;
-	long j = -1;
 	int drop_tty = 0;
 
 	mutex_lock(&tty_mutex);
@@ -1767,56 +1808,17 @@
 
 	AVC_AUDIT_DATA_INIT(&ad,FS);
 
-	spin_lock(&files->file_lock);
-	for (;;) {
-		unsigned long set, i;
-		int fd;
-
-		j++;
-		i = j * __NFDBITS;
-		fdt = files_fdtable(files);
-		if (i >= fdt->max_fds)
-			break;
-		set = fdt->open_fds->fds_bits[j];
-		if (!set)
-			continue;
-		spin_unlock(&files->file_lock);
-		for ( ; set ; i++,set >>= 1) {
-			if (set & 1) {
-				file = fget(i);
-				if (!file)
-					continue;
-				if (file_has_perm(current,
-						  file,
-						  file_to_av(file))) {
-					sys_close(i);
-					fd = get_unused_fd();
-					if (fd != i) {
-						if (fd >= 0)
-							put_unused_fd(fd);
-						fput(file);
-						continue;
-					}
-					if (devnull) {
-						get_file(devnull);
-					} else {
-						devnull = dentry_open(dget(selinux_null), mntget(selinuxfs_mount), O_RDWR);
-						if (IS_ERR(devnull)) {
-							devnull = NULL;
-							put_unused_fd(fd);
-							fput(file);
-							continue;
-						}
-					}
-					fd_install(fd, devnull);
-				}
-				fput(file);
-			}
-		}
-		spin_lock(&files->file_lock);
-
-	}
-	spin_unlock(&files->file_lock);
+	devnull = dentry_open(dget(selinux_null),
+			      mntget(selinuxfs_mount),
+			      O_RDWR);
+	if (IS_ERR(devnull))
+		devnull = NULL;
+	flush_unauthorized_fdmap(&files->file_lock, &files->lfmap,
+				 devnull);
+	flush_unauthorized_fdmap(&files->file_lock, &files->fmap,
+				 devnull);
+	if (devnull)
+		fput(devnull);
 }
 
 static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
Index: linux-2.6.mod/fs/select.c
===================================================================
--- linux-2.6.mod.orig/fs/select.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/fs/select.c	2007-06-06 12:48:03.000000000 -0700
@@ -139,16 +139,15 @@
 
 static int max_select_fd(unsigned long n, fd_set_bits *fds)
 {
-	unsigned long *open_fds;
+	const unsigned long *open_fds;
 	unsigned long set;
 	int max;
-	struct fdtable *fdt;
 
 	/* handle last in-complete long-word first */
 	set = ~(~0UL << (n & (__NFDBITS-1)));
 	n /= __NFDBITS;
-	fdt = files_fdtable(current->files);
-	open_fds = fdt->open_fds->fds_bits+n;
+	open_fds = fdmap_get_allocmap(current->files->lfmap);
+	open_fds += n;
 	max = 0;
 	if (set) {
 		set &= BITS(fds, n);
@@ -312,7 +311,6 @@
 	void *bits;
 	int ret, max_fds;
 	unsigned int size;
-	struct fdtable *fdt;
 	/* Allocate small arguments on the stack to save memory and be faster */
 	long stack_fds[SELECT_STACK_ALLOC/sizeof(long)];
 
@@ -322,8 +320,7 @@
 
 	/* max_fds can increase, so grab it once to avoid race */
 	rcu_read_lock();
-	fdt = files_fdtable(current->files);
-	max_fds = fdt->max_fds;
+	max_fds = fdmap_topfd(current->files->lfmap);
 	rcu_read_unlock();
 	if (n > max_fds)
 		n = max_fds;
Index: linux-2.6.mod/fs/compat.c
===================================================================
--- linux-2.6.mod.orig/fs/compat.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/fs/compat.c	2007-06-06 12:48:03.000000000 -0700
@@ -1546,7 +1546,6 @@
 	fd_set_bits fds;
 	void *bits;
 	int size, max_fds, ret = -EINVAL;
-	struct fdtable *fdt;
 	long stack_fds[SELECT_STACK_ALLOC/sizeof(long)];
 
 	if (n < 0)
@@ -1554,8 +1553,7 @@
 
 	/* max_fds can increase, so grab it once to avoid race */
 	rcu_read_lock();
-	fdt = files_fdtable(current->files);
-	max_fds = fdt->max_fds;
+	max_fds = fdmap_topfd(current->files->lfmap);
 	rcu_read_unlock();
 	if (n > max_fds)
 		n = max_fds;
Index: linux-2.6.mod/drivers/char/tty_io.c
===================================================================
--- linux-2.6.mod.orig/drivers/char/tty_io.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/drivers/char/tty_io.c	2007-06-06 12:48:03.000000000 -0700
@@ -3428,6 +3428,26 @@
 }
 #endif
 
+struct tty_fdmap_SAK {
+	struct tty_struct *tty;
+	struct task_struct *p
+};
+
+static int tty_fdmap_SAK_helper(void *priv, struct file *filp, int fd)
+{
+	struct tty_fdmap_SAK *shlp = priv;
+
+	if (filp->f_op->read == tty_read &&
+	    filp->private_data == shlp->tty) {
+		printk(KERN_NOTICE "SAK: killed process %d"
+		       " (%s): fd#%d opened to the tty\n",
+		       shlp->p->pid, shlp->p->comm, fd);
+		force_sig(SIGKILL, shlp->p);
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * This implements the "Secure Attention Key" ---  the idea is to
  * prevent trojan horses by killing all processes associated with this
@@ -3454,9 +3474,6 @@
 #else
 	struct task_struct *g, *p;
 	struct pid *session;
-	int		i;
-	struct file	*filp;
-	struct fdtable *fdt;
 	
 	if (!tty)
 		return;
@@ -3488,25 +3505,18 @@
 		}
 		task_lock(p);
 		if (p->files) {
+			struct tty_fdmap_SAK shlp;
+
+			shlp.tty = tty;
+			shlp.p = p;
+
 			/*
 			 * We don't take a ref to the file, so we must
 			 * hold ->file_lock instead.
 			 */
 			spin_lock(&p->files->file_lock);
-			fdt = files_fdtable(p->files);
-			for (i=0; i < fdt->max_fds; i++) {
-				filp = fcheck_files(p->files, i);
-				if (!filp)
-					continue;
-				if (filp->f_op->read == tty_read &&
-				    filp->private_data == tty) {
-					printk(KERN_NOTICE "SAK: killed process %d"
-					    " (%s): fd#%d opened to the tty\n",
-					    p->pid, p->comm, i);
-					force_sig(SIGKILL, p);
-					break;
-				}
-			}
+			fdmap_for_each_file(p->files->lfmap, 0,
+					    tty_fdmap_SAK_helper, &shlp);
 			spin_unlock(&p->files->file_lock);
 		}
 		task_unlock(p);
Index: linux-2.6.mod/arch/alpha/kernel/osf_sys.c
===================================================================
--- linux-2.6.mod.orig/arch/alpha/kernel/osf_sys.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/arch/alpha/kernel/osf_sys.c	2007-06-06 12:48:03.000000000 -0700
@@ -986,7 +986,6 @@
 	size_t size;
 	long timeout;
 	int ret = -EINVAL;
-	struct fdtable *fdt;
 	int max_fds;
 
 	timeout = MAX_SCHEDULE_TIMEOUT;
@@ -1010,8 +1009,7 @@
 	}
 
 	rcu_read_lock();
-	fdt = files_fdtable(current->files);
-	max_fds = fdt->max_fds;
+	max_fds = fdmap_topfd(current->files->lfmap);
 	rcu_read_unlock();
 	if (n < 0 || n > max_fds)
 		goto out_nofds;
Index: linux-2.6.mod/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.mod.orig/arch/ia64/kernel/perfmon.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/arch/ia64/kernel/perfmon.c	2007-06-06 12:48:03.000000000 -0700
@@ -2259,20 +2259,9 @@
 static void
 pfm_free_fd(int fd, struct file *file)
 {
-	struct files_struct *files = current->files;
-	struct fdtable *fdt;
-
-	/* 
-	 * there ie no fd_uninstall(), so we do it here
-	 */
-	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	rcu_assign_pointer(fdt->fd[fd], NULL);
-	spin_unlock(&files->file_lock);
-
+	put_unused_fd(current->files, fd);
 	if (file)
 		put_filp(file);
-	put_unused_fd(fd);
 }
 
 static int
Index: linux-2.6.mod/arch/mips/kernel/kspd.c
===================================================================
--- linux-2.6.mod.orig/arch/mips/kernel/kspd.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/arch/mips/kernel/kspd.c	2007-06-06 12:48:03.000000000 -0700
@@ -294,35 +294,19 @@
 		printk("KSPD: sp_work_handle_request failed to send to SP\n");
 }
 
+static int sp_files_fdmap_close(void *priv, struct file *file, int fd)
+{
+	filp_close(file, (struct files_struct *) priv);
+	return 0;
+}
+
 static void sp_cleanup(void)
 {
 	struct files_struct *files = current->files;
-	int i, j;
-	struct fdtable *fdt;
 
-	j = 0;
-
-	/*
-	 * It is safe to dereference the fd table without RCU or
-	 * ->file_lock
-	 */
-	fdt = files_fdtable(files);
-	for (;;) {
-		unsigned long set;
-		i = j * __NFDBITS;
-		if (i >= fdt->max_fds)
-			break;
-		set = fdt->open_fds->fds_bits[j++];
-		while (set) {
-			if (set & 1) {
-				struct file * file = xchg(&fdt->fd[i], NULL);
-				if (file)
-					filp_close(file, files);
-			}
-			i++;
-			set >>= 1;
-		}
-	}
+	fdmap_for_each_file(files->lfmap, 1, sp_files_fdmap_close, files);
+	if (files->fmap)
+		fdmap_for_each_file(files->fmap, 1, sp_files_fdmap_close, files);
 }
 
 static int channel_open = 0;
Index: linux-2.6.mod/arch/powerpc/platforms/cell/spufs/coredump.c
===================================================================
--- linux-2.6.mod.orig/arch/powerpc/platforms/cell/spufs/coredump.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/arch/powerpc/platforms/cell/spufs/coredump.c	2007-06-06 12:48:03.000000000 -0700
@@ -133,6 +133,20 @@
 	return size;
 }
 
+static int spufs_fdmap_add_one_context(void *priv, struct file *file, int fd)
+{
+	int *size = priv;
+
+	if (file->f_op == &spufs_context_fops) {
+		int rval = spufs_add_one_context(file, fd);
+		if (rval < 0)
+			return 1;
+		*size += rval;
+	}
+
+	return 0;
+}
+
 /*
  * The additional architecture-specific notes for Cell are various
  * context files in the spu context.
@@ -144,21 +158,13 @@
  */
 static int spufs_arch_notes_size(void)
 {
-	struct fdtable *fdt = files_fdtable(current->files);
-	int size = 0, fd;
+	struct files_struct *files = current->files;
+	int size = 0;
 
-	for (fd = 0; fd < fdt->max_fds; fd++) {
-		if (FD_ISSET(fd, fdt->open_fds)) {
-			struct file *file = fcheck(fd);
-
-			if (file && file->f_op == &spufs_context_fops) {
-				int rval = spufs_add_one_context(file, fd);
-				if (rval < 0)
-					break;
-				size += rval;
-			}
-		}
-	}
+	fdmap_for_each_file(files->lfmap, 0, spufs_fdmap_add_one_context, &size);
+	if (files->fmap)
+		fdmap_for_each_file(files->fmap, 0, spufs_fdmap_add_one_context,
+				    &size);
 
 	return size;
 }
Index: linux-2.6.mod/arch/sparc64/solaris/ioctl.c
===================================================================
--- linux-2.6.mod.orig/arch/sparc64/solaris/ioctl.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/arch/sparc64/solaris/ioctl.c	2007-06-06 12:48:03.000000000 -0700
@@ -294,13 +294,13 @@
 static inline int solaris_sockmod(unsigned int fd, unsigned int cmd, u32 arg)
 {
 	struct inode *ino;
-	struct fdtable *fdt;
+	struct file *file;
 	/* I wonder which of these tests are superfluous... --patrik */
 	rcu_read_lock();
-	fdt = files_fdtable(current->files);
-	if (! fdt->fd[fd] ||
-	    ! fdt->fd[fd]->f_path.dentry ||
-	    ! (ino = fdt->fd[fd]->f_path.dentry->d_inode) ||
+	file = fcheck_files(current->files, fd);
+	if (! file ||
+	    ! file->f_path.dentry ||
+	    ! (ino = file->f_path.dentry->d_inode) ||
 	    ! S_ISSOCK(ino->i_mode)) {
 		rcu_read_unlock();
 		return TBADF;
Index: linux-2.6.mod/arch/sparc64/solaris/timod.c
===================================================================
--- linux-2.6.mod.orig/arch/sparc64/solaris/timod.c	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/arch/sparc64/solaris/timod.c	2007-06-06 12:48:03.000000000 -0700
@@ -143,11 +143,11 @@
 static void timod_wake_socket(unsigned int fd)
 {
 	struct socket *sock;
-	struct fdtable *fdt;
+	struct file *file;
 
 	SOLD("wakeing socket");
-	fdt = files_fdtable(current->files);
-	sock = SOCKET_I(fdt->fd[fd]->f_path.dentry->d_inode);
+	file = fcheck_files(current->files, fd);
+	sock = SOCKET_I(file->f_path.dentry->d_inode);
 	wake_up_interruptible(&sock->wait);
 	read_lock(&sock->sk->sk_callback_lock);
 	if (sock->fasync_list && !test_bit(SOCK_ASYNC_WAITDATA, &sock->flags))
@@ -159,11 +159,11 @@
 static void timod_queue(unsigned int fd, struct T_primsg *it)
 {
 	struct sol_socket_struct *sock;
-	struct fdtable *fdt;
+	struct file *file;
 
 	SOLD("queuing primsg");
-	fdt = files_fdtable(current->files);
-	sock = (struct sol_socket_struct *)fdt->fd[fd]->private_data;
+	file = fcheck_files(current->files, fd);
+	sock = (struct sol_socket_struct *)file->private_data;
 	it->next = sock->pfirst;
 	sock->pfirst = it;
 	if (!sock->plast)
@@ -175,11 +175,11 @@
 static void timod_queue_end(unsigned int fd, struct T_primsg *it)
 {
 	struct sol_socket_struct *sock;
-	struct fdtable *fdt;
+	struct file *file;
 
 	SOLD("queuing primsg at end");
-	fdt = files_fdtable(current->files);
-	sock = (struct sol_socket_struct *)fdt->fd[fd]->private_data;
+	file = fcheck_files(current->files, fd);
+	sock = (struct sol_socket_struct *)file->private_data;
 	it->next = NULL;
 	if (sock->plast)
 		sock->plast->next = it;
@@ -350,7 +350,6 @@
 	char *buf;
 	struct file *filp;
 	struct inode *ino;
-	struct fdtable *fdt;
 	struct sol_socket_struct *sock;
 	mm_segment_t old_fs = get_fs();
 	long args[6];
@@ -359,8 +358,7 @@
 	int (*sys_sendto)(int, void __user *, size_t, unsigned, struct sockaddr __user *, int) =
 		(int (*)(int, void __user *, size_t, unsigned, struct sockaddr __user *, int))SYS(sendto);
 
-	fdt = files_fdtable(current->files);
-	filp = fdt->fd[fd];
+	filp = fcheck_files(current->files, fd);
 	ino = filp->f_path.dentry->d_inode;
 	sock = (struct sol_socket_struct *)filp->private_data;
 	SOLD("entry");
@@ -629,7 +627,6 @@
 	int oldflags;
 	struct file *filp;
 	struct inode *ino;
-	struct fdtable *fdt;
 	struct sol_socket_struct *sock;
 	struct T_unitdata_ind udi;
 	mm_segment_t old_fs = get_fs();
@@ -642,8 +639,7 @@
 	
 	SOLD("entry");
 	SOLDD(("%u %p %d %p %p %d %p %d\n", fd, ctl_buf, ctl_maxlen, ctl_len, data_buf, data_maxlen, data_len, *flags_p));
-	fdt = files_fdtable(current->files);
-	filp = fdt->fd[fd];
+	filp = fcheck_files(current->files, fd);
 	ino = filp->f_path.dentry->d_inode;
 	sock = (struct sol_socket_struct *)filp->private_data;
 	SOLDD(("%p %p\n", sock->pfirst, sock->pfirst ? sock->pfirst->next : NULL));
@@ -855,14 +851,12 @@
 	int __user *flgptr;
 	int flags;
 	int error = -EBADF;
-	struct fdtable *fdt;
 
 	SOLD("entry");
 	lock_kernel();
 	if(fd >= NR_OPEN) goto out;
 
-	fdt = files_fdtable(current->files);
-	filp = fdt->fd[fd];
+	filp = fcheck_files(current->files, fd);
 	if(!filp) goto out;
 
 	ino = filp->f_path.dentry->d_inode;
@@ -923,14 +917,12 @@
 	struct strbuf ctl, dat;
 	int flags = (int) arg3;
 	int error = -EBADF;
-	struct fdtable *fdt;
 
 	SOLD("entry");
 	lock_kernel();
 	if(fd >= NR_OPEN) goto out;
 
-	fdt = files_fdtable(current->files);
-	filp = fdt->fd[fd];
+	filp = fcheck_files(current->files, fd);
 	if(!filp) goto out;
 
 	ino = filp->f_path.dentry->d_inode;

