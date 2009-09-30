Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZI3N7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZI3N7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZI3N7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:59:04 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.45]:35682 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZI3N7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:59:03 -0400
Message-ID: <20090930155903.138834zqtgkgh8ao@webmail.df.eu>
Date: Wed, 30 Sep 2009 15:59:03 +0200
From: Bernhard Walle <bernhard@bwalle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Always print panic message on current console
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 153.96.175.71
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org>:
>>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index bcdef26..f9950e3 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -22,6 +22,7 @@
>> #include <linux/init.h>
>> #include <linux/nmi.h>
>> #include <linux/dmi.h>
>> +#include <linux/tty.h>
>
> It's odd that kmsg_redirect is declared in tty.h when it's purely a
> vt.c thing.  Why not vt.h?

Sorry, I don't know. It was there before my patch. :-)

>> int panic_on_oops;
>> static unsigned long tainted_mask;
>> @@ -65,6 +66,9 @@ NORET_TYPE void panic(const char * fmt, ...)
>> 	 */
>> 	preempt_disable();
>>
>> +	/* don't redirect the panic message to some hidden console */
>> +	kmsg_redirect = 0;
>> +
>> 	bust_spinlocks(1);
>> 	va_start(args, fmt);
>> 	vsnprintf(buf, sizeof(buf), fmt, args);
>
> Methinks CONFIG_HW_CONSOLE=n kernels won't link after making this
> change.
>
> I'd suggest something like
>
> #ifdef CONFIG_HW_CONSOLE
> extern void vt_set_kmsg_redirect(int vt);
> #else
> static inline void vt_set_kmsg_redirect(int vt)
> {
> }
> #endif

Sounds good. I will send a new patch for this.

> Another possible way of doing this would be for vt.c to hook itself
> into panic_notifier_list.  That's nice and clean from a
> separation-of-subsystems POV but isn't really conceptually correct - it
> assumes that other entries on panic_notifier_list don't print messages
> to the console.

I also thought about that, but I found it a bit oversized just for setting
a variable (in the panic case). Also, the panic() function does other things
(like blinking the keyboard LEDs) very direct, without abstraction. But
however, if you or other people think that this is the way to go, I have
no objections and will create a patch.


Regards,
Bernhard




