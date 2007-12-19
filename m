Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbXLSR27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbXLSR27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXLSR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:28:52 -0500
Received: from waste.org ([66.93.16.53]:42197 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXLSR2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:28:51 -0500
Date: Wed, 19 Dec 2007 11:28:39 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: a problem with NETPOLL/KGDBoE
Message-ID: <20071219172838.GO19691@waste.org>
References: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com> <20071206183423.GZ19691@waste.org> <dfb262380712190822l48f706b5k345762e233b693ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfb262380712190822l48f706b5k345762e233b693ae@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 06:22:55PM +0200, Ramagudi Naziir wrote:
> On 12/6/07, Matt Mackall <mpm@selenic.com> wrote:
> > netpoll will ignore incoming UDP -from- the wrong port/ip/mac, since
> > it's otherwise bypassing the firewall layer.
> ...
> > I forget how to deal
> > with the source address issue in connection with GDB, perhaps Jason
> > will remind us.
> 
> I have checked it out.
> Seems like there is absolutely no way to configure the source
> port gdb uses for the udp connection. So one must invoke a
> "target remote udp:ip:port" command, see what was the
> chosen source port (tcpdump/netstat), and reconfigure kgdb on the target.
> While this works, it is rather awkward.
> 
> Do you think there is/can be another way to solve this issue
> (like allowing NETPOLL to listen to a wildcard udp source port) ?

Here are the checks from net/core/netpoll.c:__netpoll_rx:

        if (np->local_ip && np->local_ip != ntohl(iph->daddr))
                goto out;
        if (np->remote_ip && np->remote_ip != ntohl(iph->saddr))
                goto out;
        if (np->local_port && np->local_port != ntohs(uh->dest))
                goto out;

In other words, we DON'T check remote_port and we don't check the
local_port, local_ip, or remote_ip if they're zero. Sorry for the
earlier confusion.

My hazy memory here is that my version of kgdboe took the first packet
it got and set remote_port from it so that it could reply. Not sure
whether that got copied as I can't seem to find the relevant bits in
the latest -mm.

-- 
Mathematics is the supreme nostalgia of our time.
