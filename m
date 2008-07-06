Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYGFBQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYGFBQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 21:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYGFBQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 21:16:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:54623 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753195AbYGFBQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 21:16:40 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX18tN9EwGI0t11xEISaIvbpSJ6w/QReF+sgk6Dq6+N
	flABLbMcQdG8u9
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
Date: Sun, 6 Jul 2008 03:15:50 +0200
User-Agent: KMail/1.9.6
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1214139259.2994.8.camel@jaswinder.satnam>
In-Reply-To: <1214139259.2994.8.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807060315.51736@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh wrote:
> There's no point in this, since the user can use the BUILTIN_FIRMWARE
> option to include arbitrary firmware files directly in the kernel image.

NAK! This option allows to compile the firmware into the _driver_,
which is very useful if you want to test various driver/firmware
combinations. Having the firmware in the _kernel_ does not help!

Well, I am tired to fight for this option in the kernel every other
month. :-(

@Mauro:
Is there a way to strip this stuff from Kconfig/Makefile/av7110*.[ch]
for submission to the kernel? Basically I don't care whether and how
they cripple the driver in the kernel. But I would like to keep the code
'as is' in the linuxtv repositories.

CU
Oliver

>
> Thanks to David Woodhouse for help.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> --
> drivers/media/dvb/ttpci/Kconfig  |   23 +++----------------
> drivers/media/dvb/ttpci/Makefile |    9 -------
> drivers/media/dvb/ttpci/av7110.c |   16 -------------
> drivers/media/dvb/ttpci/fdump.c    |   44 -------------------------------------
> 4 files changed, 4 insertions(+), 88 deletions(-)
> diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
> index e0bbcaf..6b7a586 100644
> --- a/drivers/media/dvb/ttpci/Kconfig
> +++ b/drivers/media/dvb/ttpci/Kconfig
> @@ -6,7 +6,7 @@ config DVB_AV7110
>  	tristate "AV7110 cards"
>  	depends on DVB_CORE && PCI && I2C
>  	depends on HOTPLUG
> -	select FW_LOADER if !DVB_AV7110_FIRMWARE
> +	select FW_LOADER
>  	select TTPCI_EEPROM
>  	select VIDEO_SAA7146_VV
>  	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
> @@ -30,6 +30,9 @@ config DVB_AV7110
>  	  download/extract it, and then copy it to /usr/lib/hotplug/firmware
>  	  or /lib/firmware (depending on configuration of firmware hotplug).
>  
> +	  Alternatively, you can download the file and use the 
> +	  BUILTIN_FIRMWARE option to build it into your kernel image.
> +
>  	  Say Y if you own such a card and want to use it.
>  
>  config DVB_AV7110_BOOTCODE
> @@ -39,24 +42,6 @@ config DVB_AV7110_BOOTCODE
>  	  This includes firmware for AV7110 bootcode
>  	  Say 'N' and let it get loaded from userspace on demand 
>  
> -config DVB_AV7110_FIRMWARE
> -	bool "Compile AV7110 firmware into the driver"
> -	depends on DVB_AV7110 && !STANDALONE
> -	default y if DVB_AV7110=y
> -	help
> -	  The AV7110 firmware is normally loaded by the firmware hotplug manager.
> -	  If you want to compile the firmware into the driver you need to say
> -	  Y here and provide the correct path of the firmware. You need this
> -	  option if you want to compile the whole driver statically into the
> -	  kernel.
> -
> -	  All other people say N.
> -
> -config DVB_AV7110_FIRMWARE_FILE
> -	string "Full pathname of av7110 firmware file"
> -	depends on DVB_AV7110_FIRMWARE
> -	default "/usr/lib/hotplug/firmware/dvb-ttpci-01.fw"
> -
>  config DVB_AV7110_OSD
>  	bool "AV7110 OSD support"
>  	depends on DVB_AV7110
> diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/dvb/ttpci/Makefile
> index d7483f1..a7ff3cd 100644
> --- a/drivers/media/dvb/ttpci/Makefile
> +++ b/drivers/media/dvb/ttpci/Makefile
> @@ -14,12 +14,3 @@ obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
>  obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
>  
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
> -
> -hostprogs-y	:= fdump
> -
> -ifeq ($(CONFIG_DVB_AV7110_FIRMWARE),y)
> -$(obj)/av7110.o: $(obj)/av7110_firm.h
> -
> -$(obj)/av7110_firm.h: $(obj)/fdump
> -	$(obj)/fdump $(CONFIG_DVB_AV7110_FIRMWARE_FILE) dvb_ttpci_fw $@
> -endif
> diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
> index 747e7f1..c11a13c 100644
> --- a/drivers/media/dvb/ttpci/av7110.c
> +++ b/drivers/media/dvb/ttpci/av7110.c
> ...

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
