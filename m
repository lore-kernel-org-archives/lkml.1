Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYBFWJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYBFWJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYBFWJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:09:13 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:44311 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYBFWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=d2Fxj6N566lXu5CFDSSwKU2aHsZPoTrhdVLaPx8V/p1ITo9PIsRU1D1YTi8fElg6/2PF+sUtp6ADcu1+gVcERXdrEhMsBE9jZyYccMt13NEJCb5CgqGlvPZCkJzBtzfqwri9MpwWw/BxbS18XNCU8/89XcmCeVmhYCTIDAk58Fc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Denis Cheng <crquan@gmail.com>
Subject: Re: [PATCH] ide-core: remove conditional compiling with MODULE in ide-core.c
Date: Wed, 6 Feb 2008 23:22:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1201938750-22423-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1201938750-22423-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802062322.02594.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 02 February 2008, Denis Cheng wrote:
> use module_init/module_exit to replace the original cond-compiling, these
> macros were well designed to deal module/built-in compiling.
> 
> the original __setup with null string was invalid and not executed,
> 	__setup("", ide_setup);

Seems to work fine for me with the latest git tree (just tried
"idebus=35" with IDE built-in and it works as expected).

[ "" - has always been a special way (or rather a special ugly hack)
  for handling "hdx=" and "idex=" kernel parameters ]

> however, with the current module_param mechanics, module parameters also can
> be input on the kernel command line, with this style:
> 
> 	ide-core.options="ide=nodma hdd=cdrom idebus=..."
> 
> so Documentation/kernel-parameters.txt also updated.

If we are going to change the currently working kernel parameters (which we
should do anyway because of other reasons, like need for handling warm-plugged
devices) we may as well use the occasion to rework it completely - making more
usage of parameter handling infrastructure present in kernel and getting rid
of passing everything through IDE core code (by moving the majority of these
parameters to where they should belong in the first place - IDE host drivers).

The sketch of how it is supposed to look like:

* Mark the rest of parameters for enabling probing of legacy VLB chipsets
  as obsoleted ("ide0=ali14xx", "ide0=umc8672", "ide0=dtc2278", "ide0=qd65xx",
  "ide0=cmd640_vlb" and "ide0=ht6560b" - the per host driver parameters have
  been available for a long time).  This should be as simple as replacing
  few "goto done;"-s by "goto obsolete_option;"-s.

* Mark "hdx=scsi" and "hdx=driver_name" as obsoleted (device-driver binding
  can be changed at runtime nowadays through sysfs + can be dealt with using
  per device driver parameters).

* Mark "hdx=remap" and "hdx=remap63" as obsoleted (they are layering violation
  and should be dealt with in the same way as done by libata - device-mapper
  should be used instead).

* Add ".pci_clock=" or ".vlb_clock=" parameter to 11 host drivers that
  use system_bus_clock().  Then obsolete "idebus=".

* Remove obsoleted "idex=nodma".

* "idex=base[,ctl[,irq]]" is going to be removed by a soon-to-posted
   patch series which adds warm-plug support (heh, it was ready two weeks
   ago but because of the "merge storm" I has been unable to _document_ it).

* Enable PIO auto-tuning in few drivers that still miss it and remove
  obsoleted "hdx=autotune"/"hdx=noautotune" parameters.

* Add "ide-4drives" host driver (I have a patch for this, needs refresh)
  and remove obsoleted "ide0=four" parameter.

* Remove obsoleted "idex=serialize" parameter.

* Remove obsoleted "idex=reset" parameter together with hwif->reset flag
  handling from ide-probe.c.

* Remove all other obsoleted "hdx="/"idex=" parameters.

* This would leave us with "idex=noprobe", "idex=ata66", "hdx=none/noprobe",
  "hdx=nowerr", "hdx=cdrom", "hdx=nodma", "hdx=noflush" and "hdx=c,h,s"
  parameters which should be passed through host drivers, i.e. for "hdc=nodma"
  and piix host driver - "piix.nodma=hdc" or even "piix.nodma=1.0" should be
  used instead.  I have some old draft patch partially implementing this
  (I will send it to you in PM as soon as I find it).

* The rest of parameters (== 5 "ide=" parameters) can be finally converted to
  use "ide_core.". :-)

[ The above plan may look like a lot of work but it really isn't - all
  changes are easy or even trivial to convey.  It should be also really
  worth to do it because together with removing __setup("", ...) hack
  it should remove 300-400 LOC from ide.c. ]

Thanks,
Bart

> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  Documentation/kernel-parameters.txt |   11 +------
>  drivers/ide/ide.c                   |   55 ++++++++++++++--------------------
>  2 files changed, 25 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index cf38689..c94730c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -759,15 +759,8 @@ and is between 256 and 4096 characters. It is defined in the file
>  	icn=		[HW,ISDN]
>  			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
>  
> -	ide=		[HW] (E)IDE subsystem
> -			Format: ide=nodma or ide=doubler or ide=reverse
> -			See Documentation/ide.txt.
> -
> -	ide?=		[HW] (E)IDE subsystem
> -			Format: ide?=noprobe or chipset specific parameters.
> -			See Documentation/ide.txt.
> -
> -	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
> +	ide-core.options= [HW] (E)IDE subsystem
> +			Format: ide-core.options="ide=nodma hdd=cdrom idebus=..."
>  			See Documentation/ide.txt.
>  
>  	idle=		[X86]
> diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
> index ab9ca2b..28923ef 100644
> --- a/drivers/ide/ide.c
> +++ b/drivers/ide/ide.c
> @@ -1654,6 +1654,25 @@ struct bus_type ide_bus_type = {
>  
>  EXPORT_SYMBOL_GPL(ide_bus_type);
>  
> +static char *options;
> +module_param(options, charp, S_IRUGO);
> +MODULE_LICENSE("GPL");
> +
> +static void __init parse_options(char *line)
> +{
> +	char *next = line;
> +
> +	if (line == NULL || !*line)
> +		return;
> +	while ((line = next) != NULL) {
> +		next = strchr(line, ' ');
> +		if (next != NULL)
> +			*next++ = 0;
> +		if (!ide_setup(line))
> +			printk(KERN_INFO "Unknown option '%s'\n", line);
> +	}
> +}
> +
>  /*
>   * This is gets invoked once during initialization, to set *everything* up
>   */
> @@ -1661,6 +1680,8 @@ static int __init ide_init(void)
>  {
>  	int ret;
>  
> +	parse_options(options);
> +
>  	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
>  	system_bus_speed = ide_system_bus_speed();
>  
> @@ -1681,32 +1702,7 @@ static int __init ide_init(void)
>  	return 0;
>  }
>  
> -#ifdef MODULE
> -static char *options = NULL;
> -module_param(options, charp, 0);
> -MODULE_LICENSE("GPL");
> -
> -static void __init parse_options (char *line)
> -{
> -	char *next = line;
> -
> -	if (line == NULL || !*line)
> -		return;
> -	while ((line = next) != NULL) {
> - 		if ((next = strchr(line,' ')) != NULL)
> -			*next++ = 0;
> -		if (!ide_setup(line))
> -			printk (KERN_INFO "Unknown option '%s'\n", line);
> -	}
> -}
> -
> -int __init init_module (void)
> -{
> -	parse_options(options);
> -	return ide_init();
> -}
> -
> -void __exit cleanup_module (void)
> +static void __exit ide_exit(void)
>  {
>  	int index;
>  
> @@ -1718,10 +1714,5 @@ void __exit cleanup_module (void)
>  	bus_unregister(&ide_bus_type);
>  }
>  
> -#else /* !MODULE */
> -
> -__setup("", ide_setup);
> -
>  module_init(ide_init);
> -
> -#endif /* MODULE */
> +module_exit(ide_exit);
