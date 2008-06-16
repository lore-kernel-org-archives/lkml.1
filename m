Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYFPMK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYFPMK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYFPMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:10:19 -0400
Received: from stinky.trash.net ([213.144.137.162]:63105 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYFPMKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:10:17 -0400
Message-ID: <48565823.4060009@trash.net>
Date: Mon, 16 Jun 2008 14:10:11 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: odie@cs.aau.dk
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
References: <4852B19E.4010202@trash.net>	 <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com>	 <20080613224711.GA15084@linux-os.sc.intel.com> <1213611339.2495.11.camel@odie.local> <48564074.9030301@trash.net>
In-Reply-To: <48564074.9030301@trash.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Simon Holm Th������������������������ wrote:
>> fre, 13 06 2008 kl. 15:47 -0700, skrev Suresh Siddha:
>>> On Fri, Jun 13, 2008 at 11:24:01AM -0700, Vegard Nossum wrote:
>>>
>>> I have a theory for your problem and have appended a patch to test 
>>> it. Can
>>> you please check if the appended patch fixes your problem.
>>>
>> At least for me, with this patch applied on top of -rc4 or -rc6+ the
>> problem still triggered after running an lguest guest for less than 30
>> seconds (the guest didn't even finish the boot of an image of Ubuntu
>> with no X-server).
> 
> 
> The patch also didn't fix the problem here, I got the same crash this
> morning. Unfortunately netconsole didn't log it, but its essentially
> the same as the one I posted.

I just got this oops. It didn't bring the machine down this time and
the Oops in math_state_restore() is new, maybe it helps in determining
the cause. One of the lguest guests is dead since the oops, so this
really seems to be lguest-related:

[47853.037829] BUG: unable to handle kernel NULL pointer dereference at 
00000000
[47853.037861] IP: [<c0104910>] math_state_restore+0x21/0x60
[47853.037887] *pde = 00000000
[47853.037904] Oops: 0000 [#1] PREEMPT
[47853.037921] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc 
exportfs sch_red cls_fw cls_flow tun sit tunnel4 sch_drr sch_hfsc 
af_packet xt_statistic xt_CONNMARK xt_connmark xt_length xt_owner 
xt_MARK ip6table_mangle ipt_MASQUERADE ipt_REDIRECT ipt_TTL 
iptable_mangle iptable_nat nf_nat_sip nf_nat_irc nf_conntrack_irc 
nf_nat_ftp nf_nat nf_conntrack_ftp ip6t_hl ip6t_REJECT ip6t_ah 
ip6table_filter ipt_ttl ipt_REJECT xt_limit ipt_ah xt_esp xt_state 
xt_TCPMSS xt_tcpmss xt_helper xt_tcpudp xt_hashlimit iptable_filter 
ip6table_raw ip6_tables xt_policy xt_NFLOG iptable_raw ip_tables 
x_tables nfnetlink_log nfnetlink nf_conntrack_ipv6 nf_conntrack_ipv4 
nf_conntrack_sip nf_conntrack deflate zlib_deflate zlib_inflate ctr 
twofish twofish_common camellia serpent blowfish des_generic xcbc 
sha256_generic sha1_generic crypto_null af_key cbc dm_crypt 
crypto_blkcipher dm_snapshot dm_mod lg cpufreq_ondemand p4_clockmod 
speedstep_lib aes_i586 aes_generic esp6 esp4 aead usblp ehci_hcd 
parport_pc parport ohci_hcd rtc sata_promise e1000 usbcore unix
[47853.038009]
[47853.038009] Pid: 14374, comm: sleep Not tainted (2.6.26-rc6 #7)
[47853.038009] EIP: 0060:[<c0104910>] EFLAGS: 00010002 CPU: 0
[47853.038009] EIP is at math_state_restore+0x21/0x60
[47853.038009] EAX: 00000000 EBX: f5e2a6c0 ECX: 00000000 EDX: 00000000
[47853.038009] ESI: e1256000 EDI: 00000001 EBP: e1256fb0 ESP: e1256fa8
[47853.038009]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[47853.038009] Process sleep (pid: 14374, ti=e1256000 task=f5e2a6c0 
task.ti=e1256000)
[47853.038009] Stack: bf84ddf4 0804c8e0 bf84dd58 c0104753 bf84ddf4 
00000000 b7f220f8 0804c8e0
[47853.038009]        00000001 bf84dd58 00000000 0000007b 0000007b 
c0320000 ffffffff 08048e7b
[47853.038009]        00000073 00010202 bf84dd00 0000007b 00002067 00001067
[47853.038009] Call Trace:
[47853.038009]  [<c0104753>] ? device_not_available+0x43/0x48
[47853.038009]  [<c0320000>] ? quirk_usb_early_handoff+0x1eb/0x44b
[47853.038009]  =======================
[47853.038009] Code: af 3c c0 e8 1e 8a 01 00 c9 c3 55 89 e5 56 53 89 e6 
81 e6 00 f0 ff ff 8b 1e f6 43 0d 20 74 1e 0f 06 0f 1f 40 00 8b 83 6c 02 
00 00 <0f> ae 08 83 4e 0c 01 80 83 90 00 00 00 01 5b 5e 5d c3 fb 0f 1f
[47853.038009] EIP: [<c0104910>] math_state_restore+0x21/0x60 SS:ESP 
0068:e1256fa8
[47853.038009] ---[ end trace 11728688d676f153 ]---
[47853.039213] BUG: unable to handle kernel NULL pointer dereference at 
000001ff
[47853.039328] IP: [<c0102aab>] __switch_to+0x2f/0x118
[47853.039409] *pde = 00000000
[47853.039484] Oops: 0002 [#2] PREEMPT
[47853.039591] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc 
exportfs sch_red cls_fw cls_flow tun sit tunnel4 sch_drr sch_hfsc 
af_packet xt_statistic xt_CONNMARK xt_connmark xt_length xt_owner 
xt_MARK ip6table_mangle ipt_MASQUERADE ipt_REDIRECT ipt_TTL 
iptable_mangle iptable_nat nf_nat_sip nf_nat_irc nf_conntrack_irc 
nf_nat_ftp nf_nat nf_conntrack_ftp ip6t_hl ip6t_REJECT ip6t_ah 
ip6table_filter ipt_ttl ipt_REJECT xt_limit ipt_ah xt_esp xt_state 
xt_TCPMSS xt_tcpmss xt_helper xt_tcpudp xt_hashlimit iptable_filter 
ip6table_raw ip6_tables xt_policy xt_NFLOG iptable_raw ip_tables 
x_tables nfnetlink_log nfnetlink nf_conntrack_ipv6 nf_conntrack_ipv4 
nf_conntrack_sip nf_conntrack deflate zlib_deflate zlib_inflate ctr 
twofish twofish_common camellia serpent blowfish des_generic xcbc 
sha256_generic sha1_generic crypto_null af_key cbc dm_crypt 
crypto_blkcipher dm_snapshot dm_mod lg cpufreq_ondemand p4_clockmod 
speedstep_lib aes_i586 aes_generic esp6 esp4 aead usblp ehci_hcd 
parport_pc parport ohci_hcd rtc sata_promise e1000 usbcore unix
[47853.040119]
[47853.040119] Pid: 14374, comm: sleep Tainted: G      D   (2.6.26-rc6 #7)
[47853.040119] EIP: 0060:[<c0102aab>] EFLAGS: 00010002 CPU: 0
[47853.040119] EIP is at __switch_to+0x2f/0x118
[47853.040119] EAX: 00000000 EBX: f60a39b8 ECX: f5e2a6c0 EDX: f60a37a0
[47853.040119] ESI: f60a37a0 EDI: f5e2a6c0 EBP: f06cded0 ESP: f06cdec0
[47853.040119]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[47853.040119] Process sleep (pid: 14374, ti=f06cd000 task=f5e2a6c0 
task.ti=e1256000)
[47853.040119] Stack: f5e2a8d8 f60a37a0 f5079300 f5079c00 e1256eac 
c0321c5c f06cdf00 00000086
[47853.040119]        c047f8e0 c1774a00 3ba50065 f60a37a0 f60a38f4 
ffffffea 00000004 f60a3798
[47853.040119]        f06cdf78 c011edbf f5e2a6c0 3ba50065 f60a37a0 
f5079300 00000000 f60a3888
[47853.040119] Call Trace:
[47853.040119]  [<c0321c5c>] ? schedule+0x1a6/0x30f
[47853.040119]  [<c011edbf>] ? do_wait+0x5b2/0xb8d
[47853.040119]  [<c0118c39>] ? default_wake_function+0x0/0xd
[47853.040119]  [<c011f3ff>] ? sys_wait4+0x65/0xa2
[47853.040119]  [<c011f463>] ? sys_waitpid+0x27/0x29
[47853.040119]  [<c0103c5a>] ? syscall_call+0x7/0xb
[47853.040119]  [<c0320000>] ? quirk_usb_early_handoff+0x1eb/0x44b
[47853.040119]  =======================
[47853.040119] Code: 56 53 83 ec 04 89 c7 89 d6 8d 80 18 02 00 00 89 45 
f0 8d 9a 18 02 00 00 8b 47 04 f6 40 0c 01 0f 84 c9 00 00 00 8b 87 6c 02 
00 00 <0f> ae 00 0f ba 60 02 07 73 02 db e2 0f 1f 00 90 8d b4 26 00 00
[47853.040119] EIP: [<c0102aab>] __switch_to+0x2f/0x118 SS:ESP 0068:f06cdec0
[47853.040119] ---[ end trace 11728688d676f153 ]---
[47853.040119] Fixing recursive fault but reboot is needed!
