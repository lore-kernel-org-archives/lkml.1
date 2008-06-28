Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYF1WRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYF1WRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 18:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYF1WQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 18:16:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:15986 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYF1WQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 18:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=qTHDx1LpQLXJyvrYdjaHbXodljhbcrcu/kFIGuVlKVsvGoQZDGhHnvLnW2MsdGrljy
         0E5PnV4xXf/3Fmh7zL3QbMXPDHBsX0p87SQec5UBR7dfhEEDHQUbZRzR0sChLb2+1I9H
         Ghwr6L0NYeZl2GKDLto0r+eLJWGSh3XyulaRk=
Message-ID: <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
Date: Sun, 29 Jun 2008 00:16:56 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] CFS vs cpu hotplug
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Avi Kivity" <avi@qumranet.com>, linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12082_18711558.1214691416233"
References: <20080619161949.GA11062@osiris.ibm.com>
	 <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12082_18711558.1214691416233
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,


it seems to be related to migrate_dead_tasks().

Firstly I added traces to see all tasks being migrated with
migrate_live_tasks() and migrate_dead_tasks(). On my setup the problem
pops up (the one with "se == NULL" in the loop of
pick_next_task_fair()) shortly after the traces indicate that some has
been migrated with migrate_dead_tasks()). btw., I can reproduce it
much faster now with just a plain cpu down/up loop.

[disclaimer] Well, unless I'm really missing something important in
this late hour [/desclaimer] pick_next_task() is not something
appropriate for migrate_dead_tasks() :-)

the following change seems to eliminate the problem on my setup
(although, I kept it running only for a few minutes to get a few
messages indicating migrate_dead_tasks() does move tasks and the
system is still ok)

[ quick hack ]

@@ -5887,6 +5907,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
                next = pick_next_task(rq, rq->curr);
                if (!next)
                        break;
+               next->sched_class->put_prev_task(rq, next);
                migrate_dead(dead_cpu, next);

        }

just in case, all the changes I've used for this test are attached "as is".

p.s. perhaps I won't be able to verify it carefully till tomorrow's
late evening.


-- 
Best regards,
Dmitry Adamushko

------=_Part_12082_18711558.1214691416233
Content-Type: text/x-diff; name=migration-experiment.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi0rskq50
Content-Disposition: attachment; filename=migration-experiment.patch

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jcHUuYyBiL2tlcm5lbC9jcHUuYwppbmRleCBjNzdiYzNhLi5k
YjkyYzAxIDEwMDY0NAotLS0gYS9rZXJuZWwvY3B1LmMKKysrIGIva2VybmVsL2NwdS5jCkBAIC0x
NSw2ICsxNSw4IEBACiAjaW5jbHVkZSA8bGludXgvc3RvcF9tYWNoaW5lLmg+CiAjaW5jbHVkZSA8
bGludXgvbXV0ZXguaD4KIAorZXh0ZXJuIGludCBzY2hlZF9jaGVja19vZmZsaW5lX2NwdShpbnQg
Y3B1KTsKKwogLyogU2VyaWFsaXplcyB0aGUgdXBkYXRlcyB0byBjcHVfb25saW5lX21hcCwgY3B1
X3ByZXNlbnRfbWFwICovCiBzdGF0aWMgREVGSU5FX01VVEVYKGNwdV9hZGRfcmVtb3ZlX2xvY2sp
OwogCkBAIC0yNDcsNyArMjQ5LDcgQEAgc3RhdGljIGludCBfX3JlZiBfY3B1X2Rvd24odW5zaWdu
ZWQgaW50IGNwdSwgaW50IHRhc2tzX2Zyb3plbikKIAogCS8qIFRoaXMgYWN0dWFsbHkga2lsbHMg
dGhlIENQVS4gKi8KIAlfX2NwdV9kaWUoY3B1KTsKLQorCQogCS8qIENQVSBpcyBjb21wbGV0ZWx5
IGRlYWQ6IHRlbGwgZXZlcnlvbmUuICBUb28gbGF0ZSB0byBjb21wbGFpbi4gKi8KIAlpZiAocmF3
X25vdGlmaWVyX2NhbGxfY2hhaW4oJmNwdV9jaGFpbiwgQ1BVX0RFQUQgfCBtb2QsCiAJCQkJICAg
IGhjcHUpID09IE5PVElGWV9CQUQpCkBAIC0yNTUsNiArMjU3LDggQEAgc3RhdGljIGludCBfX3Jl
ZiBfY3B1X2Rvd24odW5zaWduZWQgaW50IGNwdSwgaW50IHRhc2tzX2Zyb3plbikKIAogCWNoZWNr
X2Zvcl90YXNrcyhjcHUpOwogCisJc2NoZWRfY2hlY2tfb2ZmbGluZV9jcHUoY3B1KTsKKwogb3V0
X3RocmVhZDoKIAllcnIgPSBrdGhyZWFkX3N0b3AocCk7CiBvdXRfYWxsb3dlZDoKQEAgLTI4OSw2
ICsyOTMsMTEgQEAgc3RhdGljIGludCBfX2NwdWluaXQgX2NwdV91cCh1bnNpZ25lZCBpbnQgY3B1
LCBpbnQgdGFza3NfZnJvemVuKQogCWlmIChjcHVfb25saW5lKGNwdSkgfHwgIWNwdV9wcmVzZW50
KGNwdSkpCiAJCXJldHVybiAtRUlOVkFMOwogCisJcHJpbnRrKCJjcHVfdXA6XG4iKTsKKwlyZXQg
PSBzY2hlZF9jaGVja19vZmZsaW5lX2NwdShjcHUpOworCWlmIChyZXQpCisJCXJldHVybiAtRUlO
VkFMOworCiAJY3B1X2hvdHBsdWdfYmVnaW4oKTsKIAlyZXQgPSBfX3Jhd19ub3RpZmllcl9jYWxs
X2NoYWluKCZjcHVfY2hhaW4sIENQVV9VUF9QUkVQQVJFIHwgbW9kLCBoY3B1LAogCQkJCQkJCS0x
LCAmbnJfY2FsbHMpOwpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkLmMgYi9rZXJuZWwvc2NoZWQu
YwppbmRleCAzYWFhNWM4Li5mMjBmZTFjIDEwMDY0NAotLS0gYS9rZXJuZWwvc2NoZWQuYworKysg
Yi9rZXJuZWwvc2NoZWQuYwpAQCAtNDEzNSw2ICs0MTM1LDIyIEBAIHBpY2tfbmV4dF90YXNrKHN0
cnVjdCBycSAqcnEsIHN0cnVjdCB0YXNrX3N0cnVjdCAqcHJldikKIAl9CiB9CiAKK2ludCBzY2hl
ZF9jaGVja19vZmZsaW5lX2NwdShpbnQgY3B1KQoreworCXN0cnVjdCB0YXNrX2dyb3VwICp0Z2k7
CisJaW50IHJldDsKKworCXJldCA9IGNoZWNrX2Nmc190cmVlKCZjcHVfcnEoY3B1KS0+Y2ZzKTsK
KworCXJjdV9yZWFkX2xvY2soKTsKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3JjdSh0Z2ksICZ0YXNr
X2dyb3VwcywgbGlzdCkgeworCQlyZXQgKz0gY2hlY2tfY2ZzX3RyZWUodGdpLT5jZnNfcnFbY3B1
XSk7CisJfQorCXJjdV9yZWFkX3VubG9jaygpOworCisJcmV0dXJuIHJldDsKK30KKwogLyoKICAq
IHNjaGVkdWxlKCkgaXMgdGhlIG1haW4gc2NoZWR1bGVyIGZ1bmN0aW9uLgogICovCkBAIC01NzEy
LDYgKzU3MjgsOSBAQCBzdGF0aWMgaW50IF9fbWlncmF0ZV90YXNrX2lycShzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnAsIGludCBzcmNfY3B1LCBpbnQgZGVzdF9jcHUpCiAJbG9jYWxfaXJxX2Rpc2FibGUo
KTsKIAlyZXQgPSBfX21pZ3JhdGVfdGFzayhwLCBzcmNfY3B1LCBkZXN0X2NwdSk7CiAJbG9jYWxf
aXJxX2VuYWJsZSgpOworCisJcHJpbnRrKEtFUk5fRVJSICJfX21pZ3JhdGUoJWQgLS0gJXMpIC0+
IGNwdSAoJWQpID09IHJldCAoJWQpXG4iLAorCQlwLT5waWQsIHAtPmNvbW0sIGRlc3RfY3B1LCBy
ZXQpOwogCXJldHVybiByZXQ7CiB9CiAKQEAgLTU4NjgsNiArNTg4Nyw3IEBAIHN0YXRpYyB2b2lk
IG1pZ3JhdGVfZGVhZCh1bnNpZ25lZCBpbnQgZGVhZF9jcHUsIHN0cnVjdCB0YXNrX3N0cnVjdCAq
cCkKIAkgKiBmaW5lLgogCSAqLwogCXNwaW5fdW5sb2NrX2lycSgmcnEtPmxvY2spOworCXByaW50
ayhLRVJOX0VSUiAiLS0tPiBtaWdyYXRlX2RlYWQoJWQgLS0gJXMpXG4iLCBwLT5waWQsIHAtPmNv
bW0pOwogCW1vdmVfdGFza19vZmZfZGVhZF9jcHUoZGVhZF9jcHUsIHApOwogCXNwaW5fbG9ja19p
cnEoJnJxLT5sb2NrKTsKIApAQCAtNTg4Nyw2ICs1OTA3LDcgQEAgc3RhdGljIHZvaWQgbWlncmF0
ZV9kZWFkX3Rhc2tzKHVuc2lnbmVkIGludCBkZWFkX2NwdSkKIAkJbmV4dCA9IHBpY2tfbmV4dF90
YXNrKHJxLCBycS0+Y3Vycik7CiAJCWlmICghbmV4dCkKIAkJCWJyZWFrOworCQluZXh0LT5zY2hl
ZF9jbGFzcy0+cHV0X3ByZXZfdGFzayhycSwgbmV4dCk7CiAJCW1pZ3JhdGVfZGVhZChkZWFkX2Nw
dSwgbmV4dCk7CiAKIAl9CmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWRfZmFpci5jIGIva2VybmVs
L3NjaGVkX2ZhaXIuYwppbmRleCBiZTE2ZGZjLi42ZDk2ODkwIDEwMDY0NAotLS0gYS9rZXJuZWwv
c2NoZWRfZmFpci5jCisrKyBiL2tlcm5lbC9zY2hlZF9mYWlyLmMKQEAgLTEyMzUsMTAgKzEyMzUs
MTMgQEAgc3RhdGljIHN0cnVjdCB0YXNrX3N0cnVjdCAqcGlja19uZXh0X3Rhc2tfZmFpcihzdHJ1
Y3QgcnEgKnJxKQogCWRvIHsKIAkJc2UgPSBwaWNrX25leHRfZW50aXR5KGNmc19ycSk7CiAKLQkJ
aWYgKHVubGlrZWx5KCFzZSkpCisJCWlmICh1bmxpa2VseSghc2UpKSB7CiAJCQlwcmludGsoS0VS
Tl9FUlIgIkJVRzogc2UgPT0gTlVMTCBidXQgbnJfcnVubmluZyAoJWxkKSwgbG9hZCAoJWxkKSwi
CiAJCQkJCSIgcnEtbnJfcnVubmluZyAoJWxkKSwgcnEtbG9hZCAoJWxkKVxuIiwKIAkJCQljZnNf
cnEtPm5yX3J1bm5pbmcsIGNmc19ycS0+bG9hZC53ZWlnaHQsIHJxLT5ucl9ydW5uaW5nLCBycS0+
bG9hZC53ZWlnaHQpOworLy8JCQlCVUcoKTsKKwkJCXJldHVybiBOVUxMOworCQl9CiAKIAkJY2Zz
X3JxID0gZ3JvdXBfY2ZzX3JxKHNlKTsKIAl9IHdoaWxlIChjZnNfcnEpOwpAQCAtMTMxNSw2ICsx
MzE4LDQxIEBAIHN0YXRpYyBzdHJ1Y3QgdGFza19zdHJ1Y3QgKmxvYWRfYmFsYW5jZV9uZXh0X2Zh
aXIodm9pZCAqYXJnKQogCXJldHVybiBfX2xvYWRfYmFsYW5jZV9pdGVyYXRvcihjZnNfcnEsIGNm
c19ycS0+YmFsYW5jZV9pdGVyYXRvcik7CiB9CiAKK3N0YXRpYyBpbnQgY2hlY2tfY2ZzX3RyZWUo
c3RydWN0IGNmc19ycSAqY2ZzX3JxKQoreworCXN0cnVjdCBsaXN0X2hlYWQgKm5leHQgPSBjZnNf
cnEtPnRhc2tzLm5leHQ7CisJc3RydWN0IHNjaGVkX2VudGl0eSAqc2U7CisJc3RydWN0IHRhc2tf
c3RydWN0ICpwOworCWludCByZXQgPSAwOworCisJaWYgKG5leHQgPT0gJmNmc19ycS0+dGFza3Mp
CisJCXJldHVybiByZXQ7CisKKwlkbyB7CisJCXNlID0gbGlzdF9lbnRyeShuZXh0LCBzdHJ1Y3Qg
c2NoZWRfZW50aXR5LCBncm91cF9ub2RlKTsKKworCQlpZiAoZW50aXR5X2lzX3Rhc2soc2UpKSB7
CisJCQlwID0gdGFza19vZihzZSk7CisKKwkJCXByaW50aygiKiBFUlJPUjogKHRhc2spICVkIC0g
JXNcbiIsIHAtPnBpZCwgcC0+Y29tbSk7CisJCQlyZXQgPSAxOworCQl9IGVsc2UgeworCQkJc3Ry
dWN0IGNmc19ycSAqY2ZzX3JxX2NoaWxkID0gZ3JvdXBfY2ZzX3JxKHNlKTsKKworCQkJaWYgKGNm
c19ycV9jaGlsZC0+bnJfcnVubmluZyB8fCBjZnNfcnFfY2hpbGQtPmxvYWQud2VpZ2h0KSB7CisJ
CQkJcHJpbnRrKCIqIEVSUk9SOiAoZ3JvdXApICVsZCAtICVsZFxuIiwKKwkJCQkJY2ZzX3JxX2No
aWxkLT5ucl9ydW5uaW5nLCBjZnNfcnFfY2hpbGQtPmxvYWQud2VpZ2h0KTsKKwkJCQljaGVja19j
ZnNfdHJlZShjZnNfcnFfY2hpbGQpOworCQkJCXJldCA9IDE7CisJCQl9CisJCX0KKworCQluZXh0
ID0gbmV4dC0+bmV4dDsKKwl9IHdoaWxlIChuZXh0ICE9ICZjZnNfcnEtPnRhc2tzKTsKKworCXJl
dHVybiByZXQ7Cit9CisKICNpZmRlZiBDT05GSUdfRkFJUl9HUk9VUF9TQ0hFRAogc3RhdGljIGlu
dCBjZnNfcnFfYmVzdF9wcmlvKHN0cnVjdCBjZnNfcnEgKmNmc19ycSkKIHsK
------=_Part_12082_18711558.1214691416233--
