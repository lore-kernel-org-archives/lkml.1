Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbYEPFa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbYEPFa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYEPFaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:30:15 -0400
Received: from smtp2f.orange.fr ([80.12.242.152]:20554 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYEPFaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:30:13 -0400
X-ME-UUID: 20080516053011257.3ED257000418@mwinf2f27.orange.fr
Message-ID: <482D1BCE.3060501@cosmosbay.com>
Date: Fri, 16 May 2008 07:29:50 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
References: <482C9FC5.2070508@cosmosbay.com> <200805161009.12142.rusty@rustcorp.com.au>
In-Reply-To: <200805161009.12142.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------090503090203080108020901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090503090203080108020901
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Rusty Russell a =C3=A9crit :
> On Friday 16 May 2008 06:40:37 Eric Dumazet wrote:
>  =20
>> Current refcounting for modules (done if CONFIG_MODULE_UNLOAD=3Dy)
>> is using a lot of memory.
>>    =20
>
> Hi Eric,
>
>    I like this patch!  The plan was always to create a proper dynamic p=
er-cpu
> allocator which used the normal per-cpu offsets, but I think module ref=
counts
> are worthwhile as a special case.
>
>    Any chance I can ask you look at the issue of full dynamic per-cpu
> allocation?  The problem of allocating memory which is laid out precise=
ly
> as the original per-cpu alloc is vexing on NUMA, and probably requires
> reserving virtual address space and remapping into it, but the rewards
> would be maximally-efficient per-cpu accessors, and getting rid of that=

> boutique allocator in module.c.
>
>  =20
You mean using alloc_percpu() ? Problem is that current implementation=20
is expensive, since it is using
an extra array of pointers (struct percpu_data). On x86_64, that means=20
at least a 200% space increase
over the solution of using 4 bytes in the static percpu zone. We=20
probably can change this to dynamic
per-cpu as soon as Mike or Christopher finish their work on new dynamic=20
per-cpu implementation ?
> Only minor commentry on the patch itself:
>
>  =20
>> +#ifdef CONFIG_SMP
>> +       char *refptr;
>> +#else
>>    =20
>
> void * would seem more natural here (love those gcc'isms)
>
>  =20
Yes, sure.
>> +#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
>> +       void *refptr =3D NULL;
>> +#endif
>>    =20
>
> Looks like you can skip this if you assign to mod->refptr directly belo=
w:
>
>  =20
>> +#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
>> +       refptr =3D percpu_modalloc(sizeof(local_t), sizeof(local_t), m=
od->name);
>> +       if (!refptr)
>> +               goto free_mod;
>> +       mod->refptr =3D refptr;
>> +#endif
>>    =20
>
>  =20
Unfortunatly no. I tried it and failed.
This is the problem that at freeing time, we cannot anymore use mod->refp=
tr,
since we just unmaped mod, using vfree().
You had same problem with percpu, and had to use a temporaty variable on =

stack :)
> And finally:
>
>  =20
>> +#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
>> +       if (refptr)
>> +               percpu_modfree(refptr);
>> +#endif
>>    =20
>
> This if (refptr) seems redundant.
>
>  =20
Yes, thanks a lot. Please find an updated patch.
> Thanks!
> Rusty.
>
>
>  =20
[PATCH] modules: Use a better scheme for refcounting

Current refcounting for modules (done if CONFIG_MODULE_UNLOAD=3Dy)
is using a lot of memory (and disk space)

Each 'struct module' contains an [NR_CPUS] array of full cache lines.

This patch uses existing infrastructure (percpu_modalloc() &=20
percpu_modfree())
to allocate percpu space for the refcount storage.

Instead of wasting NR_CPUS*128 bytes (on i386), we now use
num_possible_cpus*sizeof(local_t) bytes.

On a typical distro, where NR_CPUS=3D8, shiping 2000 modules, we reduce
size of module files by about 2 Mbytes. (1Kb per module)

Instead of having all refcounters in the same memory node - with TLB miss=
es
because of vmalloc() - this new implementation permits to have better
NUMA properties, since each  CPU will use storage on its preferred node,
thanks to percpu storage.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/module.h |   25 +++++++++++++++---------
 kernel/module.c        |   40 +++++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 19 deletions(-)


--------------090503090203080108020901
Content-Type: text/plain;
 name="module.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="module.patch"

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW9kdWxlLmggYi9pbmNsdWRlL2xpbnV4L21v
ZHVsZS5oCmluZGV4IDNlMDNiMWEuLmRmZDM2ZWQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGlu
dXgvbW9kdWxlLmgKKysrIGIvaW5jbHVkZS9saW51eC9tb2R1bGUuaApAQCAtMjE3LDExICsy
MTcsNiBAQCB2b2lkICpfX3N5bWJvbF9nZXRfZ3BsKGNvbnN0IGNoYXIgKnN5bWJvbCk7CiAK
ICNlbmRpZgogCi1zdHJ1Y3QgbW9kdWxlX3JlZgotewotCWxvY2FsX3QgY291bnQ7Ci19IF9f
X19jYWNoZWxpbmVfYWxpZ25lZDsKLQogZW51bSBtb2R1bGVfc3RhdGUKIHsKIAlNT0RVTEVf
U1RBVEVfTElWRSwKQEAgLTMwNyw4ICszMDIsMTEgQEAgc3RydWN0IG1vZHVsZQogCiAjaWZk
ZWYgQ09ORklHX01PRFVMRV9VTkxPQUQKIAkvKiBSZWZlcmVuY2UgY291bnRzICovCi0Jc3Ry
dWN0IG1vZHVsZV9yZWYgcmVmW05SX0NQVVNdOwotCisjaWZkZWYgQ09ORklHX1NNUAorCXZv
aWQgKnJlZnB0cjsKKyNlbHNlCisJbG9jYWxfdCByZWY7CisjZW5kaWYKIAkvKiBXaGF0IG1v
ZHVsZXMgZGVwZW5kIG9uIG1lPyAqLwogCXN0cnVjdCBsaXN0X2hlYWQgbW9kdWxlc193aGlj
aF91c2VfbWU7CiAKQEAgLTM3OCwxMyArMzc2LDIyIEBAIHZvaWQgX19zeW1ib2xfcHV0KGNv
bnN0IGNoYXIgKnN5bWJvbCk7CiAjZGVmaW5lIHN5bWJvbF9wdXQoeCkgX19zeW1ib2xfcHV0
KE1PRFVMRV9TWU1CT0xfUFJFRklYICN4KQogdm9pZCBzeW1ib2xfcHV0X2FkZHIodm9pZCAq
YWRkcik7CiAKK3N0YXRpYyBpbmxpbmUgbG9jYWxfdCAqX19tb2R1bGVfcmVmX2FkZHIoc3Ry
dWN0IG1vZHVsZSAqbW9kLCBpbnQgY3B1KQoreworI2lmZGVmIENPTkZJR19TTVAKKwlyZXR1
cm4gKGxvY2FsX3QgKikgKG1vZC0+cmVmcHRyICsgcGVyX2NwdV9vZmZzZXQoY3B1KSk7Cisj
ZWxzZQorCXJldHVybiAmbW9kLT5yZWY7CisjZW5kaWYKK30KKwogLyogU29tZXRpbWVzIHdl
IGtub3cgd2UgYWxyZWFkeSBoYXZlIGEgcmVmY291bnQsIGFuZCBpdCdzIGVhc2llciBub3QK
ICAgIHRvIGhhbmRsZSB0aGUgZXJyb3IgY2FzZSAod2hpY2ggb25seSBoYXBwZW5zIHdpdGgg
cm1tb2QgLS13YWl0KS4gKi8KIHN0YXRpYyBpbmxpbmUgdm9pZCBfX21vZHVsZV9nZXQoc3Ry
dWN0IG1vZHVsZSAqbW9kdWxlKQogewogCWlmIChtb2R1bGUpIHsKIAkJQlVHX09OKG1vZHVs
ZV9yZWZjb3VudChtb2R1bGUpID09IDApOwotCQlsb2NhbF9pbmMoJm1vZHVsZS0+cmVmW2dl
dF9jcHUoKV0uY291bnQpOworCQlsb2NhbF9pbmMoX19tb2R1bGVfcmVmX2FkZHIobW9kdWxl
LCBnZXRfY3B1KCkpKTsKIAkJcHV0X2NwdSgpOwogCX0KIH0KQEAgLTM5Niw3ICs0MDMsNyBA
QCBzdGF0aWMgaW5saW5lIGludCB0cnlfbW9kdWxlX2dldChzdHJ1Y3QgbW9kdWxlICptb2R1
bGUpCiAJaWYgKG1vZHVsZSkgewogCQl1bnNpZ25lZCBpbnQgY3B1ID0gZ2V0X2NwdSgpOwog
CQlpZiAobGlrZWx5KG1vZHVsZV9pc19saXZlKG1vZHVsZSkpKQotCQkJbG9jYWxfaW5jKCZt
b2R1bGUtPnJlZltjcHVdLmNvdW50KTsKKwkJCWxvY2FsX2luYyhfX21vZHVsZV9yZWZfYWRk
cihtb2R1bGUsIGNwdSkpOwogCQllbHNlCiAJCQlyZXQgPSAwOwogCQlwdXRfY3B1KCk7CmRp
ZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxlLmMgYi9rZXJuZWwvbW9kdWxlLmMKaW5kZXggZjVl
OTQ5MS4uZTgyYjJkOSAxMDA2NDQKLS0tIGEva2VybmVsL21vZHVsZS5jCisrKyBiL2tlcm5l
bC9tb2R1bGUuYwpAQCAtNTIyLDEzICs1MjIsMTMgQEAgc3RhdGljIGNoYXIgbGFzdF91bmxv
YWRlZF9tb2R1bGVbTU9EVUxFX05BTUVfTEVOKzFdOwogLyogSW5pdCB0aGUgdW5sb2FkIHNl
Y3Rpb24gb2YgdGhlIG1vZHVsZS4gKi8KIHN0YXRpYyB2b2lkIG1vZHVsZV91bmxvYWRfaW5p
dChzdHJ1Y3QgbW9kdWxlICptb2QpCiB7Ci0JdW5zaWduZWQgaW50IGk7CisJaW50IGNwdTsK
IAogCUlOSVRfTElTVF9IRUFEKCZtb2QtPm1vZHVsZXNfd2hpY2hfdXNlX21lKTsKLQlmb3Ig
KGkgPSAwOyBpIDwgTlJfQ1BVUzsgaSsrKQotCQlsb2NhbF9zZXQoJm1vZC0+cmVmW2ldLmNv
dW50LCAwKTsKKwlmb3JfZWFjaF9wb3NzaWJsZV9jcHUoY3B1KQorCQlsb2NhbF9zZXQoX19t
b2R1bGVfcmVmX2FkZHIobW9kLCBjcHUpLCAwKTsKIAkvKiBIb2xkIHJlZmVyZW5jZSBjb3Vu
dCBkdXJpbmcgaW5pdGlhbGl6YXRpb24uICovCi0JbG9jYWxfc2V0KCZtb2QtPnJlZltyYXdf
c21wX3Byb2Nlc3Nvcl9pZCgpXS5jb3VudCwgMSk7CisJbG9jYWxfc2V0KF9fbW9kdWxlX3Jl
Zl9hZGRyKG1vZCwgcmF3X3NtcF9wcm9jZXNzb3JfaWQoKSksIDEpOwogCS8qIEJhY2t3YXJk
cyBjb21wYXRpYmlsaXR5IG1hY3JvcyBwdXQgcmVmY291bnQgZHVyaW5nIGluaXQuICovCiAJ
bW9kLT53YWl0ZXIgPSBjdXJyZW50OwogfQpAQCAtNjU5LDEwICs2NTksMTEgQEAgc3RhdGlj
IGludCB0cnlfc3RvcF9tb2R1bGUoc3RydWN0IG1vZHVsZSAqbW9kLCBpbnQgZmxhZ3MsIGlu
dCAqZm9yY2VkKQogCiB1bnNpZ25lZCBpbnQgbW9kdWxlX3JlZmNvdW50KHN0cnVjdCBtb2R1
bGUgKm1vZCkKIHsKLQl1bnNpZ25lZCBpbnQgaSwgdG90YWwgPSAwOworCXVuc2lnbmVkIGlu
dCB0b3RhbCA9IDA7CisJaW50IGNwdTsKIAotCWZvciAoaSA9IDA7IGkgPCBOUl9DUFVTOyBp
KyspCi0JCXRvdGFsICs9IGxvY2FsX3JlYWQoJm1vZC0+cmVmW2ldLmNvdW50KTsKKwlmb3Jf
ZWFjaF9wb3NzaWJsZV9jcHUoY3B1KQorCQl0b3RhbCArPSBsb2NhbF9yZWFkKF9fbW9kdWxl
X3JlZl9hZGRyKG1vZCwgY3B1KSk7CiAJcmV0dXJuIHRvdGFsOwogfQogRVhQT1JUX1NZTUJP
TChtb2R1bGVfcmVmY291bnQpOwpAQCAtODI0LDcgKzgyNSw3IEBAIHZvaWQgbW9kdWxlX3B1
dChzdHJ1Y3QgbW9kdWxlICptb2R1bGUpCiB7CiAJaWYgKG1vZHVsZSkgewogCQl1bnNpZ25l
ZCBpbnQgY3B1ID0gZ2V0X2NwdSgpOwotCQlsb2NhbF9kZWMoJm1vZHVsZS0+cmVmW2NwdV0u
Y291bnQpOworCQlsb2NhbF9kZWMoX19tb2R1bGVfcmVmX2FkZHIobW9kdWxlLCBjcHUpKTsK
IAkJLyogTWF5YmUgdGhleSdyZSB3YWl0aW5nIGZvciB1cyB0byBkcm9wIHJlZmVyZW5jZT8g
Ki8KIAkJaWYgKHVubGlrZWx5KCFtb2R1bGVfaXNfbGl2ZShtb2R1bGUpKSkKIAkJCXdha2Vf
dXBfcHJvY2Vzcyhtb2R1bGUtPndhaXRlcik7CkBAIC0xMzkyLDcgKzEzOTMsOSBAQCBzdGF0
aWMgdm9pZCBmcmVlX21vZHVsZShzdHJ1Y3QgbW9kdWxlICptb2QpCiAJa2ZyZWUobW9kLT5h
cmdzKTsKIAlpZiAobW9kLT5wZXJjcHUpCiAJCXBlcmNwdV9tb2RmcmVlKG1vZC0+cGVyY3B1
KTsKLQorI2lmIGRlZmluZWQoQ09ORklHX01PRFVMRV9VTkxPQUQpICYmIGRlZmluZWQoQ09O
RklHX1NNUCkKKwlwZXJjcHVfbW9kZnJlZShtb2QtPnJlZnB0cik7CisjZW5kaWYKIAkvKiBG
cmVlIGxvY2stY2xhc3NlczogKi8KIAlsb2NrZGVwX2ZyZWVfa2V5X3JhbmdlKG1vZC0+bW9k
dWxlX2NvcmUsIG1vZC0+Y29yZV9zaXplKTsKIApAQCAtMTc2MCw2ICsxNzYzLDkgQEAgc3Rh
dGljIHN0cnVjdCBtb2R1bGUgKmxvYWRfbW9kdWxlKHZvaWQgX191c2VyICp1bW9kLAogCXVu
c2lnbmVkIGludCBtYXJrZXJzc3RyaW5nc2luZGV4OwogCXN0cnVjdCBtb2R1bGUgKm1vZDsK
IAlsb25nIGVyciA9IDA7CisjaWYgZGVmaW5lZChDT05GSUdfTU9EVUxFX1VOTE9BRCkgJiYg
ZGVmaW5lZChDT05GSUdfU01QKQorCXZvaWQgKnJlZnB0ciA9IE5VTEw7CisjZW5kaWYKIAl2
b2lkICpwZXJjcHUgPSBOVUxMLCAqcHRyID0gTlVMTDsgLyogU3RvcHMgc3B1cmlvdXMgZ2Nj
IHdhcm5pbmcgKi8KIAlzdHJ1Y3QgZXhjZXB0aW9uX3RhYmxlX2VudHJ5ICpleHRhYmxlOwog
CW1tX3NlZ21lbnRfdCBvbGRfZnM7CkBAIC0xOTA0LDYgKzE5MTAsMTYgQEAgc3RhdGljIHN0
cnVjdCBtb2R1bGUgKmxvYWRfbW9kdWxlKHZvaWQgX191c2VyICp1bW9kLAogCWlmIChlcnIg
PCAwKQogCQlnb3RvIGZyZWVfbW9kOwogCisjaWYgZGVmaW5lZChDT05GSUdfTU9EVUxFX1VO
TE9BRCkgJiYgZGVmaW5lZChDT05GSUdfU01QKQorCXJlZnB0ciA9IHBlcmNwdV9tb2RhbGxv
YyhzaXplb2YobG9jYWxfdCksCisJCQkJIHNpemVvZihsb2NhbF90KSwKKwkJCQkgbW9kLT5u
YW1lKTsKKwlpZiAoIXJlZnB0cikgeworCQllcnIgPSAtRU5PTUVNOworCQlnb3RvIGZyZWVf
bW9kOworCX0KKwltb2QtPnJlZnB0ciA9IHJlZnB0cjsKKyNlbmRpZgogCWlmIChwY3B1aW5k
ZXgpIHsKIAkJLyogV2UgaGF2ZSBhIHNwZWNpYWwgYWxsb2NhdGlvbiBmb3IgdGhpcyBzZWN0
aW9uLiAqLwogCQlwZXJjcHUgPSBwZXJjcHVfbW9kYWxsb2Moc2VjaGRyc1twY3B1aW5kZXhd
LnNoX3NpemUsCkBAIC0xOTExLDcgKzE5MjcsNyBAQCBzdGF0aWMgc3RydWN0IG1vZHVsZSAq
bG9hZF9tb2R1bGUodm9pZCBfX3VzZXIgKnVtb2QsCiAJCQkJCSBtb2QtPm5hbWUpOwogCQlp
ZiAoIXBlcmNwdSkgewogCQkJZXJyID0gLUVOT01FTTsKLQkJCWdvdG8gZnJlZV9tb2Q7CisJ
CQlnb3RvIGZyZWVfcmVmcHRyOwogCQl9CiAJCXNlY2hkcnNbcGNwdWluZGV4XS5zaF9mbGFn
cyAmPSB+KHVuc2lnbmVkIGxvbmcpU0hGX0FMTE9DOwogCQltb2QtPnBlcmNwdSA9IHBlcmNw
dTsKQEAgLTIxNjQsNiArMjE4MCwxMCBAQCBzdGF0aWMgc3RydWN0IG1vZHVsZSAqbG9hZF9t
b2R1bGUodm9pZCBfX3VzZXIgKnVtb2QsCiAgZnJlZV9wZXJjcHU6CiAJaWYgKHBlcmNwdSkK
IAkJcGVyY3B1X21vZGZyZWUocGVyY3B1KTsKKyBmcmVlX3JlZnB0cjoKKyNpZiBkZWZpbmVk
KENPTkZJR19NT0RVTEVfVU5MT0FEKSAmJiBkZWZpbmVkKENPTkZJR19TTVApCisJcGVyY3B1
X21vZGZyZWUocmVmcHRyKTsKKyNlbmRpZgogIGZyZWVfbW9kOgogCWtmcmVlKGFyZ3MpOwog
IGZyZWVfaGRyOgo=
--------------090503090203080108020901--


