Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbYCEThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbYCEThK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbYCETg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:36:57 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41131 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYCETg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:36:56 -0500
Subject: [BUG?]  2.6.25-rc[23]-mm1 cgroup list corruption under load with
	VM Scalability patches
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 05 Mar 2008 14:37:08 -0500
Message-Id: <1204745828.6244.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_del corruption in cgroup_exit() on 16 cpu, 32GB ia64 NUMA platform.

I've been seeing this for a while now, but we've had known problems
[page leaks, ...] with the VM scalability series.  Now the system
appears to be running very well with these patches under stress loads
that would hang it or cause OOM kill of tests with plenty of swap space
left.  Eventually, [after 40-45 minutes], I hit a list corruption in
cgroup_exit().  

I can't say for sure that our patches aren't causing this, but I've been
unable to keep the system up long enough under the stress load w/o the
splitlru+noreclaim patches to hit the problem.

I looked in the mailing lists and found one other thread related to
cgroup list corruption:

	http://marc.info/?l=linux-kernel&m=119263666823236&w=4

Paul looked into this and couldn't see anywhere that the lists are
manipulate w/o holding the css set lock.  I concur.  I did find one
possible race in enabling the task cg_lists [see patch below], but this
did not solve the problem.  And I did not hit the printk in the patch.

Here's the stack trace:

On 25-rc2-mm1 + VM Scalability patches [splitlru + noreclaim] under heavy
stress load, after ~45 minutes:

list_del corruption. next->prev should be e000072051f08c40, but was 0000000000000000
kernel BUG at lib/list_debug.c:72!
as[16438]: bugcheck! 0 [1]
Modules linked in: ipv6 sunrpc dm_mirror dm_multipath dm_mod fan dock sg thermal sr_mod container processor button ehci_hcd ohci_hcd uhci_hcd usbcore

Pid: 16438, CPU 0, comm:                   as
psr : 0000101008526030 ifs : 8000000000000207 ip  : [<a0000001002fdd70>]    Not tainted (2.6.25-rc2-mm1+splitlru+noreclaim)
ip is at list_del+0x170/0x180
unat: 0000000000000000 pfs : 0000000000000207 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000100000 pr  : a5656555555a1555
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001002fdd70 b6  : a000000100447660 b7  : a000000100302300
f6  : 1003e0000044349a2b2c1 f7  : 1003e00000000000005dc
f8  : 1003e0000044349a2ace5 f9  : 1003e0000000000000001
f10 : 1003ee198ddde18870e3a f11 : 1003e00000000000000b5
r1  : a000000100ba1e50 r2  : a0000001009bb498 r3  : a00000010094ee58
r8  : 0000000000000026 r9  : 000000000000ffff r10 : ffffffffffffff82
r11 : 000000000000a36c r12 : e000072051f0fe20 r13 : e000072051f08000
r14 : 0000000000000000 r15 : a00000010094ee58 r16 : a000000100955018
r17 : a0000001009bb4a0 r18 : a000000100447660 r19 : a0000001009f9b78
r20 : 000000000000a3c7 r21 : 00000000000fffff r22 : 0000000000100000
r23 : 0000000000000000 r24 : 0000000000100000 r25 : 0000000000000034
r26 : 0000000000000034 r27 : 0000001008522030 r28 : 000000000000000d
r29 : c0000f0000018000 r30 : 0000000000000000 r31 : a0000001009bb454

Call Trace:
 [<a000000100014080>] show_stack+0x80/0xa0
                                sp=e000072051f0f9f0 bsp=e000072051f08fe8
 [<a000000100014980>] show_regs+0x880/0x8c0
                                sp=e000072051f0fbc0 bsp=e000072051f08f90
 [<a00000010003a0c0>] die+0x1a0/0x300
                                sp=e000072051f0fbc0 bsp=e000072051f08f48
 [<a00000010003a270>] die_if_kernel+0x50/0x80
                                sp=e000072051f0fbc0 bsp=e000072051f08f18
 [<a0000001006ac7f0>] ia64_bad_break+0x4b0/0x700
                                sp=e000072051f0fbc0 bsp=e000072051f08ef0
 [<a00000010000a780>] ia64_leave_kernel+0x0/0x270
                                sp=e000072051f0fc50 bsp=e000072051f08ef0
 [<a0000001002fdd70>] list_del+0x170/0x180
                                sp=e000072051f0fe20 bsp=e000072051f08eb8
 [<a0000001000e8fb0>] cgroup_exit+0x130/0x2c0
                                sp=e000072051f0fe20 bsp=e000072051f08e88
 [<a0000001000939d0>] do_exit+0x750/0x1480
                                sp=e000072051f0fe20 bsp=e000072051f08e28
 [<a000000100094780>] do_group_exit+0x80/0x220
                                sp=e000072051f0fe30 bsp=e000072051f08de0
 [<a000000100094940>] sys_exit_group+0x20/0x40
                                sp=e000072051f0fe30 bsp=e000072051f08d88
 [<a00000010000a600>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000072051f0fe30 bsp=e000072051f08d88
 [<a000000000010720>] __start_ivt_text+0xffffffff00010720/0x400
                                sp=e000072051f10000 bsp=e000072051f08d88
Kernel panic - not syncing: Fatal exception

On 25-rc3-mm1 w/ VM Scalability patches, similar bug, same stack trace 
after ~42 minutes with corrution:

list_del corruption. next->prev should be e00007604f950c30, but was e00007207f4e8c30

----------------
Here's a patch to a potential race in group initialization.  Didn't help
but maybe still needed?


PATCH close potential race in cgroup_enable_task_cg_lists()

Found this while investigating a list corruption in cgroup_exit().

It appears that two tasks could race in cgroup_iter_start(),
each seeing that use_task_css_set_links is 0 and calling
cgroup_enable_task_cg_lists() ~simultaneously.
Don't know that this is happening, but should probably retest
use_task_css_set_links under css_set_lock.

Is this patch needed?

Note:  the printk is just there to tell me if I hit this scenario.
I didn't, and still get list corruption in cgroup_exit().

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 kernel/cgroup.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.25-rc3-mm1/kernel/cgroup.c
===================================================================
--- linux-2.6.25-rc3-mm1.orig/kernel/cgroup.c	2008-03-05 12:07:32.000000000 -0500
+++ linux-2.6.25-rc3-mm1/kernel/cgroup.c	2008-03-05 12:07:37.000000000 -0500
@@ -1747,6 +1747,12 @@ static void cgroup_enable_task_cg_lists(
 {
 	struct task_struct *p, *g;
 	write_lock(&css_set_lock);
+	if (use_task_css_set_links)
+{
+printk("%s:  RACY!!!\n", __FUNCTION__);
+		goto unlock;
+}
+
 	use_task_css_set_links = 1;
 	do_each_thread(g, p) {
 		task_lock(p);
@@ -1754,6 +1760,8 @@ static void cgroup_enable_task_cg_lists(
 			list_add(&p->cg_list, &p->cgroups->tasks);
 		task_unlock(p);
 	} while_each_thread(g, p);
+
+unlock:
 	write_unlock(&css_set_lock);
 }
 



