Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYA3KYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYA3KYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbYA3KVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:21:55 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:58997 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbYA3KVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=nt5tEXAdaWiE+HOSBT1grSmn3eD1xSK7QDPF4xvGqMnLJRamaU0kYiKJK+iiW97rNe1d+ETr946wZd0h+p9tBf1LVWimswwPK3Iv+Xq01FVROAA9Xs3THm65yA3BvCXc8+5aCYON4Scnnt8cvg9+DD2NKZ0DKVFUVwH0Bi7txQM=
Message-ID: <3efb10970801300221h601261edy33cf89dac5abde78@mail.gmail.com>
Date: Wed, 30 Jan 2008 11:21:49 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       michael <trimarchi@gandalf.sssup.it>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Cc: fabio@gandalf.sssup.it, "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20352_25639908.1201688509790"
References: <20080129224316.GA23155@gandalf.sssup.it>
	 <479FB2D7.4020804@gandalf.sssup.it>
	 <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 4e908c2d990aad40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20352_25639908.1201688509790
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Haavard (and Michael),

First I want to mention that I did not found the time yet to test your
latest integration of these atmel_serial patches, and I only know that
your set of the end of December works fine. I do not know the changes
you made since posting that set and your latest patch-set.

But let me clear some things up:
The original patchset I posted, existed of a set of patches suitable
for the mainline kernel, plus an additional patch for Preempt-RT only.
So, the splitup  of the interrupt handler was also needed for
Preempt-RT, but it was not the only patch that was needed on
preempt-rt.

Now looking at this problem:
> >  * Drop the lock here since it might end up calling
> >  * uart_start(), which takes the lock.
> >    spin_unlock(&port->lock);
> >  */
> >     tty_flip_buffer_push(port->info->tty);
> > /*
> >     spin_lock(&port->lock);
> >  */
> > The same code with this comments out runs

I expect the UART generating the problem is the DBGU port. The DBGU
shares its interrupt line with the timer interrupt with the IRQF_TIMER
flag set, and thus the DBGU interrupt handler is running in
IRQF_NODELAY context. Within this context it is forbidden to lock a
normal spinlock, because a normal spinlock is converted to a mutex on
Preempt-RT; a mutex can sleep which is forbidden in interrupt context.
So, to get around this problem, this lock spinlock has to be of the
raw_spinlock_t type. The raw_spinlock_t is the normal mainline-kernel
spinlock, and as such it is not converted to a mutex, and will
therefor never sleep.

Attached a patch that changes this spinlock type. I used it in my
patchset, but your updates of December last year do not need this
patch anymore, so apparantly you changed something that has a
regression on Preempt-RT...

> > Complete Preemption (Real-Time) ok but the serials is just unusable due
> > to too many overruns (just using lrz)

This problem is not there in the December-set either. It works like a charm...

I believe I have to look at the latest set of patches, and try to find
any regressions. Do you have a location somewhere where I can download
the latest versions? Or do I need to dig through LKML to find the
latest... ;-)

Kind Regards,

Remy



2008/1/30, Haavard Skinnemoen <hskinnemoen@atmel.com>:
> On Wed, 30 Jan 2008 00:12:23 +0100
> michael <trimarchi@gandalf.sssup.it> wrote:
>
> > I'm testing this patch on an at91sam9260 on 2.6.24-rt. I'm using this
> > patch with the tclib support for hrtimer and the clocksource pit_clk.
> > These are the results:
> >
> > - Voluntary Kernel Preemption the system (crash)
> > - Preemptible  Kernel (crash)
>
> Ouch. I'm assuming this is with DMA disabled?
>
> > /*
> >  * Drop the lock here since it might end up calling
> >  * uart_start(), which takes the lock.
> >    spin_unlock(&port->lock);
> >  */
> >     tty_flip_buffer_push(port->info->tty);
> > /*
> >     spin_lock(&port->lock);
> >  */
> > The same code with this comments out runs
>
> Now, _that_ is strange. I can't see anything that needs protection
> across that call; in fact, I think we can lock a lot less than what we
> currently do.
>
> > Complete Preemption (Real-Time) ok but the serials is just unusable due
> > to too many overruns (just using lrz)
>
> Is it worse than before? IIRC Remy mentioned something about
> IRQF_NODELAY being the reason for moving all this code to softirq
> context in the first place; does the interrupt handler run in hardirq
> context?
>
> > The system is stable and doesn't crash reverting this patch.
> > I don't test with the thread hardirqs active.
>
> Ok.
>
> > >> +  ret = -ENOMEM;
> > >> +  data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
> > >> +  if (!data)
> > >> +          goto err_alloc_ring;
> > >> +  port->rx_ring.buf = data;
> > >> +
> > >>    ret = uart_add_one_port(&atmel_uart, &port->uart);
> > >>
> > Is the kmalloc correct?
> > maybe:
> > data = kmalloc(ATMEL_SERIAL_RINGSIZE * sizeof(struct atmel_uart_char),
> > GFP_KERNEL);
>
> I think you're right. Can you change it and see if it helps?
>
> I guess I didn't test it thoroughly enough with DMA
> disabled...slub_debug ought to catch such things, but not until we
> receive enough data to actually overflow the buffer.
>
> > >> @@ -1033,6 +1165,9 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
> > >>
> > >>    ret = uart_remove_one_port(&atmel_uart, port);
> > >>
> > >> +  tasklet_kill(&atmel_port->tasklet);
> > >> +  kfree(atmel_port->rx_ring.buf);
> > >> +
> > >>
> > Why the tasklet_kill is not done in atmel_shutdown?
>
> Why should it be? If it should, we must move the call to tasklet_init
> into atmel_startup too, and I don't really see the point.
>
> Haavard
>

------=_Part_20352_25639908.1201688509790
Content-Type: text/x-patch; name=atmel_serial_irqf_nodelay.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fc1pblcs
Content-Disposition: attachment; filename=atmel_serial_irqf_nodelay.patch

T24gUFJFRU1QVC1SVCB3ZSBtYXkgbm90IGJsb2NrIG9uIGEgbm9ybWFsIHNwaW5sb2NrIGluIElS
US9JUlFGX05PREVMQVktY29udGV4dC4KVGhpcyBwYXRjaCBmaXhlcyB0aGlzIGJ5IG1ha2luZyB0
aGUgbG9jayBhIHJhd19zcGlubG9ja190IGZvciB0aGUKQXRtZWwgc2VyaWFsIGNvbnNvbGUuCgpU
aGlzIHBhdGNoIGRlbWFuZHMgdGhlIGZvbGxvd2luZyBwYXRjaGVzIHRvIGJlIGluc3RhbGxlZCBm
aXJzdDoKKiBhdG1lbF9zZXJpYWxfY2xlYW51cC5wYXRjaAoqIGF0bWVsX3NlcmlhbF9pcnFfc3Bs
aXR1cC5wYXRjaAoKU2lnbmVkLW9mZi1ieTogUmVteSBCb2htZXIgPGxpbnV4QGJvaG1lci5uZXQ+
Ci0tLQogaW5jbHVkZS9saW51eC9zZXJpYWxfY29yZS5oIHwgICAgNyArKysrKystCiAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgtMi42
LjIzL2luY2x1ZGUvbGludXgvc2VyaWFsX2NvcmUuaAo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYu
MjMub3JpZy9pbmNsdWRlL2xpbnV4L3NlcmlhbF9jb3JlLmgJMjAwNy0xMi0xMyAxMzozMToyNy4w
MDAwMDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNi4yMy9pbmNsdWRlL2xpbnV4L3NlcmlhbF9jb3Jl
LmgJMjAwNy0xMi0xMyAxNjozMjoyMi4wMDAwMDAwMDAgKzAxMDAKQEAgLTIyNiw3ICsyMjYsMTIg
QEAgc3RydWN0IHVhcnRfaWNvdW50IHsKIHR5cGVkZWYgdW5zaWduZWQgaW50IF9fYml0d2lzZV9f
IHVwZl90OwogCiBzdHJ1Y3QgdWFydF9wb3J0IHsKLQlzcGlubG9ja190CQlsb2NrOwkJCS8qIHBv
cnQgbG9jayAqLworCisjaWZkZWYgQ09ORklHX1NFUklBTF9BVE1FTAorCXJhd19zcGlubG9ja190
IAkJbG9jazsJCQkvKiBwb3J0IGxvY2sgKi8KKyNlbHNlCisJc3BpbmxvY2tfdCAJCWxvY2s7CQkJ
LyogcG9ydCBsb2NrICovCisjZW5kaWYKIAl1bnNpZ25lZCBpbnQJCWlvYmFzZTsJCQkvKiBpbi9v
dXRbYndsXSAqLwogCXVuc2lnbmVkIGNoYXIgX19pb21lbQkqbWVtYmFzZTsJCS8qIHJlYWQvd3Jp
dGVbYndsXSAqLwogCXVuc2lnbmVkIGludAkJaXJxOwkJCS8qIGlycSBudW1iZXIgKi8K
------=_Part_20352_25639908.1201688509790--
