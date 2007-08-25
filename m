Return-Path: <linux-kernel-owner+w=401wt.eu-S933060AbXHYBPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbXHYBPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764683AbXHYBPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:15:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38495 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763047AbXHYBPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:15:36 -0400
Date: Sat, 25 Aug 2007 03:14:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, mb@bu3sch.de
Subject: Re: possible BUG while doing gpg --gen-key
Message-ID: <20070825011419.GL30705@stusta.de>
References: <46CF079C.7010304@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46CF079C.7010304@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 06:30:20PM +0200, Udo van den Heuvel wrote:
> While doing gpg --gen-key I can reproduce quite well some sort of
> crash/bug/etc:
> # gpg --gen-key
>...
> We need to generate a lot of random bytes. It is a good idea to perform
> some other action (type on the keyboard, move the mouse, utilize the
> disks) during the prime generation; this gives the random number
> generator a better chance to gain enough entropy.
> +++++++++++++++++++++++++.++++++++++++++++++++.+++++.+++++.++++++++++.++++++++++++++
> 
>  ++++++++++++++++.++++++++++++++++++++++++++++++++++++++++>...+++++......+++++
> Segmentation fault
> (...)
> # dmesg
> (...)
> BUG: unable to handle kernel paging request at virtual address a5773b04
>  printing eip:
> a5773b04
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in: nls_utf8 cifs pwc sch_tbf ipt_recent xt_string
> xt_MARK xt_length xt_tcpmss xt_mac xt_mark w83627hf hwmon_vid eeprom sit
> tunnel4 nf_nat_h323 nf_conntrack_h323 nf_nat_ftp nf_conntrack_ftp
> ipt_tos ipt_REDIRECT nf_nat_irc nf_conntrack_irc ipt_owner ipt_ttl ipv6
> ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK iptable_raw ipt_TOS
> iptable_mangle ipt_LOG xt_TCPMSS xt_limit xt_state ipt_TARPIT ipt_REJECT
> iptable_filter binfmt_misc nvram snd_via82xx snd_ac97_codec ac97_bus
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss
> snd_mixer_oss snd_pcm compat_ioctl32 videodev snd_timer snd_page_alloc
> parport_pc v4l2_common snd_mpu401_uart v4l1_compat snd_rawmidi parport
> snd_seq_device snd usblp i2c_viapro uhci_hcd
> CPU:    0
> EIP:    0060:[<a5773b04>]    Not tainted VLI
> EFLAGS: 00010292   (2.6.22.2 #4)
> EIP is at 0xa5773b04
> eax: 00000000   ebx: 32b79617   ecx: 00000000   edx: 00000000
> esi: 15997020   edi: 184a7dfa   ebp: d861266a   esp: dbe0ff18
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process gpg (pid: 22121, ti=dbe0e000 task=d0a84a50 task.ti=dbe0e000)
> Stack: cfc26544 b3546f92 f00ab86f a7815764 b1000d9d 7e024d7b ef89803b
> 3a816173
>        db38f9a3 4d18a9b1 de997ad3 bee35cf6 6a3b6724 43e1382b 13e8dabb
> 1c129e64
>        81cc5ec8 e3073404 706dc511 90ba38c5 5a8912dc 67e387e7 63e76d1b
> 54f7bf10
> Call Trace:
>  [<c0103b75>] show_trace_log_lvl+0x1a/0x2f
>  [<c0103c27>] show_stack_log_lvl+0x9d/0xa5
>  [<c0103dfc>] show_registers+0x1cd/0x2e3
>  [<c0104010>] die+0xfe/0x200
>  [<c010fb77>] do_page_fault+0x43c/0x511
>  [<c030220a>] error_code+0x6a/0x70
>  =======================
> Code:  Bad EIP value.
> EIP: [<a5773b04>] 0xa5773b04 SS:ESP 0068:dbe0ff18
> 
> 
> FWIW: I run audio-entropyd and use netdev-random. Both pieces of
> sofwtare don't interfere as far as I know.


Can you try without both, and if it works, which of them causes the 
problem?


> strace shows:
>...
> open("/dev/random", O_RDONLY|O_LARGEFILE) = 5
> fstat64(5, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 8), ...}) = 0
> select(6, [5], NULL, NULL, {3, 0})      = 1 (in [5], left {3, 0})
> read(5,
> "x\250v\340\342\212\2614\"\242\273i\201}\355\30\361\262a\272\230\226\2\32\352d\307\350#\324R\343"...,
> 300) = 128
> select(6, [5], NULL, NULL, {3, 0})      = 1 (in [5], left {3, 0})
> read(5,  <unfinished ...>
> +++ killed by SIGSEGV +++
> 
> 
> This is on a VIA Epia EK8000 again.


Is CONFIG_HW_RANDOM_VIA enabled in your kernel?
If yes, does disabling it help?


> Udo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

