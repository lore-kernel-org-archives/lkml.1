Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXIWGlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXIWGlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXIWGln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:41:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:61769 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXIWGlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=n1bP96y11ghUuvffUSUwLWi3+VpHKVRFbsxXdgL9uI0vqBUOmFM/HjdE1i0Vf+my04GGduHBwmyl8WEeQd/UD3SZiRss/gFLXjvNbwILRJeErpuGZc+E5gH/58p/6AtUoTKHrlG/45SF7ugygwKath5NetiptKmWbjD7fPlcV8M=
Message-ID: <46F60AA2.1060500@gmail.com>
Date: Sun, 23 Sep 2007 10:41:38 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.23-rc7] main.c: undefined reference to `acpi_sleep_prepare'
References: <200709230152.31120.elendil@planet.nl>
In-Reply-To: <200709230152.31120.elendil@planet.nl>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------030704070006050503060301"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030704070006050503060301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Frans Pop wrote:
> I wanted to test 5a50fe709d527f31 and thus created a config with ACPI and 
> CONFIG_HIBERNATION, but without CONFIG_SUSPEND, which resulted in (git 
> checkout updated to 1f0cff6e4d579ab0):
> 
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `acpi_power_off_prepare':
> main.c:(.text+0x32282): undefined reference to `acpi_sleep_prepare'
> drivers/built-in.o: In function `acpi_hibernation_prepare':
> main.c:(.text+0x3228c): undefined reference to `acpi_sleep_prepare'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/home/fjp/projects/kernel/linux-2.6'
> make: *** [debian/stamp-build-kernel] Error 2
> 
> 
yep... acpi_sleep_prepare was put under CONFIG_SUSPEND spanning half of the file...
this patch moves it out.
Thanks,
Alex.

--------------030704070006050503060301
Content-Type: text/x-patch;
 name="move_acpi_sleep_prepare_outside_of_CONFIG_SUSPEND.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="move_acpi_sleep_prepare_outside_of_CONFIG_SUSPEND.patch"

ACPI: suspend: move acpi_sleep_prepare outside of CONFIG_SUSPEND

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/sleep/main.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 85633c5..c79edcb 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -26,6 +26,27 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 
+int acpi_sleep_prepare(u32 acpi_state)
+{
+#ifdef CONFIG_ACPI_SLEEP
+	/* do we have a wakeup address for S2 and S3? */
+	if (acpi_state == ACPI_STATE_S3) {
+		if (!acpi_wakeup_address) {
+			return -EFAULT;
+		}
+		acpi_set_firmware_waking_vector((acpi_physical_address)
+						virt_to_phys((void *)
+							     acpi_wakeup_address));
+
+	}
+	ACPI_FLUSH_CPU_CACHE();
+	acpi_enable_wakeup_device_prep(acpi_state);
+#endif
+	acpi_gpe_sleep_prepare(acpi_state);
+	acpi_enter_sleep_state_prep(acpi_state);
+	return 0;
+}
+
 #ifdef CONFIG_SUSPEND
 static struct pm_ops acpi_pm_ops;
 
@@ -60,27 +81,6 @@ static int acpi_pm_set_target(suspend_state_t pm_state)
 	return error;
 }
 
-int acpi_sleep_prepare(u32 acpi_state)
-{
-#ifdef CONFIG_ACPI_SLEEP
-	/* do we have a wakeup address for S2 and S3? */
-	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
-			return -EFAULT;
-		}
-		acpi_set_firmware_waking_vector((acpi_physical_address)
-						virt_to_phys((void *)
-							     acpi_wakeup_address));
-
-	}
-	ACPI_FLUSH_CPU_CACHE();
-	acpi_enable_wakeup_device_prep(acpi_state);
-#endif
-	acpi_gpe_sleep_prepare(acpi_state);
-	acpi_enter_sleep_state_prep(acpi_state);
-	return 0;
-}
-
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
  *	@pm_state: ignored

--------------030704070006050503060301--
