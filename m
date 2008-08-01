Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYHAHcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYHAHcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYHAHcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:32:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:46218 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYHAHcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IBnk78ig38JMHMR9reMlPOtfqqM9yx+pMqtg6r4t5m6KfOEd1gSYAG6id1mw/T4SBN
         G61PSj9aYwBPOkgHHNMdrH6mA9QpoAULViqzEJJqrzBWl9gzsMWSkfZpBYTdg4+D+oSb
         iRypiCyNfFvB2S+HbmsZapnc+CTTcA/3VKCrE=
Message-ID: <a8e1da0808010032h32c18054g3712466eb40f0acf@mail.gmail.com>
Date: Fri, 1 Aug 2008 15:32:11 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807311156050.27055@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080729055731.GA3265@darkstar>
	 <1217334724.10489.47.camel@johannes.berg>
	 <20080730020820.8bcc00e2.akpm@linux-foundation.org>
	 <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	 <20080730031047.54e13e2d.akpm@linux-foundation.org>
	 <a8e1da0807301906j6438e5d8y64105fe8a2e3dffe@mail.gmail.com>
	 <20080730195637.2197a82d.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0807311156050.27055@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m717WSIG025213

On Thu, Jul 31, 2008 at 5:15 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:> Hi Andrew,>> On Wed, 30 Jul 2008, Andrew Morton wrote:>> > Ok here it is.>> > BTW, I run "klogd -c 7" after boot>>>> The sysrq output is still missing lots of stuff.  I guess we broke it.>>>> >>> > This time I get a kmalloc poison overwritten:>> >>>>> argh, that stuff hurts my brain.  None of the numbers seem to make any>> sense for a 4k allocation :( Pekka, do you have time to decrypt this?>> Sure. Here goes:>> On Wed, 30 Jul 2008, Andrew Morton wrote:>> <fixes wordwrapping, cleans stuff up>>>>> =============================================================================>> BUG kmalloc-4096: Poison overwritten>> ----------------------------------------------------------------------------->>>> INFO: 0xf6f3a080-0xf6f3a0ef. First byte 0x80 instead of 0x6b>> That's POISON_FREE ("0x6b") overwritten which means use-after-free for> the range of 0xf6f3a080 - 0xf6f3a0ef (112 bytes). The rest of the> object is okay but the SLUB debugging code only dumps the first 128 bytes> of the object which is why we don't see the full corruption.>> 2.6.27-rc1 should dump the full object so I'm assuming this is pre -rc1?
Yes, it's 2.6.26
>>> INFO: Allocated in dev_alloc_skb+0x1c/0x30 age=3642 cpu=0 pid=0>> INFO: Freed in skb_release_data+0x57/0x80 age=3146 cpu=0 pid=2398>> So the corrupted object was free'd by skb_release_data() so we need to> look for a driver or the networking stack calling that function too early.>>> INFO: Slab 0xc1c05440 objects=7 used=3 fp=0xf6f3a060 flags=0x400020c3>> INFO: Object 0xf6f3a060 @offset=8288 fp=0xf6f39030>>>> Bytes b4 0xf6f3a050:  5e 09 00 00 57 c9 05 00 5a 5a 5a 5a 5a 5a 5a 5a ^...WÃ‰..ZZZZZZZZ>> The object starts here (the poison values for first 32 bytes are okay):>>> Object 0xf6f3a060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>> Object 0xf6f3a070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>> And here are the first 96 bytes of the corruption:>>> Object 0xf6f3a080:  80 00 00 00 ff ff ff ff ff ff 00 17 7b 00 46 40 ....Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿..{.F@>> Object 0xf6f3a090:  00 17 7b 00 46 40 30 09 81 21 08 7a 21 00 00 00 ..{.F@0..!.z!...>> Object 0xf6f3a0a0:  64 00 21 04 00 07 00 00 00 00 00 00 00 01 08 82 d.!.............>> Object 0xf6f3a0b0:  84 8b 0c 12 96 18 24 03 01 01 05 04 00 02 00 00 ......$.........>> Object 0xf6f3a0c0:  07 06 43 4e 20 01 0d 14 2a 01 00 32 04 30 48 60 ..CN....*..2.0H`>> Object 0xf6f3a0d0:  6c dd 18 00 17 7b 01 04 00 00 00 01 00 00 00 10 lÃ...{..........>> But I think that's just the payload of a SKB?>>> Redzone 0xf6f3b060:  bb bb bb bb                                     Â»Â»Â»Â»>> The red-zone has SLUB_RED_INACTIVE ("0xbb") which reinforces> use-after-free.>>> Padding 0xf6f3b088:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ>> Pid: 0, comm: swapper Tainted: G        W 2.6.26-smp #2>> [<c0180f5d>] print_trailer+0xad/0xf0>> [<c018103b>] check_bytes_and_report+0x9b/0xc0>> [<c018145e>] check_object+0x19e/0x1e0>> [<c01821a4>] __slab_alloc+0x454/0x4f0>> [<c01834d6>] __kmalloc_track_caller+0xe6/0xf0>> [<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30>> [<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30>> [<c03dce79>] __alloc_skb+0x49/0x100>> [<c03dd1ec>] dev_alloc_skb+0x1c/0x30>> [<f8a58599>] ath5k_rxbuf_setup+0x39/0x200 [ath5k]>> [<f8a5a697>] ath5k_tasklet_rx+0x127/0x5c0 [ath5k]>> [<c014969a>] ? print_lock_contention_bug+0x1a/0xe0>> [<c012eafc>] tasklet_action+0x4c/0xc0>> [<c012e463>] __do_softirq+0x93/0x120>> [<c012e547>] do_softirq+0x57/0x60>> [<c012ea29>] irq_exit+0x69/0x80>> [<c0106b55>] do_IRQ+0x45/0x80>> [<c010a5d0>] ? mwait_idle+0x0/0x50>> [<c0104752>] common_interrupt+0x2e/0x34>> [<c010a5d0>] ? mwait_idle+0x0/0x50>> [<c010a609>] ? mwait_idle+0x39/0x50>> [<c01026e0>] cpu_idle+0x60/0xd0>> [<c043c8ce>] rest_init+0x4e/0x60>> =======================>> FIX kmalloc-4096: Restoring 0xf6f3a080-0xf6f3a0ef=0x6b>>>> FIX kmalloc-4096: Marking all objects used>> [<c0243b4f>] ? security_file_permission+0xf/0x20>> [<c019436f>] sys_select+0x3f/0x190>> [<c01878e9>] ? fput+0x19/0x20>> [<c0103dbf>] ? restore_nocheck+0x12/0x15>> [<c014b06d>] ? trace_hardirqs_on+0xbd/0x140>> [<c0103d5e>] syscall_call+0x7/0xb>> =======================>>>> Dave, could you please remind us which net driver was in use here?>> There's ath5k in the stack trace but that, of course, doesn't> automatically mean it's at fault here. It could have been just the poor> bastard who was the next to allocate 4 KB with kmalloc() noticing the> corruption.>> Hope this helps!>>                        Pekka
Lockdep helped me, this morning I get a lockdep warning about this,
[  171.432140] [ INFO: possible recursive locking detected ][  171.433113] 2.6.27-rc1-smp #4[  171.434079] ---------------------------------------------[  171.435039] ath5k_pci/2447 is trying to acquire lock:[  171.435990]  (&sc->lock){--..}, at: [<f89ee9b5>]ath5k_config_interface+0xd5/0x340 [ath5k][  171.437046][  171.437048] but task is already holding lock:[  171.438903]  (&sc->lock){--..}, at: [<f89ee91d>]ath5k_config_interface+0x3d/0x340 [ath5k][  171.439953][  171.439954] other info that might help us debug this:[  171.441795] 3 locks held by ath5k_pci/2447:[  171.442729]  #0:  ((name)){--..}, at: [<c013a122>] run_workqueue+0x102/0x1d0[  171.443800]  #1:  (&(&local->scan_work)->work){--..}, at:[<c013a122>] run_workqueue+0x102/0x1d0[  171.444859]  #2:  (&sc->lock){--..}, at: [<f89ee91d>]ath5k_config_interface+0x3d/0x340 [ath5k]
Deadlock happen here, I remove the lock in the sub routine, tested andfixed the problem for me.I will send the patch after a while.
But I still have no idea with the poison overwritten.
-- Regardsdaveÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
