Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYCKGXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYCKGXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYCKGXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:23:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:50802 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYCKGXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=w7yyEkRE/GdlJGzwufkK9ITo/LNTTUSjQUSJvpx8FTJLGsxJ7Sc0p7BzeGj0u/ZSe9pojZ2aZoesVFcX2d8Nb2EP7EN8fie0GvRAYjXTkRYeIQaAUCGoI4wt38GzyCO4j9GU/o4MvifeuoS4S2y9/Y6q5sudC1uZo4jOQiFn7SY=
Message-ID: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
Date: Mon, 10 Mar 2008 23:22:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH] mm: make mem_map allocation continuous.
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_556_20145663.1205216592516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_556_20145663.1205216592516
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] mm: make mem_map allocation continuous.

vmemmap allocation current got
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002000000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002400000 on node 0
...

there is 2M hole between them.

the rootcause is that usemap (24 bytes) will be allocated after every 2M
mem_map. and it will push next vmemmap (2M) to next align (2M).

solution:
try to allocate mem_map continously.

after patch, will get
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
...
and usemap will share in page because of they are allocated continuously too.
sparse_early_usemap_alloc: usemap = ffff810024e00000 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00080 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00100 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00180 size = 24
...

so we make the bootmem allocation more compact and use less memory for usemap.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_556_20145663.1205216592516
Content-Type: text/x-patch; name=vmemmap_1.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdo2qfsp0
Content-Disposition: attachment; filename=vmemmap_1.patch

CkluZGV4OiBsaW51eC0yLjYvbW0vc3BhcnNlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvbW0vc3BhcnNlLmMKKysrIGxpbnV4LTIuNi9tbS9zcGFyc2UuYwpAQCAtMjQ0LDYgKzI0NCw3
IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nICpfX2luaXQgc3BhcnNlX2VhcmwKIAlpbnQgbmlkID0g
c3BhcnNlX2Vhcmx5X25pZChtcyk7CiAKIAl1c2VtYXAgPSBhbGxvY19ib290bWVtX25vZGUoTk9E
RV9EQVRBKG5pZCksIHVzZW1hcF9zaXplKCkpOworCXByaW50ayhLRVJOX0lORk8gInNwYXJzZV9l
YXJseV91c2VtYXBfYWxsb2M6IHVzZW1hcCA9ICVwIHNpemUgPSAlbGRcbiIsIHVzZW1hcCwgdXNl
bWFwX3NpemUoKSk7CiAJaWYgKHVzZW1hcCkKIAkJcmV0dXJuIHVzZW1hcDsKIApAQCAtMjg1LDYg
KzI4Niw4IEBAIHN0cnVjdCBwYWdlIF9faW5pdCAqc3BhcnNlX2Vhcmx5X21lbV9tYXAKIAlyZXR1
cm4gTlVMTDsKIH0KIAorLyogc2VjdGlvbl9tYXAgcG9pbnRlciBhcnJheSBpcyA2NGsgKi8KK3N0
YXRpYyBfX2luaXRkYXRhIHN0cnVjdCBwYWdlICpzZWN0aW9uX21hcFtOUl9NRU1fU0VDVElPTlNd
OwogLyoKICAqIEFsbG9jYXRlIHRoZSBhY2N1bXVsYXRlZCBub24tbGluZWFyIHNlY3Rpb25zLCBh
bGxvY2F0ZSBhIG1lbV9tYXAKICAqIGZvciBlYWNoIGFuZCByZWNvcmQgdGhlIHBoeXNpY2FsIHRv
IHNlY3Rpb24gbWFwcGluZy4KQEAgLTI5NSwxNCArMjk4LDI5IEBAIHZvaWQgX19pbml0IHNwYXJz
ZV9pbml0KHZvaWQpCiAJc3RydWN0IHBhZ2UgKm1hcDsKIAl1bnNpZ25lZCBsb25nICp1c2VtYXA7
CiAKKwkvKgorCSAqIG1hcCBpcyB1c2luZyBiaWcgcGFnZSAoYWthIDJNIGluIHg4NiA2NCBiaXQp
CisJICogdXNlbWFwIGlzIGxlc3Mgb25lIHBhZ2UgKGFrYSAyNCBieXRlcykKKwkgKiBzbyBhbGxv
YyAyTSAod2l0aCAyTSBhbGlnbikgYW5kIDI0IGJ5dGVzIGluIHR1cm4gd2lsbAorCSAqIG1ha2Ug
bmV4dCAyTSBzbGlwIHRvIG9uZSBtb3JlIDJNIGxhdGVyLgorCSAqIHRoZW4gaW4gYmlnIHN5c3Rl
bSwgdGhlIG1lbW1vcnkgd2lsbCBoYXZlIGEgbG90IGhvbGUuLi4KKwkgKiBoZXJlIHRyeSB0byBh
bGxvY2F0ZSAyTSBwYWdlcyBjb250aW5vdXNseS4KKwkgKi8KIAlmb3IgKHBudW0gPSAwOyBwbnVt
IDwgTlJfTUVNX1NFQ1RJT05TOyBwbnVtKyspIHsKIAkJaWYgKCFwcmVzZW50X3NlY3Rpb25fbnIo
cG51bSkpCiAJCQljb250aW51ZTsKKwkJc2VjdGlvbl9tYXBbcG51bV0gPSBzcGFyc2VfZWFybHlf
bWVtX21hcF9hbGxvYyhwbnVtKTsKKwl9CiAKLQkJbWFwID0gc3BhcnNlX2Vhcmx5X21lbV9tYXBf
YWxsb2MocG51bSk7Ci0JCWlmICghbWFwKQorCisJZm9yIChwbnVtID0gMDsgcG51bSA8IE5SX01F
TV9TRUNUSU9OUzsgcG51bSsrKSB7CisJCWlmICghcHJlc2VudF9zZWN0aW9uX25yKHBudW0pKQog
CQkJY29udGludWU7CiAKKwkJbWFwID0gc2VjdGlvbl9tYXBbcG51bV07CisJCWlmICghbWFwKQor
CQkJIGNvbnRpbnVlOworCiAJCXVzZW1hcCA9IHNwYXJzZV9lYXJseV91c2VtYXBfYWxsb2MocG51
bSk7CiAJCWlmICghdXNlbWFwKQogCQkJY29udGludWU7Cg==
------=_Part_556_20145663.1205216592516--
