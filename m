Return-Path: <linux-kernel-owner+w=401wt.eu-S1765696AbXH0WIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765696AbXH0WIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764855AbXH0WHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:07:49 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:56673 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764742AbXH0WHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:07:47 -0400
Date: Mon, 27 Aug 2007 18:07:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix kobject uevent string handling errors (updated)
Message-ID: <20070827220745.GA15290@Krystal>
References: <200708272155.l7RLt4jo030477@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200708272155.l7RLt4jo030477@imap1.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:03:33 up 28 days, 22:22,  6 users,  load average: 0.17, 0.78, 1.50
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I thought you were going to use Kay Sievers's patch, which adds error
value checking to much of the add_event_var callers, so I did not bother
sending the updated version of my patch. Here it is, with the changelog.

---

Fix kobject uevent string handling errors

- increment env->buflen in dmi-id.c
- fix off-by-one in add_uevent_var in error checking of vsnprintf
- add warnings when add_uevent_var. Proper handling of its return values should
  really be done by the callers, but they aren't, so things currently
  fail silently. This is why I add warnings.

Fixes the following BUG in 2.6.23-rc3-mm1:

[   23.876358] skb_over_panic: text:c0252e5b len:97 put:11 head:c2b54400 data:c2b54400 tail:0xc2b54461 end:0xc2b54460 dev:<NULL>
[   23.910278] ------------[ cut here ]------------
[   23.924080] Kernel BUG at c039e12c [verbose debug info unavailable]
[   23.942809] invalid opcode: 0000 [#1] PREEMPT SMP
[   23.957213] last sysfs file: /devices/pci0000:00/0000:00:1f.1/ide0/0.0/media
[   23.978275] Modules linked in:
[   23.987429]
[   23.991884] Pid: 1038, comm: udevtrigger Not tainted (2.6.23-rc3-mm1-testssmp #286)
[   24.014773] EIP: 0060:[<c039e12c>] EFLAGS: 00010286 CPU: 0
[   24.031168] EIP is at skb_over_panic+0x5c/0x60
[   24.044444] EAX: 00000084 EBX: c2b54400 ECX: 00000001 EDX: 00000000
[   24.063171] ESI: 00000000 EDI: c2b54456 EBP: c2b67eb4 ESP: c2b67e88
[   24.081895]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   24.098027] Process udevtrigger (pid: 1038, ti=c2b66000 task=c2b08030 task.ti=c2b66000)
[   24.121423] Stack: c050110c c0252e5b 00000061 0000000b c2b54400 c2b54400 c2b54461 c2b54460
[   24.146658]        c04d21e0 c2ad8e80 00000005 c2b67efc c0252e60 c2b54400 c04d2183 c04ce0e4
[   24.171897]        c2f60c40 00000000 c04ce0e4 c2f60c40 c04e2ecb c05401e0 c2f58000 c2b67f04
[   24.197135] Call Trace:
[   24.205001]  [<c010971a>] show_trace_log_lvl+0x1a/0x30
[   24.220388]  [<c01097d8>] show_stack_log_lvl+0xa8/0xe0
[   24.235772]  [<c01098da>] show_registers+0xca/0x250
[   24.250378]  [<c0109b75>] die+0x115/0x280
[   24.262389]  [<c04187d1>] do_trap+0x91/0xc0
[   24.274919]  [<c0109fc9>] do_invalid_op+0x89/0xa0
[   24.289004]  [<c041858a>] error_code+0x72/0x78
[   24.302313]  [<c0252e60>] kobject_uevent_env+0x370/0x390
[   24.318217]  [<c0252e8a>] kobject_uevent+0xa/0x10
[   24.332303]  [<c02c524b>] store_uevent+0x2b/0x70
[   24.346130]  [<c02c4f6f>] dev_attr_store+0x2f/0x40
[   24.360476]  [<c01cd080>] sysfs_write_file+0xa0/0x100
[   24.375602]  [<c018cb89>] vfs_write+0x99/0x130
[   24.388910]  [<c018d26d>] sys_write+0x3d/0x70
[   24.401958]  [<c0108596>] syscall_call+0x7/0xb
[   24.415265]  =======================
[   24.425947] INFO: lockdep is turned off.
[   24.437665] Code: 00 00 89 5c 24 14 8b 98 8c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 0c 11 50 c0 89 44 24 08 e8 84 20 d9 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec 0c 8b 40 50 39
[   24.496006] EIP: [<c039e12c>] skb_over_panic+0x5c/0x60 SS:ESP 0068:c2b67e88

Changelog:
- Use KERN_ERR for printks
- in dmi-id.c, env->buflen += len should be used instead of env->buflen
  += len + 1. This is because the originally present \0 is overwritten
  by the new data and should therefore be counted out.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Reviewed-by: Greg KH <greg@kroah.com>
Reviewed-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/firmware/dmi-id.c |    5 +++--
 lib/kobject_uevent.c      |   12 ++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/lib/kobject_uevent.c
===================================================================
--- linux-2.6-lttng.orig/lib/kobject_uevent.c	2007-08-25 09:25:26.000000000 -0400
+++ linux-2.6-lttng/lib/kobject_uevent.c	2007-08-27 18:02:11.000000000 -0400
@@ -247,8 +247,12 @@ int add_uevent_var(struct kobj_uevent_en
 	va_list args;
 	int len;
 
-	if (env->envp_idx >= ARRAY_SIZE(env->envp))
+	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
+		printk(KERN_ERR "add_uevent_var: too small array size %u %u\n",
+			env->envp_idx, ARRAY_SIZE(env->envp));
+		WARN_ON(1);
 		return -ENOMEM;
+	}
 
 	va_start(args, format);
 	len = vsnprintf(&env->buf[env->buflen],
@@ -256,8 +260,12 @@ int add_uevent_var(struct kobj_uevent_en
 			format, args);
 	va_end(args);
 
-	if (len + 1 >= (sizeof(env->buf) - env->buflen))
+	if (len >= (sizeof(env->buf) - env->buflen)) {
+		printk(KERN_ERR "add_uevent_var: failed vsnprintf %d %u\n",
+			len, (sizeof(env->buf) - env->buflen));
+		WARN_ON(1);
 		return -ENOMEM;
+	}
 
 	env->envp[env->envp_idx++] = &env->buf[env->buflen];
 	env->buflen += len + 1;
Index: linux-2.6-lttng/drivers/firmware/dmi-id.c
===================================================================
--- linux-2.6-lttng.orig/drivers/firmware/dmi-id.c	2007-08-25 09:25:26.000000000 -0400
+++ linux-2.6-lttng/drivers/firmware/dmi-id.c	2007-08-25 14:41:16.000000000 -0400
@@ -152,9 +152,10 @@ static int dmi_dev_uevent(struct device 
 	if (add_uevent_var(env, "MODALIAS="))
 		return -ENOMEM;
 	len = get_modalias(&env->buf[env->buflen - 1],
-			   sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen))
+			   sizeof(env->buf) - (env->buflen - 1));
+	if (len >= (sizeof(env->buf) - (env->buflen - 1)))
 		return -ENOMEM;
+	env->buflen += len;
 	return 0;
 }
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
