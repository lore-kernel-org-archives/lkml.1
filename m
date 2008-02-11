Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYBKLdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYBKLdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYBKLdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:33:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27221 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYBKLdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:33:15 -0500
Date: Mon, 11 Feb 2008 14:30:37 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: print more information when removing non-empty directories
Message-ID: <20080211113037.GC6110@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This usually saves one recompile to insert similar printk like below. :)

Sample nastygram:

remove_proc_entry: removing non-empty directory '/proc/foo', leaking at least 'bar'
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:776 remove_proc_entry+0x18a/0x200()
Modules linked in: foo(-) container fan battery dock sbs ac sbshc backlight ipv6 loop af_packet amd_rng sr_mod i2c_amd8111 i2c_amd756 cdrom i2c_core button thermal processor
Pid: 3034, comm: rmmod Tainted: G   M     2.6.25-rc1 #5

Call Trace:
 [<ffffffff80231974>] warn_on_slowpath+0x64/0x90
 [<ffffffff80232a6e>] printk+0x4e/0x60
 [<ffffffff802d6c8a>] remove_proc_entry+0x18a/0x200
 [<ffffffff8045cd88>] mutex_lock_nested+0x1c8/0x2d0
 [<ffffffff8025f0f0>] __try_stop_module+0x0/0x40
 [<ffffffff8025effd>] sys_delete_module+0x14d/0x200
 [<ffffffff8045df3d>] lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8031c307>] __up_read+0x27/0xa0
 [<ffffffff8045decc>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b6ab>] system_call_after_swapgs+0x7b/0x80

---[ end trace 10ef850597e89c54 ]---


Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/generic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -769,7 +769,12 @@ continue_removing:
 		if (S_ISDIR(de->mode))
 			parent->nlink--;
 		de->nlink = 0;
-		WARN_ON(de->subdir);
+		if (de->subdir) {
+			printk(KERN_WARNING "%s: removing non-empty directory "
+			       "'%s/%s', leaking at least '%s'\n", __func__,
+			       de->parent->name, de->name, de->subdir->name);
+			WARN_ON(1);
+		}
 		if (atomic_dec_and_test(&de->count))
 			free_proc_entry(de);
 		break;

