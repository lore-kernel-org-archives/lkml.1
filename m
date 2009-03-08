Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZCHDJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZCHDJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 22:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZCHDJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 22:09:38 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2624 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZCHDJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 22:09:37 -0500
Date: Sat, 7 Mar 2009 22:09:28 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090308030928.GB14966@hash.localnet>
References: <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306094249.GA10236@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:42:49AM +0000, Sitsofe Wheeler wrote:
> > parallel with iwlist wlan0 scan (as root, so scans are actually 
> > performed), in parallel with iperf or ping.  I didn't personally have
> > luck with that workload, though.

So I looked through this log for a few hours today.  Sorry to say
that I don't have any answers, but here's a summary of what I saw:

- it didn't seem like there were any obvious race conditions at play;
  that is, I didn't see other ath5k_XXX functions being pre-empted
  by ath5k_intr, followed by the softirq.

- there were a few errors prior to catching the poison.  I don't think
  the trace contains enough info to say whether they were phy errors,
  unsupported jumbo type errors, or whatever.  Anyway there didn't seem
  to be any obvious causal pattern, nothing like an error on the
  40th previous buffer or a cascading series of errors.  Of course, 
  the error could have happened much earlier compared to when the skbuff
  in the freelist got reused.

At this point, I guess the best way forward is to have a special debug
patch for when we pass an skb up the stack, when it gets allocated, and
what is in the descriptors.

Jiri, I really think we should implement that better check for the
self linked descriptor using the rxdp register.  bf_last is no longer a
valid marker for the self-linked descriptor at the end of the loop since
we re-add the just-processed descriptor every time through the loop  
(or am I missing something?)...  If you want I'll cook up a patch for 
that too.

-- 
Bob Copeland %% www.bobcopeland.com

