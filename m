Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218Ab0AaCL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0AaCL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 21:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509Ab0AaCL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 21:11:26 -0500
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:33881 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab0AaCLZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 21:11:25 -0500
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.32: padlock_sha1 and hmac broken?
Date: Sun, 31 Jan 2010 03:11:22 +0100
User-Agent: KMail/1.9.9
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <201001300044.15769.wolfgang.walter@stwm.de> <201001301734.46003.wolfgang.walter@stwm.de> <20100130221731.GA18982@gondor.apana.org.au>
In-Reply-To: <20100130221731.GA18982@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001310311.23116.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 30. Januar 2010 schrieb Herbert Xu:
> On Sat, Jan 30, 2010 at 05:34:45PM +0100, Wolfgang Walter wrote:
> > > Please also try "modprobe tcrypt mode=101".
> >
> > [  474.947508] alg: hash: Failed to load transform for hmac(sha1): -2
> > [  474.952660] alg: hash: Failed to load transform for hmac(sha1): -2
> > [  474.952737] tcrypt: one or more tests failed!
>
> Oops, it looks like this has been broken ever since we added
> prehashing to hmac.
>
> Please try this patch and let me know whether it makes it work
> again.
>
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
> index 0af8057..a1180ca 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -57,6 +57,20 @@ static int padlock_sha_update(struct shash_desc *desc,
>  	return crypto_shash_update(&dctx->fallback, data, length);
>  }
>
> +static int padlock_sha_export(struct shash_desc *desc, void *out)
> +{
> +	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
> +
> +	return crypto_shash_export(&dctx->fallback, out);
> +}
> +
> +static int padlock_sha_import(struct shash_desc *desc, const void *in)
> +{
> +	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
> +
> +	return crypto_shash_import(&dctx->fallback, in);
> +}
> +
>  static inline void padlock_output_block(uint32_t *src,
>  		 	uint32_t *dst, size_t count)
>  {
> @@ -235,7 +249,10 @@ static struct shash_alg sha1_alg = {
>  	.update 	=	padlock_sha_update,
>  	.finup  	=	padlock_sha1_finup,
>  	.final  	=	padlock_sha1_final,
> +	.export		=	padlock_sha_export,
> +	.import		=	padlock_sha_import,
>  	.descsize	=	sizeof(struct padlock_sha_desc),
> +	.statesize	=	sizeof(struct sha1_state),
>  	.base		=	{
>  		.cra_name		=	"sha1",
>  		.cra_driver_name	=	"sha1-padlock",
> @@ -256,7 +273,10 @@ static struct shash_alg sha256_alg = {
>  	.update 	=	padlock_sha_update,
>  	.finup  	=	padlock_sha256_finup,
>  	.final  	=	padlock_sha256_final,
> +	.export		=	padlock_sha_export,
> +	.import		=	padlock_sha_import,
>  	.descsize	=	sizeof(struct padlock_sha_desc),
> +	.statesize	=	sizeof(struct sha256_state),
>  	.base		=	{
>  		.cra_name		=	"sha256",
>  		.cra_driver_name	=	"sha256-padlock",
>
> Thanks,

Not sure.

When I do

modprobe tcrypt mode=101

I get a kernel oops:

[  113.074210] BUG: unable to handle kernel NULL pointer dereference at 
00000034                                                
[  113.074375] IP: [<dfc92042>] padlock_sha_import+0xa/0x15 [padlock_sha]                                                       
[  113.074493] *pde = 00000000                                                                                                  
[  113.074590] Oops: 0000 [#1] PREEMPT                                                                                          
[  113.074727] last sysfs file: /sys/module/vt/parameters/default_utf8                                                          
[  113.074792] Modules linked in: tcrypt(+) padlock_sha nf_conntrack_tftp 
nf_conntrack_sip nf_conntrack_sane nf_conntrack_ftp xt_connlimit xt_connbytes 
xt_CONNMARK xt_connmark xt_helper xt_NOTRACK xt_conntrack nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 
[  113.075595]                                                                                                                  
[  113.075653] Pid: 1701, comm: cryptomgr_test Not tainted (2.6.32.7 #1)                                                        
[  113.075722] EIP: 0060:[<dfc92042>] EFLAGS: 00010246 CPU: 0                                                                   
[  113.075789] EIP is at padlock_sha_import+0xa/0x15 [padlock_sha]                                                              
[  113.075855] EAX: 00000000 EBX: d74619f8 ECX: dfc925d4 EDX: cd280238                                                          
[  113.075923] ESI: dc0d2a2c EDI: d74619f0 EBP: cdb77d80 ESP: cdb77d7c                                                          
[  113.075990]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068                                                                    
[  113.076057] Process cryptomgr_test (pid: 1701, ti=cdb76000 task=d97d3b80 
task.ti=cdb76000)                                   
[  113.076133] Stack:                                                                                                           
[  113.076187]  cd280238 cdb77d94 c01ec148 00000000 d74619c0 d74619e8 cdb77d9c 
c01ec165                                         
[  113.076671] <0> cdb77db4 c01e9581 00000008 d74619c0 00000000 00000000 
cdb77dbc c01e95b6                                      
[  113.076671] <0> cdb77dd4 c01e89c5 c01e959c c056fdd8 00000000 cd489008 
cdb77ddc c01e89dd                                      
[  113.076671] Call Trace:                                                                                                      
[  113.076671]  [<c01ec148>] ? hmac_import+0x3b/0x40                                                                            
[  113.076671]  [<c01ec165>] ? hmac_init+0x18/0x1a                                                                              
[  113.076671]  [<c01e9581>] ? shash_ahash_digest+0x8c/0xa7                                                                     
[  113.076671]  [<c01e95b6>] ? shash_async_digest+0x1a/0x1c                                                                     
[  113.076671]  [<c01e89c5>] ? crypto_ahash_op+0x8f/0x99                                                                        
[  113.076671]  [<c01e959c>] ? shash_async_digest+0x0/0x1c                                                                      
[  113.076671]  [<c01e89dd>] ? crypto_ahash_digest+0xe/0x10                                                                     
[  113.076671]  [<c01ea4cb>] ? test_hash+0x17c/0x4fd                                                                            
[  113.076671]  [<c01e4643>] ? crypto_larval_lookup+0x30/0xfe                                                                   
[  113.076671]  [<c01e4278>] ? crypto_alloc_tfm+0x3d/0x71
[  113.076671]  [<c01e9114>] ? crypto_alloc_shash+0x10/0x12
[  113.076671]  [<dfc92429>] ? padlock_cra_init+0x1c/0x4b [padlock_sha]
[  113.076671]  [<c01e420c>] ? crypto_create_tfm+0x59/0x88
[  113.076671]  [<c01e4eb4>] ? crypto_spawn_tfm2+0x20/0x37
[  113.076671]  [<c01ec551>] ? hmac_init_tfm+0x1b/0x46
[  113.076671]  [<c01e420c>] ? crypto_create_tfm+0x59/0x88
[  113.076671]  [<c01ea88b>] ? alg_test_hash+0x3f/0x55
[  113.076671]  [<c01ec06b>] ? alg_test+0x168/0x1e9
[  113.076671]  [<c011c37e>] ? pick_next_task_fair+0x8b/0xb5
[  113.076671]  [<c0440b4e>] ? schedule+0x1db/0x382
[  113.076671]  [<c01e9a0e>] ? cryptomgr_test+0x0/0x3e
[  113.076671]  [<c01e9a30>] ? cryptomgr_test+0x22/0x3e
[  113.076671]  [<c01308ef>] ? kthread+0x60/0x65
[  113.076671]  [<c013088f>] ? kthread+0x0/0x65
[  113.076671]  [<c0103147>] ? kernel_thread_helper+0x7/0x10
[  113.076671] Code: 41 04 89 c8 8b 52 34 ff 52 d4 5d c3 55 89 e5 53 8d 58 08 
8b 40 08 8b 48 34 89 d8 ff 51 e8 5b 5d c3 55 89 e5 53 8d 58 08 8b 40 08 <8b> 
48 34 89 d8 ff 51 ec 5b 5d c3 55 89 e5 53 8d 58 08 8b 40 04
[  113.076671] EIP: [<dfc92042>] padlock_sha_import+0xa/0x15 [padlock_sha] 
SS:ESP 0068:cdb77d7c
[  113.076671] CR2: 0000000000000034
[  113.092662] ---[ end trace d25b6d64215b111e ]---
[  123.233370] alg: hash: Failed to load transform for hmac(sha1): -4
[  123.233472] alg: hash: Failed to load transform for hmac(sha1): -4
[  123.233538] tcrypt: one or more tests failed!



Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
