Return-Path: <linux-kernel-owner+w=401wt.eu-S2992534AbXCWRFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992534AbXCWRFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992538AbXCWRFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:05:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:49936 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992534AbXCWRFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:05:38 -0400
X-Authenticated: #6819316
X-Provags-ID: V01U2FsdGVkX1/Ca8p6P+7Cc6ror2RqxniAEPkTtIQ93sPSRkXpPx
	t0R1d1TS5X3wCx
Date: Fri, 23 Mar 2007 18:05:35 +0100
From: "Jan C. Nordholz" <jckn@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: race condition in dm-crypt?
Message-ID: <20070323170535.GA3057@hejre.minidns.net>
Reply-To: jckn@gmx.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14+cvs20070315 (2007-03-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

I think I'm experiencing a race condition: Irregularly my kernel runs
into an Oops when it tries to initialize my crypt containers.

> Mar 23 17:33:08 1A:hejre kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> Mar 23 17:33:08 1A:hejre kernel:  printing eip:
> Mar 23 17:33:08 4A:hejre kernel: c0143543
> Mar 23 17:33:08 1A:hejre kernel: *pde = 00000000
> Mar 23 17:33:08 0A:hejre kernel: Oops: 0000 [#1]
> Mar 23 17:33:08 0A:hejre kernel: PREEMPT 
> Mar 23 17:33:08 4A:hejre kernel: Modules linked in: xt_NFQUEUE xt_tcpudp xt_state xt_limit xt_CONNMARK xt_connmark xt_multiport ipt_REDIRECT ipt_MASQUERADE ipt_LOG nfnetlink_queue nfnetlink iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_filter ip_tables x_tables ipv6 xfrm4_mode_transport esp4 deflate des md5 crypto_null hmac crypto_hash af_key ntfs sha256 aes_i586 cbc dm_crypt dm_mod snd_virmidi snd_seq_virmidi snd_ca0106 snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore usb_storage sd_mod scsi_mod nls_utf8 nls_cp850 nls_iso8859_1 hisax_fcpcipnp hisax_isac hisax via686a w83781d hwmon_vid hwmon i2c_isa i2c_viapro i2c_core msr isdn_bsdcomp isdn cpuid rtc
> Mar 23 17:33:08 0A:hejre kernel: CPU:    0
> Mar 23 17:33:08 0A:hejre kernel: EIP:    0060:[<c0143543>]    Not tainted VLI
> Mar 23 17:33:08 0A:hejre kernel: EFLAGS: 00010282   (2.6.20-git12 #2)
> Mar 23 17:33:08 0A:hejre kernel: EIP is at mempool_free+0x13/0xb0
> Mar 23 17:33:08 0A:hejre kernel: eax: cdf39d44   ebx: cdf39d44   ecx: 00000001   edx: 00000000
> Mar 23 17:33:08 0A:hejre kernel: esi: 00000000   edi: cdf39d44   ebp: dff19eb4   esp: dff19ea4
> Mar 23 17:33:08 0A:hejre kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Mar 23 17:33:08 0A:hejre kernel: Process kcryptd/0 (pid: 772, ti=dff18000 task=dff050d0 task.ti=dff18000)
> Mar 23 17:33:08 0A:hejre kernel: Stack: c011c58b cdf39d44 00000000 dd87f9e0 dff19ed8 e092c792 e092d7c4 cdf39d44 
> Mar 23 17:33:08 0A:hejre kernel:        e0a45040 dd87f9e0 dff19f20 dd87f9e0 dfbb76e0 dff19f4c e092cc1b d10abbe0 
> Mar 23 17:33:08 0A:hejre kernel:        0000007c 00000000 00000000 d10abbe0 cdf39d44 d10ab9a0 c0117598 0000000f 
> Mar 23 17:33:08 0A:hejre kernel: Call Trace:
> Mar 23 17:33:08 0A:hejre kernel:  [<c010500a>] show_trace_log_lvl+0x1a/0x30
> Mar 23 17:33:08 0A:hejre kernel:  [<c01050c9>] show_stack_log_lvl+0xa9/0xd0
> Mar 23 17:33:08 0A:hejre kernel:  [<c01052d1>] show_registers+0x1e1/0x330
> Mar 23 17:33:08 0A:hejre kernel:  [<c010552e>] die+0x10e/0x230
> Mar 23 17:33:08 0A:hejre kernel:  [<c01168a0>] do_page_fault+0x2b0/0x5d0
> Mar 23 17:33:08 0A:hejre kernel:  [<c0319bd4>] error_code+0x74/0x7c
> Mar 23 17:33:08 0A:hejre kernel:  [<e092c792>] dec_pending+0x62/0x80 [dm_crypt]
> Mar 23 17:33:08 0A:hejre kernel:  [<e092cc1b>] kcryptd_do_work+0x2fb/0x3b0 [dm_crypt]
> Mar 23 17:33:08 0A:hejre kernel:  [<c012b6e4>] run_workqueue+0xa4/0x180
> Mar 23 17:33:08 0A:hejre kernel:  [<c012bde7>] worker_thread+0x137/0x160
> Mar 23 17:33:08 0A:hejre kernel:  [<c012ec73>] kthread+0xa3/0xd0
> Mar 23 17:33:08 0A:hejre kernel:  [<c0104c3b>] kernel_thread_helper+0x7/0x1c
> Mar 23 17:33:08 0A:hejre kernel:  =======================
> Mar 23 17:33:08 0A:hejre kernel: Code: f4 45 1d 00 8d 74 26 00 eb d3 31 db e9 37 ff ff ff 8d b4 26 00 00 00 00 55 89 e5 83 ec 10 89 75 f8 89 7d fc 89 d6 89 5d f4 89 c7 <8b> 02 39 42 04 7d 27 9c 5b fa 89 e0 25 00 e0 ff ff ff 40 14 8b
> Mar 23 17:33:08 0A:hejre kernel: EIP: [<c0143543>] mempool_free+0x13/0xb0 SS:ESP 0068:dff19ea4

The userland process triggering the BUG gets stuck in sync_page, but the rest of
the system survives. - I suspected dec_pending's cc pointer to become invalid, so
I inserted a few printk()s in crypt_ctr, _dtr and dec_pending, et voilà:

(successful cryptsetup, a few days ago)
> Mar 21 20:37:31 6A:hejre kernel: Crypt_Ctr, DmTarget e0a4c040 now has CryptConfig daf12aa0.
> Mar 21 20:37:31 4A:hejre kernel: This is dm_crypt::dec_pending, IO d4e03e84, DmTgt e0a4c040, CC daf12aa0.
> Mar 21 20:37:31 4A:hejre last message repeated 124 times
> Mar 21 20:37:31 6A:hejre kernel: Crypt_Dtr, freeing DmTarget e0a4c040's CryptConfig daf12aa0.
> Mar 21 20:37:31 6A:hejre kernel: Crypt_Ctr, DmTarget e0a4c040 now has CryptConfig daf12ba0.
> Mar 21 20:37:31 4A:hejre kernel: This is dm_crypt::dec_pending, IO d4e03e84, DmTgt e0a4c040, CC daf12ba0.
> Mar 21 20:37:31 4A:hejre kernel: This is dm_crypt::dec_pending, IO d4e03e5c, DmTgt e0a4c040, CC daf12ba0.
> Mar 21 20:37:31 4A:hejre kernel: This is dm_crypt::dec_pending, IO d4e03e34, DmTgt e0a4c040, CC daf12ba0.
> [... and continues happily]

(context of the above oops)
> Mar 23 17:33:08 6A:hejre kernel: Crypt_Ctr, DmTarget e0a45040 now has CryptConfig dd87f9e0.
> Mar 23 17:33:08 4A:hejre kernel: This is dm_crypt::dec_pending, IO cdf39d44, DmTgt e0a45040, CC dd87f9e0.
> Mar 23 17:33:08 4A:hejre kernel: This is dm_crypt::dec_pending, IO cdf39d1c, DmTgt e0a45040, CC dd87f9e0.
> [some more of those]
> Mar 23 17:33:08 4A:hejre kernel: This is dm_crypt::dec_pending, IO cdf39d1c, DmTgt e0a45040, CC dd87f9e0.
> Mar 23 17:33:08 4A:hejre kernel: This is dm_crypt::dec_pending, IO cdf39d44, DmTgt e0a45040, CC dd87f9e0.
> Mar 23 17:33:08 6A:hejre kernel: Crypt_Dtr, freeing DmTarget e0a45040's CryptConfig dd87f9e0.
> Mar 23 17:33:08 1A:hejre kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> Mar 23 17:33:08 1A:hejre kernel:  printing eip:
> [...]
> Mar 23 17:33:08 0A:hejre kernel: EIP: [<c0143543>] mempool_free+0x13/0xb0 SS:ESP 0068:dff19ea4
> Mar 23 17:33:08 6A:hejre kernel: Crypt_Ctr, DmTarget e0a45040 now has CryptConfig dd87fce0.

I'm seeing this for quite a while now (since 2.6.16 at least), but without any obvious indicator
to what might be causing it... where should I continue debugging this?


Thanks in advance,

Jan Nordholz
