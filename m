Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYEFINu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYEFINu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYEFINa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:13:30 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:58671 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754857AbYEFIN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:13:27 -0400
Message-ID: <48201368.1090200@seznam.cz>
Date: Tue, 06 May 2008 10:14:32 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 18/56] microblaze_v2: early_printk support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>	 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>	 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>	 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>	 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>	 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>	 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>	 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>	 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>	 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu> <1210029754.5798.145.camel@localhost>
In-Reply-To: <1210029754.5798.145.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sense.
I'll add it.

Thanks,
M
> On Sun, 2008-05-04 at 13:41 +0200, monstr@seznam.cz wrote:
> 
>> +++ b/arch/microblaze/kernel/early_printk.c
> 
>> +static void early_printk_putc(char c)
>> +{
>> +	while (ioread32(STATUS) & (1<<3));
>> +	iowrite32((c & 0xff), TX_FIFO);
>> +}
> 
> The while() loop needs a retry counter - if you configure
> EARLY_PRINTK_BASE_ADDRESS wrongly and it points to memory or anything
> that is not a uartlite, the loop spins forever and you get silent
> lockup.  Not nice behaviour from debug code :)
> 
> Here's my current implementation:
> 
> static void early_printk_putc(char c)
> {
>         /* Limit how many times we'll spin waiting for TX FIFO status.
>            This will prevent lockups if the base address is incorrectly
> set, or
>            any other issue on the UARTLITE.
> 
>            This limit is pretty arbitrary, unless we are at about 10
> baud 
>            we'll never timeout on a working UART. */
> 
>         unsigned retries=10000;
>         while (retries-- && (ioread32(STATUS) & (1<<3)))
>                 ;
> 
>         /* Only attempt the iowrite if we didn't timeout */
>         if(retries)
>                 iowrite32((c & 0xff), TX_FIFO);
> }
> 
> Cheers
> 
> John
> 
> 
> 
> 
