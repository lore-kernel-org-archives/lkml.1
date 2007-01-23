Return-Path: <linux-kernel-owner+w=401wt.eu-S965611AbXAXCFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965611AbXAXCFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965612AbXAXCFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:05:50 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:38045 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965611AbXAXCFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:05:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=U8L30gOHHijhXZZbFCglrJ5qnpgnrmfiBZVxROCIKXps9ICJxDifssFsMffigKrKHTwdrEv2CMkgYnt3E/28b5gp21nmZ2EE/Zh5eVTcJA6AyxjDuBlIrkvH6cYkSThbcYaT6MwB2vfhX4S2QuKsa8NAHxNqrsBVw9vCSabCN98=  ;
X-YMail-OSG: SuqQQa4VM1msDR_U5Mc7Mh__qxkpa0eZzJUDYUwyy3bsUh0kpQx.s5PB9JNW7GY.zutLtyouFaP6kXlATcBs9kQWzT0fMHB8jMwcwgqFNLyJ4E2CPBo-
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 2.6.20-rc5] SPI: alternative fix for spi_busnum_to_master
Date: Tue, 23 Jan 2007 15:43:56 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, akpm@osdl.org
References: <200701221412.02452.david-b@pacbell.net> <200701230742.15531.david-b@pacbell.net> <20070124.010741.130240814.anemo@mba.ocn.ne.jp>
In-Reply-To: <20070124.010741.130240814.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701231543.56669.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 January 2007 8:07 am, Atsushi Nemoto wrote:
> On Tue, 23 Jan 2007 07:42:15 -0800, David Brownell <david-b@pacbell.net> wrote:
> > > Indeed the check can be omitted.  Should I send a new patch just
> > > moving class_device_get() into "if (master->bus_num == bus_num)"
> > > block?
> > 
> > Yes, please.
> 
> OK, here is.  This patch uses spi_master_get() instead of
> class_device_get().

Much better.  This should be merged for 2.6.20 ...

> 
> 
> Subject: SPI: alternative fix for spi_busnum_to_master
> 
> If a SPI master device exists, udev (udevtrigger) causes kernel crash,
> due to wrong kobj pointer in kobject_uevent_env().  This problem was
> not in 2.6.19.
> 
> The backtrace (on MIPS) was:
> [<8024db6c>] kobject_uevent_env+0x54c/0x5e8
> [<802a8264>] store_uevent+0x1c/0x3c  (in drivers/class.c)
> [<801cb14c>] subsys_attr_store+0x2c/0x50
> [<801cb80c>] flush_write_buffer+0x38/0x5c
> [<801cb900>] sysfs_write_file+0xd0/0x190
> [<80181444>] vfs_write+0xc4/0x1a0
> [<80181cdc>] sys_write+0x54/0xa0
> [<8010dae4>] stack_done+0x20/0x3c
> 
> flush_write_buffer() passes kobject of spi_master_class.subsys to
> subsys_addr_store(), then subsys_addr_store() passes a pointer to a
> struct subsystem to store_uevent() which expects a pointer to a struct
> class_device.  The problem seems subsys_attr_store() called instead of
> class_device_attr_store().
> 
> This mismatch was caused by commit
> 3bd0f6943520e459659d10f3282285e43d3990f1, which overrides kset of
> master class.  This made spi_master_class.subsys.kset.ktype NULL so
> subsys_sysfs_ops is used instead of class_dev_sysfs_ops.
> 
> The commit was to fix spi_busnum_to_master().  Here is a patch fixes
> this function in other way, just searching children list of
> class_device.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 270e621..6307428 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -366,7 +366,6 @@ spi_alloc_master(struct device *dev, uns
>  
>  	class_device_initialize(&master->cdev);
>  	master->cdev.class = &spi_master_class;
> -	kobj_set_kset_s(&master->cdev, spi_master_class.subsys);
>  	master->cdev.dev = get_device(dev);
>  	spi_master_set_devdata(master, &master[1]);
>  
> @@ -466,14 +465,20 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
>   */
>  struct spi_master *spi_busnum_to_master(u16 bus_num)
>  {
> -	char			name[9];
> -	struct kobject		*bus;
> -
> -	snprintf(name, sizeof name, "spi%u", bus_num);
> -	bus = kset_find_obj(&spi_master_class.subsys.kset, name);
> -	if (bus)
> -		return container_of(bus, struct spi_master, cdev.kobj);
> -	return NULL;
> +	struct class_device	*cdev;
> +	struct spi_master	*master = NULL;
> +	struct spi_master	*m;
> +
> +	down(&spi_master_class.sem);
> +	list_for_each_entry(cdev, &spi_master_class.children, node) {
> +		m = container_of(cdev, struct spi_master, cdev);
> +		if (m->bus_num == bus_num) {
> +			master = spi_master_get(m);
> +			break;
> +		}
> +	}
> +	up(&spi_master_class.sem);
> +	return master;
>  }
>  EXPORT_SYMBOL_GPL(spi_busnum_to_master);
>  
> 
