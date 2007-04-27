Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXD0ATK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXD0ATK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXD0ATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:19:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:44754 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbXD0ATJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:19:09 -0400
Subject: Re: [PATCH 1/1] IBM PPC EMAC driver:improved support for PHY
	configuration
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Haran <jharan@Brocade.COM>
Cc: ebs@ebshome.net, linux-kernel@vger.kernel.org
In-Reply-To: <46F9780F64AE9945815725F4C0C72CB802A6DE66@hq-exch-1.corp.brocade.com>
References: <46F9780F64AE9945815725F4C0C72CB802A6DE66@hq-exch-1.corp.brocade.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 10:18:36 +1000
Message-Id: <1177633116.14873.271.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 16:18 -0700, Jeff Haran wrote:
> From: Jeff Haran  <jharan@brocade.com>
> 
> This patch fixes some problems I found while debugging the IBM EMAC
> driver for PPC32 systems.
> The first problem was in the function that configures the PHY for
> autonegotiation, genmii_setup_aneg(). The original code does a
> read/modify/write of the autonegotiation advertizement register (reg 4),
> followed by a read/modify/write of the control register (reg 0). While
> the original code follows the proper procedure as per reading the IEEE
> specs, what I found is that on at least one PHY model (National DP83843)
> the read of the control register comes back with the soft reset bit set
> (bit 15).

Good catch ! I've seen that behaviour in the past too. Note that sungem
has this problem too.

 .../...

> The second problem was in the function that configures the PHY for
> forced operation, genmii_setup_forced(). The original code initiates a
> software reset operation via a write of a 1 to bit 15 of the control
> register (reg 0), but then proceeds to do a second write to that same
> register without waiting until that reset bit is cleared by the PHY
> itself (which according to the IEEE specs indicates that the PHY reset
> is complete). This is a violation of how one is supposed to use this
> software reset feature of these PHYs and I believe was the cause of
> mysterious, difficult to reproduce link failures that we've observed on
> some of our systems that use this driver. The fix is to modify the
> function so that it spins waiting for the reset bit to clear after doing
> the soft reset and before doing the subsequent write. Since this
> modification, we haven't seen the mysterious link failures, though they
> were so rare its difficult to say at this point whether this was the
> cause.

This is also a bug inherited from sungem (thus my fault).

> I also added some error handling and reporting for the abnormal case
> where the reset bit never clears from the soft reset operation.
> Applied to kernel version 2.6.21.

Your patch appears to have been line wrapped by your mailer though...

Cheers,
Ben.



