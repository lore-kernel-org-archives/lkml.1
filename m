Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbXJ0JWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbXJ0JWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXJ0JW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:22:28 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:27047 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751300AbXJ0JW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:22:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c7gTMt9UqpbcNto2P5JTjDErNYWJkAVOx7lxMWO4ADajQWc+ChrnWSyR3HVh1o/sVh+Q7+lYOWZSOfyKwoSx2faARF9nP0aCC7nxh6M5iFAibDK9KyLtF/7bx29I3E/d7vCjjqv0Yx+5Cj3oS8IBLXY1jPdsLxA3SdECpFn5JfQ=  ;
X-YMail-OSG: BZ4Z4W8VM1llZC3mZFMNqG.JlBZHD9DLcSpu1RrWQEXIULG8kfVEH5PzsLsZ860B3i3iyHk9LA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
Date: Sat, 27 Oct 2007 19:15:42 +1000
User-Agent: KMail/1.9.5
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1193245634.20679.8.camel@localhost.localdomain> <1193462494.25330.7.camel@Homer.simpson.net>
In-Reply-To: <1193462494.25330.7.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271915.42363.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 15:21, Mike Galbraith wrote:
> Greetings,
>
> For quite a while now, RT kernels have been locking up on me
> occasionally while my back is turned.  Yesterday, the little bugger
> finally pounced while my serial console box was up and waiting.
>
> [10138.162953] WARNING: at arch/i386/kernel/smp.c:581
> native_smp_call_function_mask() [10138.170583]  [<c01051da>]
> show_trace_log_lvl+0x1a/0x30
> [10138.175796]  [<c0105de3>] show_trace+0x12/0x14
> [10138.180291]  [<c0105dfb>] dump_stack+0x16/0x18
> [10138.184769]  [<c011609f>] native_smp_call_function_mask+0x138/0x13d
> [10138.191117]  [<c0117606>] smp_call_function+0x1e/0x24
> [10138.196210]  [<c012f85c>] on_each_cpu+0x25/0x50
> [10138.200807]  [<c0115c74>] flush_tlb_all+0x1e/0x20
> [10138.205553]  [<c016caaf>] kmap_high+0x1b6/0x417
> [10138.210118]  [<c011ec88>] kmap+0x4d/0x4f
> [10138.214102]  [<c026a9d8>] ntfs_end_buffer_async_read+0x228/0x2f9
> [10138.220163]  [<c01a0e9e>] end_bio_bh_io_sync+0x26/0x3f
> [10138.225352]  [<c01a2b09>] bio_endio+0x42/0x6d
> [10138.229769]  [<c02c2a08>] __end_that_request_first+0x115/0x4ac
> [10138.235682]  [<c02c2da7>] end_that_request_chunk+0x8/0xa
> [10138.241052]  [<c0365943>] ide_end_request+0x55/0x10a
> [10138.246058]  [<c036dae3>] ide_dma_intr+0x6f/0xac
> [10138.250727]  [<c0366d83>] ide_intr+0x93/0x1e0
> [10138.255125]  [<c015afb4>] handle_IRQ_event+0x5c/0xc9

Looks like ntfs is kmap()ing from interrupt context. Should
be using kmap_atomic instead, I think.

But the ntfs code I have seems to do just that...
