Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbXKETG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbXKETG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXKETGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:06:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.76.152]:41753 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbXKETGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:06:51 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2007 14:06:51 EST
Date: Mon, 05 Nov 2007 18:57:08 +0000
From: Enver Haase <a2232@gmx.net>
Subject: Re: [PATCH] ser_a2232.c bug removed: handles "IRQ request denied" case
In-reply-to: <20070910023205.d7aaefc7.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Message-id: <472F6784.9080900@gmx.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 1.5.0.7 (X11/20060915)
References: <Pine.LNX.4.64.0708301609120.21063@haneman.hacenet>
 <20070910023205.d7aaefc7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Well... I realize there's no point in fixing things which I cannot
even see going wrong: I cannot get hold of another A2232 after the
one I had used before went missing.

So until someone contacts me to supply me with a A2232 card, this
driver is an "Orphan" now, sorry.

Changed "Orphaned" to "Orphan", as this is the official "S:" value.

Patch is against Linux-2.6.23.1 .

--- MAINTAINERS.old	2007-11-05 18:50:33.000000000 +0000
+++ MAINTAINERS	2007-11-05 18:51:06.000000000 +0000
@@ -178,10 +178,9 @@

 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
-M:	ehaase@inf.fu-berlin.de
-M:	A2232@gmx.net
+M:	a2232@mauerkinder.co.uk
 L:	linux-m68k@lists.linux-m68k.org
-S:	Maintained
+S:	Orphan

 AIO
 P:	Benjamin LaHaise
@@ -1248,13 +1247,13 @@
 M:	Eng.Linux@digi.com
 L:	Eng.Linux@digi.com
 W:	http://www.digi.com
-S:	Orphaned
+S:	Orphan

 DIGI RIGHTSWITCH NETWORK DRIVER
 P:	Rick Richardson
 L:	netdev@vger.kernel.org
 W:	http://www.digi.com
-S:	Orphaned
+S:	Orphan

 DIRECTORY NOTIFICATION
 P:	Stephen Rothwell



Regards,
Enver




Andrew Morton wrote:
> On Thu, 30 Aug 2007 16:13:55 +0100 (BST) The AmigaLinux A2232 Driver Project <A2232@gmx.net> wrote:
> 
>>
>> This patch handles the case in which the request for the
>> vertical blank interrupt could not be granted. Thanks to
>> Nazia Zaman for spotting it.
>>
>> Applies to latest 2.6.x kernels.
>>
>>
>> --- linux/drivers/char/ser_a2232.c.org	2007-08-30 15:41:25.000000000 +0100
>> +++ linux/drivers/char/ser_a2232.c	2007-08-30 15:46:17.000000000 +0100
>> @@ -787,7 +787,7 @@ static int __init a2232board_init(void)
>>
>>   	}
>>
>> -	printk("Total: %d A2232 boards initialized.\n", nr_a2232); /* Some status report if no card was found */
>> +	printk("Total: %d A2232 boards detected.\n", nr_a2232); /* Some status report if no card was found */
>>
>>   	a2232_init_portstructs();
>>
>> @@ -795,9 +795,13 @@ static int __init a2232board_init(void)
>>   		a2232_init_drivers also registers the drivers. Must be here because all boards
>>   		have to be detected first.
>>   	*/
>> -	if (a2232_init_drivers()) return -ENODEV; // maybe we should use a different -Exxx?
>> +	if (a2232_init_drivers())
>> +		return -ENODEV; // maybe we should use a different -Exxx?
>>
>> -	request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID);
>> +	if (request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID))
>> +		return -ENODEV;
> 
> We're going to need to undo the things which a2232_init_drivers() just did.
> There's a memory leak and the registered tty driver might even cause a
> crash if someone tries to use it?
> 
> Perhaps requesting the IRQ before running a2232_init_drivers() would be a
> suitable approach.
> 
> 
>> +	printk("A2232 driver initialized successfully.\n");
>>   	return 0;
>>   }
>>
> 
