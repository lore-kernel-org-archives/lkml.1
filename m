Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXKGVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXKGVx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbXKGVxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:53:50 -0500
Received: from zakalwe.fi ([80.83.5.154]:50221 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbXKGVxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:53:49 -0500
Date: Wed, 7 Nov 2007 23:53:48 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: net: skge breakage on 2.6.24-rc1
Message-ID: <20071107215348.GB8865@zakalwe.fi>
References: <20071107214621.GA8865@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071107214621.GA8865@zakalwe.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 11:46:21PM +0200, Heikki Orsila wrote:
> After some bisecting, I found that net skge driver broke on
> 
> commit 7fb7ac241162dc51ec0f7644d4a97b2855213c32
> 
> My network card is:
> 
> 0000:00:0e.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)
> 
> Linux cheradenine 2.6.24-rc1-dirty #15 Wed Nov 7 23:39:28 EET 2007 x86_64 GNU/Linux

Sorry, forgot to say what the problem is. Doing

	nc host port < /dev/zero

on a sending machine (not skge) to an skge machine that is receiving:

	nc -l -p port >/dev/null

with ~60 MiB/s speed, causes the interface go malfunct. A slow 
transfer doesn't cause a problem.

Also, after some fiddling, I noticed that not changing the register 
write order on patch:

+       skge_write32(hw, RB_ADDR(q, RB_END), end);
        skge_write32(hw, RB_ADDR(q, RB_WP), start);
        skge_write32(hw, RB_ADDR(q, RB_RP), start);
-       skge_write32(hw, RB_ADDR(q, RB_END), end);

fixes the visible effect.. Possibly not the root cause of the problem, 
but changing the order back fixes networking here.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
