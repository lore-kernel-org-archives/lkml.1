Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYGUJw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYGUJw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYGUJwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:52:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:9739 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYGUJwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=D5BbvnHqpGCBUFOQCx28IC089xt4nIAHXRQajQOPhyLr0rqfqoCA7Q1lgM86zZDBaW
         +fp82NlyKPERJGFhJphS2m+6hLBAroArj+DjA+SV405aJ0LeOmZ/+sb7TSReB1whN8fU
         PxxAmQ7xpWLGOCuAbciXJfYTh15TOIhCl6Qyw=
Message-ID: <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:52:45 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cl@linux-foundation.org,
       davem@davemloft.net, johnpol@2ka.mipt.ru
In-Reply-To: <20080721094110.GA16029@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
	 <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu>
X-Google-Sender-Auth: 66f30ba46548c52b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6L9r9fq027496

Hi Ingo,
On Mon, Jul 21, 2008 at 12:41 PM, Ingo Molnar <mingo@elte.hu> wrote:> update about this problem: just triggered another colorful crash, see> below. This was with the 4K object dump patch already, maybe the dump> gives a clue?
...to point out the obvious:
> =============================================================================> BUG skbuff_head_cache: Poison overwritten> ----------------------------------------------------------------------------->> INFO: 0xf7ccc100-0xf7ccc103. First byte 0x0 instead of 0x6b> INFO: Allocated in __alloc_skb+0x30/0x10e age=1 cpu=1 pid=1> INFO: Freed in __kfree_skb+0x63/0x66 age=1 cpu=0 pid=0> INFO: Slab 0xc1c34ca0 objects=16 used=1 fp=0xf7ccc100 flags=0x400000c3> INFO: Object 0xf7ccc100 @offset=256 fp=0xf7ccc200>> Bytes b4 0xf7ccc0f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ>  Object 0xf7ccc100:  00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ....kkkkkkkkkkkk
Use after free where first four bytes are zeroed.
>  Object 0xf7ccc110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  Object 0xf7ccc1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkkï¿½
Rest of the object looks correct.
>  Redzone 0xf7ccc1b0:  bb bb bb bb                                     ï¿½ï¿½ï¿½ï¿½>  Padding 0xf7ccc1d8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ>  Padding 0xf7ccc1e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ>  Padding 0xf7ccc1f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ> Pid: 1, comm: swapper Not tainted 2.6.26-tip #3261>  [<c01673ad>] print_trailer+0xd1/0xd9>  [<c0167428>] check_bytes_and_report+0x73/0x8f>  [<c0167664>] check_object+0xa5/0x15a>  [<c016824c>] __slab_alloc+0x2fb/0x3c8>  [<c0168364>] kmem_cache_alloc+0x4b/0xa8>  [<c0497376>] ? __alloc_skb+0x30/0x10e>  [<c0497376>] ? __alloc_skb+0x30/0x10e>  [<c0497376>] __alloc_skb+0x30/0x10e>  [<c04a6678>] alloc_skb+0xc/0xe>  [<c04a6ce5>] find_skb+0x28/0x66>  [<c04a6f5f>] netpoll_send_udp+0x2b/0x1cf>  [<c058800f>] ? _spin_lock_irqsave+0x4b/0x55>  [<c03db399>] write_msg+0x79/0xac>  [<c03db320>] ? write_msg+0x0/0xac>  [<c0122f96>] __call_console_drivers+0x56/0x63>  [<c0122ffa>] _call_console_drivers+0x57/0x5b>  [<c0123386>] release_console_sem+0x112/0x1a5>  [<c01238f3>] vprintk+0x344/0x35e> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
