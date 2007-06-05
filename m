Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbXFELIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbXFELIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXFELHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:07:54 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:47400 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751802AbXFELHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:07:53 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Subject: Re: [KJ] Re: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
References: <87odjvu1on.fsf@wanadoo.fr>
	<20070604210018.0eaa20a0.akpm@linux-foundation.org>
Date: Tue, 05 Jun 2007 13:05:18 +0200
In-Reply-To: <20070604210018.0eaa20a0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 4 Jun 2007 21:00:18 -0700")
Message-ID: <87k5uimzkh.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> 
>>  net/wan/lmc/lmc_main.c        |    2 +-
>>  scsi/megaraid/megaraid_mm.c   |    2 +-
>>  usb/serial/io_ti.c            |    2 +-
>>  usb/serial/ti_usb_3410_5052.c |    2 +-
>>  usb/serial/whiteheat.c        |    6 +++---
>>  5 files changed, 7 insertions(+), 7 deletions(-)
>
> This patch covers three areas of maintainer responsibility, so poor old me
> has to split it up and redo the changelogs.  Oh well.

Sorry. 

For modifications that crosscut the kernel it is not very practical to
look each time for the maintainer. We plan to send a patch that
replaces some calls to kmalloc/memset with kzalloc; do we have to split
it for each maintainer ?

>> diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
>> index ae132c1..750b3ef 100644
>> --- a/drivers/net/wan/lmc/lmc_main.c
>> +++ b/drivers/net/wan/lmc/lmc_main.c
>> @@ -483,7 +483,7 @@ #endif /* end ifdef _DBG_EVENTLOG */
>>                              break;
>>                      }
>>  
>> -                    data = kmalloc(xc.len, GFP_KERNEL);
>> +                    data = kmalloc(xc.len, GFP_ATOMIC);
>>                      if(data == 0x0){
>>                              printk(KERN_WARNING "%s: Failed to allocate memory for copy\n", dev->name);
>>                              ret = -ENOMEM;
>
> A few lines later we do:
>
> 	if(copy_from_user(data, xc.data, xc.len))
>
> which also is illegal under spinlock.

I have launched my tool to detect such situations and I get this 
(in a diff-like format).

--- /home/pad/kernels/git/linux-2.6/arch/cris/arch-v10/drivers/gpio.c	2007-03-27 15:12:38.000000000 +0200
+++ /tmp/output.c	2007-06-05 11:38:47.000000000 +0200
@@ -776,7 +776,7 @@
 		/* bits set in *arg is set to input,
 		 * *arg updated with current input pins.
 		 */
-		if (copy_from_user(&val, (unsigned long*)arg, sizeof(val)))
 		{
 			ret = -EFAULT;
 			break;
@@ -789,7 +789,7 @@
 		/* bits set in *arg is set to output,
 		 * *arg updated with current output pins.
 		 */
-		if (copy_from_user(&val, (unsigned long*)arg, sizeof(val)))
 		{
 			ret = -EFAULT;
 			break;


--- /home/pad/kernels/git/linux-2.6/arch/mips/au1000/common/power.c	2007-03-27 15:12:41.000000000 +0200
+++ /tmp/output.c	2007-06-05 11:38:57.000000000 +0200
@@ -330,7 +330,7 @@
 			spin_unlock_irqrestore(&pm_lock, flags);
 			return -EFAULT;
 		}
-		if (copy_from_user(buf, buffer, *len)) {
 			spin_unlock_irqrestore(&pm_lock, flags);
 			return -EFAULT;
 		}

and some cases in lmc_main.c


>
>
> Frankly, I think that a better use of this tool would be to just report on
> the errors, let humans fix them up.

Ok. Do you have a preference on the format ?  a <file>:<line> format  ?

Is there a place that gathered all those implicit programming rules 
(that copy_from_user must not be called inside a spinlock, etc) so that
I can translate them in a script for our tool.


