Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZKZU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZKZU1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 15:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZKZU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 15:27:42 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37289 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZKZU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 15:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KpYYsQGv/iGkQo6Q7oJFwUKGBJrkjWU4hB8LDOaybPNXHSBkUXYz0OKU3tTA+laWTQ
         0E8q6IRvETw8OkIAFoDuZb5/sIUQlEihMopo0k6t/Xo1M85X8vkfdljsg8Tiz3V28RDg
         gXLl3NNbAYeLGvankKoDBf3pMq58q4ZdigsAA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0911251414480.4779@router.home>
References: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi>
	 <1259173636.29779.41.camel@Joe-Laptop.home>
	 <4B0D77CC.3020807@cs.helsinki.fi>
	 <alpine.DEB.2.00.0911251414480.4779@router.home>
Date: Thu, 26 Nov 2009 22:27:46 +0200
X-Google-Sender-Auth: 8c6e1794922cbaf7
Message-ID: <84144f020911261227i3f2c9193v388a7b118402cbb5@mail.gmail.com>
Subject: Re: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 10:15 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Wed, 25 Nov 2009, Pekka Enberg wrote:
>
>> Because that has no effect on the generated code.
>
> Does this affect the cycle count in slab_alloc?

I ran the synthetic benchmarks here and cycle count is roughly the
same for both versions.

SLUB 2.6.32-rc8:

  Single thread testing
  =====================
  1. Kmalloc: Repeatedly allocate then free test
  10000 times kmalloc(8) -> 118 cycles kfree -> 158 cycles
  10000 times kmalloc(16) -> 129 cycles kfree -> 162 cycles
  10000 times kmalloc(32) -> 136 cycles kfree -> 149 cycles
  10000 times kmalloc(64) -> 148 cycles kfree -> 168 cycles
  10000 times kmalloc(128) -> 189 cycles kfree -> 189 cycles
  10000 times kmalloc(256) -> 217 cycles kfree -> 242 cycles
  10000 times kmalloc(512) -> 254 cycles kfree -> 377 cycles
  10000 times kmalloc(1024) -> 284 cycles kfree -> 468 cycles
  10000 times kmalloc(2048) -> 304 cycles kfree -> 509 cycles
  10000 times kmalloc(4096) -> 388 cycles kfree -> 567 cycles
  10000 times kmalloc(8192) -> 523 cycles kfree -> 658 cycles
  10000 times kmalloc(16384) -> 790 cycles kfree -> 843 cycles
  2. Kmalloc: alloc/free test
  10000 times kmalloc(8)/kfree -> 199 cycles
  10000 times kmalloc(16)/kfree -> 197 cycles
  10000 times kmalloc(32)/kfree -> 197 cycles
  10000 times kmalloc(64)/kfree -> 196 cycles
  10000 times kmalloc(128)/kfree -> 197 cycles
  10000 times kmalloc(256)/kfree -> 197 cycles
  10000 times kmalloc(512)/kfree -> 210 cycles
  10000 times kmalloc(1024)/kfree -> 201 cycles
  10000 times kmalloc(2048)/kfree -> 186 cycles
  10000 times kmalloc(4096)/kfree -> 204 cycles
  10000 times kmalloc(8192)/kfree -> 202 cycles
  10000 times kmalloc(16384)/kfree -> 871 cycles
  Concurrent allocs
  =================
  Kmalloc N*alloc N*free(8): 0=160/182 1=160/179 Average=160/180
  Kmalloc N*alloc N*free(16): 0=164/189 1=163/186 Average=164/188
  Kmalloc N*alloc N*free(32): 0=177/194 1=176/192 Average=177/193
  Kmalloc N*alloc N*free(64): 0=206/211 1=202/209 Average=204/210
  Kmalloc N*alloc N*free(128): 0=238/283 1=238/288 Average=238/285
  Kmalloc N*alloc N*free(256): 0=286/465 1=282/462 Average=284/463
  Kmalloc N*alloc N*free(512): 0=385/604 1=382/600 Average=384/602
  Kmalloc N*alloc N*free(1024): 0=466/606 1=405/604 Average=436/605
  Kmalloc N*alloc N*free(2048): 0=417/650 1=415/659 Average=416/654
  Kmalloc N*alloc N*free(4096): 0=574/838 1=574/827 Average=574/833
  Kmalloc N*(alloc free)(8): 0=222 1=219 Average=221
  Kmalloc N*(alloc free)(16): 0=222 1=220 Average=221
  Kmalloc N*(alloc free)(32): 0=222 1=219 Average=221
  Kmalloc N*(alloc free)(64): 0=185 1=184 Average=184
  Kmalloc N*(alloc free)(128): 0=222 1=219 Average=221
  Kmalloc N*(alloc free)(256): 0=224 1=221 Average=223
  Kmalloc N*(alloc free)(512): 0=225 1=221 Average=223
  Kmalloc N*(alloc free)(1024): 0=225 1=223 Average=224
  Kmalloc N*(alloc free)(2048): 0=225 1=223 Average=224
  Kmalloc N*(alloc free)(4096): 0=225 1=222 Average=224
  Remote free test
  ================
  N*remote free(8): 0=8/187 1=161/0 Average=84/93
  N*remote free(16): 0=8/189 1=163/0 Average=86/94
  N*remote free(32): 0=8/198 1=177/0 Average=92/99
  N*remote free(64): 0=8/197 1=210/0 Average=109/98
  N*remote free(128): 0=8/214 1=249/0 Average=129/107
  N*remote free(256): 0=8/273 1=267/0 Average=137/136
  N*remote free(512): 0=8/380 1=283/0 Average=145/190
  N*remote free(1024): 0=8/466 1=300/0 Average=154/233
  N*remote free(2048): 0=8/486 1=325/0 Average=166/243
  N*remote free(4096): 0=8/564 1=420/0 Average=214/282
  1 alloc N free test
  ===================
  1 alloc N free(8): 0=211 1=152 Average=181
  1 alloc N free(16): 0=217 1=155 Average=186
  1 alloc N free(32): 0=243 1=165 Average=204
  1 alloc N free(64): 0=352 1=233 Average=293
  1 alloc N free(128): 0=356 1=232 Average=294
  1 alloc N free(256): 0=448 1=296 Average=372
  1 alloc N free(512): 0=468 1=308 Average=388
  1 alloc N free(1024): 0=450 1=282 Average=366
  1 alloc N free(2048): 0=391 1=218 Average=305
  1 alloc N free(4096): 0=508 1=286 Average=397


SLUB 2.6.32-rc8 + GFP_ZERO fix:

  Single thread testing
  =====================
  1. Kmalloc: Repeatedly allocate then free test
  10000 times kmalloc(8) -> 114 cycles kfree -> 146 cycles
  10000 times kmalloc(16) -> 131 cycles kfree -> 161 cycles
  10000 times kmalloc(32) -> 139 cycles kfree -> 186 cycles
  10000 times kmalloc(64) -> 162 cycles kfree -> 168 cycles
  10000 times kmalloc(128) -> 193 cycles kfree -> 190 cycles
  10000 times kmalloc(256) -> 218 cycles kfree -> 246 cycles
  10000 times kmalloc(512) -> 254 cycles kfree -> 390 cycles
  10000 times kmalloc(1024) -> 276 cycles kfree -> 450 cycles
  10000 times kmalloc(2048) -> 284 cycles kfree -> 492 cycles
  10000 times kmalloc(4096) -> 406 cycles kfree -> 536 cycles
  10000 times kmalloc(8192) -> 495 cycles kfree -> 630 cycles
  10000 times kmalloc(16384) -> 797 cycles kfree -> 788 cycles
  2. Kmalloc: alloc/free test
  10000 times kmalloc(8)/kfree -> 197 cycles
  10000 times kmalloc(16)/kfree -> 224 cycles
  10000 times kmalloc(32)/kfree -> 199 cycles
  10000 times kmalloc(64)/kfree -> 199 cycles
  10000 times kmalloc(128)/kfree -> 199 cycles
  10000 times kmalloc(256)/kfree -> 199 cycles
  10000 times kmalloc(512)/kfree -> 199 cycles
  10000 times kmalloc(1024)/kfree -> 199 cycles
  10000 times kmalloc(2048)/kfree -> 178 cycles
  10000 times kmalloc(4096)/kfree -> 208 cycles
  10000 times kmalloc(8192)/kfree -> 233 cycles
  10000 times kmalloc(16384)/kfree -> 875 cycles
  Concurrent allocs
  =================
  Kmalloc N*alloc N*free(8): 0=157/182 1=157/178 Average=157/180
  Kmalloc N*alloc N*free(16): 0=161/188 1=161/184 Average=161/186
  Kmalloc N*alloc N*free(32): 0=173/194 1=174/192 Average=173/193
  Kmalloc N*alloc N*free(64): 0=201/212 1=197/211 Average=199/211
  Kmalloc N*alloc N*free(128): 0=233/281 1=233/283 Average=233/282
  Kmalloc N*alloc N*free(256): 0=279/446 1=283/447 Average=281/446
  Kmalloc N*alloc N*free(512): 0=374/565 1=372/570 Average=373/567
  Kmalloc N*alloc N*free(1024): 0=394/591 1=391/593 Average=393/592
  Kmalloc N*alloc N*free(2048): 0=407/621 1=404/629 Average=405/625
  Kmalloc N*alloc N*free(4096): 0=559/786 1=558/788 Average=559/787
  Kmalloc N*(alloc free)(8): 0=216 1=214 Average=215
  Kmalloc N*(alloc free)(16): 0=216 1=214 Average=215
  Kmalloc N*(alloc free)(32): 0=216 1=214 Average=215
  Kmalloc N*(alloc free)(64): 0=216 1=214 Average=215
  Kmalloc N*(alloc free)(128): 0=216 1=214 Average=215
  Kmalloc N*(alloc free)(256): 0=216 1=214 Average=215
  Kmalloc N*(alloc free)(512): 0=216 1=215 Average=216
  Kmalloc N*(alloc free)(1024): 0=217 1=215 Average=216
  Kmalloc N*(alloc free)(2048): 0=217 1=215 Average=216
  Kmalloc N*(alloc free)(4096): 0=217 1=215 Average=216
  Remote free test
  ================
  N*remote free(8): 0=8/188 1=156/0 Average=82/94
  N*remote free(16): 0=8/189 1=159/0 Average=84/94
  N*remote free(32): 0=8/191 1=171/0 Average=89/95
  N*remote free(64): 0=8/197 1=200/0 Average=104/98
  N*remote free(128): 0=8/214 1=243/0 Average=125/107
  N*remote free(256): 0=8/266 1=258/0 Average=133/133
  N*remote free(512): 0=8/379 1=274/0 Average=141/189
  N*remote free(1024): 0=8/443 1=291/0 Average=150/221
  N*remote free(2048): 0=8/472 1=318/0 Average=163/236
  N*remote free(4096): 0=8/546 1=416/0 Average=212/273
  1 alloc N free test
  ===================
  1 alloc N free(8): 0=208 1=149 Average=179
  1 alloc N free(16): 0=219 1=158 Average=189
  1 alloc N free(32): 0=241 1=165 Average=203
  1 alloc N free(64): 0=311 1=207 Average=259
  1 alloc N free(128): 0=350 1=226 Average=288
  1 alloc N free(256): 0=439 1=292 Average=366
  1 alloc N free(512): 0=470 1=314 Average=392
  1 alloc N free(1024): 0=361 1=203 Average=282
  1 alloc N free(2048): 0=385 1=216 Average=300
  1 alloc N free(4096): 0=492 1=278 Average=385
