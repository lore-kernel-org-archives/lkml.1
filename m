Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbZC3U0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbZC3U0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZC3U0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:26:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:17913 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbZC3U0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=RywCvEk7JEGpxAenOMBJt9gNjqeMYNpGkGZAKlO4tj2L4oeDhx/7kVaCmuBH0on/xU
         kj7nkGLbUI1hUC7AgW/BtPBdvyW4zn7XcFfAxAWO2SleR3kvKlfHGvBM7In+OsS5fm2y
         1QMEic2JbFfy4JziCH3S4qelKyHfDfniP/680=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable workaround
Date: Mon, 30 Mar 2009 22:28:54 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Michael Roth <mroth@nessie.de>, linux-kernel@vger.kernel.org
References: <49CFCB2A.4020505@nessie.de> <49CFEA24.10700@nessie.de> <20090330072713.GA13776@liondog.tnic>
In-Reply-To: <20090330072713.GA13776@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903302228.54601.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Borislav Petkov wrote:
> Hi Michael,
> 
> On Sun, Mar 29, 2009 at 11:37:40PM +0200, Michael Roth wrote:
> > Hello Borislav,
> > 
> > thank you for your help.
> > 
> > Borislav Petkov schrieb:
> > 
> > >  Can we please see a dmesg of a working
> > > kernel on your machine
> > 
> > Sure, dmesg output appended beneath. I also added the dmesg output
> > of the patched kernel. See below.
> > 
> > 
> > > and also is it possible to catch any kernel output of the crash
> > > any oops or something when your machine freezes - the more the better.
> > 
> > There aren't any messages, neither on the console nor in the syslog.
> > The kernel simple freeze, cursor on the console stops blinking, no
> > more ide activity. I have to hit the reset-bottom to restart.
> > 
> > 
> > > Probably over a serial console would be best but photographed
> > > with a digicam and uploaded somewhere as a screenshot would do too.
> > 
> > I will do that on request, but it will take some time (about days)
> > because currently I don't have access to a second computer or so.
> 
> That'll definitely be very helpful since I wanna know exactly why it
> locks up. If you still have no output it'd be cool if you could enable
> ide-cd debugging and retry catching the output. Here's a patch for that,
> just recompile and reboot (I admit this is not one of the finest ways to
> enable debugging but since this is work in progress...:) ):
> 
> --
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index e9d042d..4ef3b7e 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -8,6 +8,8 @@
>  #include <linux/ide.h>
>  #include <scsi/scsi.h>
>  
> +#define DEBUG 1
> +
>  #ifdef DEBUG
>  #define debug_log(fmt, args...) \
>  	printk(KERN_INFO "ide: " fmt, ## args)
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index ddfbea4..ea36295 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1991,7 +1991,7 @@ static int ide_cd_probe(ide_drive_t *drive)
>  		}
>  	}
>  
> -	drive->debug_mask = debug_mask;
> +	drive->debug_mask = 0xffffffff;
>  	drive->irq_handler = cdrom_newpc_intr;
>  
>  	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
> diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
> index c878bfc..225afca 100644
> --- a/drivers/ide/ide-cd.h
> +++ b/drivers/ide/ide-cd.h
> @@ -8,7 +8,7 @@
>  #include <linux/cdrom.h>
>  #include <asm/byteorder.h>
>  
> -#define IDECD_DEBUG_LOG		0
> +#define IDECD_DEBUG_LOG		1
>  
>  #if IDECD_DEBUG_LOG
>  #define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
> 
> > > You could also try the following patch to see whether that is of any
> > > help:
> > 
> > Your patch helps perfectly. I'm writing this email on the patched
> > 2.6.29. I also tested CD and DVD access: They work well. Burning not
> > tested but I assume it will work too.
> 
> @Bart: can you take at look at this. Somehow, if the device is behind a
> PCI IDE controller, the order of issuing the command and enabling DMA is
> important. Seen something like that before?

Spec is unclear on the ordering but empirically it seems that some hosts
may need packet command to start DMA.  I think that we should proceed with
your patch (please repost with patch description) and also apply the same
change to the rest of ATAPI devices in a subsequent patch.

Thanks,
Bart
