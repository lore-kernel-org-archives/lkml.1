Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZFAJvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZFAJvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbZFAJux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:50:53 -0400
Received: from mailgw3.cms.com ([202.75.200.223]:44749 "EHLO cms.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755070AbZFAJuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:50:52 -0400
X-Originating-IP: 172.19.23.105
X-Auth-User: vibi_sreenivasan@cms.com
X-Filename: C:\PROGRA~1\MailScan\in\SMT5351129116508.TMP
Subject: [Fwd: Re: [PATCH]:RESEND : Return proper error value on failure of
	dentry_open]
From: vibi sreenivasan <vibi_sreenivasan@cms.com>
Reply-To: vibi_sreenivasan@cms.com
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, Kylene Hall <kylene@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: CMS
Date: Mon, 01 Jun 2009 15:16:50 +0530
Message-Id: <1243849610.2234.3.camel@system>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8)
Content-Transfer-Encoding: 7bit
X-Trained: 2
X-MS-ContentScanSkipped: Mail Not From Internet
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

> > >  	mutex_unlock(&iint->mutex);
> > > -	if (file)
> > > +	if (!IS_ERR(file))
> > >  		fput(file);
> > 
> > No, IS_ERR won't catch NULL and there is 'file = NULL' on the
> > dentry_open fail path.
Can you please point out that line number in fs/open.c
> 
> > I still think 'if (file)' is proper condition.
> > 
if(file) will be true for file == -ve error value
so in fput(file),
	atomic_long_dec_and_test(&file->f_count)
triggers bug
> 
> > What bug did you hit?
> > 
BUG: unable to handle kernel paging request at ffffffc9
IP: [<c048092e>] fput+0x2/0x14
*pde = 007ed067 *pte = 00000000 
Oops: 0002 [#1] PREEMPT 
last sysfs file: /sys/class/drm/card0/dev
Modules linked in: i915 drm i2c_algo_bit video output autofs4 af_packet
nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT iptable_filter ip_tables
nf_conntrack_netbios_ns xt_tcpudp nf_conntrack_ipv6 xt_state
nf_conntrack ip6t_ipv6header ip6t_REJECT ip6table_filter ip6_tables
x_tables ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath
dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
snd_pcm fan sis900 mii snd_timer parport_pc parport rtc_cmos snd
rtc_core psmouse rtc_lib thermal soundcore floppy i2c_i801 button
thermal_sys serio_raw snd_page_alloc rng_core i2c_core pcspkr evdev unix
ata_piix libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd [last
unloaded: processor]

Pid: 2213, comm: file Not tainted (2.6.30-rc7 #5)  
EIP: 0060:[<c048092e>] EFLAGS: 00210282 CPU: 0
EIP is at fput+0x2/0x14
EAX: ffffffb5 EBX: c5445a58 ECX: ffffffff EDX: ffffffb5
ESI: ca2b0ab0 EDI: ffffffb5 EBP: c070c1f9 ESP: ca2adeb8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process file (pid: 2213, ti=ca2ad000 task=ca05b480 task.ti=ca2ad000)
Stack:
 c05051d2 00000024 c5448780 00000000 00008001 00000004 c04876fd ca2adf0c
 c5445a00 ca2adf0c 00000000 ca2adf0c 00008001 c04898dd 00008000 debc8000
 00000017 000081a4 00000000 00000000 00000000 ca0d9680 c5445a00 00000000
Call Trace:
 [<c05051d2>] ? ima_path_check+0x14b/0x16c
 [<c04876fd>] ? may_open+0xb0/0x271
 [<c04898dd>] ? do_filp_open+0x3df/0x73d
 [<c0487aa7>] ? getname+0x1a/0xac
 [<c0490fe2>] ? alloc_fd+0xb8/0xd3
 [<c047e063>] ? do_sys_open+0x44/0xb4
 [<c047e117>] ? sys_open+0x1e/0x23
 [<c0402830>] ? sysenter_do_call+0x12/0x22
Code: 74 24 14 89 f9 89 ea 56 e8 38 fe ff ff 59 5e 89 d8 5b 5e 5f 5d c3
53 8b 1d 08 84 85 c0 89 1d a0 5e 76 c0 5b e9 0d 2b fa ff 89 c2 <ff> 48
14 0f 94 c0 84 c0 74 07 89 d0 e9 6d fc ff ff c3 56 89 c6 
EIP: [<c048092e>] fput+0x2/0x14 SS:ESP 0068:ca2adeb8
CR2: 00000000ffffffc9
---[ end trace 301fff67fb26bbae ]---

Thanks & Regards

vibi sreenivasan


