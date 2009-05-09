Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZEIRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZEIRaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZEIRaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:30:04 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:51137 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZEIRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:30:03 -0400
X-Originating-IP: [71.195.50.4]
Message-ID: <4A05BD77.9020003@lwfinger.net>
Date: Sat, 09 May 2009 12:29:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Eric Valette <eric.valette@free.fr>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: DMA debug trace pointing to rtl8187
References: <49FDB9F8.3080400@free.fr> <20090506133131F.fujita.tomonori@lab.ntt.co.jp> <4A012FC8.3020304@free.fr> <20090506064513.GA7460@kroah.com>
In-Reply-To: <20090506064513.GA7460@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> The problem is in the rtl8187 driver.
> 
> They are calling usb_control_msg and passing a pointer to a buffer on
> the stack.  See drivers/net/wireless/rtl818x/rtl8187.h for where the
> problem happens in numerous places.
> 
> Also it looks like rtl8225_write_8051() is incorrect.  You are passing a
> pointer to a variable that was passed as an argument.  I don't know
> where that is supposed to be on, somewhere on the stack I guess.
> 
> Larry, care to fix this up?

Yes, I'll try to fix it. I'm currently traveling and have intermittent Internet
access.

I think there is a second problem that John's fix does not treat. Although the
buffer is removed from the stack, there is no assurance that the buffer obtained
with kmalloc() is reachable by DMA. This case will be triggered if the USB
adapter does 32-bit DMA and the system has more than 4 GB RAM.

Please let me know if my analysis is wrong. If so, then John's patch will be
fine, although the error handling should be improved. The severity should be
that of a warning rather than a bug. If I'm correct, my fix would be to allocate
a DMA-reachable buffer in the initialization and keep a pointer to it in the
private area.

I just saw John's version 2 that looks more like what I was thinking about. I
will be testing soon.

Thanks,

Larry

