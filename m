Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZLZUSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZLZUSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 15:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZLZUSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 15:18:06 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:53557 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZLZUSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 15:18:05 -0500
Date: Sat, 26 Dec 2009 15:17:43 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -tip: origin tree boot crash
In-reply-to: <20091225102731.GA25513@elte.hu>
Message-id: <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [   28.643216] evbug.c: Connected device: input1 (Dell WMI hotkeys at wmi/input0)
> [   28.650449] BUG: unable to handle kernel NULL pointer dereference at 00000014
> [   28.654439] IP: [<c17f7f21>] wmi_install_notify_handler+0x31/0x70

Rather than reverting the broken patch that caused wmi to load,
does applying this patch to deal with the broken error handling
cause the oops to go away?

thanks,
-Len

>From d11e073ee3e3091d9190dace97ce480e960cca1b Mon Sep 17 00:00:00 2001
From: Len Brown <len.brown@intel.com>
Date: Fri, 25 Dec 2009 23:14:26 -0500
Subject: [PATCH] Revert "wmi: Free the allocated acpi objects through wmi_get_event_data"
X-Patchwork-Hint: ignore

This reverts commit 3e9b988e4edf065d39c1343937f717319b1c1065.

Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/dell-wmi.c |    1 -
 drivers/platform/x86/hp-wmi.c   |    2 --
 drivers/platform/x86/wmi.c      |    4 ++--
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 916ccb2..46244c6 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -238,7 +238,6 @@ static void dell_wmi_notify(u32 value, void *context)
 			input_sync(dell_wmi_input_dev);
 		}
 	}
-	kfree(obj);
 }
 
 
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 8781d8f..222ab57 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -388,8 +388,6 @@ static void hp_wmi_notify(u32 value, void *context)
 	} else
 		printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
 			eventcode);
-
-	kfree(obj);
 }
 
 static int __init hp_wmi_input_setup(void)
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 9f93d6c..e425a86 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -540,8 +540,8 @@ EXPORT_SYMBOL_GPL(wmi_remove_notify_handler);
 /**
  * wmi_get_event_data - Get WMI data associated with an event
  *
- * @event: Event to find
- * @out: Buffer to hold event data. out->pointer should be freed with kfree()
+ * @event - Event to find
+ * &out - Buffer to hold event data
  *
  * Returns extra data associated with an event in WMI.
  */
-- 
1.6.6.rc4.11.g129a5

