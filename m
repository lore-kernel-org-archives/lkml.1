Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbYEUWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbYEUWlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbYEUWlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:41:01 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:6268 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbYEUWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=gevpaaiQXAU6SN4bizLXgPhh/LZQjV4l7uD1cKh8d/irx9z2Iz9BaP7alE8G0RsNwRyEcgfOUwXBpziTlVaXR9dCI4DUi93Bic+mZb5YtzCeRAtT8i73lkAQ9eWYbh5q/fL9E9Wek2oO+lIWaN7wwqZO82+WTQBiC/A0HihVlgc=
Message-ID: <86802c440805211540m4ff68aeh827a1f823305742b@mail.gmail.com>
Date: Wed, 21 May 2008 15:40:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Suspected regression in "x86: extend e820 ealy_res support 32bit"
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48349B9D.1000501@goop.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9515_5778254.1211409657053"
References: <483467CD.90401@goop.org>
	 <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
	 <48349B9D.1000501@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9515_5778254.1211409657053
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, May 21, 2008 at 3:01 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> On Wed, May 21, 2008 at 11:19 AM, Jeremy Fitzhardinge <jeremy@goop.org>
>> wrote:
>>
>>>
>>> I'm seeing a crash in current x86.git tip/auto-latest when booting under
>>> Xen.  The crash is rather early, but it's in __alloc_bootmem_core() in
>>> the
>>> final memset clear.  Apparently the allocator is returning a bad page.
>>>
>>> This points to changes in the setup of the bootmem allocator, and the
>>> changes "x86: extend e820 ealy_res support 32bit" make to
>>> arch/x86/kernel/setup_32.c:setup_bootmem_allocator() looks like the most
>>> likely suspect.  Unfortunately its a rather large patch which is not easy
>>> to
>>> revert, so I haven't actually confirmed this yet.
>>>
>>
>>
>> thanks. please check the attached patch
>>
>
> Thanks for the quick response.  I definitely confirmed that "x86: extend
> e820 ealy_res support 32bit" is the source of the regression, and reverting
> the change makes the system bootable under Xen. (My previous reversion
> failed because I didn't actually have the x86.git changes applied :-/)
>
> This patch generates the warning:
>
>     CC      arch/x86/kernel/setup_32.o
>   /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/setup_32.c: In
>   function 'setup_arch':
>   /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/setup_32.c:580:
>   warning: 'bootmap_size' is used uninitialized in this function
>
> but I think it's just that the panic() message still uses it before its
> assigned.
>
> Hm, and it also fails to fix the problem.  I'm still seeing the virtual
> machine crash in the same way.

noticed that bootmap_size is shifted already...

please use attached patch to see if bootmap is right...

YH

------=_Part_9515_5778254.1211409657053
Content-Type: text/x-patch; name=bootmap_32_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgihz44z0
Content-Disposition: attachment; filename=bootmap_32_fix.patch

W1BBVENIXSB4ODY6IGJvb3RtYXAgc2l6ZSBmaXggZm9yIDMyIGJpdAoKSmVyZW15IEZpdHpoYXJk
aW5nZSBmb3VuZAp4ODY6IGV4dGVuZCBlODIwIGVhbHlfcmVzIHN1cHBvcnQgMzJiaXQKY2F1c2Ug
cmVncmVzc2lvbi4uLgoKaW4gc2V0dXBfYm9vdG1lbV9hbGxvY2F0b3IKClNpZ25lZC1vZmYtYnk6
IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCkluZGV4OiBsaW51eC0yLjYvYXJj
aC94ODYva2VybmVsL3NldHVwXzMyLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJj
aC94ODYva2VybmVsL3NldHVwXzMyLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0
dXBfMzIuYwpAQCAtNTc3LDYgKzU3Nyw4IEBAIHZvaWQgX19pbml0IHNldHVwX2Jvb3RtZW1fYWxs
b2NhdG9yKHZvaWQKIAlpZiAoYm9vdG1hcCA9PSAtMUwpCiAJCXBhbmljKCJDYW5ub3QgZmluZCBi
b290bWVtIG1hcCBvZiBzaXplICVsZFxuIiwgYm9vdG1hcF9zaXplKTsKIAlib290bWFwX3NpemUg
PSBpbml0X2Jvb3RtZW0oYm9vdG1hcCA+PiBQQUdFX1NISUZULCBtYXhfbG93X3Bmbik7CisJcHJp
bnRrKEtFUk5fSU5GTyAiICBib290bWFwIFslMDE2bHggLSAgJTAxNmx4XSBtaW5fbG93X3Bmbjog
JTAxNnhcbiIsCisJCSBib290bWFwLCBib290bWFwICsgYm9vdG1hcF9zaXplIC0gMSwgbWluX2xv
d19wZm4pOwogCXJlZ2lzdGVyX2Jvb3RtZW1fbG93X3BhZ2VzKG1heF9sb3dfcGZuKTsKIAllYXJs
eV9yZXNfdG9fYm9vdG1lbSgwLCBtYXhfbG93X3Bmbjw8UEFHRV9TSElGVCk7CiAJcmVzZXJ2ZV9i
b290bWVtKGJvb3RtYXAsIGJvb3RtYXBfc2l6ZSwgQk9PVE1FTV9ERUZBVUxUKTsK
------=_Part_9515_5778254.1211409657053--
