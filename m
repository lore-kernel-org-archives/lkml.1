Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYEKUrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYEKUrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYEKUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:47:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50370 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYEKUrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:47:31 -0400
Date: Sun, 11 May 2008 22:48:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] HID: add compat support
Message-ID: <20080511204807.GB850@uranus.ravnborg.org>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com> <1210536043-19812-2-git-send-email-jirislaby@gmail.com> <1210536043-19812-3-git-send-email-jirislaby@gmail.com> <1210536043-19812-4-git-send-email-jirislaby@gmail.com> <1210536043-19812-5-git-send-email-jirislaby@gmail.com> <1210536043-19812-6-git-send-email-jirislaby@gmail.com> <1210536043-19812-7-git-send-email-jirislaby@gmail.com> <1210536043-19812-8-git-send-email-jirislaby@gmail.com> <1210536043-19812-9-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210536043-19812-9-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:00:43PM +0200, Jiri Slaby wrote:
> Add compat option to hid code to allow loading of all modules on
> systems which don't allow autoloading because of old userspace.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  drivers/hid/Kconfig        |   11 +++++++++++
>  drivers/hid/Makefile       |   22 ++++++++++++++++++++++
>  drivers/hid/hid-apple.c    |    2 ++
>  drivers/hid/hid-core.c     |   12 ++++++++++++
>  drivers/hid/hid-dummy.c    |   11 +++++++++++
>  drivers/hid/hid-logitech.c |    2 ++
>  include/linux/hid.h        |   13 +++++++++++--
>  7 files changed, 71 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/hid/hid-dummy.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 9a9fd7d..ba9ca39 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -70,6 +70,17 @@ source "drivers/hid/usbhid/Kconfig"
>  menu "Special HID drivers"
>  	depends on HID
>  
> +config HID_COMPAT
> +	bool "Load all HID drivers on hid core load"
> +	---help---
> +	Compatible option for older userspace. If you have system without udev
> +	support of module loading through aliases and also old
> +	module-init-tools which can't handle hid bus, choose Y here. Otherwise
> +	say N. If you say N and your userspace is old enough, the only
> +	functionality you loose is modules autoloading.
> +
> +	If unsure, say N.
> +
>  config HID_LOGITECH
>  	tristate "Logitech"
>  	default m
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 8a5cbbe..c5bca8f 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -15,3 +15,25 @@ obj-$(CONFIG_USB_HID)		+= usbhid/
>  obj-$(CONFIG_USB_MOUSE)		+= usbhid/
>  obj-$(CONFIG_USB_KBD)		+= usbhid/
>  
> +targets := hid-dummy.h
> +
> +ifdef CONFIG_HID_COMPAT
> +
> +obj-m		+= hid-dummy.o
> +
> +$(srctree)/$(src)/hid-dummy.c: $(obj)/hid-dummy.h
> +
> +$(obj)/hid-dummy.h: $(filter-out $(srctree)/drivers/hid/hid-dummy.c,$(wildcard $(srctree)/drivers/hid/*.c))
> +	@echo -e 'static void __always_inline hid_dummy_load(void)\n{' > $@
> +	@FUNS=`grep -h 'HID_COMPAT_LOAD_DRIVER(' $(srctree)/drivers/hid/*.c | \
> +	sed -e 's/HID_COMPAT_LOAD_DRIVER( *\([^ ]*\) *) *;/\1/'`; \
> +	for FUN in $$FUNS; do \
> +		echo -e "\textern void hid_compat_$$FUN(void);"; \
> +	done >> $@; \
> +	echo >> $@; \
> +	for FUN in $$FUNS; do \
> +		echo -e "\thid_compat_$$FUN();"; \
> +	done >> $@
> +	@echo "}" >> $@

I would prefer to see this done explicit in favour of some magic
makefile fragment as the above.
It is much simpler to understand if done explicit.
And it is not like we are talking 10 or 50 files here.


	Sam
