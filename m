Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYFAKOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYFAKOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 06:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYFAKOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 06:14:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:53877 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYFAKOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 06:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pMb2xJz3cZfNmtGCWCzjuG7vXkAyoOZJJQTNj9bsT4wk4iH9EwlLtiRugL4B8XoHX3
         DkNo9s5Cjoot/nra+Y3Nr9XZ9xxh57qv1FG9mHRKjGsNNFHKjfTU/z9i7PyEohH4KwUK
         ywrQn5X8VB29JxdRZf+HWr9tlf7FBYs+E+Yo8=
Date: Sun, 1 Jun 2008 14:10:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm: switch to seq_files
Message-ID: <20080601101021.GA5063@martell.zuzino.mipt.ru>
References: <20080531203940.40536c9a@infradead.org> <20080531214821.19218b6b@infradead.org> <20080601092546.GA4967@martell.zuzino.mipt.ru> <20080601093600.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601093600.GL28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 10:36:00AM +0100, Al Viro wrote:
> On Sun, Jun 01, 2008 at 01:25:46PM +0400, Alexey Dobriyan wrote:
> > On Sat, May 31, 2008 at 09:48:21PM -0700, Arjan van de Ven wrote:
> > > Subject: [PATCH] drm: make drm use create_proc_read_entry() instead
> > > 
> > > Al Viro points out that DRM should have used create_proc_read_entry(),
> > > and although that is still racey right now, it at least has a chance
> > > of getting fixed on the api level.
> > 
> > Fix on API level is proc_create_data(), so this patch is pointless.
> 
> Yeah...  OTOH, it might make sense to reorder assignments in the
> create_proc_read_entry() and slap the barrier in there - it would
> close at least some of the holes until we get around to proper
> proc_create_data() conversions and remove the ->read_proc() crap...

Hmm, I already have drm conversion patch.

Could someone please test it, there are nvidias here...



[PATCH] drm: convert to seq_files

Switch to proc_create_data() while I'm at it, it fixes "->data is NULL"
race: http://www.kerneloops.org/search.php?search=drm_name_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/drm/drmP.h             |   11 -
 drivers/char/drm/drm_memory.c       |   13 -
 drivers/char/drm/drm_memory_debug.h |   23 --
 drivers/char/drm/drm_proc.c         |  311 ++++++++++++++++--------------------
 4 files changed, 151 insertions(+), 207 deletions(-)

--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -49,6 +49,7 @@
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/file.h>
 #include <linux/pci.h>
@@ -198,12 +199,7 @@ struct drm_device;
 #define DRM_PROC_LIMIT (PAGE_SIZE-80)
 
 #define DRM_PROC_PRINT(fmt, arg...)					\
-   len += sprintf(&buf[len], fmt , ##arg);				\
-   if (len > DRM_PROC_LIMIT) { *eof = 1; return len - offset; }
-
-#define DRM_PROC_PRINT_RET(ret, fmt, arg...)				\
-   len += sprintf(&buf[len], fmt , ##arg);				\
-   if (len > DRM_PROC_LIMIT) { ret; *eof = 1; return len - offset; }
+   seq_printf(m, fmt , ##arg);						\
 
 /*@}*/
 
@@ -860,8 +856,7 @@ extern unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait);
 				/* Memory management support (drm_memory.h) */
 #include "drm_memory.h"
 extern void drm_mem_init(void);
-extern int drm_mem_info(char *buf, char **start, off_t offset,
-			int request, int *eof, void *data);
+extern int drm_mem_proc_show(struct seq_file *m, void *v);
 extern void *drm_realloc(void *oldpt, size_t oldsize, size_t size, int area);
 
 extern DRM_AGP_MEM *drm_alloc_agp(struct drm_device *dev, int pages, u32 type);
--- a/drivers/char/drm/drm_memory.c
+++ b/drivers/char/drm/drm_memory.c
@@ -47,19 +47,8 @@ void drm_mem_init(void)
 
 /**
  * Called when "/proc/dri/%dev%/mem" is read.
- *
- * \param buf output buffer.
- * \param start start of output data.
- * \param offset requested start offset.
- * \param len requested number of bytes.
- * \param eof whether there is no more data to return.
- * \param data private data.
- * \return number of written bytes.
- *
- * No-op.
  */
-int drm_mem_info(char *buf, char **start, off_t offset,
-		 int len, int *eof, void *data)
+int drm_mem_proc_show(struct seq_file *m, void *v)
 {
 	return 0;
 }
--- a/drivers/char/drm/drm_memory_debug.h
+++ b/drivers/char/drm/drm_memory_debug.h
@@ -91,18 +91,8 @@ void drm_mem_init (void) {
 
 /* drm_mem_info is called whenever a process reads /dev/drm/mem. */
 
-static int drm__mem_info (char *buf, char **start, off_t offset,
-			   int request, int *eof, void *data) {
+static int drm__mem_info (struct seq_file *m) {
 	drm_mem_stats_t *pt;
-	int len = 0;
-
-	if (offset > DRM_PROC_LIMIT) {
-		*eof = 1;
-		return 0;
-	}
-
-	*eof = 0;
-	*start = &buf[offset];
 
 	DRM_PROC_PRINT("		  total counts			"
 		       " |    outstanding  \n");
@@ -126,19 +116,14 @@ static int drm__mem_info (char *buf, char **start, off_t offset,
 			       (long)pt->bytes_allocated
 			       - (long)pt->bytes_freed);
 	}
-
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+	return 0;
 }
 
-int drm_mem_info (char *buf, char **start, off_t offset,
-		   int len, int *eof, void *data) {
+int drm_mem_proc_show (struct seq_file *m, void *v) {
 	int ret;
 
 	spin_lock(&drm_mem_lock);
-	ret = drm__mem_info (buf, start, offset, len, eof, data);
+	ret = drm__mem_info (m);
 	spin_unlock(&drm_mem_lock);
 	return ret;
 }
--- a/drivers/char/drm/drm_proc.c
+++ b/drivers/char/drm/drm_proc.c
@@ -39,19 +39,14 @@
 
 #include "drmP.h"
 
-static int drm_name_info(char *buf, char **start, off_t offset,
-			 int request, int *eof, void *data);
-static int drm_vm_info(char *buf, char **start, off_t offset,
-		       int request, int *eof, void *data);
-static int drm_clients_info(char *buf, char **start, off_t offset,
-			    int request, int *eof, void *data);
-static int drm_queues_info(char *buf, char **start, off_t offset,
-			   int request, int *eof, void *data);
-static int drm_bufs_info(char *buf, char **start, off_t offset,
-			 int request, int *eof, void *data);
+static const struct file_operations drm_name_proc_fops;
+static const struct file_operations drm_mem_proc_fops;
+static const struct file_operations drm_vm_proc_fops;
+static const struct file_operations drm_clients_proc_fops;
+static const struct file_operations drm_queues_proc_fops;
+static const struct file_operations drm_bufs_proc_fops;
 #if DRM_DEBUG_CODE
-static int drm_vma_info(char *buf, char **start, off_t offset,
-			int request, int *eof, void *data);
+static const struct file_operations drm_vma_proc_fops;
 #endif
 
 /**
@@ -59,16 +54,16 @@ static int drm_vma_info(char *buf, char **start, off_t offset,
  */
 static struct drm_proc_list {
 	const char *name;	/**< file name */
-	int (*f) (char *, char **, off_t, int, int *, void *);		/**< proc callback*/
+	const struct file_operations *proc_fops;	/**< proc callback*/
 } drm_proc_list[] = {
-	{"name", drm_name_info},
-	{"mem", drm_mem_info},
-	{"vm", drm_vm_info},
-	{"clients", drm_clients_info},
-	{"queues", drm_queues_info},
-	{"bufs", drm_bufs_info},
+	{"name", &drm_name_proc_fops},
+	{"mem", &drm_mem_proc_fops},
+	{"vm", &drm_vm_proc_fops},
+	{"clients", &drm_clients_proc_fops},
+	{"queues", &drm_queues_proc_fops},
+	{"bufs", &drm_bufs_proc_fops},
 #if DRM_DEBUG_CODE
-	{"vma", drm_vma_info},
+	{"vma", &drm_vma_proc_fops},
 #endif
 };
 
@@ -102,8 +97,9 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
 	}
 
 	for (i = 0; i < DRM_PROC_ENTRIES; i++) {
-		ent = create_proc_entry(drm_proc_list[i].name,
-					S_IFREG | S_IRUGO, minor->dev_root);
+		ent = proc_create_data(drm_proc_list[i].name,
+					S_IFREG | S_IRUGO, minor->dev_root,
+					drm_proc_list[i].proc_fops, minor);
 		if (!ent) {
 			DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
 				  name, drm_proc_list[i].name);
@@ -114,8 +110,6 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
 			minor->dev_root = NULL;
 			return -1;
 		}
-		ent->read_proc = drm_proc_list[i].f;
-		ent->data = minor;
 	}
 
 	return 0;
@@ -160,20 +154,10 @@ int drm_proc_cleanup(struct drm_minor *minor, struct proc_dir_entry *root)
  *
  * Prints the device name together with the bus id if available.
  */
-static int drm_name_info(char *buf, char **start, off_t offset, int request,
-			 int *eof, void *data)
+static int drm_name_proc_show(struct seq_file *m, void *v)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
-	int len = 0;
-
-	if (offset > DRM_PROC_LIMIT) {
-		*eof = 1;
-		return 0;
-	}
-
-	*start = &buf[offset];
-	*eof = 0;
 
 	if (dev->unique) {
 		DRM_PROC_PRINT("%s %s %s\n",
@@ -183,13 +167,35 @@ static int drm_name_info(char *buf, char **start, off_t offset, int request,
 		DRM_PROC_PRINT("%s %s\n", dev->driver->pci_driver.name,
 			       pci_name(dev->pdev));
 	}
+	return 0;
+}
 
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+static int drm_name_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_name_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations drm_name_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_name_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int drm_mem_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_mem_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations drm_mem_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_mem_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /**
  * Called when "/proc/dri/.../vm" is read.
  *
@@ -203,12 +209,10 @@ static int drm_name_info(char *buf, char **start, off_t offset, int request,
  *
  * Prints information about all mappings in drm_device::maplist.
  */
-static int drm__vm_info(char *buf, char **start, off_t offset, int request,
-			int *eof, void *data)
+static int drm__vm_info(struct seq_file *m)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
-	int len = 0;
 	struct drm_map *map;
 	struct drm_map_list *r_list;
 
@@ -219,14 +223,6 @@ static int drm__vm_info(char *buf, char **start, off_t offset, int request,
 	const char *type;
 	int i;
 
-	if (offset > DRM_PROC_LIMIT) {
-		*eof = 1;
-		return 0;
-	}
-
-	*start = &buf[offset];
-	*eof = 0;
-
 	DRM_PROC_PRINT("slot	 offset	      size type flags	 "
 		       "address mtrr\n\n");
 	i = 0;
@@ -250,64 +246,54 @@ static int drm__vm_info(char *buf, char **start, off_t offset, int request,
 		}
 		i++;
 	}
-
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+	return 0;
 }
 
 /**
  * Simply calls _vm_info() while holding the drm_device::struct_mutex lock.
  */
-static int drm_vm_info(char *buf, char **start, off_t offset, int request,
-		       int *eof, void *data)
+static int drm_vm_proc_show(struct seq_file *m, void *v)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
-	ret = drm__vm_info(buf, start, offset, request, eof, data);
+	ret = drm__vm_info(m);
 	mutex_unlock(&dev->struct_mutex);
 	return ret;
 }
 
+static int drm_vm_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_vm_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations drm_vm_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_vm_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /**
  * Called when "/proc/dri/.../queues" is read.
- *
- * \param buf output buffer.
- * \param start start of output data.
- * \param offset requested start offset.
- * \param request requested number of bytes.
- * \param eof whether there is no more data to return.
- * \param data private data.
- * \return number of written bytes.
  */
-static int drm__queues_info(char *buf, char **start, off_t offset,
-			    int request, int *eof, void *data)
+static int drm__queues_info(struct seq_file *m)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
-	int len = 0;
 	int i;
 	struct drm_queue *q;
 
-	if (offset > DRM_PROC_LIMIT) {
-		*eof = 1;
-		return 0;
-	}
-
-	*start = &buf[offset];
-	*eof = 0;
-
 	DRM_PROC_PRINT("  ctx/flags   use   fin"
 		       "   blk/rw/rwf  wait    flushed	   queued"
 		       "      locks\n\n");
 	for (i = 0; i < dev->queue_count; i++) {
 		q = dev->queuelist[i];
 		atomic_inc(&q->use_count);
-		DRM_PROC_PRINT_RET(atomic_dec(&q->use_count),
+		DRM_PROC_PRINT(
 				   "%5d/0x%03x %5d %5d"
 				   " %5d/%c%c/%c%c%c %5Zd\n",
 				   i,
@@ -325,56 +311,49 @@ static int drm__queues_info(char *buf, char **start, off_t offset,
 				   DRM_BUFCOUNT(&q->waitlist));
 		atomic_dec(&q->use_count);
 	}
-
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+	return 0;
 }
 
 /**
  * Simply calls _queues_info() while holding the drm_device::struct_mutex lock.
  */
-static int drm_queues_info(char *buf, char **start, off_t offset, int request,
-			   int *eof, void *data)
+static int drm_queues_proc_show(struct seq_file *m, void *v)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
-	ret = drm__queues_info(buf, start, offset, request, eof, data);
+	ret = drm__queues_info(m);
 	mutex_unlock(&dev->struct_mutex);
 	return ret;
 }
 
+static int drm_queues_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_queues_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations drm_queues_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_queues_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /**
  * Called when "/proc/dri/.../bufs" is read.
- *
- * \param buf output buffer.
- * \param start start of output data.
- * \param offset requested start offset.
- * \param request requested number of bytes.
- * \param eof whether there is no more data to return.
- * \param data private data.
- * \return number of written bytes.
  */
-static int drm__bufs_info(char *buf, char **start, off_t offset, int request,
-			  int *eof, void *data)
+static int drm__bufs_info(struct seq_file *m)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
-	int len = 0;
 	struct drm_device_dma *dma = dev->dma;
 	int i;
 
-	if (!dma || offset > DRM_PROC_LIMIT) {
-		*eof = 1;
+	if (!dma)
 		return 0;
-	}
-
-	*start = &buf[offset];
-	*eof = 0;
 
 	DRM_PROC_PRINT(" o     size count  free	 segs pages    kB\n\n");
 	for (i = 0; i <= DRM_MAX_ORDER; i++) {
@@ -399,56 +378,46 @@ static int drm__bufs_info(char *buf, char **start, off_t offset, int request,
 		DRM_PROC_PRINT(" %d", dma->buflist[i]->list);
 	}
 	DRM_PROC_PRINT("\n");
-
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+	return 0;
 }
 
 /**
  * Simply calls _bufs_info() while holding the drm_device::struct_mutex lock.
  */
-static int drm_bufs_info(char *buf, char **start, off_t offset, int request,
-			 int *eof, void *data)
+static int drm_bufs_proc_show(struct seq_file *m, void *v)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
-	ret = drm__bufs_info(buf, start, offset, request, eof, data);
+	ret = drm__bufs_info(m);
 	mutex_unlock(&dev->struct_mutex);
 	return ret;
 }
 
+static int drm_bufs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_bufs_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations drm_bufs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_bufs_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /**
  * Called when "/proc/dri/.../clients" is read.
- *
- * \param buf output buffer.
- * \param start start of output data.
- * \param offset requested start offset.
- * \param request requested number of bytes.
- * \param eof whether there is no more data to return.
- * \param data private data.
- * \return number of written bytes.
  */
-static int drm__clients_info(char *buf, char **start, off_t offset,
-			     int request, int *eof, void *data)
+static int drm__clients_info(struct seq_file *m)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
-	int len = 0;
 	struct drm_file *priv;
 
-	if (offset > DRM_PROC_LIMIT) {
-		*eof = 1;
-		return 0;
-	}
-
-	*start = &buf[offset];
-	*eof = 0;
-
 	DRM_PROC_PRINT("a dev	pid    uid	magic	  ioctls\n\n");
 	list_for_each_entry(priv, &dev->filelist, lhead) {
 		DRM_PROC_PRINT("%c %3d %5d %5d %10u %10lu\n",
@@ -457,51 +426,49 @@ static int drm__clients_info(char *buf, char **start, off_t offset,
 			       priv->pid,
 			       priv->uid, priv->magic, priv->ioctl_count);
 	}
-
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+	return 0;
 }
 
 /**
  * Simply calls _clients_info() while holding the drm_device::struct_mutex lock.
  */
-static int drm_clients_info(char *buf, char **start, off_t offset,
-			    int request, int *eof, void *data)
+static int drm_clients_proc_show(struct seq_file *m, void *v)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
-	ret = drm__clients_info(buf, start, offset, request, eof, data);
+	ret = drm__clients_info(m);
 	mutex_unlock(&dev->struct_mutex);
 	return ret;
 }
 
+static int drm_clients_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_clients_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations drm_clients_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_clients_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #if DRM_DEBUG_CODE
 
-static int drm__vma_info(char *buf, char **start, off_t offset, int request,
-			 int *eof, void *data)
+static int drm__vma_info(struct seq_file *m)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
-	int len = 0;
 	struct drm_vma_entry *pt;
 	struct vm_area_struct *vma;
 #if defined(__i386__)
 	unsigned int pgprot;
 #endif
 
-	if (offset > DRM_PROC_LIMIT) {
-		*eof = 1;
-		return 0;
-	}
-
-	*start = &buf[offset];
-	*eof = 0;
-
 	DRM_PROC_PRINT("vma use count: %d, high_memory = %p, 0x%08lx\n",
 		       atomic_read(&dev->vma_count),
 		       high_memory, virt_to_phys(high_memory));
@@ -535,23 +502,31 @@ static int drm__vma_info(char *buf, char **start, off_t offset, int request,
 #endif
 		DRM_PROC_PRINT("\n");
 	}
-
-	if (len > request + offset)
-		return request;
-	*eof = 1;
-	return len - offset;
+	return 0;
 }
 
-static int drm_vma_info(char *buf, char **start, off_t offset, int request,
-			int *eof, void *data)
+static int drm_vma_proc_show(struct seq_file *m, void *v)
 {
-	struct drm_minor *minor = (struct drm_minor *) data;
+	struct drm_minor *minor = m->private;
 	struct drm_device *dev = minor->dev;
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
-	ret = drm__vma_info(buf, start, offset, request, eof, data);
+	ret = drm__vma_info(m);
 	mutex_unlock(&dev->struct_mutex);
 	return ret;
 }
+
+static int drm_vma_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, drm_vma_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations drm_vma_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_vma_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif

