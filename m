Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbZDBT2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbZDBT2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760461AbZDBT23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:28:29 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:46717 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762192AbZDBT21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IgMwDM9RFQnHr2YY3KEISDO8SytOq0WKxq+Obh4tq5dvUZXGbS2BzMutoLWks2BV1C
         T70ocj1I8Ukhw7VwDGEeOrql1lYQrorighldcJCe1s3ubrv2dcujQ27eJrRd+64pfTA+
         tevIOZxGXgaomlo45wUqSkdN2cqQydSzyLYus=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 15:28:06 -0400
Message-ID: <671c20540904021228l2f719dd7y1dd9724d68e5c29b@mail.gmail.com>
Subject: BUG: sleeping while atomic from ipmr_destroy_unres
From: Tom Burns <tom.i.burns@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  I apologize for talking about a kernel bug against 2.6.20, but it's
in a production environment, I don't have the resources to replace the
kernel and reproduce the issue at this time, and from my code
comparison this issue appears to still exist in 2.6.29 (might_sleep()
still results in schedule() call if CONFIG_PREEMPT_VOLUNTARY=y,
__do_softirq still calls __local_bh_disable(), which still puts us in
atomic for the duration of the __do_softirq - which makes sense, and
the ipmr code is still the same).

  I'm debugging a kernel BUG reported in a production environment
running 2.6.20 SMP (from Redhat RPM, full version
2.6.20-1.2320.fc5smp) and have run into 2 related BUGs.  When we only
see the first it's non-fatal, but the second BUG (below) is always
paired with a panic and resultant crash.

Here is the first BUG that makes it to the log:

 BUG: sleeping function called from invalid context at kernel/mutex.c:86
 in_atomic():1, irqs_disabled():0
  [phys_startup_32+-1084201671/-1073741824] ipmr_expire_process+0x0/0x8e
  [phys_startup_32+-1084105458/-1073741824] mutex_lock+0x15/0x29
  [phys_startup_32+-1084464563/-1073741824] rtnetlink_rcv+0x17/0x3d
  [phys_startup_32+-1084407949/-1073741824] netlink_data_ready+0x12/0x52
  [phys_startup_32+-1084412015/-1073741824] netlink_sendskb+0x1c/0x33
  [phys_startup_32+-1084463665/-1073741824] rtnl_unicast+0x18/0x23
  [phys_startup_32+-1084201716/-1073741824] ipmr_destroy_unres+0xc7/0xf4
  [phys_startup_32+-1086087209/-1073741824] hrtimer_run_queues+0x127/0x141
  [phys_startup_32+-1085998565/-1073741824] enable_irq+0x92/0xaf
  [phys_startup_32+-1084161925/-1073741824] xfrm_timer_handler+0x18d/0x21a
  [phys_startup_32+-1084201576/-1073741824] ipmr_expire_process+0x5f/0x8e
  [phys_startup_32+-1086134877/-1073741824] run_timer_softirq+0x101/0x164
  [phys_startup_32+-1086148568/-1073741824] __do_softirq+0x5d/0xba
  [phys_startup_32+-1086299719/-1073741824] do_softirq+0x59/0xb1
  [phys_startup_32+-1086179650/-1073741824] scheduler_tick+0x7c/0xdc
  [phys_startup_32+-1085997014/-1073741824] handle_edge_irq+0x0/0x10a
  [phys_startup_32+-1086299433/-1073741824] do_IRQ+0xc6/0xdb
  [phys_startup_32+-1086306041/-1073741824] common_interrupt+0x23/0x28
  [phys_startup_32+-1084161997/-1073741824] xfrm_timer_handler+0x145/0x21a

It appears that the top ipmr_expire_process call is some sort of
reporting mistake in dump_stack(), I don't see how it's being executed
by mutex_lock().

I've determined that the problem is caused by a combination of config
flags and code path.

Our kernel config has:
CONFIG_PREEMPT_VOLUNTARY = y
CONFIG_PREEMPT_BKL = y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_PREEMPT is not set and neither is CONFIG_PREEMPT_NONE

With these flags, in_atomic() is always set to '1' during the entire
time doing the softirq.

The code path which causes the BUG is in net/ipv4/ipmr.c in function
ipmr_destroy_unres:

 307                if (skb->nh.iph->version == 0) {
 308                        struct nlmsghdr *nlh = (struct nlmsghdr
*)skb_pull(skb, sizeof(struct iphdr));
 309                        nlh->nlmsg_type = NLMSG_ERROR;
 310                        nlh->nlmsg_len =
NLMSG_LENGTH(sizeof(struct nlmsgerr));
 311                        skb_trim(skb, nlh->nlmsg_len);
 312                        e = NLMSG_DATA(nlh);
 313                        e->error = -ETIMEDOUT;
 314                        memset(&e->msg, 0, sizeof(e->msg));
 315
 316                        rtnl_unicast(skb, NETLINK_CB(skb).pid);
 317                } else
 318                        kfree_skb(skb);

So the BUG only occurs if we try to unicast out a netlink error packet
in response to the inability to resolve a netlink multicast packet
(iph->version == 0). When this happens we eventually call mutex_lock,
who calls might_sleep(), which with our kernel config results in
reporting the BUG in __might_sleep(), and then attempting to
schedule() (with CONFIG_PREEMPT_VOLUNTARY = y, might_sleep() resolves
to "__might_sleep(); schedule();" ).

I'm unsure if we're supposed to be in_atomic at this point because in
hrtimer_run_queue before running the timer function
(ipmr_expire_process) seems to try to re-enable kernel preemption
(__run_hrtimer calls spin_unlock calls _spin_unlock calls
preempt_enable(), which resolves to nothing since CONFIG_PREEMPT = n.

Unfortunately this otherwise harmless BUG seems to become fatal to the
system if there is a process waiting to be scheduled when mutex_lock
calls might_sleep().  When that's the case, we see the following BUG
immediately after the first one:

 BUG: scheduling while atomic: Parser/0x00000100/2465
  [phys_startup_32+-1084110266/-1073741824] __sched_text_start+0x56/0xa21
  [phys_startup_32+-1086166488/-1073741824] release_console_sem+0x17f/0x1be
  [<e0510524>] __nf_conntrack_confirm+0x2a6/0x2d9 [nf_conntrack]
  [phys_startup_32+-1086299433/-1073741824] do_IRQ+0xc6/0xdb
  [phys_startup_32+-1084105164/-1073741824] __mutex_lock_slowpath+0x45/0x77
  [phys_startup_32+-1084105441/-1073741824] mutex_lock+0x26/0x29
  [phys_startup_32+-1084464563/-1073741824] rtnetlink_rcv+0x17/0x3d
  [phys_startup_32+-1084407949/-1073741824] netlink_data_ready+0x12/0x52
  [phys_startup_32+-1084412015/-1073741824] netlink_sendskb+0x1c/0x33
  [phys_startup_32+-1084409373/-1073741824] netlink_ack+0x178/0x193
  [phys_startup_32+-1084409070/-1073741824] netlink_run_queue+0x7b/0xca
  [phys_startup_32+-1084464481/-1073741824] rtnetlink_rcv_msg+0x0/0x1e4
  [phys_startup_32+-1086302708/-1073741824] dump_stack+0x12/0x14
  [phys_startup_32+-1084201671/-1073741824] ipmr_expire_process+0x0/0x8e
  [phys_startup_32+-1084464549/-1073741824] rtnetlink_rcv+0x25/0x3d
  [phys_startup_32+-1084407949/-1073741824] netlink_data_ready+0x12/0x52
  [phys_startup_32+-1084412015/-1073741824] netlink_sendskb+0x1c/0x33
  [phys_startup_32+-1084463665/-1073741824] rtnl_unicast+0x18/0x23
  [phys_startup_32+-1084201716/-1073741824] ipmr_destroy_unres+0xc7/0xf4
  [phys_startup_32+-1086087209/-1073741824] hrtimer_run_queues+0x127/0x141
  [phys_startup_32+-1085998565/-1073741824] enable_irq+0x92/0xaf
  [phys_startup_32+-1084161925/-1073741824] xfrm_timer_handler+0x18d/0x21a
  [phys_startup_32+-1084201576/-1073741824] ipmr_expire_process+0x5f/0x8e
  [phys_startup_32+-1086134877/-1073741824] run_timer_softirq+0x101/0x164
  [phys_startup_32+-1086148568/-1073741824] __do_softirq+0x5d/0xba
  [phys_startup_32+-1086299719/-1073741824] do_softirq+0x59/0xb1
  [phys_startup_32+-1086179650/-1073741824] scheduler_tick+0x7c/0xdc
  [phys_startup_32+-1085997014/-1073741824] handle_edge_irq+0x0/0x10a
  [phys_startup_32+-1086299433/-1073741824] do_IRQ+0xc6/0xdb
  [phys_startup_32+-1086306041/-1073741824] common_interrupt+0x23/0x28
  [phys_startup_32+-1084161997/-1073741824] xfrm_timer_handler+0x145/0x21a
  =======================

At this point the computer has effectively crashed.

I'm a complete newcomer to netlink packets, so while I'm going to try
to send some unresolvable netlink packets with hope to make this BUG
easily reproduce able, if anyone has any other ideas I'd love to hear
them.

Thank you,
Tom Burns
