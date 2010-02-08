Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0BHXvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:51:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab0BHXvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:51:22 -0500
Date: Mon, 8 Feb 2010 15:50:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-Id: <20100208155059.eed393a6.akpm@linux-foundation.org>
In-Reply-To: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Feb 2010 16:32:07 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> Brightness notification does not work until the user writes to
> hotkey_mask attribute. That's because the polling thread will only run
> if hotkey_user_mask is set and someone is reading the input device or if
> hotkey_driver_mask is set. In this second case, this condition is not
> tested after the mask is changed, because the brightness and volume
> drivers are started after the hotkey drivers.
> 
> This fix test for the polling condition that ends up starting the
> polling thread after hotkey_driver_mask is set in brightness and volume
> init functions.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index e67e4fe..d69749d 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -6272,6 +6272,11 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
>  	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
>  				| TP_ACPI_HKEY_BRGHTUP_MASK
>  				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
> +
> +#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> +	hotkey_poll_setup(true);
> +#endif
> +
>  	return 0;
>  }
>  
> @@ -6903,6 +6908,10 @@ static int __init volume_init(struct ibm_init_struct *iibm)
>  			| TP_ACPI_HKEY_VOLDWN_MASK
>  			| TP_ACPI_HKEY_MUTE_MASK);
>  
> +#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> +	hotkey_poll_setup(true);
> +#endif
> +
>  	return 0;
>  }

Something like this is needed, methinks:

- Avoid ifdefs

- Make sure that hotkey_mutex is held when calling hotkey_poll_setup:
  use hotkey_poll_setup_safe.  Doesn't matter much in __init code.

--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -2597,6 +2597,10 @@ static void hotkey_poll_set_freq(unsigne
 
 #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
 
+static void hotkey_poll_setup(bool __unused)
+{
+}
+
 static void hotkey_poll_setup_safe(bool __unused)
 {
 }
@@ -2694,9 +2698,7 @@ static ssize_t hotkey_mask_store(struct 
 
 	res = hotkey_user_mask_set(t);
 
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
 	hotkey_poll_setup(true);
-#endif
 
 	mutex_unlock(&hotkey_mutex);
 
@@ -6273,9 +6275,7 @@ static int __init brightness_init(struct
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
 
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
-	hotkey_poll_setup(true);
-#endif
+	hotkey_poll_setup_safe(true);
 
 	return 0;
 }
_

