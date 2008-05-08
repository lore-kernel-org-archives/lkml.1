Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbYEHRug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbYEHRug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765180AbYEHRoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:44:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:33587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765170AbYEHRoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:44:02 -0400
Date: Thu, 8 May 2008 10:42:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 15/16] CRYPTO: authenc: Fix async crypto crash in
	crypto_authenc_genicv()
Message-ID: <20080508174231.GP855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-authenc-fix-async-crypto-crash-in-crypto_authenc_genicv.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

[CRYPTO] authenc: Fix async crypto crash in crypto_authenc_genicv()

[ Upstream commit: 161613293fd4b7d5ceb1faab788f47e688e07a67 ]

crypto_authenc_givencrypt_done uses req->data as struct aead_givcrypt_request,
while it really points to a struct aead_request, causing this crash:

BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<dc87517b>] :authenc:crypto_authenc_genicv+0x23/0x109
*pde = 00000000
Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
Modules linked in: hifn_795x authenc esp4 aead xfrm4_mode_tunnel sha1_generic hmac crypto_hash]

Pid: 3074, comm: ping Not tainted (2.6.25 #4)
EIP: 0060:[<dc87517b>] EFLAGS: 00010296 CPU: 0
EIP is at crypto_authenc_genicv+0x23/0x109 [authenc]
EAX: daa04690 EBX: daa046e0 ECX: dab0a100 EDX: daa046b0
ESI: 6b6b6b6b EDI: dc872054 EBP: c033ff60 ESP: c033ff0c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process ping (pid: 3074, ti=c033f000 task=db883a80 task.ti=dab6c000)
Stack: 00000000 daa046b0 c0215a3e daa04690 dab0a100 00000000 ffffffff db9fd7f0
       dba208c0 dbbb1720 00000001 daa04720 00000001 c033ff54 c0119ca9 dc852a75
       c033ff60 c033ff60 daa046e0 00000000 00000001 c033ff6c dc87527b 00000001
Call Trace:
 [<c0215a3e>] ? dev_alloc_skb+0x14/0x29
 [<c0119ca9>] ? printk+0x15/0x17
 [<dc87527b>] ? crypto_authenc_givencrypt_done+0x1a/0x27 [authenc]
 [<dc850cca>] ? hifn_process_ready+0x34a/0x352 [hifn_795x]
 [<dc8353c7>] ? rhine_napipoll+0x3f2/0x3fd [via_rhine]
 [<dc851a56>] ? hifn_check_for_completion+0x4d/0xa6 [hifn_795x]
 [<dc851ab9>] ? hifn_tasklet_callback+0xa/0xc [hifn_795x]
 [<c011d046>] ? tasklet_action+0x3f/0x66
 [<c011d230>] ? __do_softirq+0x38/0x7a
 [<c0105a5f>] ? do_softirq+0x3e/0x71
 [<c011d17c>] ? irq_exit+0x2c/0x65
 [<c010e0c0>] ? smp_apic_timer_interrupt+0x5f/0x6a
 [<c01042e4>] ? apic_timer_interrupt+0x28/0x30
 [<dc851640>] ? hifn_handle_req+0x44a/0x50d [hifn_795x]
 ...

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/authenc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -217,9 +217,10 @@ static void crypto_authenc_givencrypt_do
 					   int err)
 {
 	if (!err) {
-		struct aead_givcrypt_request *greq = req->data;
+		struct aead_request *areq = req->data;
+		struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
 
-		err = crypto_authenc_genicv(&greq->areq, greq->giv, 0);
+		err = crypto_authenc_genicv(areq, greq->giv, 0);
 	}
 
 	aead_request_complete(req->data, err);

-- 
