Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYANTdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYANTdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYANTdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:33:35 -0500
Received: from smtp2a.orange.fr ([80.12.242.139]:31179 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbYANTde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:33:34 -0500
X-ME-UUID: 20080114193328516.7E1E27000097@mwinf2a06.orange.fr
Message-ID: <478BB904.3060903@cosmosbay.com>
Date: Mon, 14 Jan 2008 20:33:24 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <2c0942db0801112137k3f3f885ek212d5cbaecb7fea0@mail.gmail.com> <478B8473.6080506@nortel.com> <478B943C.7080009@cosmosbay.com> <478BB722.1020004@nortel.com>
In-Reply-To: <478BB722.1020004@nortel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> Eric Dumazet wrote:
>> Chris Friesen a écrit :
>
>>> Based on profiling and instrumentation it seems like the cost of 
>>> sctp_endpoint_lookup_assoc() more than triples, which means that the 
>>> amount of time that bottom halves are disabled in that function also 
>>> triples.
>>
>> Any idea of the size of sctp hash size you have ?
>> (your dmesg probably includes a message starting with SCTP: Hash 
>> tables configured...
>> How many concurrent sctp sockets are handled ?
>
> Our lab is currently rebooting, but I'll try and get this once it's 
> back up.
>
>> Maybe sctp_assoc_hashfn() is too weak for your use, and some chains 
>> are *really* long.
>
> Based on the profiling information we're spending time in 
> sctp_endpoint_lookup_assoc() which doesn't actually use hashes, so I 
> can't see how the hash would be related.  I'm pretty new to SCTP 
> though, so I may be missing something.
Well, it does use hashes :)

        hash = sctp_assoc_hashfn(ep->base.bind_addr.port, rport);
        head = &sctp_assoc_hashtable[hash];
        read_lock(&head->lock);
        sctp_for_each_hentry(epb, node, &head->chain) {
            /* maybe your machine is traversing here a *really* long 
chain */
            }

>
> Here's the top results from readprofile, unfortunately these are 
> aggregated across both cpus so they don't really show what's going on. 
> The key thing is that sctp_endpoint_lookup_assoc() is the most 
> expensive kernel routine on this entire system.
>
>   3147 .power4_idle                              22.4786
>   1712 .native_idle                              20.3810
>   1234 .sctp_endpoint_lookup_assoc                2.1725

>   1212 ._spin_unlock_irqrestore                   6.4468
>    778 .do_futex                                  0.3791
>    447 ._spin_unlock_irq                          4.2981
>    313 .fget                                      1.7784
>    277 .fput                                      3.8472
>    275 .kfree                                     0.7473
>    234 .__kmalloc                                 0.5571
>    131 SystemCall_common                          0.3411
>    130 .sctp_assoc_is_match                       0.6373
>    123 .lock_sock                                 0.4155
>    119 .find_vma                                  0.6919
>    116 .kmem_cache_alloc                          0.3580
>    111 .kmem_cache_free                           0.3343
>    106 .skb_release_data                          0.4907
>    102 .__copy_tofrom_user                        0.0724
>    100 .exit_elf_binfmt                           1.9231
>    100 .do_select                                 0.0820
>
>
> Chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>




