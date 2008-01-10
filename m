Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYAJKnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYAJKnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYAJKnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:43:08 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:54503 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYAJKnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:43:06 -0500
Date: Thu, 10 Jan 2008 11:43:03 +0100
Message-Id: <285479690@web.de>
MIME-Version: 1.0
From: Torben Viets <Viets@web.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+pID4+xqtEZB4T6II9okCy90njFEFDZJP1gSTRtInticR2s
 l9ax2NFSZ2GQLp2fFPf7LCl2agOBjU81vuxyYAbZo+VsPYdKKo=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply,

the patch doesn't work witch the patch utility, so I did it manually, hope this was rigth:

static void aes_crypt_copy(const u8 *in, u8 *out, u32 *key, struct cword *cword)
{
        u8 tmp[AES_BLOCK_SIZE * 2]
                __attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));

        memcpy(tmp, in, AES_BLOCK_SIZE);
//      padlock_xcrypt(tmp, out, key, cword);
        padlock_xcrypt(tmp, tmp, key, cword);
        memcpy(out, tmp, AES_BLOCK_SIZE);
}

After rebuilding the kernel, I tried: cryptsetup -c aes-xts-plain -s 256 luksFormat /dev/raid/test

It does the same as before, dmesg says:

general protection fault: 0000 [#1] 
Modules linked in: xt_TCPMSS xt_tcpmss iptable_mangle ipt_MASQUERADE xt_tcpudp pppoe pppox xt_mark xt_state iptable_nat nf_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables af_packet ppp_generic slhc aes_i586 dm_crypt dm_mod

Pid: 4409, comm: kcryptd Not tainted (2.6.24-rc7 #2)
EIP: 0060:[<c03599cc>] EFLAGS: 00010282 CPU: 0
EIP is at aes_crypt_copy+0x2c/0x50
EAX: f62e1ff0 EBX: f60ab850 ECX: 00000001 EDX: f60ab830
ESI: f620dda8 EDI: f620dda8 EBP: f62e1ff0 ESP: f620dda8
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kcryptd (pid: 4409, ti=f620c000 task=f61f5030 task.ti=f620c000)
Stack: 638522f6 b587b135 a30487c5 d57aa809 f620de50 f620defc c02613e1 0000007b 
       f60ab850 f62e1ff0 f62e1ff0 f620de00 c0359ad6 f60ab830 f62e1ff0 f62e1ff0 
       00000010 c0267cfc f6edf6e0 f620de34 f620dea8 00000010 8f88b41a 3ba46549 
Call Trace:
 [<c02613e1>] blkcipher_walk_next+0x151/0x320
 [<c0359ad6>] aes_decrypt+0x56/0x60
 [<c0267cfc>] crypt+0xdc/0x110
 [<c0359a80>] aes_decrypt+0x0/0x60
 [<c0267e22>] decrypt+0x42/0x50
 [<c035a1c0>] aes_encrypt+0x0/0x60
 [<c0359a80>] aes_decrypt+0x0/0x60
 [<f886a7de>] crypt_convert_scatterlist+0x6e/0xe0 [dm_crypt]
 [<f886a9ea>] crypt_convert+0x19a/0x1c0 [dm_crypt]
 [<f886aa10>] kcryptd_do_crypt+0x0/0x260 [dm_crypt]
 [<f886aa59>] kcryptd_do_crypt+0x49/0x260 [dm_crypt]
 [<c011964a>] update_curr+0xfa/0x110
 [<f886aa10>] kcryptd_do_crypt+0x0/0x260 [dm_crypt]
 [<c012aeb6>] run_workqueue+0x66/0xe0
 [<c03f3339>] schedule+0x149/0x270
 [<c012b620>] worker_thread+0x0/0x100
 [<c012b6bd>] worker_thread+0x9d/0x100
 [<c012e4c0>] autoremove_wake_function+0x0/0x50
 [<c012b620>] worker_thread+0x0/0x100
 [<c012e182>] kthread+0x42/0x70
 [<c012e140>] kthread+0x0/0x70
 [<c0104acf>] kernel_thread_helper+0x7/0x18
 =======================
Code: ec 30 89 5c 24 20 89 cb 89 74 24 24 89 c6 89 7c 24 28 89 e7 89 6c 24 2c 89 d5 8b 54 24 34 a5 a5 a5 a5 b9 01 00 00 00 89 e6 89 e7 <f3> 0f a7 c8 89 ef 89 e6 a5 a5 a5 a5 8b 5c 24 20 8b 74 24 24 8b 
EIP: [<c03599cc>] aes_crypt_copy+0x2c/0x50 SS:ESP 0068:f620dda8
---[ end trace 927124c395b6378a ]---
note: kcryptd[4409] exited with preempt_count 1

One other strange thing ist, that after rebooting the entry:

 name         : xts(aes)
driver       : xts(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 2
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16

is not visible in /proc/crypt (and of course not useable with cryptsetup), till I use /etc/init.d/udev restart. 

Sorry I don't no why this happens. I guess it is because of reloading the modules, these are my modules:

xt_TCPMSS               3840  1 
xt_tcpmss               2176  1 
iptable_mangle          2752  1 
ipt_MASQUERADE          3456  1 
xt_tcpudp               3136  6 
pppoe                  12800  2 
pppox                   3852  1 pppoe
xt_mark                 1792  1 
xt_state                2368  1 
iptable_nat             7236  1 
nf_nat                 17964  2 ipt_MASQUERADE,iptable_nat
nf_conntrack_ipv4       9988  3 iptable_nat
iptable_filter          2880  1 
ip_tables              12232  3 iptable_mangle,iptable_nat,iptable_filter
x_tables               14724  8 xt_TCPMSS,xt_tcpmss,ipt_MASQUERADE,xt_tcpudp,xt_mark,xt_state,iptable_nat,ip_tables
af_packet              21188  4 
ppp_generic            23700  6 pppoe,pppox
slhc                    6464  1 ppp_generic
aes_i586               33280  0 
dm_crypt               13956  1 
dm_mod                 54976  14 dm_crypt


grettings 
Torben Viets

> -----Ursprüngliche Nachricht-----
> Von: "Herbert Xu" <herbert@gondor.apana.org.au>
> Gesendet: 10.01.08 04:03:26
> An: Torben Viets <viets@web.de>
> CC: linux-kernel@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> Betreff: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?


> 
> On Wed, Jan 09, 2008 at 10:55:27PM +0000, Torben Viets wrote:
> > 
> > eneral protection fault: 0000 [#1]
> > Modules linked in: xt_TCPMSS xt_tcpmss iptable_mangle ipt_MASQUERADE 
> > xt_tcpudp xt_mark xt_state iptable_nat nf_nat nf_conntrack_ipv4 
> > iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc 
> > aes_i586
> > CPU:    0
> > EIP:    0060:[<c035b828>]    Not tainted VLI
> > EFLAGS: 00010292   (2.6.23.12 #7)
> > EIP is at aes_crypt_copy+0x28/0x40
> > eax: f7639ff0   ebx: f6c24050   ecx: 00000001   edx: f6c24030
> > esi: f7e89dc8   edi: f7639ff0   ebp: 00010000   esp: f7e89dc8
> 
> Thanks for the report.  It would appear that your CPU goes one step
> further than the other report and insists on having two blocks in the
> destination too.
> 
> Please let me know whether this patch fixes the problem.
> 
> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
> index a337b69..ed3ae47 100644
> --- a/drivers/crypto/padlock-aes.c
> +++ b/drivers/crypto/padlock-aes.c
> @@ -433,7 +433,8 @@ static void aes_crypt_copy(const u8 *in, u8 *out, u32 *key, struct cword *cword)
>  		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
>  
>  	memcpy(tmp, in, AES_BLOCK_SIZE);
> -	padlock_xcrypt(tmp, out, key, cword);
> +	padlock_xcrypt(tmp, tmp, key, cword);
> +	memcpy(out, tmp, AES_BLOCK_SIZE);
>  }
>  
>  static inline void aes_crypt(const u8 *in, u8 *out, u32 *key,
> 


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

