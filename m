Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXIXHhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXIXHhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbXIXHha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:37:30 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56280 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIXHh3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:37:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Mon, 24 Sep 2007 08:06:45 +0200."
             <46F753F5.7060707@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu> <46F3FF9C.7040200@gmail.com> <4109.1190403228@turing-police.cc.vt.edu> <46F41DC0.9060407@gmail.com> <46F41ED8.3020301@gmail.com> <18727.1190604314@turing-police.cc.vt.edu>
            <46F753F5.7060707@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190619431_3891P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 03:37:11 -0400
Message-ID: <4399.1190619431@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190619431_3891P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 08:06:45 +0200, Jiri Slaby said:

> Heh :). The few last before the list corruption BUG (you have to have LIST_DEBUG
> enabled) -- but it seems you never reached that phase?

Seems to be somewhat racy - had one attempt that obviously got into some grand
Mongolian flustercluck, because I had a 2M printk buffer defined, and more
than 2M worth of apparently looping output saying that the netconsole/printk
path was poisoning.  I defined the printk buffer to 4M, added a initcall_debug,
and then it managed to die in a reasonable amount of time.  Here's the whole
thing from when it starts blurbing out the POISONS messages until it
rolls over and dies (about 736 lines).

(Interestingly, I can't find any of the 3 addresses listed in the 'list_add
corruption' message anywhere *else* in the netconsole output, and the last thing
we hear from before the kersplat is apparently an RCU callback in a softirq?)

[   47.997000] POISONS (ffff810003fb6ca8): ffff810003fb6ca8, ffff8100051600d8
[   47.997000] 
[   47.997000] Call Trace:
[   47.998000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   47.998000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[   47.998000]  [<ffffffff80276649>] vma_prio_tree_insert+0x34/0x39
[   47.998000]  [<ffffffff8027da6c>] vma_adjust+0x310/0x452
[   47.998000]  [<ffffffff8027dc89>] split_vma+0xdb/0xed
[   47.998000]  [<ffffffff8027f30b>] mprotect_fixup+0x13b/0x481
[   47.998000]  [<ffffffff80323da3>] file_map_prot_check+0x7d/0x86
[   47.998000]  [<ffffffff80326d93>] selinux_file_mprotect+0xe0/0xe9
[   47.998000]  [<ffffffff8027f803>] sys_mprotect+0x1b2/0x22b
[   47.998000]  [<ffffffff8020c2fc>] tracesys+0xdc/0xe1
[   47.998000] 
[   48.078000] POISONS (ffff81000402d768): ffff810004727810, ffff810006221810
[   48.078000] 
[   48.078000] Call Trace:
[   48.078000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.078000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.078000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.078000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.078000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.079000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.079000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.079000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.079000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.079000] 
[   48.080000] POISONS (ffff810004096618): ffff810005266c00, ffff81000576a960
[   48.080000] 
[   48.080000] Call Trace:
[   48.080000]  [<ffffffff80517086>] __down_write_nested+0x3d/0xa1
[   48.080000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.080000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[   48.080000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.080000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.080000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.080000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.080000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.080000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.080000] 
[   48.081000] POISONS (ffff810004096768): ffff81000526e378, ffff81000526e378
[   48.081000] 
[   48.081000] Call Trace:
[   48.081000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.081000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[   48.081000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.081000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.081000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.081000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.081000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.081000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.081000] 
[   48.081000] POISONS (ffff8100040964c8): ffff81000576a960, ffff8100051c12d0
[   48.082000] 
[   48.082000] Call Trace:
[   48.087000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.087000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[   48.087000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.087000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.087000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.087000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.087000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.087000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.087000] 
[   48.087000] POISONS (ffff810004096d50): ffff81000412bab0, ffff810004536618
[   48.087000] 
[   48.087000] Call Trace:
[   48.087000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.088000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.088000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.088000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.088000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.088000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.088000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.088000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.088000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.088000] 
[   48.088000] POISONS (ffff810004096c00): ffff81000412b960, ffff8100043e7ca8
[   48.088000] 
[   48.088000] Call Trace:
[   48.088000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.088000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.089000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.089000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.089000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.089000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.089000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.089000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.089000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.089000] 
[   48.089000] POISONS (ffff810004096ca8): ffff81000526e960, ffff810003f0fb58
[   48.089000] 
[   48.089000] Call Trace:
[   48.089000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.089000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.089000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.090000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.090000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.090000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.090000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.090000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.090000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.090000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.090000] 
[   48.090000] POISONS (ffff810004096ab0): ffff8100045368b8, ffff8100061a5d50
[   48.090000] 
[   48.090000] Call Trace:
[   48.090000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.090000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.090000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.091000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.091000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.091000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.091000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.091000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.091000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.091000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.091000] 
[   48.091000] POISONS (ffff810004096570): ffff8100061a5c00, ffff8100061a5f48
[   48.091000] 
[   48.091000] Call Trace:
[   48.091000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.091000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.092000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.092000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.092000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.092000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.092000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.092000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.092000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.092000] 
[   48.092000] POISONS (ffff810004096f48): ffff8100061a5ab0, ffff8100062cc180
[   48.092000] 
[   48.092000] Call Trace:
[   48.092000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.092000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.093000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.093000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.093000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.093000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.093000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.093000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.093000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.093000] 
[   48.093000] POISONS (ffff810004096180): ffff8100043e7c00, ffff810003f060d8
[   48.093000] 
[   48.093000] Call Trace:
[   48.093000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.093000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.093000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.094000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.094000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.094000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.094000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.094000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.094000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.094000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.094000] 
[   48.094000] POISONS (ffff810004096ea0): ffff810004436ca8, ffff810004174618
[   48.094000] 
[   48.094000] Call Trace:
[   48.094000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.095000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.095000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.095000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.095000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.095000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.095000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.095000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.095000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.095000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.095000] 
[   48.095000] POISONS (ffff810004096df8): ffff8100051c1ab0, ffff8100051c1ab0
[   48.095000] 
[   48.095000] Call Trace:
[   48.096000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.096000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.096000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.096000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.096000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.096000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.096000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.096000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.096000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.096000] 
[   48.096000] POISONS (ffff810004096a08): ffff810005266570, ffff810005266570
[   48.096000] 
[   48.096000] Call Trace:
[   48.097000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.097000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.097000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.097000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.097000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.097000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.097000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.097000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.097000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.097000] 
[   48.097000] POISONS (ffff810004096960): ffff810005266228, ffff810005266228
[   48.097000] 
[   48.097000] Call Trace:
[   48.098000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.098000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.098000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.098000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.098000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.098000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.098000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.098000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.098000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.098000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.098000] 
[   48.098000] POISONS (ffff810004096420): ffff810004399570, ffff81000571a768
[   48.099000] 
[   48.099000] Call Trace:
[   48.099000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.099000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.099000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.099000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.099000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.099000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.099000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.099000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.099000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.099000] 
[   48.099000] POISONS (ffff810004096378): ffff810004399618, ffff8100041f3960
[   48.100000] 
[   48.100000] Call Trace:
[   48.100000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.100000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.100000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.100000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.100000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.100000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.105000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.105000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.105000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.105000] 
[   48.105000] POISONS (ffff810004096228): ffff8100043996c0, ffff8100061a5b58
[   48.106000] 
[   48.106000] Call Trace:
[   48.106000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.106000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.106000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.106000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.106000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.106000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.106000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.106000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.106000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.106000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.106000] 
[   48.106000] POISONS (ffff8100042cdea0): ffff810004727810, ffff810006221810
[   48.107000] 
[   48.107000] Call Trace:
[   48.107000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.107000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.107000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.107000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.107000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.107000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.107000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.107000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.107000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.107000] 
[   48.108000] POISONS (ffff8100042cdab0): ffff8100061a5ab0, ffff8100062cc180
[   48.108000] 
[   48.108000] Call Trace:
[   48.108000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.108000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.108000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.108000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.108000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.108000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.108000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.108000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.109000] 
[   48.109000] POISONS (ffff8100042cddf8): ffff8100043e7c00, ffff810003f060d8
[   48.109000] 
[   48.109000] Call Trace:
[   48.109000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.109000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.109000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.109000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.109000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.109000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.109000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.109000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.109000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.110000] 
[   48.110000] POISONS (ffff8100042cdea0): ffff810004436ca8, ffff810004174618
[   48.110000] 
[   48.110000] Call Trace:
[   48.110000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.110000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.110000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.110000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.110000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.110000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.110000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.110000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.110000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.111000] 
[   48.111000] POISONS (ffff810004096228): ffff8100051c1ab0, ffff8100051c1ab0
[   48.111000] 
[   48.111000] Call Trace:
[   48.111000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.111000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.111000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.111000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.111000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.111000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.111000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.111000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.112000] 
[   48.112000] POISONS (ffff810004096378): ffff810005266570, ffff810005266570
[   48.112000] 
[   48.112000] Call Trace:
[   48.112000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.112000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.112000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.112000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.112000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.112000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.112000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.112000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.112000] 
[   48.113000] POISONS (ffff810004096420): ffff810005266228, ffff810005266228
[   48.113000] 
[   48.113000] Call Trace:
[   48.113000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.113000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.113000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.113000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.113000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.113000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.113000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.113000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.113000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.113000] 
[   48.114000] POISONS (ffff810004096960): ffff810004399570, ffff81000571a768
[   48.114000] 
[   48.114000] Call Trace:
[   48.114000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.114000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.114000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.114000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.114000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.114000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.114000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.114000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.114000] 
[   48.114000] POISONS (ffff810004096a08): ffff810004399618, ffff8100041f3960
[   48.115000] 
[   48.115000] Call Trace:
[   48.115000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.115000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.115000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.115000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.115000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.115000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.115000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.115000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.115000] 
[   48.115000] POISONS (ffff810004096df8): ffff8100043996c0, ffff8100061a5b58
[   48.115000] 
[   48.115000] Call Trace:
[   48.116000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.116000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.116000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.116000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.116000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.116000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.116000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.116000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.116000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.116000] 
[   48.116000] POISONS (ffff810004096ea0): ffff810004727810, ffff810006221810
[   48.116000] 
[   48.116000] Call Trace:
[   48.117000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.117000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.117000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.117000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.117000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.117000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.117000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.117000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.117000] 
[   48.117000] POISONS (ffff810004096ab0): ffff810003fb6ca8, ffff81000416e618
[   48.117000] 
[   48.117000] Call Trace:
[   48.118000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.118000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.118000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.118000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.118000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.118000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.118000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.118000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.118000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.118000] 
[   48.118000] POISONS (ffff810004096ca8): ffff8100045360d8, ffff81000514dd50
[   48.118000] 
[   48.118000] Call Trace:
[   48.119000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.119000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.119000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.119000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.119000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.119000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.119000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.119000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.119000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.124000] 
[   48.220000] POISONS (ffff8100042cdc00): ffff81000412bab0, ffff81000576aca8
[   48.220000] 
[   48.220000] Call Trace:
[   48.220000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.220000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.220000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.220000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.220000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.220000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.220000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.220000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.220000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.220000] 
[   48.220000] POISONS (ffff81000420cad0): ffff8100052664e8, ffff8100061a5788
[   48.220000] 
[   48.220000] Call Trace:
[   48.220000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.220000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.220000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.220000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.220000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.220000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.220000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.220000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.220000] 
[   48.220000] POISONS (ffff8100042cd960): ffff8100051c1ab0, ffff8100051c1ab0
[   48.220000] 
[   48.220000] Call Trace:
[   48.220000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.220000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.221000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.221000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473ea28): ffff81000515c3c8, ffff81000515c3c8
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e6e0): ffff81000515c8f0, ffff81000515c8f0
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e1a0): ffff81000515c398, ffff81000515c398
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e788): ffff81000515c368, ffff81000525f440
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e638): ffff81000525f2f0, ffff81000473e788
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e2f0): ffff81000515c8a8, ffff81000515c8a8
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e0f8): ffff81000515c908, ffff810005255c20
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e398): ffff810005237d70, ffff81000473e0f8
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473ecc8): ffff81000515c278, ffff81000515c278
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473ec20): ffff81000515c320, ffff81000515c320
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.221000] POISONS (ffff81000473e8d8): ffff81000515cef0, ffff81000515cef0
[   48.221000] 
[   48.221000] Call Trace:
[   48.221000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.221000]  [<ffffffff80281141>] anon_vma_link+0x2d/0x3a
[   48.221000]  [<ffffffff8023249e>] copy_process+0xc11/0x1515
[   48.221000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.221000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.221000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.221000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.221000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.221000] 
[   48.222000] POISONS (ffff8100040ea810): ffff81000412b960, ffff810003f3d960
[   48.222000] 
[   48.222000] Call Trace:
[   48.222000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.222000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.222000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.222000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.222000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.222000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.222000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.222000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.222000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.222000] 
[   48.222000] POISONS (ffff81000444e960): ffff810003fb6ca8, ffff81000473e0d8
[   48.222000] 
[   48.222000] Call Trace:
[   48.222000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.222000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.222000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.222000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.222000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.222000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.222000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.222000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.222000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.222000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.222000] 
[   48.222000] POISONS (ffff81000444e768): ffff8100045360d8, ffff81000473e378
[   48.222000] 
[   48.222000] Call Trace:
[   48.222000]  [<ffffffff8027edaf>] __vm_enough_memory+0x1e/0x113
[   48.222000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.222000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.222000]  [<ffffffff802765e2>] vma_prio_tree_add+0xad/0xe0
[   48.222000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.222000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.222000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.222000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.222000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.222000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.222000] 
[   48.222000] POISONS (ffff81000444e4c8): ffff810005237ab0, ffff810005255ea0
[   48.222000] 
[   48.222000] Call Trace:
[   48.222000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.222000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[   48.222000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.222000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.222000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.222000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.222000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.222000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.222000] 
[   48.222000] POISONS (ffff81000444edf8): ffff810005237ab0, ffff810005237ab0
[   48.222000] 
[   48.222000] Call Trace:
[   48.222000]  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.222000]  [<ffffffff802765fe>] vma_prio_tree_add+0xc9/0xe0
[   48.222000]  [<ffffffff802324f0>] copy_process+0xc63/0x1515
[   48.222000]  [<ffffffff80232eff>] do_fork+0x75/0x20b
[   48.222000]  [<ffffffff80353d54>] __up_write+0xf0/0x100
[   48.222000]  [<ffffffff8020c17e>] system_call+0x7e/0x83
[   48.222000]  [<ffffffff8020a64f>] sys_clone+0x23/0x25
[   48.222000]  [<ffffffff8020c497>] ptregscall_common+0x67/0xb0
[   48.222000] 
[   48.297000] POISONS (ffff810001179148): ffff810006bbc000, ffff81000341bec0
[   48.297000] 
[   48.297000] Call Trace:
[   48.297000]  <IRQ>  [<ffffffff803580aa>] __list_add+0xd7/0x138
[   48.297000]  [<ffffffff80358117>] list_add+0xc/0x11
[   48.297000]  [<ffffffff80270865>] free_hot_cold_page+0xe8/0x16d
[   48.297000]  [<ffffffff8027093e>] free_hot_page+0xb/0xd
[   48.297000]  [<ffffffff80270958>] __free_pages+0x18/0x21
[   48.297000]  [<ffffffff80270990>] free_pages+0x2f/0x34
[   48.297000]  [<ffffffff8028922d>] kmem_freepages+0xc5/0xce
[   48.297000]  [<ffffffff8028957f>] slab_destroy+0x3c/0x53
[   48.297000]  [<ffffffff80289663>] free_block+0xcd/0x110
[   48.297000]  [<ffffffff80289345>] cache_flusharray+0x71/0xa7
[   48.297000]  [<ffffffff802894c2>] kmem_cache_free+0x99/0xb2
[   48.297000]  [<ffffffff8029d8b2>] __d_free+0x30/0x34
[   48.297000]  [<ffffffff8029dcb6>] d_callback+0xd/0xf
[   48.297000]  [<ffffffff802458e0>] __rcu_process_callbacks+0x143/0x1da
[   48.297000]  [<ffffffff8024599a>] rcu_process_callbacks+0x23/0x44
[   48.297000]  [<ffffffff802396d2>] tasklet_action+0x54/0x9e
[   48.297000]  [<ffffffff802395ad>] __do_softirq+0x57/0xc7
[   48.297000]  [<ffffffff802398e3>] ksoftirqd+0x0/0x148
[   48.297000]  [<ffffffff8020d32c>] call_softirq+0x1c/0x28
[   48.297000]  <EOI>  [<ffffffff8020e916>] do_softirq+0x34/0x87
[   48.297000]  [<ffffffff80239956>] ksoftirqd+0x73/0x148
[   48.297000]  [<ffffffff80247ddd>] kthread+0x49/0x78
[   48.297000]  [<ffffffff8020cfc8>] child_rip+0xa/0x12
[   48.297000]  [<ffffffff80247d94>] kthread+0x0/0x78
[   48.297000]  [<ffffffff8020cfbe>] child_rip+0x0/0x12
[   48.297000] 
[   48.297000] list_add corruption. next->prev should be prev (ffffffff8067e050), but was ffff8100066d59c0. (next=ffff81000119e560).
[   48.297000] ------------[ cut here ]------------
[   48.297000] kernel BUG at lib/list_debug.c:46!
[   48.297000] invalid opcode: 0000 [1] PREEMPT SMP 
[   48.297000] last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:03:01.4/resource
[   48.297000] CPU 1 
[   48.297000] Modules linked in: irnet(U) ppp_generic(U) slhc(U) irtty_sir(U) sir_dev(U) ircomm_tty(U) ircomm(U) irda(U) crc_ccitt(U) coretemp(U) nf_conntrack_ftp(U) xt_pkttype(U) ipt_REJECT(U) ipt_osf(U) nf_conntrack_ipv4(U) xt_ipisforif(U) ipt_recent(U) ipt_LOG(U) xt_u32(U) iptable_filter(U) ip_tables(U) xt_tcpudp(U) nf_conntrack_ipv6(U) xt_state(U) nf_conntrack(U) nfnetlink(U) ip6t_LOG(U) xt_limit(U) ip6table_filter(U) ip6_tables(U) x_tables(U) sha256(U) aes(U) fan(U) container(U) bay(U) acpi_cpufreq(U) nvram(U) pcmcia(U) firmware_class(U) yenta_socket(U) ohci1394(U) rsrc_nonstatic(U) iTCO_wdt(U) iTCO_vendor_support(U) watchdog_core(U) nvidia(P)(U) thermal(U) ieee1394(U) pcmcia_core(U) watchdog_dev(U) processor(U) snd_hda_intel(U) intel_agp(U) ac(U) button(U) video(U) battery(U) power_supply(U) output(U) rtc(U)
[   48.297000] Pid: 7, comm: ksoftirqd/1 Tainted: P        2.6.23-rc6-mm1 #8
[   48.297000] RIP: 0010:[<ffffffff803580ce>]  [<ffffffff803580ce>] __list_add+0xfb/0x138
[   48.297000] RSP: 0000:ffff81000349fd38  EFLAGS: 00010002
[   48.297000] RAX: 0000000000000088 RBX: ffff810001179148 RCX: ffffffff8061dbbb
[   48.297000] RDX: 0000000100000000 RSI: 0000000000000006 RDI: ffffffff80672620
[   48.297000] RBP: ffff81000349fd58 R08: ffffffff80672628 R09: 0000000000000000
[   48.297000] R10: 00000000e731ffa2 R11: ffff81000349fa98 R12: ffff81000119e560
[   48.297000] R13: ffffffff8067e050 R14: ffffffff8067df80 R15: ffff81000346d128
[   48.297000] FS:  0000000000000000(0000) GS:ffff8100034689c0(0000) knlGS:0000000000000000
[   48.297000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   48.297000] CR2: 000000000049b9b0 CR3: 0000000004168000 CR4: 00000000000006e0
[   48.297000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.297000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   48.297000] Process ksoftirqd/1 (pid: 7, threadinfo ffff810003494000, task ffff810003463810)
[   48.297000] last branch before last exception/interrupt
[   48.297000]  from  [<ffffffff80234989>] printk+0xa3/0xa4
[   48.297000]  to  [<ffffffff803580c8>] __list_add+0xf5/0x138
[   48.297000] Stack:  ffff81000349fe60 ffff810001179120 ffffffff8067e040 0000000000000002
[   48.297000]  ffff81000349fd68 ffffffff80358117 ffff81000349fd98 ffffffff80270865
[   48.297000]  ffff810001000000 0000000000000000 ffff81000341bec0 ffff810006bbc000
[   48.297000] Call Trace:
[   48.297000]  <IRQ>  [<ffffffff80358117>] list_add+0xc/0x11
[   48.297000]  [<ffffffff80270865>] free_hot_cold_page+0xe8/0x16d
[   48.297000]  [<ffffffff8027093e>] free_hot_page+0xb/0xd
[   48.297000]  [<ffffffff80270958>] __free_pages+0x18/0x21
[   48.297000]  [<ffffffff80270990>] free_pages+0x2f/0x34
[   48.297000]  [<ffffffff8028922d>] kmem_freepages+0xc5/0xce
[   48.297000]  [<ffffffff8028957f>] slab_destroy+0x3c/0x53
[   48.297000]  [<ffffffff80289663>] free_block+0xcd/0x110
[   48.297000]  [<ffffffff80289345>] cache_flusharray+0x71/0xa7
[   48.297000]  [<ffffffff802894c2>] kmem_cache_free+0x99/0xb2
[   48.297000]  [<ffffffff8029d8b2>] __d_free+0x30/0x34
[   48.297000]  [<ffffffff8029dcb6>] d_callback+0xd/0xf
[   48.297000]  [<ffffffff802458e0>] __rcu_process_callbacks+0x143/0x1da
[   48.297000]  [<ffffffff8024599a>] rcu_process_callbacks+0x23/0x44
[   48.297000]  [<ffffffff802396d2>] tasklet_action+0x54/0x9e
[   48.297000]  [<ffffffff802395ad>] __do_softirq+0x57/0xc7
[   48.297000]  [<ffffffff802398e3>] ksoftirqd+0x0/0x148
[   48.297000]  [<ffffffff8020d32c>] call_softirq+0x1c/0x28
[   48.297000]  <EOI>  [<ffffffff8020e916>] do_softirq+0x34/0x87
[   48.297000]  [<ffffffff80239956>] ksoftirqd+0x73/0x148
[   48.297000]  [<ffffffff80247ddd>] kthread+0x49/0x78
[   48.297000]  [<ffffffff8020cfc8>] child_rip+0xa/0x12
[   48.297000]  [<ffffffff80247d94>] kthread+0x0/0x78
[   48.297000]  [<ffffffff8020cfbe>] child_rip+0x0/0x12
[   48.297000] 
[   48.297000] 
[   48.297000] Code: 0f 0b eb fe 49 8b 55 00 4c 39 e2 74 18 4c 89 e9 4c 89 e6 48 
[   48.297000] RIP  [<ffffffff803580ce>] __list_add+0xfb/0x138
[   48.297000]  RSP <ffff81000349fd38>


--==_Exmh_1190619431_3891P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG92kncC3lWbTT17ARAoakAKD9fj3m0n50bO0LOQ/j5xxKJswG/gCfbVTo
Wa1OH9saJt2R5MEWYoWDpjA=
=gfBS
-----END PGP SIGNATURE-----

--==_Exmh_1190619431_3891P--
