Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXBGPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXBGPlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 10:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030632AbXBGPlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 10:41:22 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53473 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030628AbXBGPlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 10:41:21 -0500
Message-ID: <45C9F317.9010700@us.ibm.com>
Date: Wed, 07 Feb 2007 09:41:11 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Carl Love <cel@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
 patch
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
In-Reply-To: <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carl Love wrote:

>
>Subject: Add support to OProfile for profiling Cell BE SPUs
>
>From: Maynard Johnson <maynardj@us.ibm.com>
>
>This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
>to add in the SPU profiling capabilities.  In addition, a 'cell' subdirectory
>was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
>code.
>
>Signed-off-by: Carl Love <carll@us.ibm.com>
>Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
>
>Index: linux-2.6.20-rc1/arch/powerpc/configs/cell_defconfig
>  
>
I've discovered more problems with the kref handling for the cached_info 
object that we store in the spu_context.  :-(

When the OProfile module initially determines that no cached_info yet 
exists for a given spu_context, it creates the cached_info, inits the 
cached_info's kref (which increments the refcount) and does a kref_get 
(for SPUFS' ref) before passing the cached_info reference off to SUPFS 
to store into the spu_context.  When OProfile shuts down or the SPU job 
ends, OProfile gives up its ref to the cached_info with kref_put.  Then 
when SPUFS destroys the spu_context, it also gives up its ref.  HOWEVER 
. . . . If OProfile shuts down while the SPU job is still active _and_ 
_then_ is restarted while the job is still active, OProfile will find 
that the cached_info exists for the given spu_context, so it won't go 
through the process of creating it and doing kref_init on the kref.  
Under this scenario, OProfile does not own a ref of its own to the 
cached_info, and should not be doing a kref_put when done using the 
cached_info -- but it does, and so does SPUFS when the spu_context is 
destroyed.  The end result (with the code as currently written) is that 
an extra kref_put is done when the refcount is already down to zero.  To 
fix this, OProfile needs to detect when it finds an existing cached_info 
already stored in the spu_context.  Then, instead of creating a new one, 
it sets a reminder flag to be used later when it's done using the cached 
info to indicate whether or not it needs to call kref_put.

Unfortunately, there's another problem (one that should have been 
obvious to me).  The cached_info's kref "release" function is 
destroy_cached_info(), defined in the OProfile module.  If the OProfile 
module is unloaded when SPUFS destroys the spu_context and calls 
kref_put on the cached_info's kref -- KABOOM!  The destroy_cached_info 
function (the second arg to kref_put) is not in memory, so we get a 
paging fault.  I see a couple options to solve this:
    1) Don't store the cached_info in the spu_context.  Basically, go 
back to the simplistic model of creating/deleting the cached_info on 
every SPU task activation/deactivation.
    2)  If there's some way to do this, force the OProfile module to 
stay loaded until SPUFS has destroyed its last spu_context that holds a 
cached_info object.

I thought about putting the cached_info's kref "release" function in 
SPUFS, but this just won't work. This implies that SPUFS needs to know 
about the structure of the cached_info, e.g., that it contains the 
vma_map member that needs to be freed.  But even with that information, 
it's not enough, since the vma_map member consists of list of vma_maps, 
which is why we have the vma_map_free() function.  So SPUFS would still 
need access to vma_map_free() from the OProfile module.

Opinions from others would be appreciated.

Thanks.
-Maynard

>+/* Container for caching information about an active SPU task.
>+ * 
>+ */
>+struct cached_info {
>+	struct vma_to_fileoffset_map * map;
>+	struct spu * the_spu;   /* needed to access pointer to local_store */
>+	struct kref cache_ref;
>+};
>+
>+static struct cached_info * spu_info[MAX_NUMNODES * 8];
>+
>+static void destroy_cached_info(struct kref * kref)
>+{
>+	struct cached_info * info;
>+	info = container_of(kref, struct cached_info, cache_ref);
>+	vma_map_free(info->map);
>+	kfree(info);
>+}
>+
>+/* Return the cached_info for the passed SPU number.
>+ * 
>+ */
>+static struct cached_info * get_cached_info(struct spu * the_spu, int spu_num)
>+{
>+	struct cached_info * ret_info = NULL;
>+	unsigned long flags = 0;
>+	if (spu_num >= num_spu_nodes) {
>+		printk(KERN_ERR "SPU_PROF: " 
>+		       "%s, line %d: Invalid index %d into spu info cache\n",
>+		       __FUNCTION__, __LINE__, spu_num); 
>+		goto out;
>+	}
>+	spin_lock_irqsave(&cache_lock, flags);
>+	if (!spu_info[spu_num] && the_spu)
>+		spu_info[spu_num] = (struct cached_info *)
>+			spu_get_profile_private(the_spu->ctx);
>+
>+	ret_info = spu_info[spu_num];
>+	spin_unlock_irqrestore(&cache_lock, flags);
>+ out:
>+	return ret_info;
>+}
>+
>+
>+/* Looks for cached info for the passed spu.  If not found, the
>+ * cached info is created for the passed spu.
>+ * Returns 0 for success; otherwise, -1 for error.  
>+ */ 
>+static int
>+prepare_cached_spu_info(struct spu * spu, unsigned int objectId)
>+{
>+	unsigned long flags = 0;
>+	struct vma_to_fileoffset_map * new_map;
>+	int retval = 0;
>+	struct cached_info * info = get_cached_info(spu, spu->number);
>+
>+	if (info) {
>+		pr_debug("Found cached SPU info.\n");
>+		goto out;
>+	}
>+
>+	/* Create cached_info and set spu_info[spu->number] to point to it.
>+	 * spu->number is a system-wide value, not a per-node value.
>+	 */
>+	info = kzalloc(sizeof(struct cached_info), GFP_KERNEL);
>+	if (!info) {
>+		printk(KERN_ERR "SPU_PROF: "
>+		       "%s, line %d: create vma_map failed\n",
>+		       __FUNCTION__, __LINE__);
>+		goto err_alloc;
>+	}
>+	new_map = create_vma_map(spu, objectId);
>+	if (!new_map) {
>+		printk(KERN_ERR "SPU_PROF: "
>+		       "%s, line %d: create vma_map failed\n",
>+		       __FUNCTION__, __LINE__);
>+		goto err_alloc;
>+	}
>+
>+	pr_debug("Created vma_map\n");
>+	info->map = new_map;
>+	info->the_spu = spu;
>+	kref_init(&info->cache_ref);
>+	spin_lock_irqsave(&cache_lock, flags);
>+	spu_info[spu->number] = info;
>+	spin_unlock_irqrestore(&cache_lock, flags);
>+	/* Increment count before passing off ref to SPUFS. */
>+	kref_get(&info->cache_ref);
>+	spu_set_profile_private(spu->ctx, info, &info->cache_ref,
>+				destroy_cached_info);
>+	goto out;
>+	
>+err_alloc:
>+	retval = -1;
>+out:
>+	return retval;
>+}
>+
>+/*
>+ * NOTE:  The caller is responsible for locking the
>+ *	  cache_lock prior to calling this function.
>+ */
>+static int release_cached_info(int spu_index)
>+{
>+	int index, end;
>+	if (spu_index == RELEASE_ALL) {
>+		end = num_spu_nodes;
>+		index = 0;
>+	} else {
>+	        if (spu_index >= num_spu_nodes) {
>+        	        printk(KERN_ERR "SPU_PROF: "
>+			       "%s, line %d: Invalid index %d into spu info cache\n",
>+               	               __FUNCTION__, __LINE__, spu_index);
>+	                goto out;
>+	        }
>+		end = spu_index +1;
>+		index = spu_index;
>+	}
>+	for (; index < end; index++) {
>+		if (spu_info[index]) {
>+			kref_put(&spu_info[index]->cache_ref, destroy_cached_info);
>+			spu_info[index] = NULL;
>+		}
>+	}
>+
>+out:
>+	return 0;
>+}
>+
>Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/context.c
>===================================================================
>--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/context.c	2007-02-05 14:42:04.359859432 -0600
>+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/context.c	2007-02-06 16:44:05.983965096 -0600
>@@ -22,6 +22,7 @@
>
> #include <linux/fs.h>
> #include <linux/mm.h>
>+#include <linux/module.h>
> #include <linux/slab.h>
> #include <asm/spu.h>
> #include <asm/spu_csa.h>
>@@ -71,6 +72,8 @@
> 	spu_fini_csa(&ctx->csa);
> 	if (ctx->gang)
> 		spu_gang_remove_ctx(ctx->gang, ctx);
>+	if (ctx->prof_priv_kref)
>+		kref_put(ctx->prof_priv_kref, ctx->prof_priv_release);
> 	kfree(ctx);
> }
>
>@@ -200,3 +203,29 @@
>
> 	downgrade_write(&ctx->state_sema);
> }
>+
>+/* This interface allows a profiler (e.g., OProfile) to store
>+ * spu_context information needed for profiling, allowing it to
>+ * be saved across context save/restore operation.
>+ *
>+ * Assumes the caller has already incremented the ref count to
>+ * profile_info; then spu_context_destroy must call kref_put
>+ * on prof_info_kref.
>+ */
>+void spu_set_profile_private(struct spu_context * ctx, void * profile_info,
>+			     struct kref * prof_info_kref,
>+			     void (* prof_info_release) (struct kref * kref))
>+{
>+	ctx->profile_private = profile_info;
>+	ctx->prof_priv_kref = prof_info_kref;
>+	ctx->prof_priv_release = prof_info_release;
>+}
>+EXPORT_SYMBOL_GPL(spu_set_profile_private);
>+
>+void * spu_get_profile_private(struct spu_context * ctx)
>+{
>+	return ctx->profile_private;
>+}
>+EXPORT_SYMBOL_GPL(spu_get_profile_private);
>+
>+
>
>
>  
>


