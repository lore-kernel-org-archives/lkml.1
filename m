Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYHDJW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYHDJW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYHDJWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:22:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14865 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYHDJWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=phbt34I3+ZN0PlJggO3GsOA7cPsOzDOoWqHIDb1YpNwmPTVbL4Qzp/FAed2qV268IO
         7iqGMg0Y10F7E+bRo4z2uGg+OwokPfGdCViETLQElL6AH2jvZsl+W6Zts4Y/xMI+c+b/
         /puEYgPfFAaZ4U0qkH9eZMBvpsetmgrlDvogQ=
Message-ID: <4896CA3F.3070709@gmail.com>
Date: Mon, 04 Aug 2008 11:22:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [BUG] wireless : cpu stuck for 61s
References: <20080729055731.GA3265@darkstar>  <1217334724.10489.47.camel@johannes.berg>  <20080730020820.8bcc00e2.akpm@linux-foundation.org>  <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>  <20080730031047.54e13e2d.akpm@linux-foundation.org>  <a8e1da080 <a8e1da0808010032h32c18054g3712466eb40f0acf@mail.gmail.com>
In-Reply-To: <a8e1da0808010032h32c18054g3712466eb40f0acf@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young napsal(a):
> On Thu, Jul 31, 2008 at 5:15 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>> On Wed, 30 Jul 2008, Andrew Morton wrote:
>>> INFO: Allocated in dev_alloc_skb+0x1c/0x30 age=3642 cpu=0 pid=0
>>> INFO: Freed in skb_release_data+0x57/0x80 age=3146 cpu=0 pid=2398
>> So the corrupted object was free'd by skb_release_data() so we need to
>> look for a driver or the networking stack calling that function too early.
>>
>>> INFO: Slab 0xc1c05440 objects=7 used=3 fp=0xf6f3a060 flags=0x400020c3
>>> INFO: Object 0xf6f3a060 @offset=8288 fp=0xf6f39030
>>>
>>> Bytes b4 0xf6f3a050:  5e 09 00 00 57 c9 05 00 5a 5a 5a 5a 5a 5a 5a 5a ^...WÉ..ZZZZZZZZ
>> The object starts here (the poison values for first 32 bytes are okay):
>>
>>> Object 0xf6f3a060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>> Object 0xf6f3a070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> And here are the first 96 bytes of the corruption:
>>
>>> Object 0xf6f3a080:  80 00 00 00 ff ff ff ff ff ff 00 17 7b 00 46 40 ....ÿÿÿÿÿÿ..{.F@
>>> Object 0xf6f3a090:  00 17 7b 00 46 40 30 09 81 21 08 7a 21 00 00 00 ..{.F@0..!.z!...
>>> Object 0xf6f3a0a0:  64 00 21 04 00 07 00 00 00 00 00 00 00 01 08 82 d.!.............
>>> Object 0xf6f3a0b0:  84 8b 0c 12 96 18 24 03 01 01 05 04 00 02 00 00 ......$.........
>>> Object 0xf6f3a0c0:  07 06 43 4e 20 01 0d 14 2a 01 00 32 04 30 48 60 ..CN....*..2.0H`
>>> Object 0xf6f3a0d0:  6c dd 18 00 17 7b 01 04 00 00 00 01 00 00 00 10 lÝ...{..........
>> But I think that's just the payload of a SKB?

It's a receive frame from ath5k, I suppose. 00:17:7b:00:46:40 is your AP?

>>> Redzone 0xf6f3b060:  bb bb bb bb                                     »»»»
>> The red-zone has SLUB_RED_INACTIVE ("0xbb") which reinforces
>> use-after-free.
>>
>>> Padding 0xf6f3b088:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
>>> Pid: 0, comm: swapper Tainted: G        W 2.6.26-smp #2
>>> [<c0180f5d>] print_trailer+0xad/0xf0
>>> [<c018103b>] check_bytes_and_report+0x9b/0xc0
>>> [<c018145e>] check_object+0x19e/0x1e0
>>> [<c01821a4>] __slab_alloc+0x454/0x4f0
>>> [<c01834d6>] __kmalloc_track_caller+0xe6/0xf0
>>> [<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30
>>> [<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30
>>> [<c03dce79>] __alloc_skb+0x49/0x100
>>> [<c03dd1ec>] dev_alloc_skb+0x1c/0x30
>>> [<f8a58599>] ath5k_rxbuf_setup+0x39/0x200 [ath5k]
>>> [<f8a5a697>] ath5k_tasklet_rx+0x127/0x5c0 [ath5k]
>>> [<c014969a>] ? print_lock_contention_bug+0x1a/0xe0
>>> [<c012eafc>] tasklet_action+0x4c/0xc0
[...]
>>> =======================
>>> FIX kmalloc-4096: Restoring 0xf6f3a080-0xf6f3a0ef=0x6b

>>> Dave, could you please remind us which net driver was in use here?
>> There's ath5k in the stack trace but that, of course, doesn't
>> automatically mean it's at fault here. It could have been just the poor
>> bastard who was the next to allocate 4 KB with kmalloc() noticing the
>> corruption.

No, unfortunately ath5k *is* likely the culprit. Next time please Cc 
ath5k-devel@lists.ath5k.org even if it is only a suspicion.

> But I still have no idea with the poison overwritten.

Could you try patch from
http://lkml.org/lkml/2008/7/15/276
? (I have no idea how reproducible is this by you, it often happens on noisy 
channels and/or by lowering RX buffers, i.e. ATH_RXBUF).

[It hit mainline few days ago, I'm going to fwd it to stable.]
