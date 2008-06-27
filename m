Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbYF0QIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbYF0QIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbYF0QIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:08:10 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:20274 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757321AbYF0QIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:08:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lbblnRBS3tQ8J19Fp6Q5Br1wMVHo3Y/Z3TVDQHk8sPA/7q5zep15chXxvoo0TUumDIp7HvmJqG5ayNcuPKFKa2WuGyUyA9MQfjwaQbDMWNPIVDMbLWoO56gWJnEem5/41ngGQXjaJN822yNdJWaY0c+ptEuet2uwigPYBg0mx4I=  ;
X-YMail-OSG: bEF_sAQVM1mb8AFtG318wG5j.tCF1eZxpoDNQX84WjzYYU8Ew_x.ykznkUcOyhLKNSCq5zPMVl9sIDlMR17r..k1w.m.WCP_DwxiXnYsZQAzf51eqwEK0kGwksJCRGhiBUk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Becker <Stefan.Becker@nokia.com>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external USB harddrive
Date: Fri, 27 Jun 2008 09:07:37 -0700
User-Agent: KMail/1.9.9
Cc: ext Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0806261018340.2811-100000@iolanthe.rowland.org> <48641325.2020903@nokia.com>
In-Reply-To: <48641325.2020903@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806270907.37245.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Stefan Becker wrote:
> it seems that the following code paths have the interrupts 
> enabled when calling usb_hcd_unlink_urb_from_ep():
> 
>    [<c0574d9d>] usb_hcd_unlink_urb_from_ep+0x25/0x6b
>    [<de850559>] uhci_giveback_urb+0xcd/0x1e3 [uhci_hcd]
>    [<de850e02>] uhci_scan_schedule+0x511/0x720 [uhci_hcd]
> ...
>    [<de8529c3>] uhci_irq+0x131/0x142 [uhci_hcd]
>    [<c05750cb>] usb_hcd_irq+0x23/0x51

I'll let Alan look at that one, but:


> and
> 
>    [<c0574d9d>] usb_hcd_unlink_urb_from_ep+0x25/0x6b
>    [<de839d55>] ehci_urb_done+0x73/0x92 [ehci_hcd]
>    [<de83a92f>] qh_completions+0x373/0x3eb [ehci_hcd]
>    [<de83aa43>] ehci_work+0x9c/0x6a9 [ehci_hcd]
> ...
>    [<de83ec3c>] ehci_irq+0x241/0x265 [ehci_hcd]
> ...
>    [<c05750cb>] usb_hcd_irq+0x23/0x51
> 
> 
> Is that enough information to fix the problem?

No, but it suggests a few ways to get closer to the root cause.

That looks fishy.   The IRQ handler does not re-enable IRQs,
so it looks like something re-enabled IRQs in the middle of
an IRQ handler!  Which will obviously cause trouble.

(I'll assume that this isn't a case of a misleading stack dump,
where the IRQ frames are dead ones that were wrongly dumped...)

If 442258e2ff69276ff767f3703b30ce6a31fdd181 isn't in the
kernel with those bugs, try applying it... else, I suggest
you try putting something like your

	if (!raw_irqs_disabled()) {
		printk(KERN_CRIT "interrupts enabled!\n");
		dump_stack();
        }

logic at the beginning and end of usb_hcd_giveback_urb ... and
maybe have it dump the address of the completion handler, when
you can finger such a handler as re-enabling IRQs.

- Dave
