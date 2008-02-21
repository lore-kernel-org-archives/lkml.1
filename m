Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbYBUSre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbYBUSre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYBUSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:47:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50160 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760148AbYBUSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:47:13 -0500
Date: Thu, 21 Feb 2008 19:46:20 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: MMC card detection
Message-ID: <20080221194620.6a3c0030@dhcp-252-066.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I've been trying to debug some card detection problems in the atmel-mci
driver. Sometimes, when I remove a card, the event doesn't seem to get
detected properly, and the MMC core thinks the card is still there.
When I re-insert the card, the MMC core thinks the card is gone.

I've tried to add a debouncing timer to avoid glitches on the card
detect pin. This helps a bit, but it does not eliminate the problem
altogether.

It seems like the problem only occurs if the card is removed very
slowly. If I increase the debouncing or detection delay, I have to
remove the card more slowly to trigger the problem.

I think the real problem is that the card detection interrupt triggers
while there is still electrical contact with the card. So when the MMC
core tries to send a SEND_STATUS command to check if it's still there,
the card will respond even though it's about to be removed. Since there
will be no more interrupts as the card is completely removed, the MMC
core will never notice that the card is gone.

When the card is reinserted, the MMC core will try to send a
SEND_STATUS command again. This time, the card won't respond because it
is in the "idle" state, and the MMC core will think the card is gone.

In order to fix this problem, I think I need a way to tell the MMC core
that the card really is gone and that there's no point trying to
communicate with it. Is there any way I can do that?

Haavard
