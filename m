Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZBOUZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZBOUZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBOUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:25:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:36174 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbZBOUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:25:05 -0500
Message-ID: <49987A37.9000300@ru.mvista.com>
Date: Sun, 15 Feb 2009 23:25:27 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] ide: use ->tf_load in SELECT_DRIVE()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213451.13202.12671.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213451.13202.12671.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Convert SELECT_DRIVE() to use ->tf_load instead of ->OUTB.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/ide-iops.c
> ===================================================================
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -88,11 +88,15 @@ void SELECT_DRIVE (ide_drive_t *drive)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	const struct ide_port_ops *port_ops = hwif->port_ops;
> +	ide_task_t task;
>  
>  	if (port_ops && port_ops->selectproc)
>  		port_ops->selectproc(drive);
>  
> -	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
> +	memset(&task, 0, sizeof(task));
> +	task.tf_flags = IDE_TFLAG_OUT_DEVICE;
> +
> +	drive->hwif->tf_load(drive, &task);

    This actually doesn't seem like a bright idea to me, considering that this 
gets called when starting every request. How will you look at me adding the 
transport method for writing this register? :-)

MBR, Sergei
