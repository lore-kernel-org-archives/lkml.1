Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXJ2PRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXJ2PRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXJ2PRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:17:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41009 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbXJ2PRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:17:13 -0400
Date: Mon, 29 Oct 2007 15:16:47 +0000 (GMT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m & CONFIG_VIDEO_SAA7146_VV=y
In-Reply-To: <20071029112303.GA18994@elte.hu>
Message-ID: <Pine.LNX.4.64.0710291125250.6567@pentafluge.infradead.org>
References: <20071026073736.GA24172@elte.hu> <20071027213057.GA15211@linuxtv.org>
 <20071027163932.e0a0522b.randy.dunlap@oracle.com> <20071029112303.GA18994@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Ingo Molnar wrote:

>
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>>> config VIDEO_SAA7146_VV
>>> 	tristate
>>> 	depends on VIDEO_DEV = y || VIDEO_DEV = VIDEO_SAA7146_VV
>>> 	select VIDEOBUF_DMA_SG
>>> 	select VIDEO_SAA7146
>>>
>>> (untested)
>>
>> Nope, won't work.  I tried that last night.  VIDEO_DEV_SAA7146_VV
>> has too many "select"s involved, but select doesn't follow the dependency
>> chains.  IOW, as written in Documentation/kbuild/kconfig-language.txt:
>>
>> 	select is evil.... select will by brute force set a symbol
>> 	equal to 'y' without visiting the dependencies. So abusing
>> 	select you are able to select a symbol FOO even if FOO depends
>> 	on BAR that is not set.
>
> so ... what should we do? Remove those ~7 select VIDEO_SAA7146_VV lines
> and replace them with depends on VIDEO_SAA7146_VV ?

If select is not following the dependency chains, This would mean that we may 
need to rewrite also on other parts of /drivers/media Kconfig files that may 
be suffering the same kind of trouble.

There are several places where a similar logic is used, to select modules that 
are present only on some configurations.

For example, by default, bttv module selects all possible audio TV decoders 
that can be needed by a bttv device (msp34xx, tvaudio, tda7432, ...). Just one 
audio decoder is needed for a specific bttv hardware. So, there's also an 
option to manually select just the needed drivers.

The actual logic is:

menu "Encoders/decoders and other helper chips"
         depends on !VIDEO_HELPER_CHIPS_AUTO

config VIDEO_TVAUDIO
         tristate "Simple audio decoder chips"
         depends on VIDEO_V4L1 && I2C
...
endmenu

config VIDEO_BT848
         tristate "BT848 Video For Linux"
         depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L1
         select I2C_ALGOBIT
         select FW_LOADER
         select VIDEO_BTCX
         select VIDEOBUF_DMA_SG
         select VIDEO_IR
         select VIDEO_TUNER
         select VIDEO_TVEEPROM
         select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
         select VIDEO_TVAUDIO if VIDEO_HELPER_CHIPS_AUTO
         select VIDEO_TDA7432 if VIDEO_HELPER_CHIPS_AUTO
         select VIDEO_TDA9875 if VIDEO_HELPER_CHIPS_AUTO

Also, the same audio decoders can be used by other devices. For example, 
msp34xx is used also with pvrusb2 and several em28xx devices.

So, converting this to "depend on" won't be trivial, since there's no direct 
dependency of a bridge driver (cx88, bttv, pvrusb2) and an auxiliary i2c 
device (msp34xx, tvaudio, ir, ...).

There's something weird, though. The select does the proper thing for tuners. 
Why is it failing for SAA7146_VV?

-- 
Cheers,
Mauro
