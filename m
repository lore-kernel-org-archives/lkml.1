Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbXGWAGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbXGWAGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbXGWAGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:06:25 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55980 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbXGWAGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:06:24 -0400
Date: Mon, 23 Jul 2007 09:05:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lots of scheduling bugs (?) with -rc1
Message-ID: <20070723000559.GA16374@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	linux-kernel@vger.kernel.org
References: <92a12cdb0707221449s4cef6c93x68d75386a6ec8a64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92a12cdb0707221449s4cef6c93x68d75386a6ec8a64@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 10:49:26PM +0100, Adrian McMenamin wrote:
> [   16.818606] Call trace:
> [   16.822686] [<8c00f782>] __cond_resched+0x1a/0x40
> [   16.827589] [<8c15adf4>] cond_resched+0x30/0x48
> [   16.832256] [<8c15b6ba>] mutex_lock+0xa/0x50
> [   16.836656] [<8c00c4d8>] clear_user_page+0x84/0x12c

Yes, this is not related to -rc1, we've had this problem for some time,
but it does require some reworking of how we do page colouring in order
to clear it up. I have some patches for this, but they've triggered some
problems on older cores, so this is still something that's being
debugged. I'll send you some stuff off-list you might want to try for
SH7750/SH7091, unfortunately you have a direct-mapped cache, so it
doesn't trigger some of the regressions that we've seen on other parts
with those patches.

> / # modprobe pvr2fb
> [  186.214551] Fault in unaligned fixup: 0000 [#1]
> [  186.218469] Modules linked in: pvr2fb cfbcopyarea cfbimgblt
> cfbfillrect snd_aica snd_pcm_oss snd_pcm snd_timer snd_page_alloc
> snd_mixer_oss snd soundcore
> [  186.232658]
> [  186.234190] Pid : 1254, Comm:             modprobe
> [  186.239152] PC is at request_dma+0x2a/0x84
> [  186.243360] PC  : 8c0f9bae SP  : 8ca33eac SR  : 400080f1 TEA :
> c0104344    Not tainted
> [  186.251534] R0  : 00000000 R1  : 00000001 R2  : 8c1cd480 R3  : 8c1cd480
> [  186.258360] R4  : 00000004 R5  : c012b10c R6  : 000000fb R7  : 8c233e60
> [  186.265186] R8  : ffffffea R9  : 00000000 R10 : 00000000 R11 : c012b10c
> [  186.272012] R12 : c012c224 R13 : 8c2a7398 R14 : c0125000
> [  186.277490] MACH: 00000000 MACL: 00000005 GBR : 00000000 PR  : 8c0f9b9e
> [  186.284307]
> [  186.284321] Call trace:
> [  186.288443] [<c012e0b8>] pvr2fb_dc_init+0x9c/0x108 [pvr2fb]
> [  186.294203] [<c012e180>] pvr2fb_init+0x5c/0xa8 [pvr2fb]
> [  186.299581] [<8c02b53a>] sys_init_module+0xf7a/0x1050

This however looks a bit strange,  the r4 value implies that we're not
getting the proper pointer for some reason. I'll try and reproduce it on
some other boards and start digging in to it, thanks for the reports.
