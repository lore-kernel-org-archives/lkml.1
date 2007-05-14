Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXENRiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXENRiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXENRiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:38:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:57350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbXENRiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FeFeTnEuzBu6YP7V3CHWwO2JWnlRpCtvF+LdeVFPyDXpSnEipN1aUIXcVcdep1ihiiTtM3cF+rU+UcAQo0I6PsuZzk5oELjl4VA0oRaLHuwyPSfHgtNZzxKO9ZuhgOjkyqbZnH0j0uuppDH4hD+vqwjQRPL2IGoX946bqwqTybs=
Date: Mon, 14 May 2007 19:38:23 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070514173823.GA7137@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester <kjwinchester@gmail.com> ha scritto:
> On 5/9/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Tue, May 08, 2007 at 09:58:09PM -0300, Kevin Winchester wrote:
>> >
>> > Not having any idea what I'm doing, I looked at cryptomgr_probe and
>> > cryptomgr_notify, and can't seem to see much, except for the following
>> > odd lines.
>> >
>> > From cryptomgr_schedule_probe, which is almost certainly inlined into
>> > crypto_notify:
>>
>> Thanks for reporting this.  This patch should fix the problem.
>>
>> Cheers,
>> --
>> Visit Openswan at http://www.openswan.org/
>> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>> --
>> diff -puN crypto/cryptomgr.c~crypto-fix crypto/cryptomgr.c
>> --- a/crypto/cryptomgr.c~crypto-fix
>> +++ a/crypto/cryptomgr.c
>> @@ -24,8 +24,6 @@
>>  #include "internal.h"
>>
>>  struct cryptomgr_param {
>> -       struct task_struct *thread;
>> -
>>         struct rtattr *tb[CRYPTOA_MAX];
>>
>>         struct {
>> @@ -81,6 +79,7 @@ err:
>>
>>  static int cryptomgr_schedule_probe(struct crypto_larval *larval)
>>  {
>> +       struct task_struct *thread;
>>         struct cryptomgr_param *param;
>>         const char *name = larval->alg.cra_name;
>>         const char *p;
>> @@ -130,8 +129,8 @@ static int cryptomgr_schedule_probe(stru
>>
>>         memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
>>
>> -       param->thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
>> -       if (IS_ERR(param->thread))
>> +       thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
>> +       if (IS_ERR(thread))
>>                 goto err_free_param;
>>
>>         return NOTIFY_STOP;
>> _
>>
> 
> I see that this patch made it in to mainline, and latest -git now
> works for me, so I assume this was the correct solution.  I thought I
> had tried this exact change without success when I was looking at the
> problem, but I guess I did something wrong along the way.

Hum,
I'm running git 705962cc (which is a commit after -rc1) and I still see
the OOPS on boot. The patch above is already applied though. Note that
I'm using the SLAB allocator:

CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set


Ending clean XFS mount for filesystem: dm-4
BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
 printing eip:
b0141aef
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP 
BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
b0141aef
*pde = 00000000
Modules linked in: sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ohci1394 snd e100 parport_pc parport ehci_hcd uhci_hcd atl1 intel_agp agpgart ieee1394 usbcore soundcore mii i2c_i801 snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    0
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010256   (2.6.22-rc1-libata-g705962cc-dirty #62)
EIP is at module_put+0x1c/0x57
eax: 00000000   ebx: 6b6b6b6b   ecx: 00000001   edx: ee5bb000
esi: 00000000   edi: ee7b8a38   ebp: 00000000   esp: ee5bbfa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4532, ti=ee5bb000 task=ef2fc070 task.ti=ee5bb000)
Stack: ee7b8a38 00000000 ee7b8a38 f0858235 00000282 ef1a0bc0 00000000 ee7b8a38 
       f08581b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       ef1a0bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f0858235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f08581b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:ee5bbfa8
Oops: 0002 [#2]
note: cryptomgr[4532] exited with preempt_count 1
PREEMPT SMP 
Modules linked in: sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ohci1394 snd e100 parport_pc parport ehci_hcd uhci_hcd atl1 intel_agp agpgart ieee1394 usbcore soundcore mii i2c_i801 snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    1
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010212   (2.6.22-rc1-libata-g705962cc-dirty #62)
EIP is at module_put+0x1c/0x57
eax: 00000080   ebx: 6b6b6b6b   ecx: 00000001   edx: b1a0f000
esi: 00000000   edi: ee20fd80   ebp: 00000000   esp: b1a0ffa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4537, ti=b1a0f000 task=eecce0b0 task.ti=b1a0f000)
Stack: ee20fd80 00000000 ee20fd80 f0858235 00000282 ef1a0bc0 00000000 ee20fd80 
       f08581b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       ef1a0bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f0858235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f08581b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:b1a0ffa8
note: cryptomgr[4537] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
b0141aef
*pde = 00000000
Oops: 0002 [#3]
PREEMPT SMP 
Modules linked in: des cbc blkcipher sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ohci1394 snd e100 parport_pc parport ehci_hcd uhci_hcd atl1 intel_agp agpgart ieee1394 usbcore soundcore mii i2c_i801 snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    1
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010212   (2.6.22-rc1-libata-g705962cc-dirty #62)
EIP is at module_put+0x1c/0x57
eax: 00000080   ebx: 6b6b6b6b   ecx: 00000001   edx: b1a0f000
esi: f1b32b60   edi: ee20fc68   ebp: fffffffe   esp: b1a0ffa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4564, ti=b1a0f000 task=eecfd570 task.ti=b1a0f000)
Stack: fffffffe f1b32b60 fffffffe f0858235 00000282 ef1a0bc0 00000000 ee20fc68 
       f08581b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       ef1a0bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f0858235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f08581b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:b1a0ffa8
note: cryptomgr[4564] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
 printing eip:
b0141aef
*pde = 00000000
Oops: 0002 [#4]
BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
b0141aef
*pde = 00000000
PREEMPT SMP 
Modules linked in: des cbc blkcipher sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ohci1394 snd e100 parport_pc parport ehci_hcd uhci_hcd atl1 intel_agp agpgart ieee1394 usbcore soundcore mii i2c_i801 snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    0
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010256   (2.6.22-rc1-libata-g705962cc-dirty #62)
EIP is at module_put+0x1c/0x57
eax: 00000000   ebx: 6b6b6b6b   ecx: 00000001   edx: ed1a1000
esi: f1b32b60   edi: edf47e98   ebp: fffffffe   esp: ed1a1fa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4569, ti=ed1a1000 task=eec4aa70 task.ti=ed1a1000)
Stack: fffffffe f1b32b60 fffffffe f0858235 00000282 ef1a0bc0 00000000 edf47e98 
       f08581b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       ef1a0bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f0858235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f08581b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:ed1a1fa8
Oops: 0002 [#5]
note: cryptomgr[4569] exited with preempt_count 1
PREEMPT SMP 
Modules linked in: des cbc blkcipher sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ohci1394 snd e100 parport_pc parport ehci_hcd uhci_hcd atl1 intel_agp agpgart ieee1394 usbcore soundcore mii i2c_i801 snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    1
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010212   (2.6.22-rc1-libata-g705962cc-dirty #62)
EIP is at module_put+0x1c/0x57
eax: 00000080   ebx: 6b6b6b6b   ecx: 00000001   edx: efcf7000
esi: f1b32b60   edi: ee20f920   ebp: fffffffe   esp: efcf7fa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4574, ti=efcf7000 task=ee67c0b0 task.ti=efcf7000)
Stack: fffffffe f1b32b60 fffffffe f0858235 00000282 ef1a0bc0 00000000 ee20f920 
       f08581b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       ef1a0bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f0858235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f08581b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:efcf7fa8
note: cryptomgr[4574] exited with preempt_count 1

(More OOPSes)

Luca
-- 
"Chi parla in tono cortese, ma continua a prepararsi, potra` andare avanti;
 chi parla in tono bellicoso e avanza rapidamente dovra` ritirarsi" 
Sun Tzu -- L'arte della guerra
