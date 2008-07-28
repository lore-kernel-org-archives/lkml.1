Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYG1WG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYG1WG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYG1WGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:06:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYG1WGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:06:48 -0400
Date: Tue, 29 Jul 2008 00:06:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Sterba <dsterba@suse.cz>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
	error: invalid use of undefined type 'struct ipw_network'
Message-ID: <20080728220631.GA8095@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu> <20080728213532.GA24744@elte.hu> <20080728214153.GA30511@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080728214153.GA30511@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of 
> undefined type 'struct ipw_network'
> 
> http://redhat.com/~mingo/misc/config-Mon_Jul_28_23_36_20_CEST_2008.bad
> 
> probably due to a string of commits to that file from today.

hm, has this version of the driver ever been built successfully? Because 
struct ipw_network is defined in network.c [only], and then used in 
hardware.c.

It could be changed to void * if the structure wasnt relied on by:

                        const int min_capacity =
                                ipwireless_ppp_mru(hw->network + 2);

so changing it to void * would break this part of the code.

furthermore, what does that "hw->network + 2" mean? It points into 
la-la-land AFAICS, because it's initialized as:

        struct ipw_network *network =
                kzalloc(sizeof(struct ipw_network), GFP_ATOMIC);

and then written into hw->network via:

        ipwireless_associate_network(hw, network);

it's getting late here, so i might be missing some really obvious 
solution (and Jiri is asleep i suspect), so below is a temporary patch 
that marks the driver CONFIG_BROKEN until this is resolved. This gets 
allyesconfig going on x86.

	Ingo

--------------->
>From 56df93b08edb33310aaf5c17c48be098d134cc07 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Jul 2008 00:06:05 +0200
Subject: [PATCH] ipwireless: disable for now
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

mark it CONFIG_BROKEN for now, it breaks the build:

drivers/char/pcmcia/ipwireless/hardware.c: In function ‘pool_allocate':
drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of undefined type ‘struct ipw_network'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/pcmcia/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index ffa0efc..8ee7bbd 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -46,6 +46,7 @@ config CARDMAN_4040
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
 	depends on PCMCIA && NETDEVICES
+	depends on BROKEN
 	select PPP
 	help
 	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
