Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXBRPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXBRPKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 10:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXBRPKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 10:10:53 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41744 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXBRPKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 10:10:53 -0500
Message-ID: <45D86C7B.5050900@drzeus.cx>
Date: Sun, 18 Feb 2007 16:10:51 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <306317.86250.qm@web36706.mail.mud.yahoo.com>
In-Reply-To: <306317.86250.qm@web36706.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> This is hard to trigger problem, so I'll spare you the rather lengthy log.
> It happens if card timeouts and mmc_remove_host is called while mmc_register_card is still in
> progress (the hint was in crash dump). If I sleep before remove, it gives the mmc_register_card
> chance to finish/mark card as dead and everything's fine.
> The remove callback of mmc_block is apparently not executed in this case (probably because device
> has not finished registering).

Let's see, you manage to call mmc_remove_host() when a detection is pending in
the workqueue? That could indeed generate new request (up until mmc_free_host()
is called), but as the card is removed the mmc layer shouldn't be able to detect
anything, hence mmc_block should never get involved.

> 
> My proposition: lets flush the workqueue first thing in the mmc_remove_host (and make sure that
> nothing gets scheduled into it after this). 
> 

This is fixed in -mm. Making sure that nothing gets scheduled is the driver's
responsibility. I've added checks to catch broken drivers though.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
