Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYGVRgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYGVRgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYGVRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:36:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:39706 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYGVRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jSFBuP3EkGkWcYktHoLYdHTj0CBezyIam4pocyeeXhf18UAm9GAqh3hyStQjb9SU0D
         lwiQtpx6sJWbM8eJNKznDkqbfz3wczEpcQzWfp9gXUeRj5ZCPBfx16+XldFgDtZ1xPjq
         9ho+orVgq9myLPUONnG0vdUaGlMmC3S8K590k=
Date: Tue, 22 Jul 2008 18:35:09 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [Patch] um: fix a build error
Message-ID: <20080722173509.GE3081@hack.voiplan.pt>
References: <20080722105812.GB5283@alice> <20080722115354.79ba2314@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722115354.79ba2314@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:53:54AM +0100, Alan Cox wrote:
>> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
>> 
>> --- linux-2.6/arch/um/drivers/line.c.orig	2008-07-22 12:06:17.000000000 +0200
>> +++ linux-2.6/arch/um/drivers/line.c	2008-07-22 12:06:49.000000000 +0200
>> @@ -362,10 +362,8 @@ static irqreturn_t line_write_interrupt(
>>  	if (tty == NULL)
>>  		return IRQ_NONE;
>>  
>> -	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
>> -	   (tty->ldisc.write_wakeup != NULL))
>> -		(tty->ldisc.write_wakeup)(tty);
>> -
>> +	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
>> +		tty_wakeup(tty);
>
>Sorry I should have been clearer - you don't want the test_bit either.
>

What about the below one?

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 5047490..d741f35 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -362,19 +362,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	if (tty == NULL)
 		return IRQ_NONE;
 
-	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
-	   (tty->ldisc.write_wakeup != NULL))
-		(tty->ldisc.write_wakeup)(tty);
-
-	/*
-	 * BLOCKING mode
-	 * In blocking mode, everything sleeps on tty->write_wait.
-	 * Sleeping in the console driver would break non-blocking
-	 * writes.
-	 */
-
-	if (waitqueue_active(&tty->write_wait))
-		wake_up_interruptible(&tty->write_wait);
+	tty_wakeup(tty);
 	return IRQ_HANDLED;
 }
 
