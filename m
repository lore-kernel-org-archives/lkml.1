Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZEWLnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZEWLnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 07:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZEWLnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 07:43:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58188 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZEWLnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 07:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=C8e9z89/E66W0oav/K0YkR1mZTTE6hd7dF1oKXgciuw6xSJ2pNYSt5wAF+9gHH43IQ
         FDuDHijzYMroWs4NCx1gNUi/G+z4UlB6EgDbg1B1uvn6Am/HRNatxUnmmsJLersCxt0I
         lWSL/KB1ZUGVOkz+MXdXl47bTp5bY8KF1IzJM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: yanh@lemote.com
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Sat, 23 May 2009 13:47:34 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.3; i686; ; )
Cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com> <200905222032.55869.bzolnier@gmail.com> <1243062702.8509.7.camel@localhost.localdomain>
In-Reply-To: <1243062702.8509.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905231347.34717.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009 09:11:42 yanh wrote:
> 在 2009-05-22五的 20:32 +0200，Bartlomiej Zolnierkiewicz写道：
> > On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
> > > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > > 
> > > This is originally from the to-mips branch from
> > > http://dev.lemote.com/code/linux_loongson
> > 
> > Sadly, the patch description lacks all the important information.
> > 
> > What is the original problem that this fixup tries to address?
> > 
> > Is it limited to amd74xx controllers?
> 
> In loongson2f yeeloong machines, the ide controller is AMD cs5536, or
> say  amd74xx, and the hard drives is Fujistu. 

Then it should use the new & shiny :) native cs5536 IDE host driver
instead of legacy support in amd74xx...

> While debuging the hard disk suspned and resume, the ide irq can not be
> cleared. I guess this is a fake interrupt, hence the clear irq action
> can not be finished. 

AFAICS the only change that the fixup would cause for suspend/resume paths
is the one in ide_config_drive_speed() which is called during resume to set
transfer mode on the drive:

       tp_ops->write_devctl(hwif, ATA_NIEN | ATA_DEVCTL_OBS);

        memset(&tf, 0, sizeof(tf));
        tf.feature = SETFEATURES_XFER;
        tf.nsect   = speed;

        tp_ops->tf_load(drive, &tf, IDE_VALID_FEATURE | IDE_VALID_NSECT);

        tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
--->
        if (drive->quirk_list == 2)
                tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
--->
        error = __ide_wait_stat(drive, drive->ready_stat,
                                ATA_BUSY | ATA_DRQ | ATA_ERR,
                                WAIT_CMD, &stat);

Please tell me I if understand the issue correctly: if the above quirk is
not executed we end up with spurious IRQs, right?

> This patch is to fix this issue. Maybe other controller and drives also
> have this issue, but I am not sure.

Probably moving it to a generic quirk_drives list later will be useful...

Anyway this fixup needs to be ported to / verified with cs5536 first.

Thanks.
Bart
