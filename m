Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYGENXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYGENXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYGENW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:22:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:60873 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYGENWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WQNy2g7fSCLG6Gf1em1w8A9OQ+4QnIPlSAZ31KkVyfHD1m+hrPHGtgZht9i4C+CvGO
         t+BxYosRhcOUceGcpxCz2OFvhyRVI/9QP5Ly6QRk1XxqWIC9/WGV1ChNU+TYIYg70hJl
         +o/KghMcOtC1J0w6Hl34+qeoD7X1O6r0JDWjY=
Date: Sat, 5 Jul 2008 15:21:06 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080705131924.GA2083@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppdev (which provides support for user-space parallel port device drivers)
is slightly different from other parallel port drivers. It allows to open
the device by more than one process, but locks the device on ioctl (PPCLAIM).
Unfortunately registration of sysctl entries were done before locking
the device, so 2 processes could open it and try to register sysctl
(it ignored error on registration, so it didn't block access to port).

So move registration of sysctl after locking (parport_claim_or_block).

Warning:
ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice
Sysctl already exists
Pid: 14491, comm: hpijs Not tainted 2.6.24-rc5 #1

Call Trace:
 [<ffffffff8024c0b0>] set_fail+0x3f/0x47
 [<ffffffff8024c566>] sysctl_check_table+0x4ae/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8024c062>] sysctl_check_lookup+0xc1/0xd0
 [<ffffffff8024c57c>] sysctl_check_table+0x4c4/0x4fb
 [<ffffffff8023ca15>] register_sysctl_table+0x52/0x9d
 [<ffffffff881d97cb>] :parport:parport_device_proc_register+0xc3/0xe3
 [<ffffffff881d7da7>] :parport:parport_register_device+0x206/0x267
 [<ffffffff884171ae>] :ppdev:pp_irq+0x0/0x40
 [<ffffffff8841774f>] :ppdev:pp_ioctl+0x13f/0x77c
 [<ffffffff80296a11>] do_ioctl+0x55/0x6b
 [<ffffffff80296c6a>] vfs_ioctl+0x243/0x25c
 [<ffffffff80296cd4>] sys_ioctl+0x51/0x71
 [<ffffffff8020beee>] system_call+0x7e/0x83

http://lkml.org/lkml/2007/12/16/121
http://kerneloops.org/guilty.php?guilty=parport_device_proc_register&version=2.6.25-release&start=1671168&end=1703935&class=warn
https://bugzilla.redhat.com/show_bug.cgi?id=449112

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
Frans: Could you test it on real hardware?
---
 drivers/char/ppdev.c     |    4 +++-
 drivers/parport/procfs.c |    1 +
 drivers/parport/share.c  |    6 ++++--
 include/linux/parport.h  |    1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 3aab837..e60111a 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -302,7 +302,8 @@ static int register_device (int minor, struct pp_struct *pp)
 
 	fl = (pp->flags & PP_EXCL) ? PARPORT_FLAG_EXCL : 0;
 	pdev = parport_register_device (port, name, NULL,
-					NULL, pp_irq, fl, pp);
+					NULL, pp_irq,
+					fl | PARPORT_DONT_REG_PROC, pp);
 	parport_put_port (port);
 
 	if (!pdev) {
@@ -359,6 +360,7 @@ static int pp_ioctl(struct inode *inode, struct file *file,
 		ret = parport_claim_or_block (pp->pdev);
 		if (ret < 0)
 			return ret;
+		parport_device_proc_register(pp->pdev);
 
 		pp->flags |= PP_CLAIMED;
 
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index d950fc3..5a6ac1d 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -554,6 +554,7 @@ int parport_device_proc_register(struct pardevice *device)
 	device->sysctl_table = t;
 	return 0;
 }
+EXPORT_SYMBOL(parport_device_proc_register);
 
 int parport_device_proc_unregister(struct pardevice *device)
 {
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index a8a62bb..3a777be 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -572,7 +572,7 @@ parport_register_device(struct parport *port, const char *name,
 	tmp->preempt = pf;
 	tmp->wakeup = kf;
 	tmp->private = handle;
-	tmp->flags = flags;
+	tmp->flags = flags & ~PARPORT_DONT_REG_PROC;
 	tmp->irq_func = irq_func;
 	tmp->waiting = 0;
 	tmp->timeout = 5 * HZ;
@@ -614,7 +614,9 @@ parport_register_device(struct parport *port, const char *name,
 	 * pardevice fields. -arca
 	 */
 	port->ops->init_state(tmp, tmp->state);
-	parport_device_proc_register(tmp);
+	if (!(flags & PARPORT_DONT_REG_PROC))
+		parport_device_proc_register(tmp);
+
 	return tmp;
 
  out_free_all:
diff --git a/include/linux/parport.h b/include/linux/parport.h
index dcb9e01..f871031 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -463,6 +463,7 @@ static __inline__ int parport_yield_blocking(struct pardevice *dev)
 #define PARPORT_DEV_EXCL		(1<<1)	/* Need exclusive access. */
 
 #define PARPORT_FLAG_EXCL		(1<<1)	/* EXCL driver registered. */
+#define PARPORT_DONT_REG_PROC		(1<<2)
 
 /* IEEE1284 functions */
 extern void parport_ieee1284_interrupt (void *);
-- 
1.5.4.5

