Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZBWPfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZBWPfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZBWPfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:35:17 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2040 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbZBWPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:35:16 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Date: Mon, 23 Feb 2009 10:35:02 -0500
Message-Id: <20090223152724.M82409@bobcopeland.com>
In-Reply-To: <49A1DDD2.7040706@gmail.com>
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.121 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 00:20:50 +0100, Jiri Slaby wrote
> On 22.2.2009 22:56, Jiri Slaby wrote:
> > Well, maybe we should try to reproduce with jumbo packets sent to the
> > ath5k receiver, since I think it (1) is not very much test-covered code
> > (2) appears to be related.
> 
> According to the spec I have for older chip, there is not `done' flag 
> set for descriptors which have `more' flag set. We handle this wrongly. 
> Am I looking correctly, Nick, Luis, Bob?
> 
> I still don't see what could have caused this though.

As I understand it, yes, we don't do the right thing when the more flag
is set.  We're supposed to keep processing packets until we get one with
the done flag, and then all of that is supposed to be merged into a single
packet.  Other flags such as the rx rate are only valid on the final
packet.

However, I did some debugging of this a while ago and concluded that the
'jumbo' frames were largely garbage data.  The dma buffer size is certainly
large enough for a standard 802.11 frame and the 'more' flag is only
supposed to be set if the dma buffer size is too small for a packet.  In
all cases the dma buffer size was 2500+ bytes and the actual contents of
the packets looked like random values (I did have encryption turned on,
but there were no 802.11 headers I could see.)

So I am not sure if the jumbo packets are causing bad things to happen,
or if they are an indication that something bad has already happened.

-- 
Bob Copeland %% www.bobcopeland.com


