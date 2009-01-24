Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbZAXFzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbZAXFzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 00:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZAXFzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 00:55:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:26751 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZAXFza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 00:55:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QTnqzvarPHmVENoUKQmzNTDiz7N9bnTmeowMfY7NQirH0I89BWVebT8geUPP729xoO
         f/ASCRxEgo2i/08W7uEEL9XmvdiGhWBQ/mNGp/tbjIuO6iwgmOR6jXWdwmns4a0GFT/A
         uzvh+WCpw6GQ/aMqia1iKzGP5hvt3OG4NdeBg=
MIME-Version: 1.0
In-Reply-To: <1210931362-18422-9-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
	 <1210931362-18422-9-git-send-email-jirislaby@gmail.com>
Date: Sat, 24 Jan 2009 11:25:27 +0530
Message-ID: <3f9a31f40901232155q7f898f00l9a1cf16ca6c8fb75@mail.gmail.com>
Subject: Re: [PATCH 09/10] HID: add compat support
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com, gregkh@suse.de,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 3:19 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Add compat option to hid code to allow loading of all modules on
> systems which don't allow autoloading because of old userspace.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  Documentation/feature-removal-schedule.txt |    7 +++++++
>  drivers/hid/Kconfig                        |   11 +++++++++++
>  drivers/hid/Makefile                       |    4 ++++
>  drivers/hid/hid-apple.c                    |    2 ++
>  drivers/hid/hid-core.c                     |   12 ++++++++++++
>  drivers/hid/hid-dummy.c                    |   13 +++++++++++++
>  drivers/hid/hid-logitech.c                 |    2 ++
>  include/linux/hid.h                        |   17 +++++++++++++++--
>  8 files changed, 66 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/hid/hid-dummy.c
>

> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index c67e5fe..447aed9 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h

> +#ifdef CONFIG_HID_COMPAT
> +#define HID_COMPAT_LOAD_DRIVER(name)   \
> +void hid_compat_##name(void) { }       \
> +EXPORT_SYMBOL(hid_compat_##name)
> +#else
> +#define HID_COMPAT_LOAD_DRIVER(name)
> +#endif /* HID_COMPAT */
> +#define HID_COMPAT_CALL_DRIVER(name)   do {    \
> +       extern void hid_compat_##name(void);    \
> +       hid_compat_##name();                    \
> +} while (0)
> +
>  #endif
>

This leads to 3 headers_check warnings:

 usr/include/linux/hid.h:66: leaks CONFIG_HID to userspace where it is not valid
 usr/include/linux/hid.h:69: extern's make no sense in userspace
 usr/include/linux/hid.h:76: extern's make no sense in userspace

So I  am moving whole above block in #ifdef __KEREL__

If you have any objections, then let me know, now it will look like this:

 #endif /* HID_FF */

+#ifdef __KERNEL__
 #ifdef CONFIG_HID_COMPAT
 #define HID_COMPAT_LOAD_DRIVER(name)   \
 /* prototype to avoid sparse warning */        \
@@ -804,6 +805,7 @@ EXPORT_SYMBOL(hid_compat_##name)
        extern void hid_compat_##name(void);    \
        hid_compat_##name();                    \
 } while (0)
+#endif /* __KERNEL__ */

 #endif


--
JSR
