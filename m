Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbXL1THx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbXL1THx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXL1THb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:07:31 -0500
Received: from verein.lst.de ([213.95.11.210]:39044 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbXL1TH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:07:28 -0500
Date: Fri, 28 Dec 2007 20:07:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: arndb@de.ibm.com, stefano.brivio@polimi.it
Subject: [PATCH 1/3] libfs: allow error return from simple attributes
Message-ID: <20071228190712.GA4855@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes simple attributes might need to return an error, e.g. for
acquiring a mutex interruptibly.  In fact we have that situation in
spufs already which is the original user of the simple attributes.  This
patch merged the temporarily forked attributes in spufs back into the
main ones and allows to return errors.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6.24-rc6/fs/libfs.c
===================================================================
--- linux-2.6.24-rc6.orig/fs/libfs.c	2007-12-28 10:11:11.000000000 +0100
+++ linux-2.6.24-rc6/fs/libfs.c	2007-12-28 19:50:54.000000000 +0100
@@ -583,8 +583,8 @@ int simple_transaction_release(struct in
 /* Simple attribute files */
 
 struct simple_attr {
-	u64 (*get)(void *);
-	void (*set)(void *, u64);
+	int (*get)(void *, u64 *);
+	int (*set)(void *, u64);
 	char get_buf[24];	/* enough to store a u64 and "\n\0" */
 	char set_buf[24];
 	void *data;
@@ -595,7 +595,7 @@ struct simple_attr {
 /* simple_attr_open is called by an actual attribute open file operation
  * to set the attribute specific access operations. */
 int simple_attr_open(struct inode *inode, struct file *file,
-		     u64 (*get)(void *), void (*set)(void *, u64),
+		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt)
 {
 	struct simple_attr *attr;
@@ -635,14 +635,20 @@ ssize_t simple_attr_read(struct file *fi
 		return -EACCES;
 
 	mutex_lock(&attr->mutex);
-	if (*ppos) /* continued read */
+	if (*ppos) {		/* continued read */
 		size = strlen(attr->get_buf);
-	else	  /* first read */
+	} else {		/* first read */
+		u64 val;
+		ret = attr->get(attr->data, &val);
+		if (ret)
+			goto out;
+
 		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
-				 attr->fmt,
-				 (unsigned long long)attr->get(attr->data));
+				 attr->fmt, (unsigned long long)val);
+	}
 
 	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
+out:
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
@@ -657,7 +663,6 @@ ssize_t simple_attr_write(struct file *f
 	ssize_t ret;
 
 	attr = file->private_data;
-
 	if (!attr->set)
 		return -EACCES;
 
Index: linux-2.6.24-rc6/arch/avr32/kernel/ocd.c
===================================================================
--- linux-2.6.24-rc6.orig/arch/avr32/kernel/ocd.c	2007-12-28 10:17:00.000000000 +0100
+++ linux-2.6.24-rc6/arch/avr32/kernel/ocd.c	2007-12-28 10:18:18.000000000 +0100
@@ -90,25 +90,29 @@ static struct dentry *ocd_debugfs_DC;
 static struct dentry *ocd_debugfs_DS;
 static struct dentry *ocd_debugfs_count;
 
-static u64 ocd_DC_get(void *data)
+static int ocd_DC_get(void *data, u64 *val)
 {
-	return ocd_read(DC);
+	*val = ocd_read(DC);
+	return 0;
 }
-static void ocd_DC_set(void *data, u64 val)
+static int ocd_DC_set(void *data, u64 val)
 {
 	ocd_write(DC, val);
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_DC, ocd_DC_get, ocd_DC_set, "0x%08llx\n");
 
-static u64 ocd_DS_get(void *data)
+static int ocd_DS_get(void *data, u64 *val)
 {
-	return ocd_read(DS);
+	*val = ocd_read(DS);
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_DS, ocd_DS_get, NULL, "0x%08llx\n");
 
-static u64 ocd_count_get(void *data)
+static int ocd_count_get(void *data, u64 *val)
 {
-	return ocd_count;
+	*val = ocd_count;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_count, ocd_count_get, NULL, "%lld\n");
 
Index: linux-2.6.24-rc6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.24-rc6.orig/arch/powerpc/platforms/cell/spufs/file.c	2007-12-28 10:23:59.000000000 +0100
+++ linux-2.6.24-rc6/arch/powerpc/platforms/cell/spufs/file.c	2007-12-28 10:24:19.000000000 +0100
@@ -340,7 +340,7 @@ static int spufs_cntl_open(struct inode 
 	if (!i->i_openers++)
 		ctx->cntl = inode->i_mapping;
 	mutex_unlock(&ctx->mapping_lock);
-	return spufs_attr_open(inode, file, spufs_cntl_get,
+	return simple_attr_open(inode, file, spufs_cntl_get,
 					spufs_cntl_set, "0x%08lx");
 }
 
@@ -350,7 +350,7 @@ spufs_cntl_release(struct inode *inode, 
 	struct spufs_inode_info *i = SPUFS_I(inode);
 	struct spu_context *ctx = i->i_ctx;
 
-	spufs_attr_release(inode, file);
+	simple_attr_close(inode, file);
 
 	mutex_lock(&ctx->mapping_lock);
 	if (!--i->i_openers)
@@ -362,8 +362,8 @@ spufs_cntl_release(struct inode *inode, 
 static const struct file_operations spufs_cntl_fops = {
 	.open = spufs_cntl_open,
 	.release = spufs_cntl_release,
-	.read = spufs_attr_read,
-	.write = spufs_attr_write,
+	.read = simple_attr_read,
+	.write = simple_attr_write,
 	.mmap = spufs_cntl_mmap,
 };
 
Index: linux-2.6.24-rc6/fs/debugfs/file.c
===================================================================
--- linux-2.6.24-rc6.orig/fs/debugfs/file.c	2007-12-28 10:20:55.000000000 +0100
+++ linux-2.6.24-rc6/fs/debugfs/file.c	2007-12-28 10:22:30.000000000 +0100
@@ -56,13 +56,15 @@ const struct inode_operations debugfs_li
 	.follow_link    = debugfs_follow_link,
 };
 
-static void debugfs_u8_set(void *data, u64 val)
+static int debugfs_u8_set(void *data, u64 val)
 {
 	*(u8 *)data = val;
+	return 0;
 }
-static u64 debugfs_u8_get(void *data)
+static int debugfs_u8_get(void *data, u64 *val)
 {
-	return *(u8 *)data;
+	*val = *(u8 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs_u8_get, debugfs_u8_set, "%llu\n");
 
@@ -97,13 +99,15 @@ struct dentry *debugfs_create_u8(const c
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u8);
 
-static void debugfs_u16_set(void *data, u64 val)
+static int debugfs_u16_set(void *data, u64 val)
 {
 	*(u16 *)data = val;
+	return 0;
 }
-static u64 debugfs_u16_get(void *data)
+static int debugfs_u16_get(void *data, u64 *val)
 {
-	return *(u16 *)data;
+	*val = *(u16 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugfs_u16_get, debugfs_u16_set, "%llu\n");
 
@@ -138,13 +142,15 @@ struct dentry *debugfs_create_u16(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u16);
 
-static void debugfs_u32_set(void *data, u64 val)
+static int debugfs_u32_set(void *data, u64 val)
 {
 	*(u32 *)data = val;
+	return 0;
 }
-static u64 debugfs_u32_get(void *data)
+static int debugfs_u32_get(void *data, u64 *val)
 {
-	return *(u32 *)data;
+	*val = *(u32 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugfs_u32_get, debugfs_u32_set, "%llu\n");
 
@@ -179,14 +185,16 @@ struct dentry *debugfs_create_u32(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
-static void debugfs_u64_set(void *data, u64 val)
+static int debugfs_u64_set(void *data, u64 val)
 {
 	*(u64 *)data = val;
+	return 0;
 }
 
-static u64 debugfs_u64_get(void *data)
+static int debugfs_u64_get(void *data, u64 *val)
 {
-	return *(u64 *)data;
+	*val = *(u64 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
 
Index: linux-2.6.24-rc6/lib/fault-inject.c
===================================================================
--- linux-2.6.24-rc6.orig/lib/fault-inject.c	2007-12-28 10:18:26.000000000 +0100
+++ linux-2.6.24-rc6/lib/fault-inject.c	2007-12-28 10:19:43.000000000 +0100
@@ -134,9 +134,10 @@ bool should_fail(struct fault_attr *attr
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
-static void debugfs_ul_set(void *data, u64 val)
+static int debugfs_ul_set(void *data, u64 val)
 {
 	*(unsigned long *)data = val;
+	return 0;
 }
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
@@ -148,9 +149,10 @@ static void debugfs_ul_set_MAX_STACK_TRA
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-static u64 debugfs_ul_get(void *data)
+static int debugfs_ul_get(void *data, u64 *val)
 {
-	return *(unsigned long *)data;
+	*val = *(unsigned long *)data;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_ul, debugfs_ul_get, debugfs_ul_set, "%llu\n");
@@ -174,14 +176,16 @@ static struct dentry *debugfs_create_ul_
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-static void debugfs_atomic_t_set(void *data, u64 val)
+static int debugfs_atomic_t_set(void *data, u64 val)
 {
 	atomic_set((atomic_t *)data, val);
+	return 0;
 }
 
-static u64 debugfs_atomic_t_get(void *data)
+static int debugfs_atomic_t_get(void *data, u64 *val)
 {
-	return atomic_read((atomic_t *)data);
+	*val = atomic_read((atomic_t *)data);
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_t, debugfs_atomic_t_get,
Index: linux-2.6.24-rc6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.24-rc6.orig/virt/kvm/kvm_main.c	2007-12-28 10:19:47.000000000 +0100
+++ linux-2.6.24-rc6/virt/kvm/kvm_main.c	2007-12-28 10:20:42.000000000 +0100
@@ -1179,38 +1179,38 @@ static struct notifier_block kvm_cpu_not
 	.priority = 20, /* must be > scheduler priority */
 };
 
-static u64 vm_stat_get(void *_offset)
+static int vm_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
-	u64 total = 0;
 	struct kvm *kvm;
 
+	*val = 0;
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		total += *(u32 *)((void *)kvm + offset);
+		*val += *(u32 *)((void *)kvm + offset);
 	spin_unlock(&kvm_lock);
-	return total;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(vm_stat_fops, vm_stat_get, NULL, "%llu\n");
 
-static u64 vcpu_stat_get(void *_offset)
+static int vcpu_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
-	u64 total = 0;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	*val = 0;
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 			vcpu = kvm->vcpus[i];
 			if (vcpu)
-				total += *(u32 *)((void *)vcpu + offset);
+				*val += *(u32 *)((void *)vcpu + offset);
 		}
 	spin_unlock(&kvm_lock);
-	return total;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, NULL, "%llu\n");
Index: linux-2.6.24-rc6/include/linux/fs.h
===================================================================
--- linux-2.6.24-rc6.orig/include/linux/fs.h	2007-12-28 10:11:04.000000000 +0100
+++ linux-2.6.24-rc6/include/linux/fs.h	2007-12-28 10:26:45.000000000 +0100
@@ -2073,7 +2073,7 @@ __simple_attr_check_format(const char *f
 }
 
 int simple_attr_open(struct inode *inode, struct file *file,
-		     u64 (*get)(void *), void (*set)(void *, u64),
+		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt);
 int simple_attr_close(struct inode *inode, struct file *file);
 ssize_t simple_attr_read(struct file *file, char __user *buf,
