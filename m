Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYGLNAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYGLNAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 09:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYGLNAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 09:00:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49931 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYGLNAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 09:00:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jul 2008 14:59:44 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 1/4] firewire: fix race of bus reset with request
 transmission
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.58323b2455660591@s5r6.in-berlin.de>
Message-ID: <tkrat.c946d53f67bae7d5@s5r6.in-berlin.de>
References: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
 <tkrat.58323b2455660591@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Contexts which access an instance of struct fw_transaction are:
>  1. the submitter, until it inserted the packet which is embedded in the
>     transaction into the AT req DMA,
>  2. the AsReqTrContext tasklet when the request packet was acked by the
>     responder node or transmission to the responder failed,
>  3. the AsRspRcvContext tasklet when it found a request which matched
>     an incoming response,
>  4. the card->flush_timer when it picks up timed-out transactions to
>     cancel them,
>  5. the bus reset tasklet when it cancels transactions (this access is
>     eliminated by this patch),
>  6. a process which shuts down an fw_card (unregisters it from fw-core
>     when the controller is unbound from fw-ohci) --- although in this
>     case there shouldn't really be any transactions anymore because we
>     wait until all card users finished their business with the card.
> 
> All of these contexts run concurrently (except for the 6th, presumably).

PS:  Actually the three tasklets (2nd, 3rd, 5th context) are all
scheduled on the same CPU, hence are serialized.  Therefore

> The 5th looks safe against 2nd, 3rd [...] but is unsafe against 1st.

5th is serialized against 4th and 6th by lock protection of
card->transaction_list accesses.
-- 
Stefan Richter
-=====-==--- -=== -==--
http://arcgraph.de/sr/

