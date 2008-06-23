Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYFWJtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYFWJtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFWJtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:49:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:36331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbYFWJtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:49:23 -0400
Message-ID: <485F7184.1030907@kernel.org>
Date: Mon, 23 Jun 2008 18:48:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Pavel Machek <pavel@suse.cz>, Andreas Schwab <schwab@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, jgarzik@pobox.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
References: <20080617093602.GA28140@elf.ucw.cz>	 <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz>	 <je63s0sfxv.fsf@sykes.suse.de> <20080623085338.GE1850@elf.ucw.cz>	 <485F6540.6000907@kernel.org>  <20080623090130.GF1850@elf.ucw.cz> <1214211859.8011.250.camel@pasglop>
In-Reply-To: <1214211859.8011.250.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Mon, 23 Jun 2008 09:48:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Am I the only one to find Pavel variant almost as obscure as
> the original one ? :-)
> 
> It should explain precisely what the workaround is. Ie. to start the
> DMA there instead of where it normally is started which is the
> bmdma_setup() function.

Well, it's better than the original which kind of directed the other
way.  :-)

> BTW. Tejun, I suppose that usually starting DMA after issuing the
> command is a standard practice of legacy/sff type controllers ? Or it's
> just because that's how linux did it until now ?

It's how the standard says it should be programmed.  Please take a look
at section 3 of the following document.

http://www.centrillium-it.com/Projects/idems100.pdf

It's a non-issue for PATA ones as the host is responsible for running
the clock and transferring data after the drive indicated readiness, so
the worst that can happen by starting the dma engine after issuing the
command is the drive waiting in ready state.

For SATA, it should work the same.  The host should hold the transfer by
not acking the data transfer request (or prefetch the data if it feels
smart and brave).  So, it's something sata_svw screwed up.

-- 
tejun
