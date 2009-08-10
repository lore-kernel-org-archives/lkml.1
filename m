Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZHJIvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZHJIvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZHJIvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:51:22 -0400
Received: from d1.icnet.pl ([212.160.220.21]:52609 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZHJIvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:51:20 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jhnikula@gmail.com>
Subject: [RFC][PATCH 0/3] Enhance ASoC on OMAP1510 by implementing DMA channel linking
Date: Mon, 10 Aug 2009 10:49:49 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101049.52744.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation of ASoC OMAP PCM makes use of DMA channel self linking
feature for all machines but OMAP1510. This is caused by channel linking not
supported on OMAP1510 in current OMAP DMA implementation. Instead, DMA
interrputs are counted as periods, and after all periods in a buffer has been
detected, DMA transfer is started again for a new buffer content. The period
counter is also used as a software replacement for a hardware DMA progress
counter that has been found unusable on OMAP1510 in case of playback.

In my attempts to debug random PCM hangups, I was wondering what could happen
if a single interrupt was missing, ie. the period index was not incremented
for a period. It seems that the transfer would just hang after the current
buffer processed, as DMA would not be started again, waiting for a
missing period.

Furthermore, software calculated PCM pointer accuracy can suffer from missing
DMA interrupts.

Even if OMAP1510 DMA hardware does not support channel linking in a way like
newer models do, it has some other features that could be used for the
purpose.

Interrupt status flags, passed to OMAP PCM interrupt handler routine, can be
used to get more accurate DMA progress counter software calculation.

Even if these enhancements did not help me in eliminating random PCM hangups
completely, I find them worth of sharing.

There are three patches in the series:
[RFC][PATCH 1/3] ARM: OMAP: DMA: Add support for DMA channel self linking on OMAP1510
[RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self linking on OMAP1510
[RFC][PATCH 3/3] ASoC: OMAP: Enhance OMAP1510 DMA progress software counter

Created against linux-2.6.31-rc5.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
