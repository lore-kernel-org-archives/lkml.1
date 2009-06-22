Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZFVPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZFVPDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZFVPD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:03:29 -0400
Received: from main.gmane.org ([80.91.229.2]:39327 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZFVPD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:03:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Pierre Tardy <tardyp@gmail.com>
Subject: Re: [PATCH 0/1] MMC: SDIO card reset support for Intel Moorestown  platform
Date: Mon, 22 Jun 2009 15:03:17 +0000 (UTC)
Message-ID: <loom.20090622T144530-979@post.gmane.org>
References: <95608CFE3D0C064B8468DB61F8403BE036C19F9ECE@PDSMSX501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.88.168.35 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.11) Gecko/2009060308 Ubuntu/9.04 (jaunty) Firefox/3.0.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li, Jiebing <jiebing.li <at> intel.com> writes:

> 
> Hi Pierre and all,
> 
> Here's a SDIO driver code patch which implements SDIO card reset support for
device driver to recover the
> card to the normal status in case that error occurs.

Another case that may need to be addressed is sdio reset in the scan sequence.
On some HC board, the sdio power survives upon board reset. A previously
initialised SD card will stay in IORDY mode, and wont answer to CMD5.
Though, a reset cmd52 should be sent before or after cmd0 in case of a io card
is still initialised from a previous boot.

One problem here is that mmc_io_rw_direct needs a struct mmc_card *, which is
not yet available in mmc_rescan().

I have a Q&D mmc_io_reset implementation, which works, but rely on
mmc_io_rw_direct implementation only to use card->host.

int mmc_io_reset(struct mmc_host *host)
{
	struct mmc_card card;
        u8 reg;
        int ret;
	card.host = host;
        // not sure if we really need to read and modify. 
        // Reset wont reset the other bits anyway?
        ret = mmc_io_rw_direct(&card, 0, 0, SDIO_CCCR_ABORT, 0, &reg);
	if (ret)
		reg = 0x08;
	else
		reg |= 0x08;

	return mmc_io_rw_direct(&card, 1, 0, SDIO_CCCR_ABORT, reg, NULL);
}

Any idea on how to deal with this situation correctly?



