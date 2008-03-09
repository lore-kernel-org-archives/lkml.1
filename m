Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbYCIOTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbYCIOTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 10:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCIOS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 10:18:59 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:40100 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYCIOS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 10:18:59 -0400
Date: Sun, 9 Mar 2008 15:16:59 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "LKML" <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Dave Jones" <davej@codemonkey.org.uk>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Adam Belay" <abelay@novell.com>, "Lee Revell" <rlrevell@joe-job.com>,
       "Pavel  Machek" <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080309151659.63d54f38@mjolnir.drzeus.cx>
In-Reply-To: <20080306092730.4412d085@mjolnir.drzeus.cx>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
	<20080305070201.0d16cd40@mjolnir.drzeus.cx>
	<20080305094023.6486ebdf@mjolnir.drzeus.cx>
	<20080306092730.4412d085@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm beginning to think this is a lost cause. I've tried several variants, all without satisfactory results.

In case anyone else has any more ideas, I'll detail what I've found influences the noise:

1. C state

This is the big one. There is no noise as long as C3 is avoided (processor.max_cstate).

2. uhci_hcd driver

USB is somehow involved in this problem. Unloading the uhci_hcd driver almost entirely kills the noise on a 1000 HZ NO_HZ kernel. On a 100 HZ, no NO_HZ kernel, the effect is very small, but still there.

3. Low speed USB devices

Related, the noise goes away if I insert a USB mouse (low speed). A high-speed device does not effect the noise, neither does the two built-in low speed devices (a fingerprint reader and a bluetooth host).

4. Battery and AC

The noise increases with the battery present and also when the AC supply is removed.

5. Second core

Disabling the second core makes the noise go away. This might be a subset of 1., as I've been told that a stopped core enters C1.


Changing HZ and NO_HZ has no noticeable effect on the problem (except the odd behaviour in 2.). This is further supported by the fact that Windows also has the problem (which should behave close to 100 HZ without NO_HZ).


So for now, the only viable workaround is processor.max_cstate....

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
