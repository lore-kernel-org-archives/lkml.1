Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZHTF1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZHTF1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZHTF1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:27:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54537 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbZHTF1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:27:15 -0400
Date: Thu, 20 Aug 2009 15:27:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Roel Kluin <roel.kluin@gmail.com>
Subject: linux-next: manual merge of the drm tree with the  tree
Message-Id: <20090820152712.2eac152e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got conflicts in
drivers/gpu/drm/ttm/ttm_bo.c between commits
ad49f501867cba87e1e45e5ebae0b12435d68bf1 ("drm/ttm/radeon: add dma32
support") and c96e7c7a3a79931446ecf9494a8415e4d164ebd8 ("drm/ttm: Read
buffer overflow") from Linus' tree and commit
a987fcaa805fcb24ba885c2e29fd4fdb6816f08f ("ttm: Make parts of a struct
ttm_bo_device global") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/ttm/ttm_bo.c
index c2b0d71,0d0b1b7..0000000
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@@ -43,7 -43,41 +43,40 @@@
  #define TTM_BO_HASH_ORDER 13
  
  static int ttm_bo_setup_vm(struct ttm_buffer_object *bo);
 -static void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo);
  static int ttm_bo_swapout(struct ttm_mem_shrink *shrink);
+ static void ttm_bo_global_kobj_release(struct kobject *kobj);
+ 
+ static struct attribute ttm_bo_count = {
+ 	.name = "bo_count",
+ 	.mode = S_IRUGO
+ };
+ 
+ static ssize_t ttm_bo_global_show(struct kobject *kobj,
+ 				  struct attribute *attr,
+ 				  char *buffer)
+ {
+ 	struct ttm_bo_global *glob =
+ 		container_of(kobj, struct ttm_bo_global, kobj);
+ 
+ 	return snprintf(buffer, PAGE_SIZE, "%lu\n",
+ 			(unsigned long) atomic_read(&glob->bo_count));
+ }
+ 
+ static struct attribute *ttm_bo_global_attrs[] = {
+ 	&ttm_bo_count,
+ 	NULL
+ };
+ 
+ static struct sysfs_ops ttm_bo_global_ops = {
+ 	.show = &ttm_bo_global_show
+ };
+ 
+ static struct kobj_type ttm_bo_glob_kobj_type  = {
+ 	.release = &ttm_bo_global_kobj_release,
+ 	.sysfs_ops = &ttm_bo_global_ops,
+ 	.default_attrs = ttm_bo_global_attrs
+ };
+ 
  
  static inline uint32_t ttm_bo_type_flags(unsigned type)
  {
@@@ -1182,7 -1193,8 +1225,8 @@@ static int ttm_bo_force_list_clean(stru
  
  int ttm_bo_clean_mm(struct ttm_bo_device *bdev, unsigned mem_type)
  {
+ 	struct ttm_bo_global *glob = bdev->glob;
 -	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
 +	struct ttm_mem_type_manager *man;
  	int ret = -EINVAL;
  
  	if (mem_type >= TTM_NUM_MEM_TYPES) {
@@@ -1329,17 -1414,10 +1447,11 @@@ int ttm_bo_device_release(struct ttm_bo
  }
  EXPORT_SYMBOL(ttm_bo_device_release);
  
- /*
-  * This function is intended to be called on drm driver load.
-  * If you decide to call it from firstopen, you must protect the call
-  * from a potentially racing ttm_bo_driver_finish in lastclose.
-  * (This may happen on X server restart).
-  */
- 
  int ttm_bo_device_init(struct ttm_bo_device *bdev,
- 		       struct ttm_mem_global *mem_glob,
- 		       struct ttm_bo_driver *driver, uint64_t file_page_offset,
+ 		       struct ttm_bo_global *glob,
+ 		       struct ttm_bo_driver *driver,
 -		       uint64_t file_page_offset)
++		       uint64_t file_page_offset,
 +		       bool need_dma32)
  {
  	int ret = -EINVAL;
  
@@@ -1374,30 -1444,17 +1478,18 @@@
  	INIT_DELAYED_WORK(&bdev->wq, ttm_bo_delayed_workqueue);
  	bdev->nice_mode = true;
  	INIT_LIST_HEAD(&bdev->ddestroy);
- 	INIT_LIST_HEAD(&bdev->swap_lru);
  	bdev->dev_mapping = NULL;
 +	bdev->need_dma32 = need_dma32;
- 	ttm_mem_init_shrink(&bdev->shrink, ttm_bo_swapout);
- 	ret = ttm_mem_register_shrink(mem_glob, &bdev->shrink);
- 	if (unlikely(ret != 0)) {
- 		printk(KERN_ERR TTM_PFX
- 		       "Could not register buffer object swapout.\n");
- 		goto out_err2;
- 	}
+ 	bdev->glob = glob;
  
- 	bdev->ttm_bo_extra_size =
- 		ttm_round_pot(sizeof(struct ttm_tt)) +
- 		ttm_round_pot(sizeof(struct ttm_backend));
- 
- 	bdev->ttm_bo_size = bdev->ttm_bo_extra_size +
- 		ttm_round_pot(sizeof(struct ttm_buffer_object));
+ 	mutex_lock(&glob->device_list_mutex);
+ 	list_add_tail(&bdev->device_list, &glob->device_list);
+ 	mutex_unlock(&glob->device_list_mutex);
  
  	return 0;
- out_err2:
+ out_no_addr_mm:
  	ttm_bo_clean_mm(bdev, 0);
- out_err1:
- 	__free_page(bdev->dummy_read_page);
- out_err0:
+ out_no_sys:
  	return ret;
  }
  EXPORT_SYMBOL(ttm_bo_device_init);
