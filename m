Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZFXItx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZFXItx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZFXItm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:49:42 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:31359 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754376AbZFXItj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:49:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BCJjypE2FYcXkNdPvJfZjDYqTHP7o2FCAjHTPZtTmj/7FxdqGMFdYQBrYFEuIwWCzfP/01xy5gGtVQ12j44t3ruP6QTMnlylb18LPzqY91MsWT10mTXir1sgvy5dMJKqY6U5pcH8ipO0DkeTDRvJTlz92EIQywdjWX6HwI5/suw=  ;
X-YMail-OSG: y8XcAPIVM1k8_Df_VXU48j7UewtAC8UKNPKewoYRP4L_XPJQyX5AGHrmRtPsa1ncLbyMqKR356OruGU5ggAlDKWnHyVVMfHATGxedJmtg9cxA6dPMdQsXhPsOR0WgfX54XjIOXcs0c.lC8mlUIE8gz7NkIEKbUi_7zd6X.FVO7WY13vg1uWq45fJjDqcDsZy.MpuZwTKeXb00GntKAl196tf73wCte_SQiRihpQlfWhz8_rX8FszguTFXOsCBHoUrPnjjCACZ1cJgiQFn81Ju8wIrWeLeFKb7wt.JdxhmRS3K9XKUPrV
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Wed, 24 Jun 2009 01:49:40 -0700
User-Agent: KMail/1.9.10
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <200906230952.37592.david-b@pacbell.net> <002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com>
In-Reply-To: <002101c9f49a$6cfcaf50$46f60df0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906240149.41013.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Marek Szyprowski wrote:
> I did some additional tests and found another bug. When I enabled debug in my
> low level udc driver then I can easily trigger the following bug:
> 
> [   55.630000] Unable to handle kernel NULL pointer dereference at virtual address 00000014
> [   55.630000] pgd = c0004000
> [   55.630000] [00000014] *pgd=00000000
> [   55.630000] Internal error: Oops: 17 [#1] PREEMPT
> [   55.630000] Modules linked in:
> [   55.630000] CPU: 0    Not tainted  (2.6.30 #355)
> [   55.630000] PC is at __lock_acquire+0xa0/0xa6c
> [   55.630000] LR is at lock_acquire+0x58/0x6c
> [   55.630000] ...
> [   55.630000] [<c005786c>] (__lock_acquire+0xa0/0xa6c) from [<c0058290>] (lock_acquire+0x58/0x6c)
> [   55.630000] [<c0058290>] (lock_acquire+0x58/0x6c) from [<c0274e74>] (_spin_lock_irqsave+0x44/0x58)
> [   55.630000] [<c0274e74>] (_spin_lock_irqsave+0x44/0x58) from [<c019d608>] (gs_write_room+0x10/0x58)
> [   55.630000] [<c019d608>] (gs_write_room+0x10/0x58) from [<c0156058>] (tty_write_room+0x20/0x28)

So it's looking like tty->driver_data is somehow NULL.  That's
never supposed to happen.  Did gs_open() fail or something?



> [   55.630000] [<c0156058>] (tty_write_room+0x20/0x28) from [<c01538e0>] (process_echoes+0x4c/0x288)
> [   55.630000] [<c01538e0>] (process_echoes+0x4c/0x288) from [<c0155a40>] (n_tty_receive_buf+0x9ec/0xecc)
> [   55.630000] [<c0155a40>] (n_tty_receive_buf+0x9ec/0xecc) from [<c0158174>] (flush_to_ldisc+0x104/0x1b0)
> [   55.630000] [<c0158174>] (flush_to_ldisc+0x104/0x1b0) from [<c00498e0>] (worker_thread+0x1d0/0x2cc)
> [   55.630000] [<c00498e0>] (worker_thread+0x1d0/0x2cc) from [<c004d55c>] (kthread+0x58/0x90)
> [   55.630000] [<c004d55c>] (kthread+0x58/0x90) from [<c003c03c>] (do_exit+0x0/0x5d0)
> [   55.630000] [<c003c03c>] (do_exit+0x0/0x5d0) from [<c6c26180>] (0xc6c26180)
> [   55.630000] Code: ea000076 e59d100c e3510000 1a000002 (e5994004)
> [   55.640000] ---[ end trace f9a4499d9482c504 ]---
> [   55.650000] note: events/0[5] exited with preempt_count 1
> 
> The low latency mode is disabled. I've tested different ways of gathering
> the debug output from my lowlevel udc driver: in first attempt it was 
> printk(KERN_INFO ...) then I switched to use lowlevel printascii() to remove
> possible interaction with console/tty framework at all. In both cases I got
> the above NULL pointer exception. It only worked fine when I switched to
> printk(KERN_DEBUG ...) with debug level above KERN_DEBUG, so all the
> messages were only buffered in dmesg buffer. This looks like a timing issue
> in tty framework...
>  


