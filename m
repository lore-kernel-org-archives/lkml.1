Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZCHQLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZCHQLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZCHQLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:11:04 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:4695 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZCHQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:11:03 -0400
Date: Sun, 8 Mar 2009 12:10:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090308161051.GA17812@hash.localnet>
References: <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B38FB7.3000002@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 10:28:23AM +0100, Jiri Slaby wrote:
>> bf_last is no longer a
>> valid marker for the self-linked descriptor at the end of the loop since
>> we re-add the just-processed descriptor every time through the loop
>> (or am I missing something?)...
>
> Why? bf_last is snapshotted before the loop. And when we see this bf  
> while processing, we stop. In the next round we check if bf->next is  
> done. If yes, we move on.

I think it works for the first one but doesn't take into account 
subsequent self-linked descriptors.  E.g. if we start with buffers:

A->B->C

bf_last is 'C'.  The hardware sees descriptors:

A'->B'->C'(->C')

After one round, the hardware sees:

B'->C'->A'(->A')

Suppose the hardware does A',B',C' before we process any buffer.  So after
we process A, the hardware moves on to A'.  It finishes a packet, re-reads
the link and starts overwriting A' again, but for some reason is really
slow to complete this second packet.  

Now, the tasklet burns through B and C.  On C we do the check if bf->next 
(i.e. A) is done, and it is because the hardware wrote one packet to it[1].
However, it's still in the process of writing another frame over A' again.  
We skip C, send A to __ieee80211_rx, the skb is freed, but the hardware 
is still writing stuff to it.

In the trace Sitsofe posted, I didn't see any tasklets processing more
than a couple of packets, though.

[1] Note, the status is cleared when we hand the buffer to hardware, but
not by the hardware itself when it rewrites the same buffer.  That could
explain why status is "martian" for overwritten frames.

>> If you want I'll cook up a patch for that too.
>
> If you like, feel free to kick it off. Remember to remove bf->flags  
> completely, so that we save another bunch of memory ;).

Ok, I probably won't get to it until this evening so if you prefer to
do it, go ahead - otherwise I'll tackle it then.

-- 
Bob Copeland %% www.bobcopeland.com

