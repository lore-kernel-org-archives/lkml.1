Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbXJYXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbXJYXZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXJYXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:25:05 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:37180 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbXJYXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:25:03 -0400
Subject: Re: [PATCH RESEND] SCSI not showing tray status correctly
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Maarten Bressers <mbres@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk,
       tasio@hierro.tasio.net, dsd@gentoo.org
In-Reply-To: <20071025223037.C077D65309@smtp.gentoo.org>
References: <20071025223037.C077D65309@smtp.gentoo.org>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 18:24:53 -0500
Message-Id: <1193354693.3301.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 22:30 +0000, Maarten Bressers wrote:
> From: David Martin <tasio@tasio.net>
> 
> Greetings,
> 
> The following patch was submitted to the lkml in 2004 by David Martin
> (http://lkml.org/lkml/2004/12/27/1). It wasn't accepted, but I was
> unable to find a reason why, so I'm resending it now.

Well, sending SCSI patches to the kernel mailing list but not to
linux-scsi is usually a good enough reason.

> Without this patch the SCSI ioctl CDROM_DRIVE_STATUS always returns
> CDS_TRAY_OPEN even if the tray is closed. This patch fixes that.
> Gentoo bug report: http://bugs.gentoo.org/show_bug.cgi?id=196879
> 
> Signed-off by: Maarten Bressers <mbres@gentoo.org>
> 
> ---
> 
> --- a/drivers/scsi/sr_ioctl.c	2007-10-09 22:31:38.000000000 +0200
> +++ b/drivers/scsi/sr_ioctl.c	2007-10-25 22:57:21.000000000 +0200
> @@ -310,6 +310,8 @@ int sr_lock_door(struct cdrom_device_inf
>  
>  int sr_drive_status(struct cdrom_device_info *cdi, int slot)
>  {
> +	struct media_event_desc med;
> +
>  	if (CDSL_CURRENT != slot) {
>  		/* we have no changer support */
>  		return -EINVAL;
> @@ -317,7 +319,10 @@ int sr_drive_status(struct cdrom_device_
>  	if (0 == test_unit_ready(cdi->handle))
>  		return CDS_DISC_OK;
>  
> -	return CDS_TRAY_OPEN;
> +	if (!cdrom_get_media_event(cdi, &med) && med.door_open)
> +		return CDS_TRAY_OPEN;
> +
> +	return CDS_NO_DISC;
>  }
>  
>  int sr_disk_status(struct cdrom_device_info *cdi)

This patch is too simplistic.  ide-cd.c:ide_cdrom_drive_status() looks
to be a reasonable implementation.  However, the worry is that
GET_EVENT_NOTIFICATION is a MMC command; devices not conforming to MMC
won't support it.  In theory, they should just return ILLEGAL_REQUEST,
but USB devices have been known to crash when given commands they don't
understand.  How widely tested has this been (if it's been in Gentoo
since 2004, then it's probably widely tested enough)?

James


