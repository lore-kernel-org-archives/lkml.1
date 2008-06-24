Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYFXJfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYFXJfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYFXJfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:35:09 -0400
Received: from mail.atmel.fr ([81.80.104.162]:60814 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbYFXJfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:35:06 -0400
Message-ID: <4860BFBD.6050203@atmel.com>
Date: Tue, 24 Jun 2008 11:34:53 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sdio: bad CISTPL_FUNCE error
References: <485BCBB3.20405@atmel.com> <alpine.LFD.1.10.0806211045390.2979@xanadu.home> <485FAF34.8000609@atmel.com> <alpine.LFD.1.10.0806231059250.2979@xanadu.home>
In-Reply-To: <alpine.LFD.1.10.0806231059250.2979@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre :
> On Mon, 23 Jun 2008, Nicolas Ferre wrote:
> 
>> Here is the log :
>> mmc0: bad function CISTPL_FUNCE size 28 type 1
> 
> If you look in cistpl_funce_func() you'll find this code:
> 
>         vsn = func->card->cccr.sdio_vsn;
>         min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
>         if (size < min_size || buf[0] != 1)
>                 return -EINVAL;
> 
> I suspect your card might be buggy wrt the SDIO standard.
> 
> You could try printing out the value of vsn here, and then hardcode it 
> to SDIO_SDIO_REV_1_00 to see if that helps.

Indeed, I hardcode the value with SDIO_SDIO_REV_1_00 and the card 
seems to identify itself better :

vsn = 0x1, buf[0] = 0x1
mmc0: starting CMD52 arg 0020e400 flags 00000195
Sending command 52 as 00001074, arg = 0020E400, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C1E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c1e5 [000010FF 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 000010ff 00000000 00000000 00000000
mmc0: read tpl 0xff
mmc0: new SDIO card at address 0001

So far, so good...

But when going to the next step, it hangs in sdio_uart probing :
mmc0: starting CMD52 arg 800220c0 flags 00000195
Sending command 52 as 00001074, arg = 800220C0, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C1E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c1e5 [000010C0 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 000010c0 00000000 00000000 00000000
mmc0: starting CMD52 arg 80022201 flags 00000195
Sending command 52 as 00001074, arg = 80022201, blocks = 0, length = 0 (MR = 00001B01)
MCI irq: status = 0000C1E5, C07F0001, 00000001
Command ready
Completed command
Status = 00000001/0000c1e5 [00001101 00000000 00000000 00000000]
mmc0: req done (CMD52): 0: 00001101 00000000 00000000 00000000
sdio_uart: probe of mmc0:0001:1 failed with error -34

It seems that I have a out of range error in R5 now...

Regards,
-- 
Nicolas Ferre

