Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZASVZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZASVZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZASVZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:25:29 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34445 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZASVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nS0Ja4hoJ43LmF2oCGC7Pca2QM3q5fxDNgSeD8D2C/PUbxYs+kcr9H2nwufE+zFejr
         jmbn/yXvxlUp8FVlul1OW3k/en5ZGVndJoj5Mf86C0Rq13199WfbAoFhQCRsaGiCzltl
         i+E8i9WC+EIirbPbA9nW7TSdfCw5vWE4S+pAw=
Date: Mon, 19 Jan 2009 22:25:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Frans Pop <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Message-ID: <20090119212428.GB6194@nowhere>
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org> <200901192053.50831.rjw@sisk.pl> <200901192054.55536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192054.55536.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 08:54:54PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce boolean function system_entering_hibernation() returning
> 'true' during the last phase of hibernation, in which devices are
> being put into low power states and the sleep state (for example,
> ACPI S4) is finally entered.
> 
> Some device drivers need such a function to check if the system is
> in the final phase of hibernation.  In particular, some SATA drivers
> are going to use it for blacklisting systems in which the disks
> should not be spun down during the last phase of hibernation (the
> BIOS will do that anyway).
>

Hi Rafael,

Why not using the power event notifier?

Frederic.

 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  include/linux/suspend.h |    2 ++
>  kernel/power/disk.c     |   10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> Index: linux-2.6/include/linux/suspend.h
> ===================================================================
> --- linux-2.6.orig/include/linux/suspend.h
> +++ linux-2.6/include/linux/suspend.h
> @@ -237,6 +237,7 @@ extern int hibernate_nvs_alloc(void);
>  extern void hibernate_nvs_free(void);
>  extern void hibernate_nvs_save(void);
>  extern void hibernate_nvs_restore(void);
> +extern bool system_entering_hibernation(void);
>  #else /* CONFIG_HIBERNATION */
>  static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
>  static inline void swsusp_set_page_free(struct page *p) {}
> @@ -252,6 +253,7 @@ static inline int hibernate_nvs_alloc(vo
>  static inline void hibernate_nvs_free(void) {}
>  static inline void hibernate_nvs_save(void) {}
>  static inline void hibernate_nvs_restore(void) {}
> +static inline bool system_entering_hibernation(void) { return false; }
>  #endif /* CONFIG_HIBERNATION */
>  
>  #ifdef CONFIG_PM_SLEEP
> Index: linux-2.6/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/disk.c
> +++ linux-2.6/kernel/power/disk.c
> @@ -71,6 +71,14 @@ void hibernation_set_ops(struct platform
>  	mutex_unlock(&pm_mutex);
>  }
>  
> +static bool entering_platform_hibernation;
> +
> +bool system_entering_hibernation(void)
> +{
> +	return entering_platform_hibernation;
> +}
> +EXPORT_SYMBOL(system_entering_hibernation);
> +
>  #ifdef CONFIG_PM_DEBUG
>  static void hibernation_debug_sleep(void)
>  {
> @@ -411,6 +419,7 @@ int hibernation_platform_enter(void)
>  	if (error)
>  		goto Close;
>  
> +	entering_platform_hibernation = true;
>  	suspend_console();
>  	error = device_suspend(PMSG_HIBERNATE);
>  	if (error) {
> @@ -445,6 +454,7 @@ int hibernation_platform_enter(void)
>   Finish:
>  	hibernation_ops->finish();
>   Resume_devices:
> +	entering_platform_hibernation = false;
>  	device_resume(PMSG_RESTORE);
>  	resume_console();
>   Close:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

