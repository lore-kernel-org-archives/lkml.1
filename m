Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYEBGcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYEBGcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYEBGcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:32:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:63749 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYEBGcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=U8NTpKsS0vQAWaHkMZ/u8kDgCkbFTic3kXPB8nIUSJTbT+zJzJ2PKoEnk8urBuLAHw2Z5YfVKADSD0t01v/TZsjnPEQmpJmfeCqK7sC1IofuaQJjmw4HBJInvacGZ0a+UST/MPKHMnAb3sJL1zeYeG+pcHAVazJeV0PEvg5QlAs=
Date: Fri, 2 May 2008 14:36:14 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] (Resend) arch/um/kernel/irq.c: clean up some functions
Message-ID: <alpine.LFD.1.10.0805021430280.3349@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make activate_fd() and free_irq_by_irq_and_dev() static.
Remove init_aio_irq() since it has no users.

Compile testing passed.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
  arch/um/include/irq_kern.h |    2 --
  arch/um/include/irq_user.h |    2 --
  arch/um/kernel/irq.c       |   35 ++---------------------------------
  3 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/arch/um/include/irq_kern.h b/arch/um/include/irq_kern.h
index 4f77559..fba3895 100644
--- a/arch/um/include/irq_kern.h
+++ b/arch/um/include/irq_kern.h
@@ -13,8 +13,6 @@ extern int um_request_irq(unsigned int irq, int fd, int type,
  			  irq_handler_t handler,
  			  unsigned long irqflags,  const char * devname,
  			  void *dev_id);
-extern int init_aio_irq(int irq, char *name,
-			irq_handler_t handler);

  #endif

diff --git a/arch/um/include/irq_user.h b/arch/um/include/irq_user.h
index e60b318..c6c784d 100644
--- a/arch/um/include/irq_user.h
+++ b/arch/um/include/irq_user.h
@@ -21,8 +21,6 @@ struct irq_fd {
  enum { IRQ_READ, IRQ_WRITE };

  extern void sigio_handler(int sig, struct uml_pt_regs *regs);
-extern int activate_fd(int irq, int fd, int type, void *dev_id);
-extern void free_irq_by_irq_and_dev(unsigned int irq, void *dev_id);
  extern void free_irq_by_fd(int fd);
  extern void reactivate_fd(int fd, int irqnum);
  extern void deactivate_fd(int fd, int irqnum);
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 91587f8..3d7aad0 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -102,7 +102,7 @@ void sigio_handler(int sig, struct uml_pt_regs *regs)

  static DEFINE_SPINLOCK(irq_lock);

-int activate_fd(int irq, int fd, int type, void *dev_id)
+static int activate_fd(int irq, int fd, int type, void *dev_id)
  {
  	struct pollfd *tmp_pfd;
  	struct irq_fd *new_fd, *irq_fd;
@@ -216,7 +216,7 @@ static int same_irq_and_dev(struct irq_fd *irq, void *d)
  	return ((irq->irq == data->irq) && (irq->id == data->dev));
  }

-void free_irq_by_irq_and_dev(unsigned int irq, void *dev)
+static void free_irq_by_irq_and_dev(unsigned int irq, void *dev)
  {
  	struct irq_and_dev data = ((struct irq_and_dev) { .irq  = irq,
  							  .dev  = dev });
@@ -403,37 +403,6 @@ void __init init_IRQ(void)
  	}
  }

-int init_aio_irq(int irq, char *name, irq_handler_t handler)
-{
-	int fds[2], err;
-
-	err = os_pipe(fds, 1, 1);
-	if (err) {
-		printk(KERN_ERR "init_aio_irq - os_pipe failed, err = %d\n",
-		       -err);
-		goto out;
-	}
-
-	err = um_request_irq(irq, fds[0], IRQ_READ, handler,
-			     IRQF_DISABLED | IRQF_SAMPLE_RANDOM, name,
-			     (void *) (long) fds[0]);
-	if (err) {
-		printk(KERN_ERR "init_aio_irq - : um_request_irq failed, "
-		       "err = %d\n",
-		       err);
-		goto out_close;
-	}
-
-	err = fds[1];
-	goto out;
-
- out_close:
-	os_close_file(fds[0]);
-	os_close_file(fds[1]);
- out:
-	return err;
-}
-
  /*
   * IRQ stack entry and exit:
   *
-- 
1.5.2.4

