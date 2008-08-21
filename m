Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYHUIKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYHUIKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYHUIKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:10:35 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:37198 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbYHUIKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=GJRPNm3Koql5P45T5enuxOOIbPNT+nPG9I7aa6YMmTJfOkb84FEkyps4but2sfyri9
         lORQbNUWut+e1ciYesRGuX1/VYUuJLAAqNhkC1ENBxSRPnTOXordGA9uEHGHSK7DzXVG
         cnXT8JTvZNLYBVm+Ol0IaD2e/Yvyh9tj9FdX0=
Message-ID: <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
Date: Thu, 21 Aug 2008 10:10:30 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "jay kumar" <jaykumarks@gmail.com>
Subject: Re: Bug: "bad unlock balance detected" 2.6.27-rc3-next-20080820
Cc: "David Howells" <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <6f31812b0808210004i63b3273ehf65ce9eb139256f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_47168_6489128.1219306230795"
References: <6f31812b0808210004i63b3273ehf65ce9eb139256f0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_47168_6489128.1219306230795
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Aug 21, 2008 at 9:04 AM, jay kumar <jaykumarks@gmail.com> wrote:
> While testing 2.6.27-rc3-next-20080820 ,  i observed this    "BUG:bad
> unlock balance detected" during boot time
>
> commit 765d4840cc9cca98c0cc4ff4764608780c3265f6
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Wed Aug 20 18:59:47 2008 +1000
>
>
> Bug info:
>
> [    0.140173] =====================================
> [    0.145977] [ BUG: bad unlock balance detected! ]
> [    0.145977] -------------------------------------
> [    0.145977] khelper/12 is trying to release lock (&p->cred_exec_mutex) at:
> [    0.146977] [<c05c624f>] mutex_unlock+0xd/0xf
> [    0.146977] but there are no more locks to release!
> [    0.146977]
> [    0.146977] other info that might help us debug this:
> [    0.146977] no locks held by khelper/12.
> [    0.146977]
> [    0.146977] stack backtrace:
> [    0.146977] Pid: 12, comm: khelper Not tainted 2.6.27-rc3-next-20080820 #13
> [    0.146977]  [<c05c624f>] ? mutex_unlock+0xd/0xf
> [    0.146977]  [<c0242944>] print_unlock_inbalance_bug+0xa5/0xb2
> [    0.146977]  [<c05c624f>] ? mutex_unlock+0xd/0xf
> [    0.146977]  [<c0245cd7>] lock_release+0x8f/0x186
> [    0.146977]  [<c05c61f0>] __mutex_unlock_slowpath+0x9b/0xed
> [    0.146977]  [<c05c624f>] mutex_unlock+0xd/0xf
> [    0.146977]  [<c029506f>] free_bprm+0x24/0x39
> [    0.146977]  [<c029644e>] do_execve+0x1e5/0x1fb
> [    0.146977]  [<c0202156>] sys_execve+0x2e/0x51
> [    0.146977]  [<c0203a72>] syscall_call+0x7/0xb
> [    0.146977]  [<c0206654>] ? kernel_execve+0x1c/0x21
> [    0.146977]  [<c023383c>] ? ____call_usermodehelper+0x0/0x129
> [    0.146977]  [<c023395b>] ? ____call_usermodehelper+0x11f/0x129
> [    0.146977]  [<c023383c>] ? ____call_usermodehelper+0x0/0x129
> [    0.146977]  [<c020466b>] ? kernel_thread_helper+0x7/0x10
> [    0.146977]  =======================

(config clipped)

Hi,

Thanks for the report. The error comes from

commit d9a939fb80ef390b78b3c801f668bd1e35ebc970
Author: David Howells <dhowells@redhat.com>
Date:   Thu Aug 7 20:02:20 2008 +1000

    CRED: Make execve() take advantage of copy-on-write credentials

(Added to Cc. I guess it's also nice to Cc linux-next on errors in -next code.)

I couldn't reproduce your original failure, but I've attempted to fix
it by reordering the mutex unlock and bprm free and removing the
extraneous unlock (see attached patch; it boots for me without
errors).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_47168_6489128.1219306230795
Content-Type: application/octet-stream; name=fix-execve.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk53bnzi0
Content-Disposition: attachment; filename=fix-execve.patch

ZGlmZiAtLWdpdCBhL2ZzL2V4ZWMuYyBiL2ZzL2V4ZWMuYwppbmRleCA0YjMxYTcyLi41OGRkYzk1
IDEwMDY0NAotLS0gYS9mcy9leGVjLmMKKysrIGIvZnMvZXhlYy5jCkBAIC0xMjc4LDcgKzEyNzgs
NiBAQCB2b2lkIGZyZWVfYnBybShzdHJ1Y3QgbGludXhfYmlucHJtICpicHJtKQogewogCWZyZWVf
YXJnX3BhZ2VzKGJwcm0pOwogCWlmIChicHJtLT5jcmVkKSB7Ci0JCW11dGV4X3VubG9jaygmY3Vy
cmVudC0+Y3JlZF9leGVjX211dGV4KTsKIAkJYWJvcnRfY3JlZHMoYnBybS0+Y3JlZCk7CiAJfQog
CWtmcmVlKGJwcm0pOwpAQCAtMTMwMSwyNSArMTMwMCwyNSBAQCBpbnQgZG9fZXhlY3ZlKGNoYXIg
KiBmaWxlbmFtZSwKIAlpZiAocmV0dmFsKQogCQlnb3RvIG91dF9yZXQ7CiAKKwlyZXR2YWwgPSBt
dXRleF9sb2NrX2ludGVycnVwdGlibGUoJmN1cnJlbnQtPmNyZWRfZXhlY19tdXRleCk7CisJaWYg
KHJldHZhbCA8IDApCisJCWdvdG8gb3V0X2ZpbGVzOworCiAJcmV0dmFsID0gLUVOT01FTTsKIAli
cHJtID0ga3phbGxvYyhzaXplb2YoKmJwcm0pLCBHRlBfS0VSTkVMKTsKIAlpZiAoIWJwcm0pCi0J
CWdvdG8gb3V0X2ZpbGVzOwotCi0JcmV0dmFsID0gbXV0ZXhfbG9ja19pbnRlcnJ1cHRpYmxlKCZj
dXJyZW50LT5jcmVkX2V4ZWNfbXV0ZXgpOwotCWlmIChyZXR2YWwgPCAwKQotCQlnb3RvIG91dF9m
cmVlOworCQlnb3RvIG91dF91bmxvY2s7CiAKIAlyZXR2YWwgPSAtRU5PTUVNOwogCWJwcm0tPmNy
ZWQgPSBwcmVwYXJlX2V4ZWNfY3JlZHMoKTsKIAlpZiAoIWJwcm0tPmNyZWQpCi0JCWdvdG8gb3V0
X3VubG9jazsKKwkJZ290byBvdXRfZnJlZTsKIAljaGVja191bnNhZmVfZXhlYyhicHJtKTsKIAog
CWZpbGUgPSBvcGVuX2V4ZWMoZmlsZW5hbWUpOwogCXJldHZhbCA9IFBUUl9FUlIoZmlsZSk7CiAJ
aWYgKElTX0VSUihmaWxlKSkKLQkJZ290byBvdXRfdW5sb2NrOworCQlnb3RvIG91dF9mcmVlOwog
CiAJc2NoZWRfZXhlYygpOwogCkBAIC0xMzYyLDYgKzEzNjEsNyBAQCBpbnQgZG9fZXhlY3ZlKGNo
YXIgKiBmaWxlbmFtZSwKIAkJLyogZXhlY3ZlIHN1Y2Nlc3MgKi8KIAkJYWNjdF91cGRhdGVfaW50
ZWdyYWxzKGN1cnJlbnQpOwogCQlmcmVlX2Jwcm0oYnBybSk7CisJCW11dGV4X3VubG9jaygmY3Vy
cmVudC0+Y3JlZF9leGVjX211dGV4KTsKIAkJaWYgKGRpc3BsYWNlZCkKIAkJCXB1dF9maWxlc19z
dHJ1Y3QoZGlzcGxhY2VkKTsKIAkJcmV0dXJuIHJldHZhbDsKQEAgLTEzNzcsMTIgKzEzNzcsMTIg
QEAgb3V0X2ZpbGU6CiAJCWZwdXQoYnBybS0+ZmlsZSk7CiAJfQogCi1vdXRfdW5sb2NrOgotCW11
dGV4X3VubG9jaygmY3VycmVudC0+Y3JlZF9leGVjX211dGV4KTsKLQogb3V0X2ZyZWU6CiAJZnJl
ZV9icHJtKGJwcm0pOwogCitvdXRfdW5sb2NrOgorCW11dGV4X3VubG9jaygmY3VycmVudC0+Y3Jl
ZF9leGVjX211dGV4KTsKKwogb3V0X2ZpbGVzOgogCWlmIChkaXNwbGFjZWQpCiAJCXJlc2V0X2Zp
bGVzX3N0cnVjdChkaXNwbGFjZWQpOwo=
------=_Part_47168_6489128.1219306230795--
