Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYA0Tgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYA0Tgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYA0Tck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:8690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYA0TcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=BBorJvh0a7k8sWxrBJ3gQyqB12lWSf8tzj2rY+e9Zr2N1A5rx0l8gIb6WA0r9xyzrTgONCV0rqK90JNrAo5Dzyg92gW7aXkhEEqyibmfB3cC1IlvoKmOTPTpKYzk2SLl0Novj4ZYQp5p+svtmXQ4TFpLWuodShwg93c16QRe5Lk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 31/32] ide-tape: remove idetape_config_t typedef
Date: Sun, 27 Jan 2008 19:30:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-26-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-26-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801271930.53933.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Since this is used only in idetape_blkdev_ioctl(), remove the typedef and make
> the struct function-local.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied

> ---
>  drivers/ide/ide-tape.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index c22d7f6..424879d 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -540,15 +540,6 @@ struct idetape_id_gcw {
>  #define	IDETAPE_CAPABILITIES_PAGE	0x2a
>  
>  /*
> - *	Run time configurable parameters.
> - */
> -typedef struct {
> -	int	dsc_rw_frequency;
> -	int	dsc_media_access_frequency;
> -	int	nr_stages;
> -} idetape_config_t;
> -
> -/*
>   *	The variables below are used for the character device interface.
>   *	Additional state variables are defined in our ide_drive_t structure.
>   */
> @@ -2742,14 +2733,21 @@ static int idetape_rewind_tape (ide_drive_t *drive)
>  static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
> -	idetape_config_t config;
> +
> +	struct idetape_config {
> +		int dsc_rw_frequency;
> +		int dsc_media_access_frequency;
> +		int nr_stages;
> +	} config;
> +
>  	void __user *argp = (void __user *)arg;
>  
>  	debug_log(DBG_PROCS, "Enter %s\n", __func__);
>  
>  	switch (cmd) {
>  		case 0x0340:
> -			if (copy_from_user(&config, argp, sizeof (idetape_config_t)))
> +			if (copy_from_user(&config, argp,
> +						sizeof(struct idetape_config)))

s/sizeof(struct idetape_config)/sizeof(config)/ so it fits nicely in one line

>  				return -EFAULT;
>  			tape->best_dsc_rw_freq = config.dsc_rw_frequency;
>  			tape->max_stages = config.nr_stages;
> @@ -2757,7 +2755,8 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
>  		case 0x0350:
>  			config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
>  			config.nr_stages = tape->max_stages; 
> -			if (copy_to_user(argp, &config, sizeof (idetape_config_t)))
> +			if (copy_to_user(argp, &config,
> +						sizeof(struct idetape_config)))

ditto
