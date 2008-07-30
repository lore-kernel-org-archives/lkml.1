Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbYG3MWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbYG3MWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYG3MWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:22:11 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:20766 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYG3MWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cEMIsS3Y6PC6nrnH/Pac6PR/UQcQRPL8hVA1VfwJzmqelQYYbyyiX6do9TTfyx4TAA
         XLz0F0fnRX3bfZ1loAYIHU/i0qG5TSbE9u+yRMxZKPmVMtS3/gGCHTAqnl6wyzPtHVAH
         /FzUlhk8owJrX0e7tYXMQBEdK8enXt91W74w4=
Message-ID: <6f31812b0807300522v6ecc4ebev4ea7e552d69753b5@mail.gmail.com>
Date: Wed, 30 Jul 2008 17:52:08 +0530
From: "jay kumar" <jaykumarks@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.27-rc1 inconsistent lock state during boot time
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080730034443.748d9a19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6f31812b0807300237k54a5350fsc12189ea4b5479cd@mail.gmail.com>
	 <20080730034443.748d9a19.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 4:14 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 30 Jul 2008 15:07:14 +0530 "jay kumar" <jaykumarks@gmail.com> wrote:
>
>>          While  testing  2.6.27-rc1 ,  "inconsistent lock state"
>> warning appeared at boot time
>>          posting: dmesg  along with .config and hardware info.
>>
>>          commit 6e86841d05f371b5b9b86ce76c02aaee83352298
>>          Author: Linus Torvalds <torvalds@linux-foundation.org>
>>          Date:   Mon Jul 28 19:40:31 2008 -0700
>>
>> ..
>>
>> [    7.317402] debug: unmapping init memory c0571000..c0625000
>> [    7.324903]
>> [    7.324904] =================================
>> [    7.330825] [ INFO: inconsistent lock state ]
>> [    7.335218] 2.6.27-rc1 #5
>> [    7.337873] ---------------------------------
>> [    7.342273] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
>> [    7.348325] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>> [    7.353331]  (&port_lock_key){+-..}, at: [<c02e2eee>]
>> serial8250_interrupt+0x6e/0x160
>> [    7.361383] {hardirq-on-W} state was registered at:
>> [    7.366303]   [<c0155b65>] __lock_acquire+0x3b5/0x12e0
>> [    7.371559]   [<c0156b28>] lock_acquire+0x98/0xd0
>> [    7.376383]   [<c0404be2>] _spin_lock+0x32/0x60
>> [    7.381036]   [<c02e2a1d>] serial8250_startup+0x29d/0x640
>> [    7.386559]   [<c02dda91>] uart_startup+0x51/0x170
>> [    7.391471]   [<c02df58f>] uart_open+0xef/0x420
>> [    7.396124]   [<c02c9599>] tty_open+0x159/0x300
>> [    7.401396]   [<c01aac81>] chrdev_open+0x91/0x190
>> [    7.406220]   [<c01a63d6>] __dentry_open+0xb6/0x230
>> [    7.411220]   [<c01a6597>] nameidata_to_filp+0x47/0x60
>> [    7.416481]   [<c01b30de>] do_filp_open+0x19e/0x710
>> [    7.421480]   [<c01a61cd>] do_sys_open+0x4d/0xe0
>> [    7.426218]   [<c01a62c9>] sys_open+0x29/0x40
>> [    7.430698]   [<c0101146>] init_post+0x36/0x100
>> [    7.435353]   [<ffffffff>] 0xffffffff
>> [    7.439137] irq event stamp: 177720
>
> Does this fix it?
Fixed ..

Thanks

>
> From: Borislav Petkov <petkovbb@googlemail.com>
>
> serial8250_startup() doesn't disable interrupts while taking the &up->port.lock
> which might race against the interrupt handler serial8250_interrupt(), which
> when entered, will deadlock waiting for the lock to be released.
>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> Tested-by: Ingo Molnar <mingo@elte.hu>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/serial/8250.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN drivers/serial/8250.c~8250c-portlock-is-irq-safe drivers/serial/8250.c
> --- a/drivers/serial/8250.c~8250c-portlock-is-irq-safe
> +++ a/drivers/serial/8250.c
> @@ -1885,7 +1885,7 @@ static int serial8250_startup(struct uar
>                 * the interrupt is enabled.  Delays are necessary to
>                 * allow register changes to become visible.
>                 */
> -               spin_lock(&up->port.lock);
> +               spin_lock_irqsave(&up->port.lock, flags);
>                if (up->port.flags & UPF_SHARE_IRQ)
>                        disable_irq_nosync(up->port.irq);
>
> @@ -1901,7 +1901,7 @@ static int serial8250_startup(struct uar
>
>                if (up->port.flags & UPF_SHARE_IRQ)
>                        enable_irq(up->port.irq);
> -               spin_unlock(&up->port.lock);
> +               spin_unlock_irqrestore(&up->port.lock, flags);
>
>                /*
>                 * If the interrupt is not reasserted, setup a timer to
> _
>
>
