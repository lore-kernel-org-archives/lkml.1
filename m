Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab0BYBw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:52:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60953 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0BYBw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:52:26 -0500
Date: Thu, 25 Feb 2010 12:52:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, linux-rmda@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the infiniband tree with the vfs tree
Message-Id: <20100225125224.af78cc78.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/core/uverbs_main.c between commit
ce916e2b935f8b3402da1457ff23b9f9f786c09b ("switch infiniband uverbs to
anon_inodes") from the vfs tree and commit
055422ddbb0a7610c5f57a056743d7336a39e90f ("IB/uverbs: Convert *cdev to
cdev in struct ib_uverbs_device") from the infiniband tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/core/uverbs_main.c
index 810f277,dbf0451..0000000
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@@ -41,9 -41,8 +41,8 @@@
  #include <linux/fs.h>
  #include <linux/poll.h>
  #include <linux/sched.h>
 +#include <linux/anon_inodes.h>
  #include <linux/file.h>
- #include <linux/cdev.h>
 -#include <linux/mount.h>
  
  #include <asm/uaccess.h>
  
@@@ -79,36 -79,38 +77,36 @@@ static DECLARE_BITMAP(dev_map, IB_UVERB
  static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
  				     const char __user *buf, int in_len,
  				     int out_len) = {
- 	[IB_USER_VERBS_CMD_GET_CONTEXT]   	= ib_uverbs_get_context,
- 	[IB_USER_VERBS_CMD_QUERY_DEVICE]  	= ib_uverbs_query_device,
- 	[IB_USER_VERBS_CMD_QUERY_PORT]    	= ib_uverbs_query_port,
- 	[IB_USER_VERBS_CMD_ALLOC_PD]      	= ib_uverbs_alloc_pd,
- 	[IB_USER_VERBS_CMD_DEALLOC_PD]    	= ib_uverbs_dealloc_pd,
- 	[IB_USER_VERBS_CMD_REG_MR]        	= ib_uverbs_reg_mr,
- 	[IB_USER_VERBS_CMD_DEREG_MR]      	= ib_uverbs_dereg_mr,
+ 	[IB_USER_VERBS_CMD_GET_CONTEXT]		= ib_uverbs_get_context,
+ 	[IB_USER_VERBS_CMD_QUERY_DEVICE]	= ib_uverbs_query_device,
+ 	[IB_USER_VERBS_CMD_QUERY_PORT]		= ib_uverbs_query_port,
+ 	[IB_USER_VERBS_CMD_ALLOC_PD]		= ib_uverbs_alloc_pd,
+ 	[IB_USER_VERBS_CMD_DEALLOC_PD]		= ib_uverbs_dealloc_pd,
+ 	[IB_USER_VERBS_CMD_REG_MR]		= ib_uverbs_reg_mr,
+ 	[IB_USER_VERBS_CMD_DEREG_MR]		= ib_uverbs_dereg_mr,
  	[IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL] = ib_uverbs_create_comp_channel,
- 	[IB_USER_VERBS_CMD_CREATE_CQ]     	= ib_uverbs_create_cq,
- 	[IB_USER_VERBS_CMD_RESIZE_CQ]     	= ib_uverbs_resize_cq,
- 	[IB_USER_VERBS_CMD_POLL_CQ]     	= ib_uverbs_poll_cq,
- 	[IB_USER_VERBS_CMD_REQ_NOTIFY_CQ]     	= ib_uverbs_req_notify_cq,
- 	[IB_USER_VERBS_CMD_DESTROY_CQ]    	= ib_uverbs_destroy_cq,
- 	[IB_USER_VERBS_CMD_CREATE_QP]     	= ib_uverbs_create_qp,
- 	[IB_USER_VERBS_CMD_QUERY_QP]     	= ib_uverbs_query_qp,
- 	[IB_USER_VERBS_CMD_MODIFY_QP]     	= ib_uverbs_modify_qp,
- 	[IB_USER_VERBS_CMD_DESTROY_QP]    	= ib_uverbs_destroy_qp,
- 	[IB_USER_VERBS_CMD_POST_SEND]    	= ib_uverbs_post_send,
- 	[IB_USER_VERBS_CMD_POST_RECV]    	= ib_uverbs_post_recv,
- 	[IB_USER_VERBS_CMD_POST_SRQ_RECV]    	= ib_uverbs_post_srq_recv,
- 	[IB_USER_VERBS_CMD_CREATE_AH]    	= ib_uverbs_create_ah,
- 	[IB_USER_VERBS_CMD_DESTROY_AH]    	= ib_uverbs_destroy_ah,
- 	[IB_USER_VERBS_CMD_ATTACH_MCAST]  	= ib_uverbs_attach_mcast,
- 	[IB_USER_VERBS_CMD_DETACH_MCAST]  	= ib_uverbs_detach_mcast,
- 	[IB_USER_VERBS_CMD_CREATE_SRQ]    	= ib_uverbs_create_srq,
- 	[IB_USER_VERBS_CMD_MODIFY_SRQ]    	= ib_uverbs_modify_srq,
- 	[IB_USER_VERBS_CMD_QUERY_SRQ]     	= ib_uverbs_query_srq,
- 	[IB_USER_VERBS_CMD_DESTROY_SRQ]   	= ib_uverbs_destroy_srq,
+ 	[IB_USER_VERBS_CMD_CREATE_CQ]		= ib_uverbs_create_cq,
+ 	[IB_USER_VERBS_CMD_RESIZE_CQ]		= ib_uverbs_resize_cq,
+ 	[IB_USER_VERBS_CMD_POLL_CQ]		= ib_uverbs_poll_cq,
+ 	[IB_USER_VERBS_CMD_REQ_NOTIFY_CQ]	= ib_uverbs_req_notify_cq,
+ 	[IB_USER_VERBS_CMD_DESTROY_CQ]		= ib_uverbs_destroy_cq,
+ 	[IB_USER_VERBS_CMD_CREATE_QP]		= ib_uverbs_create_qp,
+ 	[IB_USER_VERBS_CMD_QUERY_QP]		= ib_uverbs_query_qp,
+ 	[IB_USER_VERBS_CMD_MODIFY_QP]		= ib_uverbs_modify_qp,
+ 	[IB_USER_VERBS_CMD_DESTROY_QP]		= ib_uverbs_destroy_qp,
+ 	[IB_USER_VERBS_CMD_POST_SEND]		= ib_uverbs_post_send,
+ 	[IB_USER_VERBS_CMD_POST_RECV]		= ib_uverbs_post_recv,
+ 	[IB_USER_VERBS_CMD_POST_SRQ_RECV]	= ib_uverbs_post_srq_recv,
+ 	[IB_USER_VERBS_CMD_CREATE_AH]		= ib_uverbs_create_ah,
+ 	[IB_USER_VERBS_CMD_DESTROY_AH]		= ib_uverbs_destroy_ah,
+ 	[IB_USER_VERBS_CMD_ATTACH_MCAST]	= ib_uverbs_attach_mcast,
+ 	[IB_USER_VERBS_CMD_DETACH_MCAST]	= ib_uverbs_detach_mcast,
+ 	[IB_USER_VERBS_CMD_CREATE_SRQ]		= ib_uverbs_create_srq,
+ 	[IB_USER_VERBS_CMD_MODIFY_SRQ]		= ib_uverbs_modify_srq,
+ 	[IB_USER_VERBS_CMD_QUERY_SRQ]		= ib_uverbs_query_srq,
+ 	[IB_USER_VERBS_CMD_DESTROY_SRQ]		= ib_uverbs_destroy_srq,
  };
  
 -static struct vfsmount *uverbs_event_mnt;
 -
  static void ib_uverbs_add_one(struct ib_device *device);
  static void ib_uverbs_remove_one(struct ib_device *device);
  
@@@ -838,8 -933,12 +867,10 @@@ out
  static void __exit ib_uverbs_cleanup(void)
  {
  	ib_unregister_client(&uverbs_client);
 -	mntput(uverbs_event_mnt);
 -	unregister_filesystem(&uverbs_event_fs);
  	class_destroy(uverbs_class);
  	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
+ 	if (overflow_maj)
+ 		unregister_chrdev_region(overflow_maj, IB_UVERBS_MAX_DEVICES);
  	idr_destroy(&ib_uverbs_pd_idr);
  	idr_destroy(&ib_uverbs_mr_idr);
  	idr_destroy(&ib_uverbs_mw_idr);
