Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbXJMWDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbXJMWDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXJMWDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:03:23 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:56143 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXJMWDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CEtGfWZTeCyB3FyBBv9DaGxTw2qJ64ZbBk9yhfZESzGV2d1NrfKqsN8D55pOpE2O6M0fygvNutnxrrEqGDlNrItgf/IAy0XyRYFH4z+0U4Gu/Txe7AM07fzNAPyrNYKarQ3TN4kX91K86CiwafkMLfQDr8P8iKaFC+A/FWpv13s=
Message-ID: <3aa654a40710131503t1ba08614jc8ab7f6813dc5c2e@mail.gmail.com>
Date: Sat, 13 Oct 2007 15:03:20 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: 2.6.23-rc4-mm1 myri10ge module link error on x86_64
Cc: "David Miller" <davem@davemloft.net>, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, help@myri.com
In-Reply-To: <46E1E5E7.4080508@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	 <20070906193751.GA4518@Krystal>
	 <20070906.134038.85411315.davem@davemloft.net>
	 <20070906.134831.39160997.davem@davemloft.net>
	 <46E1E5E7.4080508@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Thu, 06 Sep 2007 13:40:38 -0700 (PDT)
> >
> >> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >> Date: Thu, 6 Sep 2007 15:37:51 -0400
> >>
> >>> I got a link error on myri10ge when building 2.6.23-rc4-mm1 on x86_64 :
> >>>
> >>> ERROR: "lro_flush_all" [drivers/net/myri10ge/myri10ge.ko] undefined!
> >>> ERROR: "lro_receive_frags" [drivers/net/myri10ge/myri10ge.ko] undefined!
> >>> make[2]: *** [__modpost] Error 1
> >>> make[1]: *** [modules] Error 2
> >>> make: *** [_all] Error 2
> >> myri10ge needs some LRO ifdeffery.
> >
> > Actually the fix is even simpler, missing select in Kconfig.
> >
> > I've checked the following fix for this into the net-2.6.24
> > tree.
> >
> > commit 9fd380e892e078b582920325357292c07eeeecc9
> > Author: David S. Miller <davem@kimchee.(none)>
> > Date:   Thu Sep 6 21:44:36 2007 +0100
> >
> >     [MYRI10GE]: Need to select INET_LRO.
> >
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index b92b7dc..7d1a84e 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -2496,6 +2496,7 @@ config MYRI10GE
> >       depends on PCI
> >       select FW_LOADER
> >       select CRC32
> > +     select INET_LRO
>
> Yes, that's the correct fix.  ACK.

This bug still exists, though now it is in mainline. I just bisected
to it with this config[1], unless, of course randconfig is still
making bad configs.

Errors out with:
drivers/built-in.o: In function `myri10ge_poll':
myri10ge.c:(.text+0xce259): undefined reference to `lro_receive_frags'
myri10ge.c:(.text+0xce37c): undefined reference to `lro_flush_all'

It bisects back to this with this:
sbh@shapeshifter /tmp/tester/linux-2.6 $ git-bisect bad
1e6e9342d41ff80ced0ad5dfcf084926700cdfc5 is first bad commit
commit 1e6e9342d41ff80ced0ad5dfcf084926700cdfc5
Author: Andrew Gallatin <gallatin@myri.com>
Date:   Mon Sep 17 11:37:42 2007 -0700

    [MYRI10GE]: Use LRO.

    Singed off by: Andrew Gallatin <gallatin@myri.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

This is with linux-2.6.git
master: 8d8fe64237646fdd2c2de2722ec4189a5999119d

[1] http://avuton.googlepages.com/undef-reference-lro_receive_frags.config
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
