Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321Ab0AUIq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab0AUIq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204Ab0AUIq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:46:58 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64532 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab0AUIq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ee6eIjOH0Sk7B8CVlRh2g7L+JttEeTP8+uQVWmGs2ALnDO14Av5GzaDw/CgeghA9uT
         +ZYD/PgfxR03W7Mz5UapvV65k97CbCJL+GzGVmroyguJphUe/iShmqVU0hLgrOs2Z4W1
         EOtuvs9XE5MbNjzweML4tiq3GOU63Vlpwi29U=
MIME-Version: 1.0
In-Reply-To: <1264062159.4283.1125.camel@laptop>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
	 <1264062159.4283.1125.camel@laptop>
Date: Thu, 21 Jan 2010 16:46:56 +0800
Message-ID: <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
Subject: Re: qlogic lockdep warning
From: Xiaotian Feng <xtfeng@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       James.Bottomley@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qla24xx_msix_default is using spin_lock_irq and spin_unlock_irq within
the irq handler...
I think convert to spin_lock_irqsave/spin_unlock_irqrestore can solve
this warning.

On Thu, Jan 21, 2010 at 4:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-01-20 at 17:10 -0800, Yinghai Lu wrote:
>
>> [   77.962879] ------------[ cut here ]------------
>> [   77.965784] WARNING: at kernel/lockdep.c:2332
>> trace_hardirqs_on_caller+0xc6/0x14b()
>> [   77.977492] Hardware name: Sun
>> [   77.979485] Modules linked in:
>> [   77.994337] Pid: 0, comm: swapper Not tainted
>> 2.6.33-rc4-tip-yh-03949-g3a8e3f5-dirty #64
>> [   78.000120] Call Trace:
>> [   78.013298]  <IRQ>  [<ffffffff81076b54>] warn_slowpath_common+0x7c/0x94
>> [   78.017746]  [<ffffffff81cd712c>] ? _raw_spin_unlock_irq+0x30/0x36
>> [   78.035171]  [<ffffffff81076b80>] warn_slowpath_null+0x14/0x16
>> [   78.040152]  [<ffffffff810a2ae8>] trace_hardirqs_on_caller+0xc6/0x14b
>> [   78.055400]  [<ffffffff810a2b7a>] trace_hardirqs_on+0xd/0xf
>> [   78.058951]  [<ffffffff81cd712c>] _raw_spin_unlock_irq+0x30/0x36
>> [   78.074889]  [<ffffffff816461ef>] qla24xx_msix_default+0x243/0x281
>> [   78.091598]  [<ffffffff810a5752>] ? __lock_release+0xa5/0xae
>> [   78.096799]  [<ffffffff810c02ae>] handle_IRQ_event+0x53/0x113
>> [   78.111568]  [<ffffffff810c2061>] handle_edge_irq+0xf3/0x13b
>> [   78.116255]  [<ffffffff81035109>] handle_irq+0x24/0x2f
>> [   78.132063]  [<ffffffff81cdc4b4>] do_IRQ+0x5c/0xc3
>> [   78.134684]  [<ffffffff81cd7393>] ret_from_intr+0x0/0xf
>> [   78.137903]  <EOI>  [<ffffffff81039a56>] ? mwait_idle+0xaf/0xbb
>> [   78.155674]  [<ffffffff81039a4d>] ? mwait_idle+0xa6/0xbb
>> [   78.158600]  [<ffffffff81031c7c>] cpu_idle+0x61/0xa1
>> [   78.174333]  [<ffffffff81c85d7a>] rest_init+0x7e/0x80
>> [   78.178122]  [<ffffffff82832d1f>] start_kernel+0x316/0x31d
>> [   78.193623]  [<ffffffff82832297>] x86_64_start_reservations+0xa7/0xab
>> [   78.198924]  [<ffffffff8283237f>] x86_64_start_kernel+0xe4/0xeb
>> [   78.214540] ---[ end trace be4529f30a2e4ef5 ]---
>
> It appears the thing tries to enable IRQs from within an IRQ handler,
> naughty.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
