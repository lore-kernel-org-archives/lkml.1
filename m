Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851Ab0AHQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0AHQS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828Ab0AHQS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:18:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab0AHQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:18:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: compat_ioctl: unknown cmd on serial /dev/console
Date: Fri, 8 Jan 2010 17:18:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20100109.000510.193873785.anemo@mba.ocn.ne.jp>
In-Reply-To: <20100109.000510.193873785.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001081718.23840.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+J/eRWvAdbCCMd4rr5SLiqaj67tValdEY+UG+
 MJseQ3ij2rQylno8H/kNo+92bjtji0+aPaNGrKrsd2XwbHo7xu
 UHrJjnRNfDmfw9i2yCrQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 January 2010, Atsushi Nemoto wrote:
> After the commit fb07a5f8 ("compat_ioctl: remove all VT ioctl
> handling"), I got this error message on 64-bit mips kernel with 32-bit
> busybox userland:
> 
> ioctl32(init:1): Unknown cmd fd(0) cmd(00005600){t:'V';sz:0} arg(7fd76480) on /dev/console

Just to confirm: The behaviour of the kernel is still correct, it's only
the message you are worried about, right?

Sorry for this, it will be trivial to fix.

> The cmd 5600 is VT_OPENQRY.  The busybox's init issues this ioctl to
> know vt-console or serial-console.  If the console was serial console,
> VT ioctls are not handled by the serial driver.
> 
> How this error should be fixed?  Is this patch OK?
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 332dd00..731478f 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1005,6 +1005,8 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
>  COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
>  COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
>  #endif
> +/* Big V (for serial console case) */
> +COMPATIBLE_IOCTL(VT_OPENQRY)
>  /* Little p (/dev/rtc, /dev/envctrl, etc.) */
>  COMPATIBLE_IOCTL(RTC_AIE_ON)
>  COMPATIBLE_IOCTL(RTC_AIE_OFF)

I would probably write this as IGNORE_IOCTL() instead of COMPATIBLE_IOCTL
in order to document the intent, but it's functionally the same.

> And by quick search, I found some programs using VT_GETMODE to check
> vt-console is available or not.  So VT_GETMODE might be an another
> candidate, but not sure.

Yes, that sounds reasonable, too.

	Arnd
