Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYDSElA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYDSElA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYDSEku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:40:50 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40406 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYDSEks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:40:48 -0400
Message-ID: <48097886.9000907@keyaccess.nl>
Date: Sat, 19 Apr 2008 06:43:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
References: <20080418204955.342963315@ldl.fc.hp.com> <20080418205051.704761191@ldl.fc.hp.com> <480920BB.9010506@keyaccess.nl> <200804182157.34313.bjorn.helgaas@hp.com>
In-Reply-To: <200804182157.34313.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.6 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-04-08 05:57, Bjorn Helgaas wrote:

> Yep, you're right.  I fixed it, but it requires changes to a couple
> other patches down the line, so I'll wait to repost the series until
> next week in case you find more problems.
> 
> I think this is only a problem for bisection.  By the time you
> apply the whole series, we start with an empty resource list, and
> every time we add one, we set the type in pnp_new_resource().
> 
> That makes me wonder whether pnp_init_resources() should just
> free the whole list, so we just start again with an empty list.

Probably. Just a quick heads up; if you don't beat me to it I'll look at it 
in more detail over the weekend but with the current series ISAPnP is quite 
decidedly broken. Forget the OOPS for now which seems just a symptom of the 
same thing as the "too many" warnings". Result of "modprobe snd-cs4236".

I believe it's pnp_assign_resources() which has all the pnp_assign_foo() 
helpers fail due to there not being any yet. I guess pnp_assign_mem() and 
friends should allocate upon not finding one available and not fail?

Don't get why isapnp_get_resources() didn't allocate though. As said, unless 
you beat me to it I'll look into it more tomorrow or sunday.

===
pnp: the driver 'cs4236_isapnp' has been registered
cs4236_isapnp 01:01.00: driver attached
cs4236_isapnp 01:01.02: driver attached
cs4236_isapnp 01:01.03: driver attached
cs4236_isapnp 01:01.00: too many I/O port resources
cs4236_isapnp 01:01.00: too many I/O port resources
cs4236_isapnp 01:01.00: too many I/O port resources
cs4236_isapnp 01:01.00: too many IRQ resources
cs4236_isapnp 01:01.00: too many DMA resources
cs4236_isapnp 01:01.00: too many DMA resources
cs4236_isapnp 01:01.00: activated
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<f0c604da>] :snd_cs4236:snd_cs423x_pnpc_detect+0x104/0x390
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: snd_cs4236(+) snd_opl3_lib snd_hwdep snd_cs4236_lib 
snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
snd soundcore snd_page_alloc nfsd lockd nfs_acl sunrpc exportfs

Pid: 1198, comm: modprobe Not tainted (2.6.25 #2)
EIP: 0060:[<f0c604da>] EFLAGS: 00010202 CPU: 0
EIP is at snd_cs423x_pnpc_detect+0x104/0x390 [snd_cs4236]
EAX: 00000000 EBX: ef868c00 ECX: ef868d6c EDX: 00000000
ESI: 00000000 EDI: f0c63004 EBP: ef84d600 ESP: eed4ce88
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1198, ti=eed4c000 task=eecf0aa0 task.ti=eed4c000)
Stack: ef312d40 ef84d7b8 ef843200 ef312d40 f0c63004 00000003 c10d981b f0c62720
        ef868a00 f0c62720 ef84391c f0cab090 f0c633c0 c10d9df7 00000001 0000002b
        f0c4802f f0c633c0 c102eb21 00018f20 c1050987 000226c4 00000000 00000690
Call Trace:
  [<c10d981b>] card_probe+0xba/0x107
  [<c10d9df7>] pnp_register_card_driver+0xa2/0xb2
  [<f0c4802f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
  [<c102eb21>] sys_init_module+0x149a/0x1604
  [<c1050987>] do_sync_read+0xbe/0xfd
  [<c1017be8>] __request_region+0x0/0x85
  [<c10513bd>] sys_read+0x3c/0x63
  [<c1003a62>] syscall_call+0x7/0xb
  =======================
Code: 89 d8 e8 93 ad 47 d0 85 c0 79 0a 68 5a 0a c6 f0 e9 30 01 00 00 31 c9 
ba 00 01 00 00 89 d8 e8 fc 9d 47 d0 83 3c b5 40 26 c6 f0 00 <8b> 00 89 04 b5 
a0 26 c6 f0 7e 1a b9 01 00 00 00 ba 00 01 00 00
EIP: [<f0c604da>] snd_cs423x_pnpc_detect+0x104/0x390 [snd_cs4236] SS:ESP 
0068:eed4ce88
---[ end trace 6704e77dc1a89be6 ]---
===

Rene

