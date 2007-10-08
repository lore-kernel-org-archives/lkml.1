Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbXJHWah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbXJHWah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXJHWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:30:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:65236 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXJHWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=aEq38K5LbQPOdkbnvjQrUcSHNpZt0uoIS9qH0KaDy9DaMusjFM+bjEwvrCSsr5hN2NJ7yNuwTOO7hVL2v0Q226Hndaj+mIpDLJLXqpv8MA1LGAyUyOnYI6mU+O8vXRqEyytkSerUtURnUDTpVGbPF5dXnD7TaVGBKhIlkaCNo+0=
Subject: Re: parallel networking
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, peter.p.waskiewicz.jr@intel.com, krkumar2@in.ibm.com,
       johnpol@2ka.mipt.ru, herbert@gondor.apana.org.au, kaber@trash.net,
       shemminger@linux-foundation.org, jagana@us.ibm.com,
       Robert.Olsson@data.slu.se, rick.jones2@hp.com, xma@us.ibm.com,
       gaagaan@gmail.com, netdev@vger.kernel.org, rdreier@cisco.com,
       mingo@elte.hu, mchan@broadcom.com, general@lists.openfabrics.org,
       kumarkr@linux.ibm.com, tgraf@suug.ch, randy.dunlap@oracle.com,
       sri@us.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071008.141154.107706003.davem@davemloft.net>
References: <20071007.215124.85709188.davem@davemloft.net>
	 <1191850490.4352.41.camel@localhost> <470A3D24.3050803@garzik.org>
	 <20071008.141154.107706003.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 18:30:18 -0400
Message-Id: <1191882618.4373.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-10 at 14:11 -0700, David Miller wrote:

> The problem is that the packet schedulers want global guarantees
> on packet ordering, not flow centric ones.
> 
> That is the issue Jamal is concerned about.

indeed, thank you for giving it better wording. 

> The more I think about it, the more inevitable it seems that we really
> might need multiple qdiscs, one for each TX queue, to pull this full
> parallelization off.
> 
> But the semantics of that don't smell so nice either.  If the user
> attaches a new qdisc to "ethN", does it go to all the TX queues, or
> what?
> 
> All of the traffic shaping technology deals with the device as a unary
> object.  It doesn't fit to multi-queue at all.

If you let only one CPU at a time access the "xmit path" you solve all
the reordering. If you want to be more fine grained you make the
serialization point as low as possible in the stack - perhaps in the
driver.
But I think even what we have today with only one cpu entering the
dequeue/scheduler region, _for starters_, is not bad actually ;->  What
i am finding (and i can tell you i have been trying hard;->) is that a
sufficiently fast cpu doesnt sit in the dequeue area for "too long" (and
batching reduces the time spent further). Very quickly there are no more
packets for it to dequeue from the qdisc or the driver is stoped and it
has to get out of there. If you dont have any interupt tied to a
specific cpu then you can have many cpus enter and leave that region all
the time. 

cheers,
jamal

