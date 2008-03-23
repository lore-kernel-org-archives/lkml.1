Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbYCWMHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbYCWMHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759176AbYCWMHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:07:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33841 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbYCWMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LPkdV4YFP0HnsqP7BYRMofTiXdFr3Q9Wkuvs5YmqLw0yBY1FjPQDM4UnUfRRmUc8lpNuiQON5BGgC5X7Q4QlbVdfFiecULmR/8+uQiRmUcyKUESRMnQQU28W6oB9Qvlhe6FsM1r82MIa5qS6R+b2JVEzYV7G/zQ47v+Kd9PgsDs=
Message-ID: <47E64802.4040507@gmail.com>
Date: Sun, 23 Mar 2008 21:07:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: jeff@garzik.org, kurt@roeckx.be, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug quirk
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se>	<47E5CCC3.3000301@gmail.com> <18406.12612.194477.944676@harpo.it.uu.se>
In-Reply-To: <18406.12612.194477.944676@harpo.it.uu.se>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
>  > Actually, this is common to many SATA controllers.  Lots of them raise
>  > PHY event or hotplug interrupt during COMRESET and they all plug PHY
>  > events from ->freeze.
> 
> Hmm, no I didn't know that. It's still undocumented, but perhaps
> shouldn't be called a "quirk" if it's as common as you say.

Yeap, it's common behavior.  "quirk" would be a bit unfair to promise. :-)

>  > > Although SATA hotplug status and control is per-port, it resides in
>  > > a single register shared by all ports. Therefore accesses to it must
>  > > be serialised: the controller's host->lock is used for that. The
>  > > interrupt handler is also adjusted so its hotplug register accesses
>  > > are inside the region protected by host->lock.
>  > 
>  > Hmmm... This is supposed to be handled by setting ap->lock appropriately
>  > and ap->lock already is initialized to &host->lock, so sticking with
>  > ap->lock is the right thing to do.
> 
> I'll check this. The code relies on the lock being shared by all ports,
> so at a minimum it will need a comment stating that requirement.

That's the default assumption all other LLDs depend on.  I agree it
needs documentation.

>  > ->freeze() is called with ap->lock held, trying to lock host->lock
>  > inside pdc_sata_enable/disable_hotplug() will result in deadlock.  Have
>  > you tested w/ SMP configuration or spinlock debugging turned on?
> 
> No, I'll do that and fix whatever damage occurs.

Thanks.

-- 
tejun
