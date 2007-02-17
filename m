Return-Path: <linux-kernel-owner+w=401wt.eu-S2992797AbXBQXOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992797AbXBQXOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992794AbXBQXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:14:06 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43114 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992797AbXBQXOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:14:04 -0500
Message-ID: <45D78C3D.6060200@drzeus.cx>
Date: Sun, 18 Feb 2007 00:14:05 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <961103.42832.qm@web36715.mail.mud.yahoo.com>
In-Reply-To: <961103.42832.qm@web36715.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> If we are already on the topic, I would like to report two additional issues with mmc_block:
> 
> 1. If, for some reason, device driver cannot return the requested data amount, but does not sets
> any error, mmc_block would retry indefinitely. Of course, its always a device driver's fault, but
> may be we can set some limit on retry count (this can help a lot with debugging).

Well, we could add a check that data requests get fully satisfied.

> 
> And the more serious:
> 2. There was a write corruption problem with tifm_sd caused by missing wait cycle (card busy/card
> not busy) after stop command. It should not had been a problem (the mmc layer was spinning around
> with CMD13 untill the card become not-busy), but for some reason it was. We are currently testing
> this. The intersting part, however, is behavior of mmc_block given this situation:
> 
> It appears that mmc_block's instance manages to get stuck because of this. The symptoms: module
> usage count is not decremented when low level driver is unloaded and partition block devices do
> not get created afterwards. The fun part: the main block device gets created and deleted on card
> insertion/removal and its dump is correct (dd if=/dev/mmcblk0 ...); yet partition detection does
> not happens. To fix this, one have to reboot the machine or to wait about 30 minutes for mmc_block
> to regain its senses (then it becomes rmmod'able again).
> 
> On the other hand, it may be some sort of generic block layer problem.
> 

The block layer can get a bit fuzzy when you start yanking device out from under
it. That said, the mmc block driver should be forgiving. So if you can figure
out what it is up to (and more exactly how it is provoked), I'll try to fix it.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
