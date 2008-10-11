Return-Path: <linux-kernel-owner+w=401wt.eu-S1764329AbYJKGyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764329AbYJKGyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYJKGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:07 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52144 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYJKGg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:57 -0400
Date: Sat, 11 Oct 2008 02:35:45 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 25/85] Introduce FW_BUG,
 FW_WARN and FW_INFO to consistenly tell users about BIOS bugs
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <a0ad05c75aa362c91f4d9cd91ff375a739574dd8.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

The idea is to add this to printk after the severity:
printk(KERN_ERR FW_BUG "This is not our fault, BIOS developer: fix it by
simply add ...\n");

If a Firmware issue should be hidden, because it is
work-arounded, but you still want to see something popping up e.g.
for info only:
printk(KERN_INFO FW_INFO "This is done stupid, we can handle it,
but it should better be avoided in future\n");

or on the Linuxfirmwarekit to tell vendors that they did something
stupid or wrong without bothering the user:
printk(KERN_INFO FW_BUG "This is done stupid, we can handle it,
but it should better be avoided in future\n");

Some use cases:
  - If a user sees a [Firmware Bug] message in the kernel
    he should first update the BIOS before wasting time with
    debugging and submiting on old firmware code to mailing
    lists.

  - The linuxfirmwarekit (http://www.linuxfirmwarekit.org)
    tries to detect firmware bugs. It currently is doing that
    in userspace which results in:
        - Huge test scripts that could be a one liner in the kernel
        - A lot of BIOS bugs are already absorbed by the kernel

What do we need such a stupid linuxfirmwarekit for?

  - Vendors: Can test their BIOSes for Linux compatibility.
    There will be the time when vendors realize that the test utils
    on Linux are more strict and using them increases the qualitity
    and stability of their products.

  - Vendors: Can easily fix up their BIOSes and be more Linux
    compatible by:
    dmesg |grep "Firmware Bug"
    and send the result to their BIOS developer colleagues who should
    know what the messages are about and how to fix them, without
    the need of studying kernel code.

  - Distributions: can do a first automated HW/BIOS checks.
    This can then be done without the need of asking kernel developers
    who need to dig down the code and explain the details.
    Certification can/will just be rejected until
    dmesg |grep "Firmware Bug" is empty.

  - Thus this can be used as an instrument to enforce cleaner BIOS
    code. Currently every stupid Windows ACPI bug is
    re-implemented in Linux which is a rather unfortunate situation.
    We already have the power to avoid this in e.g. memory
    or cpu hot-plug ACPI implementations, because Linux certification
    is a must for most vendors in the server area.
    Working towards being able to do that in the laptop area
    (vendors are starting to look at Linux here also and will use this tool)
    is the goal. At least provide them a tool to make it as easy
    for this guys (e.g. not needing to browse kernel code) as possible.

  - The ordinary Linux user: can go into the next shop, boots the
    firmwarekit on his most preferred machines. He chooses one without
    BIOS bugs. Unsupported HW is ok, he likes to try out latest projects
    which might support them or likes to dig on it on his own, but he
    hates to workaround broken BIOSes like hell.

I double checked with the firmwarekit.
There they have:
So the mapping generally is (also depending on how likely the BIOS is
to blame, this could sometimes be difficult):
FW_INFO  = INFO
FW_WARN  = WARN
FW_BUG   = FAIL

For more info about the linuxfirmwarekit and why this is needed
can be found here:
http://www.linuxfirmwarekit.org

While severity matches with the firmwarekit, it might be tricky
to hide messages from the user.
E.g. we recently found out that on HP BIOSes negative temperatures
are returned, which seem to indicate that the thermal zone is
invalid.
We can work around that gracefully by ignoring the thermal zone
and we do not want to bother the ordinary user with a frightening
message: Firmware Bug: thermal management absolutely broken
but want to hide it from the user.

But in the linuxfirmwarekit this should be shown as a real
show stopper (the temperatures could really be wrong,
broken thermal management is one of the worst things
that can happen and the BIOS guys of the machine must
implement this properly).

It is intended to do that (hide it from the user with
KERN_INFO msg, but still print it as a BIOS bug) by:
printk(KERN_INFO FW_BUG "Negativ temperature values detected.
Try to workarounded, BIOS must get fixed\n");
Hope that works out..., no idea how to better hide it
as printk is the only way to easily provide this functionality.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/kernel.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..0b19848 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -190,6 +190,30 @@ extern int kernel_text_address(unsigned long addr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
+/*
+ * FW_BUG
+ * Add this to a message where you are sure the firmware is buggy or behaves
+ * really stupid or out of spec. Be aware that the responsible BIOS developer
+ * should be able to fix this issue or at least get a concrete idea of the
+ * problem by reading your message without the need of looking at the kernel
+ * code.
+ * 
+ * Use it for definite and high priority BIOS bugs.
+ *
+ * FW_WARN
+ * Use it for not that clear (e.g. could the kernel messed up things already?)
+ * and medium priority BIOS bugs.
+ *
+ * FW_INFO
+ * Use this one if you want to tell the user or vendor about something
+ * suspicious, but generally harmless related to the firmware.
+ *
+ * Use it for information or very low priority BIOS bugs.
+ */
+#define FW_BUG		"[Firmware Bug]: "
+#define FW_WARN		"[Firmware Warn]: "
+#define FW_INFO		"[Firmware Info]: "
+
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-- 
1.5.5.1

