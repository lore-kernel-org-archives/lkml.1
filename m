Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXK3X5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXK3X5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXK3X5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:57:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:51318 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXK3X5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YlzSwAoME3ZPVKhJaHlIk9ompFOow3OUt7ECIfaxDU9dVMsgX4GZ4W7iIHr1tBW/VIcPIAZ5IZyJrcZ/DFbs9JeE2AtxbVtnDca1dntlk+GRNXHz3Vk6WtHlMsvKEN2z8CqGeoCaQE8usatcRfZAwJdLLTgRsqtFGJf7JYiFG0A=
Message-ID: <4750A33C.4080509@gmail.com>
Date: Sat, 01 Dec 2007 08:56:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com> <474F3A4B.3080304@cfl.rr.com> <474F530D.8090302@gmail.com> <47505A63.8070507@cfl.rr.com>
In-Reply-To: <47505A63.8070507@cfl.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Tejun Heo wrote:
>> Because SFF ATA controller don't have IRQ pending bit.  You don't know
>> whether IRQ is raised or not.  Plus, accessing the status register which
>> clears pending IRQ can be very slow on PATA machines.  It has to go
>> through the PCI and ATA bus and come back.  So, unconditionally trying
>> to clear IRQ by accessing Status can incur noticeable overhead if the
>> IRQ is shared with devices which raise a lot of IRQs.
> 
> There HAS to be a way to determine if that device generated the
> interrupt, or the interrupt can not be shared.  Since the kernel said
> nobody cared about the interrupt, that indicates that the sata driver
> checked the status register and realized the sata chip didn't generate
> the interrupt, and returned to the kernel letting it know that the
> interrupt was not for it.

Surprise, surprise.  There's no way to tell whether the controller
raised interrupt or not if command is not in progress.  As I said
before, there's no IRQ pending bit.  While processing commands, you can
tell by looking at other status registers but when there's nothing in
flight and the controller determines it's a good time to raise a
spurious interrupt, there's no way you can tell.  That dang SFF
interface is like 15+ years old.

But we can still make things pretty robust.  We're working on it.

Thanks.

-- 
tejun
