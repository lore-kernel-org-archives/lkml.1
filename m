Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYAIWo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYAIWo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYAIWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:44:15 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:56682 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbYAIWoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:44:14 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PNP_DRIVER_RES_DISABLE breaks swsusp at least with snd_cs4236
Date: Wed, 9 Jan 2008 23:43:47 +0100
User-Agent: KMail/1.9.7
Cc: alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092343.48726.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
as hibernation (swsusp) started to work with my CPU, I found that my Turtle 
Beach Malibu stops working after resume from hibernation. It's caused by fact 
that the card is not enabled on the pnp layer during resume - and thus card 
registers are inaccessible (reads return FFs, writes go nowhere).

During resume, pnp_bus_resume() in drivers/pnp/driver.c is called for each pnp 
device. This function calls pnp_start_dev() only when the 
PNP_DRIVER_RES_DO_NOT_CHANGE bit is NOT seting pnp_drv->flags. But the cs4236 
driver in sound/isa/cs423x/cs4236.c explicitly sets the .flags to 
PNP_DRIVER_RES_DISABLE - it's value is 3 and that includes 
PNP_DRIVER_RES_DO_NOT_CHANGE bit.

The same .flags value is present in many of the ALSA ISA sound drivers.

Removing that .flags line caused this to appear inlog when loading snd_cs4236 
module:
CS4236+ WSS PnP manual resources are invalid, using auto config
CS4236+ CTRL PnP manual resources are invalid, using auto config
CS4236+ MPU401 PnP manual resources are invalid, using auto config

and the sound now works after resume!

So the question is: why is this line present?

Is this a bug? What's the correct fix?

-- 
Ondrej Zary
