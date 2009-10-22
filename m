Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZJVMyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZJVMyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZJVMyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:54:22 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59459 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbZJVMyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ccz37sn1GJK9ebRIWvWBC8kKY1QfV2xuzptDxUilrq4vMW0cNwIlW4cH8nl5ab1tSO
         rwaLv6YUAJtP2hlbbSu2fgsjqWVOwarD74Jhtw/J0BXbm69OQ8VUnzHpaYD40EyNl48F
         QRKNhpuOQ00V5QXcxUk1A+HxJ3PIgTTP1yPQc=
Date: Thu, 22 Oct 2009 12:54:15 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, tilman@imap.cc, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-wireless@vger.kernel.org, linux-ppp@vger.kernel.org,
       netdev@vger.kernel.org, paulus@samba.org, mb@bu3sch.de,
       oliver@hartkopp.net
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
Message-ID: <20091022125415.GA21699@ff.dom.local>
References: <20091021211906.GA11401@ami.dom.local> <1256160330.12174.2.camel@johannes.local> <20091021213947.GA12202@ami.dom.local> <20091022.042939.95166154.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022.042939.95166154.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 04:29:39AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Wed, 21 Oct 2009 23:39:47 +0200
> 
> > I'm not sure I can understand your question. This patch is mainly to
> > avoid using netif_rx()/netif_rx_ni() pair as a test of proper process
> > context handling; IMHO there're better tools for this (lockdep,
> > WARN_ON's).
> 
> Semantically I think your patch is correct, but I wonder about cost.
> 
> Something that is a simply per-cpu inline "or" operation is now a
> function call and potentially mispredicted branch inside of
> raise_softirq_irqoff().
> 
> And netif_rx() is indeed a fast path for tunnels and other users so
> this does matter.
> 
> I like having people call things in the correct context the function
> was built for, and thus we can avoiryd completely useless operations and
> tests as we can now in netif_rx().

I like it too, but in this particular case I'm not sure netif_rx()
functionality requires this kind of separation; it looks to me quite
similarly to e.g. tasklet_schedule(), the same for process or softirq
contexts.

> 
> Makaing things general purpose costs something, and it costs too much
> here for this critical routine, sorry.
> 
> I was just having a talk with Nick Piggin about these kinds of issues
> today, too few people care about these ever encrouching tiny pieces
> of bloat that slow the kernel down gradually over time, and I simply
> won't stand for it when I notice it :-)

I'm not sure we're saving in the right place. As a matter of fact,
whenever I look into kernel/ code I can't see this kind of
optimization. There is quite a lot of WARN_ON's and if's. These NOHZ
warnings simply show somebody's else debugging triggers far from
places where it all started and is quite accidental, while this
particular "bug" should've been printed immediately long time ago, if
we really cared.

Since I understand it's a question of taste, and it's not anything
critical, I'm quite OK with staying with the old way (except old
bugs, I hope ;-).

Jarek P.
