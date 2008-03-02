Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYCBUDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYCBUDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYCBUDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:03:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYCBUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:03:23 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 15:03:23 EST
Date: Sun, 2 Mar 2008 12:02:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
Message-Id: <20080302120236.61e0ec74.akpm@linux-foundation.org>
In-Reply-To: <47CAE7D5.5040907@gmail.com>
References: <47C7E280.4010805@gmail.com>
	<Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
	<47CAE7D5.5040907@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Mar 2008 18:45:57 +0100 Jiri Olsa <olsajiri@gmail.com> wrote:

> Jiri Kosina wrote:
> > On Fri, 29 Feb 2008, Jiri Olsa wrote:
> > 
> >> when I run 'ipcs' my system freeze up immediatelly. I was able to get 
> >> kernel BUG message once, I think it is not printed out all the time it 
> >> freeze.
> >> I tried on 2.6.24, 2.6.20 and 2.6.18.
> >> I attached screenshot from 2.6.18 freeze and config.
> > 
> > Could you please turn all the lock debugging options in your .config on 
> > (most importantly CONFIG_PROVE_LOCKING, and all the other lock debugging 
> > options might come handy too) and try again, to see if we get any debug 
> > error messages? I'd guess that someone is holding mqueue_inode_info->lock 
> > for too long or there is some AB-BA deadlock on it, which lockdep and 
> > friends might be able to diagnose.
> > 
> 
> I got more logs via netconsole, first I ran ipcs it segfaulted next run
> the system freezed.
> I attached also the current config.

oh goody.

> [  144.699366] BUG: unable to handle kernel paging request at virtual address 6b6b6c2b
> [  144.699391] printing eip: c0137b44 *pde = 00000000 
> [  144.699412] Oops: 0002 [#1] 
> [  144.699424] Modules linked in: netconsole i915 drm configfs snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm ipw2200 snd_timer snd snd_page_alloc e1000
> [  144.699507] 
> [  144.699515] Pid: 5656, comm: ipcs Not tainted (2.6.24.3-dirty #17)
> [  144.699526] EIP: 0060:[<c0137b44>] EFLAGS: 00010002 CPU: 0
> [  144.699539] EIP is at __lock_acquire+0x319/0xc20
> [  144.699547] EAX: 00000002 EBX: 00000246 ECX: def4dbf4 EDX: 00000002
> [  144.699561] ESI: 6b6b6b6b EDI: 00000000 EBP: d8d37e7c ESP: d8d37e20
> [  144.699569]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  144.699576] Process ipcs (pid: 5656, ti=d8d36000 task=df098230 task.ti=d8d36000)
> [  144.699583] Stack: d8d37e84 c0138404 00000000 d8d37e44 00000351 00000000 00000002 00000000 
> [  144.699642]        00000000 def4dbf4 00000000 df098230 00000001 df098230 00000000 dec11330 
> [  144.699703]        dec11320 d8d37e70 00000351 00000000 00000246 00000000 00000000 d8d37ea4 
> [  144.699767] Call Trace:
> [  144.699777]  [<c0105c7b>] show_trace_log_lvl+0x1a/0x2f
> [  144.699793]  [<c0105d2d>] show_stack_log_lvl+0x9d/0xa5
> [  144.699813]  [<c0105de2>] show_registers+0xad/0x17c
> [  144.699826]  [<c0105fa8>] die+0xf7/0x1c8
> [  144.699838]  [<c0115781>] do_page_fault+0x464/0x54b
> [  144.699866]  [<c037cc2a>] error_code+0x6a/0x70
> [  144.699886]  [<c01384c3>] lock_acquire+0x78/0x91
> [  144.699899]  [<c037c5f5>] _spin_lock+0x2e/0x58
> [  144.699911]  [<c01e2e8a>] sys_shmctl+0x6f8/0x776
> [  144.699930]  [<c0108b0f>] sys_ipc+0x19f/0x1b5
> [  144.699943]  [<c0104cfa>] sysenter_past_esp+0x5f/0xa5
> [  144.699955]  =======================
> [  144.699961] Code: 00 85 c0 0f 84 1d 09 00 00 83 3d 40 44 7b c0 00 0f 85 10 09 00 00 c7 44 24 0c c8 5d 38 c0 c7 44 24 08 26 03 00 00 e9 8b 07 00 00 <ff> 86 c0 00 00 00 8b 45 d0 8b 80 54 06 00 00 83 f8 1d 89 45 cc 

Looks like you got a use-after free when lockdep was playing with a
spinlock which is taken in sys_shmctl() or one of its inlined callees.

Does setting CONFIG_LOCKDEP=n prevent this from happening?
