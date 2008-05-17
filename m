Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYEQSQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYEQSQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYEQSQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:16:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41687 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYEQSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:16:46 -0400
Date: Sat, 17 May 2008 11:16:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "koos vriezen" <koos.vriezen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mplayer v4l hangs in 2.6.25.2/4
Message-ID: <20080517111639.21a3e177@infradead.org>
In-Reply-To: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 18:54:06 +0200
"koos vriezen" <koos.vriezen@gmail.com> wrote:

> Hi,
> 
> I'm using mplayer for tv watch quite some kernels but 2.6.25 makes
> mplayer unkillable. Last working kernel is 2.24.5 that I have tried.
> 
> This gets printed on the console
> 
> INFO: task mplayer:3465 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message. mplayer       D 0000000000000000     0  3465   3464
>  ffff810074333c68 0000000000200086 0000000000000000 00000000ffffffff
>  ffff81007a3889c0 ffff810074333c18 ffff810074333c98 ffffffff8064a800
>  ffffffff8064a800 ffffffff80646eb0 ffffffff8064a800 ffff8100757c1900
> Call Trace:
>  [<ffffffff8049b26f>] __mutex_lock_slowpath+0x68/0xa0
>  [<ffffffff802274aa>] enqueue_task_fair+0x72/0x9b
>  [<ffffffff8049b0ee>] mutex_lock+0x1a/0x1e
>  [<ffffffff802265aa>] enqueue_task+0x13/0x1e
>  [<ffffffff880b51ab>] :videobuf_core:videobuf_mmap_setup+0x1c/0x45
>  [<ffffffff8813dbbe>] :bttv:vidiocgmbuf+0x2c/0x99
>  [<ffffffff8810b91d>] :videodev:__video_do_ioctl+0xa1/0x2ad9
>  [<ffffffff802272d5>] set_next_entity+0x18/0x36
>  [<ffffffff8049aa70>] thread_return+0x3a/0xa4
>  [<ffffffff8810e622>] :videodev:video_ioctl2+0x17c/0x210
>  [<ffffffff80238c7b>] ptrace_stop+0xfc/0x140
>  [<ffffffff8023a705>] ptrace_notify+0x83/0xa6
>  [<ffffffff80289221>] vfs_ioctl+0x55/0x6b
>  [<ffffffff8028948a>] do_vfs_ioctl+0x253/0x264
>  [<ffffffff802894ec>] sys_ioctl+0x51/0x71
>  [<ffffffff8020bef8>] int_very_careful+0x35/0x3e
>  [<ffffffff8020be79>] tracesys+0xdc/0xe1
> 
> I've attached what might be usable wrt to this.
> 

Hi,

this smells like a deadlock (probably in v4l). Thankfully the kernel
has a lot of diagnostics for detecting deadlocks (you just found
that the  least invasive one caught the deadlock, but unfortunately it's
also the method that yields the least information).

Is it possible for you to enable lockdep (CONFIG_PROVE_LOCKING)?
With that on, the kernel will print nicely which locks are being waited
on, and if there's a deadlock, it'll print that too. Speaking of that,
since this looks like a mutex related issue, it's worth enabling
CONFIG_DEBUG_MUTEXES as well.... more debug checks in this area.
If you also enable CONFIG_FRAME_POINTER then the backtrace will get
better too (but it's not totally required, just easier for diagnostics)

