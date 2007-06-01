Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbXFAHT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbXFAHT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXFAHTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:19:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:54900 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFAHTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T1Gqbs50laM/ft1/k9HN3MT5hSeGxe3df2wTU+l+IhzmlJbnLC+HU2yzF1Kzrkq5JvAuVGEqsc0Hcl7iMydJIk6P0T3NetWDwAdGqdoOiZcbloHF2DkiNyG7WK5h0sKHeF/OpaH5cT4ZhEs+3bBAY3dv1bkA+TuFMB5GQIw71Vo=
Message-ID: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
Date: Fri, 1 Jun 2007 09:19:20 +0200
From: "George Krajcsovits" <george.krajcsovits@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Callchain contains impossible call
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is probably RTFM (where is this manual?), but how did I get a
callchain on a uniprocessor
system where there are two functions that cannot be a part of it,
because they don't call anything ? (kfree_skbmem and __kmalloc). Also
at the end one function call is there twice.

Seems like stack corruption, but I did try to close others out with
spin_lock_bh. This part of the code is called from kernel traps and
softirq for ethernet RX.

See here (I changed call names):
kernel BUG at mm/slab.c:1783!
invalid operand: 0000 [#1]
CPU: 0
EIP: 0060:[<c014a134>] Tainted: P U
EFLAGS: 00010006 (2.6.5-tsp1 )
EIP is at kfree+0x224/0x3b0
eax: 003c664f ebx: 00010c00 ecx: 0000040c edx: 000000a4
esi: c58bf9b0 edi: 00000000 ebp: c0795c5c esp: c0795c30
ds: 007b es: 007b ss: 0068
Process swapper (pid: 0, threadinfo=c0794000 task=c060aa40)
Stack: c58bf9b0 f46e0858 c0795c5c c0149b18 f8bcf836 f46e0858 c58bb360 00000286
f46e0b28 f381fc64 f46e085c c0795c6c f8bcf836 f46e085c f46e0af4 c0795cac
f8bce00c f46e085c 00000000 f8bd26bb 0014e6d0 a295af12 f381fc78 f381fc78

Call Trace:
[<c0149b18>] __kmalloc+0x178/0x230
[<f8bcf836>] myfree+0x11/0x17 [Y]
[<f8bcf836>] myfree+0x11/0x17 [Y]
[<f8bce00c>] func4+0x36e/0x376 [Y]
...
[<f898fef6>] func3+0xe6/0x220 [X]
[<c045a735>] kfree_skbmem+0x25/0x30
[<f898de61>] func2+0x561/0x6f0 [X]
[<c0149b77>] __kmalloc+0x1d7/0x230
[<f89a524f>] func1+0x5f/0xa0 [X]
[<c045f983>] netif_receive_skb+0x1c3/0x260
[<c02d1195>] e1000_clean_rx_irq+0x375/0x400
[<c02d0bca>] e1000_clean+0x4a/0xc0
[<c045fb92>] net_rx_action+0x72/0x100
[<c012a29c>] __do_softirq+0x8c/0x90
[<c012a2cb>] do_softirq+0x2b/0x30
[<c010b655>] do_IRQ+0xe5/0x120
[<c0109a6c>] common_interrupt+0x18/0x20
[<c0107066>] default_idle+0x26/0x40
[<c01070f4>] cpu_idle+0x34/0x40
[<c0796824>] start_kernel+0x184/0x1c0
[<c0796540>] unknown_bootoption+0x0/0x120

Thanks in advance, krajo
