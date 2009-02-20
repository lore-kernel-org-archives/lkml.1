Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZBTAzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZBTAzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBTAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:55:27 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:65406 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZBTAz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:55:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=VkQctVlpCldTEz8TOOrAEqj6/KWGxZSAFgIYcIf/1ZCU/bQnvjH/7Oxhs1GPoxczx8
         8AtTYhTdRPOvxv1WR+5MTkP0ecKlM9PLQR+41gHZYMSfvYpLqTXLW67XynxSksiL5HeN
         kFCFlj40EJZ7XGuu6FWWUoOdhnTojJzsAj4qM=
Message-ID: <499DFF79.6090404@gmail.com>
Date: Thu, 19 Feb 2009 18:55:21 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: joseluismarchetti@yahoo.com.br
CC: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: Is interrupt priority supported ?
References: <20090219204902.GA3990@rhlx01.hs-esslingen.de> <164929.58875.qm@web34407.mail.mud.yahoo.com>
In-Reply-To: <164929.58875.qm@web34407.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose Luis Marchetti wrote:
>> it has been for a looong time (those things tend to almost
>> get outdated already -
>> witness the floppy controller misery):
> 
> He he, I am from the same era..., I appreciate your answer, but I am afraid your suggestion is not exactly what I was expecting.
> The tools you mention appears to act on the hardware level, not on Linux by itself, they apply only to x86 processors ( as you can see by the name ), and I am not running Linux in one of those processors.
> Roughly, this is what I have seen in other OSs that support interrupt priority:
> Imagine a table with interrupt IDs, in my example they are in decreased priority order:
> interrupt priority table:
> Serial,
> Ethernet,
> Keyboard,
> etc...
> Then, when one interrupt happen, lets say the Ethernet, the OS disable all lower priority interrupts ( keyboard in my example ), but allow the Serial interrupt nest into the Ethernet interrupt.
> In my example the serial is the highest priority interrupt and no one could nest into it.

It doesn't really work that way in Linux. Normally disabling interrupts 
is all or nothing. Whether or not other devices can cause interrupts 
during an interrupt handler execution by default is a bit 
platform-dependent, I think (unless the driver requests IRQF_DISABLED 
which requests that other interrupts should not run).

Normally in Ethernet drivers these days only very minimal processing is 
done during the interrupt handler, the rest is deferred to softirq 
context which runs with interrupts enabled so other interrupts can 
happen. That's not to say that all Ethernet drivers are so well-behaved, 
however, especially if they haven't been updated to use NAPI. (In the 
NAPI case, the driver disables further interrupts from the device until 
the softirq is able to run and process the packets.) In your case it 
seems likely that yours is not behaving so well, as one would expect the 
interrupt handler to complete in less than the time  it takes one 
character to arrive on the serial port..
