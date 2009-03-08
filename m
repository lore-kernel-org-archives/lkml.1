Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZCHJ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZCHJ2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 05:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZCHJ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 05:28:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:37150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZCHJ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 05:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=faiGtZ/ur45MynOxxKNJiVziU9DeZt0FYxoVCV+zrEGeiy0W1PuHq9AYeRdW43HM2X
         hAvQUgtoYyj8guy5bYeCT0MgZIcaZ9zN6a0EVoyWAWOhvb3BPktXhyI4XN+JZLwIeWki
         9HWtUPMm4R+Nle0LrlSx6w7al3znTD7FEdlRA=
Message-ID: <49B38FB7.3000002@gmail.com>
Date: Sun, 08 Mar 2009 10:28:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet>
In-Reply-To: <20090308030928.GB14966@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.3.2009 04:09, Bob Copeland wrote:
> At this point, I guess the best way forward is to have a special debug
> patch for when we pass an skb up the stack, when it gets allocated, and
> what is in the descriptors.

Yes, I have been thinking about some (ring buffer) array which would 
store address-desc_status pairs (even few megs in a vmalloc area) and 
pointer (not modulo-ed counter) to this array (index would be modulo-ed, 
indeed). From poison output we know the address, so we can then instruct 
ath5k to dump the buffer and see what happens :), what was in the status 
when we freed the skb.

Maybe some additional info may be needed, as you suggest.

> Jiri, I really think we should implement that better check for the
> self linked descriptor using the rxdp register.

As I stated a while ago, definitely!

> bf_last is no longer a
> valid marker for the self-linked descriptor at the end of the loop since
> we re-add the just-processed descriptor every time through the loop
> (or am I missing something?)...

Why? bf_last is snapshotted before the loop. And when we see this bf 
while processing, we stop. In the next round we check if bf->next is 
done. If yes, we move on.

> If you want I'll cook up a patch for that too.

If you like, feel free to kick it off. Remember to remove bf->flags 
completely, so that we save another bunch of memory ;).
