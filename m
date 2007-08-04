Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbXHDIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbXHDIQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 04:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXHDIPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 04:15:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:43310 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbXHDIPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 04:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DvBRt8bqRWabxJhE9b8pDkyZ6j3I2NhGz13JUssMony2Lvf6xTpsnrNrfJM4cf/KzY5PJopJ3fHTJoaDyn6TBd1Y8CgmsDPu9QxUM4mqSrnF9xIw12ponxbGH0Vqos9Q9L9UKGIwlolIJ0OGeadx6qKt1loe0SO6LPLSlE22RSc=
Message-ID: <46B4357A.2080502@gmail.com>
Date: Sat, 04 Aug 2007 17:14:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: libata git tree, mbox queue status and contents
References: <46B35344.3090208@garzik.org> <20070803172040.52853316@the-village.bc.nu>
In-Reply-To: <20070803172040.52853316@the-village.bc.nu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> * Albert: irq_on/off.  Really need to give this some thought.  Not sure 
>> I like where this model is going.  Polling and twiddling irq on/off 
>> should be kept to a minimum, because it's sorta an admission that the 
>> host state machine has broken down, and we need to bandaid.  Its a 
>> bandaid not a root-cause solution.
> 
> I think of it more as an admission that the IDE design is lacking in a
> few areas. No suprise as its an emulation of a 15 year old interface that
> was normally used polled.

I second Alan's opinion.  The root cause of the problem is that the
controller lacks reliable IRQ masking and pending register.  If you add
a slightly malfunctioning controller and/or device into the mix, it's
guaranteed to break.

And there's another addition to the mess from SATA land which I
discovered a few days ago.  Some SATA controllers with SFF interface
don't send non-command H2D Reg FIS when ATA_NIEN is toggled, so the
updated ATA_NIEN is sent together with the next command && some SATA
devices don't honor ATA_NIEN on command H2D Reg FIS.  Fun!

I think we should go combined IRQ + polling mode Jeff once mentioned so
that we automatically fallback to polling if IRQ doesn't work for some
reason.  To do that, we need reliable IRQ masking && the only way to
achieve proper IRQ masking on SFF controllers seems plugging it from the
host side.

Thanks.

-- 
tejun
