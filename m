Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbXIQPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbXIQPXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXIQPXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:23:03 -0400
Received: from mail.ccur.com ([66.10.65.12]:7675 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXIQPXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:23:00 -0400
Message-ID: <46EE9BCC.1040301@ccur.com>
Date: Mon, 17 Sep 2007 11:22:52 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Subject: [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and ib_umad_close() issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2007 15:23:36.0381 (UTC) FILETIME=[B769EED0:01C7F93E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When using OFED-1.2.5 based infiniband kernel modules on 2.6.22 based
kernels with the Ingo Molnar CONFIG_PREEMPT_RT applied, then commands 
such as ibnetdiscvoer, smpquery, sminfo, etc. will hang.  The problem is 
with the downgrade_write() rw semaphore usage in the ib_umad_close() 
routine.

This patch is a temporary work-around that gets around this
issue by changing the ib_umad_port mutex from a rw_semaphore to a
compat_rw_semaphore.

This is admittedly only a temporary solution.

An example of the BUG console message output and work around
patch are shown below.


bowser> ------------[ cut here ]------------
kernel BUG at kernel/rt.c:352!
invalid opcode: 0000 [#1]
PREEMPT SMP
last sysfs file: /class/infiniband_mad/umad0/port
Modules linked in: rdma_ucm(F) rds(F) ib_ucm(F) ib_srp(F) ib_sdp(F) 
rdma_cm(F) iw_cm(F) ib_addr(F) ib_ipoib(F) ib_cm(F) ib_sa(F) 
ib_uverbs(F) ib_umad(F) ib_mthca(F) ib_mad(F) ib_core(F)
CPU:    1
EIP:    0060:[<c014d160>]    Tainted: GF     N VLI
EFLAGS: 00210282   (2.6.22.6-rt_shield_trace #1)
EIP is at rt_downgrade_write+0x0/0x10
eax: f705df7c   ebx: 00000008   ecx: f7171014   edx: f705df9c
esi: f7170ffc   edi: f7171000   ebp: f7171004   esp: f5fcdef0
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068  preempt:00000001
Process ibnetdiscover (pid: 10842, ti=f5fcc000 task=f6cd00f0 
task.ti=f5fcc000)
Stack: f883a4a8 f705df40 00000000 00000008 f6ca1680 f63adf20 f734e7dc 
c018c240
        00000000 00000000 f734e7dc c2d442c0 f63adf20 f6ca1680 f71d06c0 
00000000
        00000001 c018a2ec 00000000 00000001 00000003 f44af440 c012bd20 
f71d06c0
Call Trace:
  [<f883a4a8>] ib_umad_close+0x98/0xf0 [ib_umad]
  [<c018c240>] __fput+0x170/0x1a0
  [<c018a2ec>] filp_close+0x3c/0x80
  [<c012bd20>] close_files+0x50/0x60
  [<c012bd98>] put_files_struct+0x28/0x80
  [<c012c996>] do_exit+0x1c6/0x570
  [<c018b1ca>] sys_write+0x6a/0xf0
  [<c012cd96>] do_group_exit+0x26/0x70
  [<c01054ff>] sysenter_past_esp+0x68/0x99
  =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c06653b9>] .... __spin_lock_irqsave+0x19/0x50
.....[<00000000>] ..   ( <= 0x0)

Code: 5b e9 45 7a 51 00 90 8d 74 26 00 8b 53 1c 85 d2 74 e3 89 d8 89 ca 
e8 c0 84 51 00 ff 4b 1c 5b c3 8d 74 26 00 8d bc 27 00 00 00 00 <0f> 0b 
eb fe 8d b6 00 00 00 00 8d bf 00 00 00 00 e8 db 79 51 00
EIP: [<c014d160>] rt_downgrade_write+0x0/0x10 SS:ESP 0068:f5fcdef0
BUG: sleeping function called from invalid context ibnetdiscover(10842) 
at kernel/rtmutex.c:636
in_atomic():1 [00000001], irqs_disabled():1
  [<c0126661>] __might_sleep+0xe1/0x100
  [<c036850b>] set_palette+0x2b/0x60
  [<c0664f66>] __rt_spin_lock+0x36/0x50
  [<c01241be>] __wake_up+0x1e/0x70
  [<c012a44b>] wake_up_klogd+0x3b/0x40
  [<c0106f76>] die+0x166/0x240
  [<c0665c31>] do_trap+0x1b1/0x260
  [<c01388a7>] raw_notifier_call_chain+0x17/0x20
  [<c0144040>] notify_die+0x30/0x40
  [<c01071e0>] do_invalid_op+0x0/0x90
  [<c0107263>] do_invalid_op+0x83/0x90
  [<c014d160>] rt_downgrade_write+0x0/0x10
  [<c01575c2>] add_preempt_count+0x12/0xe0
  [<c01575c2>] add_preempt_count+0x12/0xe0
  [<c0664f66>] __rt_spin_lock+0x36/0x50
  [<c030e345>] lock_list_del_init+0x55/0x80
  [<c018c66d>] file_kill+0x18d/0x1a0
  [<c06658c2>] error_code+0x72/0x80
  [<c015007b>] load_module+0x33b/0xe10
  [<c014d160>] rt_downgrade_write+0x0/0x10
  [<f883a4a8>] ib_umad_close+0x98/0xf0 [ib_umad]
  [<c018c240>] __fput+0x170/0x1a0
  [<c018a2ec>] filp_close+0x3c/0x80
  [<c012bd20>] close_files+0x50/0x60
  [<c012bd98>] put_files_struct+0x28/0x80
  [<c012c996>] do_exit+0x1c6/0x570
  [<c018b1ca>] sys_write+0x6a/0xf0
  [<c012cd96>] do_group_exit+0x26/0x70
  [<c01054ff>] sysenter_past_esp+0x68/0x99
  =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c06653b9>] .... __spin_lock_irqsave+0x19/0x50
.....[<00000000>] ..   ( <= 0x0)

Fixing recursive fault but reboot is needed!




--- linux-2.6.22/drivers/infiniband/core/user_mad.c	2007-09-17 
09:48:45.000000000 -0400
+++ new/drivers/infiniband/core/user_mad.c	2007-09-17 09:50:41.000000000 
-0400
@@ -93,7 +93,7 @@ struct ib_umad_port {
  	struct class_device   *sm_class_dev;
  	struct semaphore       sm_sem;

-	struct rw_semaphore    mutex;
+	struct compat_rw_semaphore    mutex;
  	struct list_head       file_list;

  	struct ib_device      *ib_dev;
@@ -159,7 +159,7 @@ static int queue_packet(struct ib_umad_f
  {
  	int ret = 1;

-	down_read(&file->port->mutex);
+	compat_down_read(&file->port->mutex);

  	for (packet->mad.hdr.id = 0;
  	     packet->mad.hdr.id < IB_UMAD_MAX_AGENTS;
@@ -173,7 +173,7 @@ static int queue_packet(struct ib_umad_f
  			break;
  		}

-	up_read(&file->port->mutex);
+	compat_up_read(&file->port->mutex);

  	return ret;
  }
@@ -461,7 +461,7 @@ static ssize_t ib_umad_write(struct file
  		goto err;
  	}

-	down_read(&file->port->mutex);
+	compat_down_read(&file->port->mutex);

  	agent = __get_agent(file, packet->mad.hdr.id);
  	if (!agent) {
@@ -558,7 +558,7 @@ static ssize_t ib_umad_write(struct file
  	if (ret)
  		goto err_send;

-	up_read(&file->port->mutex);
+	compat_up_read(&file->port->mutex);
  	return count;

  err_send:
@@ -568,7 +568,7 @@ err_msg:
  err_ah:
  	ib_destroy_ah(ah);
  err_up:
-	up_read(&file->port->mutex);
+	compat_up_read(&file->port->mutex);
  err:
  	kfree(packet);
  	return ret;
@@ -597,7 +597,7 @@ static int ib_umad_reg_agent(struct ib_u
  	int agent_id;
  	int ret;

-	down_write(&file->port->mutex);
+	compat_down_write(&file->port->mutex);

  	if (!file->port->ib_dev) {
  		ret = -EPIPE;
@@ -650,7 +650,7 @@ found:
  	ret = 0;

  out:
-	up_write(&file->port->mutex);
+	compat_up_write(&file->port->mutex);
  	return ret;
  }

@@ -663,7 +663,7 @@ static int ib_umad_unreg_agent(struct ib
  	if (get_user(id, (u32 __user *) arg))
  		return -EFAULT;

-	down_write(&file->port->mutex);
+	compat_down_write(&file->port->mutex);

  	if (id < 0 || id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
  		ret = -EINVAL;
@@ -674,7 +674,7 @@ static int ib_umad_unreg_agent(struct ib
  	file->agent[id] = NULL;

  out:
-	up_write(&file->port->mutex);
+	compat_up_write(&file->port->mutex);

  	if (agent)
  		ib_unregister_mad_agent(agent);
@@ -710,7 +710,7 @@ static int ib_umad_open(struct inode *in
  	if (!port)
  		return -ENXIO;

-	down_write(&port->mutex);
+	compat_down_write(&port->mutex);

  	if (!port->ib_dev) {
  		ret = -ENXIO;
@@ -736,7 +736,7 @@ static int ib_umad_open(struct inode *in
  	list_add_tail(&file->port_list, &port->file_list);

  out:
-	up_write(&port->mutex);
+	compat_up_write(&port->mutex);
  	return ret;
  }

@@ -748,7 +748,7 @@ static int ib_umad_close(struct inode *i
  	int already_dead;
  	int i;

-	down_write(&file->port->mutex);
+	compat_down_write(&file->port->mutex);

  	already_dead = file->agents_dead;
  	file->agents_dead = 1;
@@ -761,14 +761,14 @@ static int ib_umad_close(struct inode *i

  	list_del(&file->port_list);

-	downgrade_write(&file->port->mutex);
+	compat_downgrade_write(&file->port->mutex);

  	if (!already_dead)
  		for (i = 0; i < IB_UMAD_MAX_AGENTS; ++i)
  			if (file->agent[i])
  				ib_unregister_mad_agent(file->agent[i]);

-	up_read(&file->port->mutex);
+	compat_up_read(&file->port->mutex);

  	kfree(file);
  	kref_put(&dev->ref, ib_umad_release_dev);
@@ -839,10 +839,10 @@ static int ib_umad_sm_close(struct inode
  	};
  	int ret = 0;

-	down_write(&port->mutex);
+	compat_down_write(&port->mutex);
  	if (port->ib_dev)
  		ret = ib_modify_port(port->ib_dev, port->port_num, 0, &props);
-	up_write(&port->mutex);
+	compat_up_write(&port->mutex);

  	up(&port->sm_sem);

@@ -906,7 +906,7 @@ static int ib_umad_init_port(struct ib_d
  	port->ib_dev   = device;
  	port->port_num = port_num;
  	init_MUTEX(&port->sm_sem);
-	init_rwsem(&port->mutex);
+	compat_init_rwsem(&port->mutex);
  	INIT_LIST_HEAD(&port->file_list);

  	port->dev = cdev_alloc();
@@ -992,7 +992,7 @@ static void ib_umad_kill_port(struct ib_
  	umad_port[port->dev_num] = NULL;
  	spin_unlock(&port_lock);

-	down_write(&port->mutex);
+	compat_down_write(&port->mutex);

  	port->ib_dev = NULL;

@@ -1017,17 +1017,17 @@ static void ib_umad_kill_port(struct ib_
  		file->agents_dead = 1;
  		list_del_init(&file->port_list);

-		downgrade_write(&port->mutex);
+		compat_downgrade_write(&port->mutex);

  		for (id = 0; id < IB_UMAD_MAX_AGENTS; ++id)
  			if (file->agent[id])
  				ib_unregister_mad_agent(file->agent[id]);

-		up_read(&port->mutex);
-		down_write(&port->mutex);
+		compat_up_read(&port->mutex);
+		compat_down_write(&port->mutex);
  	}

-	up_write(&port->mutex);
+	compat_up_write(&port->mutex);

  	clear_bit(port->dev_num, dev_map);
  }
