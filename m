Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbXBUXlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbXBUXlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXBUXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:41:24 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:39611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbXBUXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LilgUVAfNaIxuHWTqoQoaCkRkJB+3xpCRp08PYWdPNeRcFhmPst8m7qV02YtuyXG1oeBWigzZxLR67Yz+k7JbMYmCfIeerIIQnbfTjosvcZXHXeg3h/XaSXgXQLhxQ2tLMHOmcnRBBJUsDQFaZDlER1l1FALZjPL1s60QjnFpkQ=
Subject: Re: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: caglar@pardus.org.tr
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200702151300.41343.caglar@pardus.org.tr>
References: <200702090838.21060.caglar@pardus.org.tr>
	 <20070215104032.GL26240@elf.ucw.cz>
	 <20070215025659.b5b78d2e.akpm@linux-foundation.org>
	 <200702151300.41343.caglar@pardus.org.tr>
Content-Type: text/plain; charset=utf-8
Date: Thu, 22 Feb 2007 07:43:41 +0800
Message-Id: <1172101421.4217.20.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 13:00 +0200, S.Çağlar Onur wrote: 
> 15 Şub 2007 Per tarihinde, Andrew Morton şunları yazmıştı: 
> > On Thu, 15 Feb 2007 11:40:32 +0100 Pavel Machek <pavel@ucw.cz> wrote:
> > > Contact fbcon people...
> >
> > There aren't any, basically.  Since Tony disappeared James has been helping
> > out but doesn't have a lot of time.  So we're pretty much on our own with
> > problems in this area.
> 
> I already sent same mail to  
> linux-fbdev-devel mailing lists at sf.net with hope :)
> 
> Cheers

Interesting... It does look like this was triggered by calling
do_blank_screen() without taking the console semaphore, but
console_callback() should have taken that.

Second point is that vesafb does not have any blanking functionality,
thus it should not trigger fbcon_event_notify().  My guess is you are
using an out-of-tree vesafb?

BUG: at drivers/char/vt.c:3332 do_blank_screen() 
 [<c02881f7>] do_blank_screen+0x4e/0x218
 [<c02977fa>] fbcon_event_notify+0x8f1/0xa1e
 [<c027b2b0>] extract_buf+0xac/0xe1
 [<c0102002>] __switch_to+0xeb/0x15d
 [<c034bbe5>] __sched_text_start+0x865/0x929
 [<c029a50d>] bit_cursor+0x4c8/0x50b
 [<c034bd67>] wait_for_completion+0x79/0xaf
 [<c011cbe2>] default_wake_function+0x0/0xc
 [<c034ece2>] notifier_call_chain+0x19/0x32
 [<c012d1c6>] blocking_notifier_call_chain+0x23/0x33
 [<c028db54>] fb_blank+0x4a/0x53
 [<c0299028>] fbcon_blank+0xf4/0x1e3
 [<c0294f33>] fbcon_cursor+0x21c/0x250
 [<c029a045>] bit_cursor+0x0/0x50b
 [<c0129e90>] lock_timer_base+0x15/0x2f
 [<c0129eee>] try_to_del_timer_sync+0x44/0x4a
 [<c0298f34>] fbcon_blank+0x0/0x1e3
 [<c028835a>] do_blank_screen+0x1b1/0x218
 [<c028abdd>] console_callback+0xaf/0xbf
 [<c012fa59>] run_workqueue+0x85/0x135
 [<c028ab2e>] console_callback+0x0/0xbf
 [<c01302f0>] worker_thread+0x10a/0x136
 [<c011cbe2>] default_wake_function+0x0/0xc
 [<c01301e6>] worker_thread+0x0/0x136
 [<c0132982>] kthread+0xb2/0xdc
 [<c01328d0>] kthread+0x0/0xdc
 [<c0103a8f>] kernel_thread_helper+0x7/0x10

As for the last tracing, it looks to be valid bug to me.
complete_change_console() should be called with the console sem
taken. I'll look into this.

BUG: at drivers/char/vt.c:3486 set_palette()
 [<c0287538>] set_palette+0x41/0x59
 [<c028886f>] redraw_screen+0x110/0x17e
 [<c0282394>] complete_change_console+0x2a/0xba
 [<c028ab73>] console_callback+0x45/0xbf
 [<c012fa59>] run_workqueue+0x85/0x135
 [<c028ab2e>] console_callback+0x0/0xbf
 [<c01302f0>] worker_thread+0x10a/0x136
 [<c011cbe2>] default_wake_function+0x0/0xc
 [<c01301e6>] worker_thread+0x0/0x136
 [<c0132982>] kthread+0xb2/0xdc
 [<c01328d0>] kthread+0x0/0xdc
 [<c0103a8f>] kernel_thread_helper+0x7/0x10

Tony
 

