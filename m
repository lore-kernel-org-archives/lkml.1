Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZGCPM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZGCPM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZGCPMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:12:47 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58388 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZGCPMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:12:46 -0400
Date: Sat, 04 Jul 2009 00:12:45 +0900 (JST)
Message-Id: <20090704.001245.208967004.anemo@mba.ocn.ne.jp>
To: nicolas.ferre@atmel.com
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
Subject: Re: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4A4B812E.2080308@atmel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
	<20090628.000624.208780184.anemo@mba.ocn.ne.jp>
	<4A4B812E.2080308@atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 17:30:54 +0200, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > Some of issues reported at that time could be applied on your driver
> > too.  With a quick look, the queue list management issue is a
> > candidate.  Here is an excerpt from the thread:
....
> 
> I try to replay the life of a descriptor chain in "queue" list:
> - it is queued by atc_tx_submit()
> - tasklet or atc_issue_pendig() will "advance_work" and so run
> atc_complete_all() at some point.
> - atc_complete_all() will issue an atc_dostart() on the first chain in
> queue list and move all to active_list
> - then all chains will be managed as active_list members:
>   - tasklet or atc_issue_pendig() will "advance_work"
>   - first member will be managed by chain_complete()
>   - next member will be started by dostart()
>   - and so on...
> - last chain in active_list will run complete_all() and may move again
> queued descriptors to active_list.
> 
> => non-first descriptor moved from queue to active_list will be
> proceeded by act_dostart() in atc_advance_work() function.

Oh yes.  I was wrong.  I missed act_dostart() in atc_advance_work().
Sorry for false warning.

> In this way of addressing descriptors, I try to keep descriptor chains
> as they are built by the prep_dma_memcpy function. I am not trying to
> rewrite the internal arrangement of a descriptor chain (not touching
> lli.dscr).
> It may be not optimal for the descriptor management speed but it tries
> to split problems in a kind of layered way (we build chains and then
> manage their flow in dma engine and associated lists).
> 
> I hope that there is no hole in this management as I am sure it is
> difficult to debug...
> I hope that my response is solid enough. Please do not hesitate to break
> my demonstration ;-).

Thank you for elaboration, I cannot find any hole now.  Indeed these
kind of problem is hard to debug.  Running dmatest with
threads_per_chan=N will catch such issues, hopefully :-)

---
Atsushi Nemoto
