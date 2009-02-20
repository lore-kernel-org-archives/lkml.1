Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBTRoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBTRoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:44:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZBTRnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:43:52 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36813 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbZBTRnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:43:52 -0500
Date: Fri, 20 Feb 2009 12:43:43 -0500
From: Andres Salomon <dilinger@queued.net>
To: drzeus-sdhci@drzeus.cx
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org, cjb@laptop.org
Subject: OLPC XO-1 sdhci regression
Message-ID: <20090220124343.707b83b4@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

With the current Linus git tree, the sdhci driver fails to find the partition
table on cards during bootup on OLPC XO-1 machines.  This makes booting off of
SD impossible.  The errors go something like this:

 mmcblk0:
mmc0: Timeout waiting for hardware interrupt.
mmcblk0: error -110 sending stop command
end_request: I/O error, dev mmcblk0, sector 0
Buffer I/O error on device mmcblk0, logical block 0
[repeat a bunch of times]
  unable to read partition table

No oopses or anything, the SD controller just fails to read the partition
table off the card.

I bisected a bit, and that led me to this commit:

 commit e809517f6fa5803a5a1cd56026f0e2190fc13d5c
 Author: Pierre Ossman <drzeus@drzeus.cx>
 Date:   Fri Jul 25 01:09:08 2008 +0200

     sdhci: let the controller wait for busy state to end
    
     The sdhci controllers can interrupt us when the busy state from the
     card has ended, saving CPU cycles and power.
    
     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

Reverting that commit allows the driver to read the partition table.
