Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYE3FJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYE3FJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYE3FJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:09:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYE3FJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:09:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCHv2 26/28] firmware: allow firmware files to be built into kernel image
Date: Fri, 30 May 2008 15:08:34 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
References: <1211708969@pmac.infradead.org> <E1K0DOO-0007ES-DU@shinybook.infradead.org>
In-Reply-To: <E1K0DOO-0007ES-DU@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301508.34635.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 20:23:56 David Woodhouse wrote:
> Some drivers have their own hacks to bypass the kernel's firmware loader
> and build their firmware into the kernel; this renders those unnecessary.
>
> Other drivers don't use the firmware loader at all, because they always
> want the firmware to be available. This allows them to start using the
> firmware loader.
>
> A third set of drivers already use the firmware loader, but can't be
> used without help from userspace, which sometimes requires an initrd.
> This allows them to work in a static kernel.
>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/base/firmware_class.c     |   33 +++++++++++++++++++++++++++++++--
>  include/asm-generic/vmlinux.lds.h |    7 +++++++
>  include/linux/firmware.h          |   21 +++++++++++++++++++++
>  3 files changed, 59 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 264b3a2..c09f060 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -49,6 +49,14 @@ struct firmware_priv {
>  	struct timer_list timeout;
>  };
>
> +#ifdef CONFIG_FW_LOADER
> +extern struct builtin_fw __start_builtin_fw[];
> +extern struct builtin_fw __end_builtin_fw[];
> +#else /* Module case. Avoid ifdefs later; it'll all optimise out */
> +static struct builtin_fw *__start_builtin_fw = NULL;
> +static struct builtin_fw *__end_builtin_fw = NULL;
> +#endif
> +
>  static void
>  fw_load_abort(struct firmware_priv *fw_priv)
>  {
> @@ -391,13 +399,12 @@ _request_firmware(const struct firmware **firmware_p,
> const char *name, struct device *f_dev;
>  	struct firmware_priv *fw_priv;
>  	struct firmware *firmware;
> +	struct builtin_fw *builtin;
>  	int retval;
>
>  	if (!firmware_p)
>  		return -EINVAL;
>
> -	printk(KERN_INFO "firmware: requesting %s\n", name);
> -
>  	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
>  	if (!firmware) {
>  		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
> @@ -406,6 +413,20 @@ _request_firmware(const struct firmware **firmware_p,
> const char *name, goto out;
>  	}
>
> +	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
> +	     builtin++) {
> +		if (strcmp(name, builtin->name))
> +			continue;
> +		printk(KERN_INFO "firmware: using built-in firmware %s\n",
> +		       name);
> +		firmware->size = builtin->size;
> +		firmware->data = builtin->data;
> +		return 0;
> +	}
> +
> +	if (uevent)
> +		printk(KERN_INFO "firmware: requesting %s\n", name);
> +
>  	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
>  	if (retval)
>  		goto error_kfree_fw;
> @@ -473,8 +494,16 @@ request_firmware(const struct firmware **firmware_p,
> const char *name, void
>  release_firmware(const struct firmware *fw)
>  {
> +	struct builtin_fw *builtin;
> +
>  	if (fw) {
> +		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
> +		     builtin++) {
> +			if (fw->data == builtin->data)
> +				goto free_fw;
> +		}
>  		vfree(fw->data);
> +	free_fw:
>  		kfree(fw);
>  	}
>  }
> diff --git a/include/asm-generic/vmlinux.lds.h
> b/include/asm-generic/vmlinux.lds.h index f054778..8d71a40 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -86,6 +86,13 @@
>  		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
>  	}								\
>  									\
> +	/* Built-in firmware blobs */					\
> +	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
> +		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
> +		*(.builtin_fw)						\
> +		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
> +	}								\
> +									\
>  	/* RapidIO route ops */						\
>  	.rio_route        : AT(ADDR(.rio_route) - LOAD_OFFSET) {	\
>  		VMLINUX_SYMBOL(__start_rio_route_ops) = .;		\
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 5e73f3f..279eaad 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -1,7 +1,10 @@
>  #ifndef _LINUX_FIRMWARE_H
>  #define _LINUX_FIRMWARE_H
> +
>  #include <linux/module.h>
>  #include <linux/types.h>
> +#include <linux/compiler.h>
> +
>  #define FIRMWARE_NAME_MAX 30
>  #define FW_ACTION_NOHOTPLUG 0
>  #define FW_ACTION_HOTPLUG 1
> @@ -13,6 +16,24 @@ struct firmware {
>
>  struct device;
>
> +struct builtin_fw {
> +	char *name;
> +	void *data;
> +	unsigned long size;
> +};
> +
> +/* We have to play tricks here much like stringify() to get the
> +   __COUNTER__ macro to be expanded as we want it */
> +#define __fw_concat1(x,y) x##y
> +#define __fw_concat(x,y) __fw_concat1(x,y)

Hmm, linux/module.h does this too, perhaps some enthusiast can implement 
__concat() and use it everywhere.

Cheers,
Rusty.
