Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZDSWIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZDSWIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZDSWH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:07:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:61246 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZDSWH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ew3kEC2fkeSeR15XdGssfB3Aag+4jQBizZ57WZnpu6UGoawJKHXqaexGD/sRAEl/7b
         UB3bngBYRg8RybD1G23eNYXowNpZWmeR0OdHvc9i+MvEV8dpDQdeFP0KH5UyACEgB6vO
         R7sojKuC3nkuGbzimpY8h0rO7XQLeSFA1OUWw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing/ring-buffer: unlock recursion protection on discard
Date: Mon, 20 Apr 2009 00:07:48 +0200
Message-Id: <1240178868-18218-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
References: <1240178868-18218-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pair of helpers trace_recursive_lock() trace_recursive_unlock()
have been introduced recently to provide a generic tracing recursion
protection.

They are used in a symetric way:

-trace_recursive_lock() on buffer reserve
-trace_recursive_unlock() on buffer commit

However sometimes, we don't commit but discard en entry
to the buffer, ie: in case of filter checking.
Then we must also unlock the recursion protection on
discard time, otherwise the tracing gets definetly deactivated
and a warning is raised spuriously, such as:

111.119821] ------------[ cut here ]------------
[  111.119829] WARNING: at kernel/trace/ring_buffer.c:1498 ring_buffer_lock_reserve+0x1b7/0x1d0()
[  111.119835] Hardware name: AMILO Li 2727
[  111.119839] Modules linked in:
[  111.119846] Pid: 5731, comm: Xorg Tainted: G        W  2.6.30-rc1 #69
[  111.119851] Call Trace:
[  111.119863]  [<ffffffff8025ce68>] warn_slowpath+0xd8/0x130
[  111.119873]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
[  111.119882]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
[  111.119891]  [<ffffffff802199b0>] ? native_sched_clock+0x20/0x70
[  111.119899]  [<ffffffff80286dee>] ? put_lock_stats+0xe/0x30
[  111.119906]  [<ffffffff80286eb8>] ? lock_release_holdtime+0xa8/0x150
[  111.119913]  [<ffffffff802c8ae7>] ring_buffer_lock_reserve+0x1b7/0x1d0
[  111.119921]  [<ffffffff802cd110>] trace_buffer_lock_reserve+0x30/0x70
[  111.119930]  [<ffffffff802ce000>] trace_current_buffer_lock_reserve+0x20/0x30
[  111.119939]  [<ffffffff802474e8>] ftrace_raw_event_sched_switch+0x58/0x100
[  111.119948]  [<ffffffff808103b7>] __schedule+0x3a7/0x4cd
[  111.119957]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.119964]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.119971]  [<ffffffff80810c08>] schedule+0x18/0x40
[  111.119977]  [<ffffffff80810e09>] preempt_schedule+0x39/0x60
[  111.119985]  [<ffffffff80813bd3>] _read_unlock+0x53/0x60
[  111.119993]  [<ffffffff807259d2>] sock_def_readable+0x72/0x80
[  111.120002]  [<ffffffff807ad5ed>] unix_stream_sendmsg+0x24d/0x3d0
[  111.120011]  [<ffffffff807219a3>] sock_aio_write+0x143/0x160
[  111.120019]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120026]  [<ffffffff80721860>] ? sock_aio_write+0x0/0x160
[  111.120033]  [<ffffffff80721860>] ? sock_aio_write+0x0/0x160
[  111.120042]  [<ffffffff8031c283>] do_sync_readv_writev+0xf3/0x140
[  111.120049]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120057]  [<ffffffff80276ff0>] ? autoremove_wake_function+0x0/0x40
[  111.120067]  [<ffffffff8045d489>] ? cap_file_permission+0x9/0x10
[  111.120074]  [<ffffffff8045c1e6>] ? security_file_permission+0x16/0x20
[  111.120082]  [<ffffffff8031cab4>] do_readv_writev+0xd4/0x1f0
[  111.120089]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120097]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120105]  [<ffffffff8031cc18>] vfs_writev+0x48/0x70
[  111.120111]  [<ffffffff8031cd65>] sys_writev+0x55/0xc0
[  111.120119]  [<ffffffff80211e32>] system_call_fastpath+0x16/0x1b
[  111.120125] ---[ end trace 15605f4e98d5ccb5 ]---

[ Impact: fix spurious warning/tracing shutdown ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ring_buffer.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bffde63..e145969 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1642,6 +1642,14 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
+static inline void rb_event_discard(struct ring_buffer_event *event)
+{
+	event->type = RINGBUF_TYPE_PADDING;
+	/* time delta must be non zero */
+	if (!event->time_delta)
+		event->time_delta = 1;
+}
+
 /**
  * ring_buffer_event_discard - discard any event in the ring buffer
  * @event: the event to discard
@@ -1656,10 +1664,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
  */
 void ring_buffer_event_discard(struct ring_buffer_event *event)
 {
-	event->type = RINGBUF_TYPE_PADDING;
-	/* time delta must be non zero */
-	if (!event->time_delta)
-		event->time_delta = 1;
+	rb_event_discard(event);
+	trace_recursive_unlock();
 }
 EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
 
@@ -1690,7 +1696,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	int cpu;
 
 	/* The event is discarded regardless */
-	ring_buffer_event_discard(event);
+	rb_event_discard(event);
 
 	/*
 	 * This must only be called if the event has not been
@@ -1735,6 +1741,8 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	if (rb_is_commit(cpu_buffer, event))
 		rb_set_commit_to_write(cpu_buffer);
 
+	trace_recursive_unlock();
+
 	/*
 	 * Only the last preempt count needs to restore preemption.
 	 */
-- 
1.6.2.3

