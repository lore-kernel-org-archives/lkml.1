Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYLOUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYLOUER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYLOUEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:04:07 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:39370 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYLOUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:04:06 -0500
Message-ID: <4946B80B.4010609@oracle.com>
Date: Mon, 15 Dec 2008 12:03:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx
Subject: Re: mmotm 2008-12-03-01-50 uploaded (sdhci)
References: <200812031006.mB3A6BRM004500@imap1.linux-foundation.org>	<4936F1C4.5060404@oracle.com> <20081214184018.157062da@mjolnir.drzeus.cx>
In-Reply-To: <20081214184018.157062da@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4946B801.00E5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Wed, 03 Dec 2008 12:53:24 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2008-12-03-01-50 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> It contains the following patches against 2.6.28-rc7:
>>
>> drivers/built-in.o: In function `sdhci_remove_host':
>> (.text+0xd246a): undefined reference to `led_classdev_unregister'
>> drivers/built-in.o: In function `sdhci_add_host':
>> (.text+0xd5378): undefined reference to `led_classdev_register'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>>
>> sdhci.c tries to handle the availability of led_()* without using
>> Kconfig attributes.  In this case, MMC_SDHCI=y and LEDS_CLASS=m,
>> which sdhci.c doesn't handle.
>>
> 
> I'm not sure how to properly solve this. I'm not a big fan of adding a
> specific Kconfig option for each and every optional feature. I'd prefer
> if we get the correct thing<tm> based on just the MMC_SDHCI and
> LEDS_CLASS options.
> 
> -#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> +#if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE)
>  	&& !defined(CONFIG_MMC_SDHCI_MODULE))
> 
> perhaps?

Hi Pierre,

If I change the last line above to
	&& defined(CONFIG_MMC_SDHCI_MODULE)
then it builds OK.  Using !defined still has build errors...
and I think that my small change is also correct.

However, I'd prefer to see this done with Kconfig and then use
empty stubs for the functions that wouldn't be called.


I think that you should audit the other uses of
#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)

in sdhci.c as well.

Also, in sdhci_add_host(), why is the call to free_irq() inside the
CONFIG_LEDS block:

#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
reset:
	sdhci_reset(host, SDHCI_RESET_ALL);
	free_irq(host->irq, host);
#endif


HTH.
~Randy
