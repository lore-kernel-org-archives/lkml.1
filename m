Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYIDPQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYIDPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYIDPQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:16:20 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:52631 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYIDPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:16:20 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] HID: fix tty<->hid deadlock
Date: Thu,  4 Sep 2008 17:16:07 +0200
Message-Id: <1220541367-10984-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <48BFFAE0.5010001@gmail.com>
References: <48BFFAE0.5010001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Valdis.Kletnieks@vt.edu napsal(a):
>> (Adding Alan Cox to the cc: in case he can shed light on this one - it
>> appears that HID_COMPAT only puts the bullet in the chamber, and doesn't
>> actually cause the hang...)
>>
>> On Tue, 02 Sep 2008 23:02:42 +0200, Jiri Slaby said:
>>> On 09/02/2008 06:11 PM, Valdis.Kletnieks@vt.edu wrote:
>>>> The following 3 lines don't go to console by default due to loglevel setting.
>>>> So I'm not sure exactly where it hangs. But it's somewhere in here.
>> Right around here, we kick off a modprobe for 'hid_dummy'.
>>>>>> [    1.959193] usbcore: registered new interface driver usbhid
>>>>>> [    1.973037] usbhid: v2.6:USB HID core driver
>> And since my initrd doesn't include any modules (since until now, I've had
>> a kernel that can everything builtin so it can boot far enough to do the
>> whole udev/modprobe off my root filesystem, and hid_dummy is a new one on
>> me), this modprobe spits out a:
>>
>> modprobe: FATAL: Could not open '/lib/modules/2.6.27-rc5-mmotm0829/modules.dep': No such file or directory
>>
>> Well, yeah.. No modules on the initrd, so no modules.dep.  But having spewed
>> its error message, modprobe apparently decides to go off in a snit and hang.
>> Eventually, the usermode_helper call does a wait() on the modprobe, and then
>> *that* hangs because modprobe isn't returning.  And eventually the whole
>> level of initcalls comes to a screeching halt...
>>
>> And here's the totally unexpected kernel traceback for the modprobe:
>>
>> schedule_timeout+0x22/0xb4
>> ? _raw_spin_lock+0xce/0x186
>> ? _raw_spin_unlock+0xb7/0xe0
>> wait_for_common+-xb2/0xfb
>> ? default_wake_function+0x0/0xf
>> wait_for_completion+0x18/0x1a
>> flush_cpu_workqueue+0x6b/0x77
>> ? wq_barrior_func+0x0/0xf
>> flush_workqueue+0x4f/0x68
>> flush_scheduled_work+0x10/0x12
>> tty_ldisc_release+0x4a/0x21e
>> ? _raw_pin_lock+0xce/0x186
>> ? debug_mutex_unlock+0x127/0x14d
>> ? mutex_unlock_slowpath+0x14a/0x15c
>> tty_release_dev+0x4da/0x508
>> ? get_parent_ip+0x11/0x41
>> ? get_parent_ip+0x11/0x41
>> tty_release+0x19/0x24
>> __fput+0xd9/0x198
>> fput+0x15/0x17
>> filp_close+0x67/0x72
>> sys_close+0xa9/0x104
>> system_call_fastpath+0x16/0x1b
>>
>> WTF? We hang trying to close a tty??!?
> 
> Hmm, *if* we stuck in request_module in hid, workqueue cannot be flushed and
> tty waits... Could you stick 2 printks into hid_compat_load if it finishes?

Ah, this is deadlock:
hid_compat_load() runs on the default workqueue, it request_module(), it
execs modprobe, it exits, tty flushes default workqueue, it hangs, because
we are still in it.

I haven't run into it since there always was at least one opener of the tty,
I guess. Could you try the patch below?

--

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/hid-core.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 92c16e1..18d952a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1663,6 +1663,7 @@ static void hid_compat_load(struct work_struct *ws)
 	request_module("hid-dummy");
 }
 static DECLARE_WORK(hid_compat_work, hid_compat_load);
+static struct workqueue_struct *hid_compat_wq;
 #endif
 
 static int __init hid_init(void)
@@ -1680,7 +1681,12 @@ static int __init hid_init(void)
 		goto err_bus;
 
 #ifdef CONFIG_HID_COMPAT
-	schedule_work(&hid_compat_work);
+	hid_compat_wq = create_workqueue("hid_compat");
+	if (!hid_compat_wq) {
+		hidraw_exit();
+		goto err;
+	}
+	queue_work(hid_compat_wq, &hid_compat_work);
 #endif
 
 	return 0;
@@ -1692,6 +1698,9 @@ err:
 
 static void __exit hid_exit(void)
 {
+#ifdef CONFIG_HID_COMPAT
+	destroy_workqueue(hid_compat_wq);
+#endif
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
 }
-- 
1.6.0

