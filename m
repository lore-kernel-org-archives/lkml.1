Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbYG1WV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbYG1WV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYG1WVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:21:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYG1WVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:21:18 -0400
Date: Mon, 28 Jul 2008 15:20:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, travis@sgi.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, dsterba@suse.cz,
       jkosina@suse.cz
Subject: Re: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
 error: invalid use of undefined type 'struct ipw_network'
Message-Id: <20080728152056.8e83c4ec.akpm@linux-foundation.org>
In-Reply-To: <20080728220631.GA8095@elte.hu>
References: <20080727190601.GA764@elte.hu>
	<alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
	<200807281042.12860.rusty@rustcorp.com.au>
	<488E06F0.4070404@sgi.com>
	<alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org>
	<20080728205700.GA3613@elte.hu>
	<20080728213532.GA24744@elte.hu>
	<20080728214153.GA30511@elte.hu>
	<20080728220631.GA8095@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 00:06:31 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of 
> > undefined type 'struct ipw_network'
> > 
> > http://redhat.com/~mingo/misc/config-Mon_Jul_28_23_36_20_CEST_2008.bad
> > 
> > probably due to a string of commits to that file from today.
> 
> hm, has this version of the driver ever been built successfully? Because 
> struct ipw_network is defined in network.c [only], and then used in 
> hardware.c.
> 
> It could be changed to void * if the structure wasnt relied on by:
> 
>                         const int min_capacity =
>                                 ipwireless_ppp_mru(hw->network + 2);
> 
> so changing it to void * would break this part of the code.
> 
> furthermore, what does that "hw->network + 2" mean? It points into 
> la-la-land AFAICS, because it's initialized as:
> 
>         struct ipw_network *network =
>                 kzalloc(sizeof(struct ipw_network), GFP_ATOMIC);
> 
> and then written into hw->network via:
> 
>         ipwireless_associate_network(hw, network);
> 
> it's getting late here, so i might be missing some really obvious 
> solution (and Jiri is asleep i suspect), so below is a temporary patch 
> that marks the driver CONFIG_BROKEN until this is resolved. This gets 
> allyesconfig going on x86.

I suspect that this:

--- a/drivers/char/pcmcia/ipwireless/hardware.c~a
+++ a/drivers/char/pcmcia/ipwireless/hardware.c
@@ -568,7 +568,7 @@ static struct ipw_rx_packet *pool_alloca
 			list_del(&packet->queue);
 		} else {
 			const int min_capacity =
-				ipwireless_ppp_mru(hw->network + 2);
+				ipwireless_ppp_mru(hw->network) + 2;
 			int new_capacity;
 
 			spin_unlock_irqrestore(&hw->lock, flags);
_

was intended.
