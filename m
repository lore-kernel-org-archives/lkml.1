Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZIFG4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZIFG4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 02:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZIFG4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 02:56:18 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:60828 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZIFG4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 02:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AEYp/R8MO1tTSDTqUsjqyQgWF1GnHGn/G2U2BkBTYzquCyeGJF6kMLhdrm3WlOFvoc
         3Jbufb1MbjiTzgbPKmW7OnsnPhWgY/Wot9rDl7dAmtoydQYWjwhSwKAFTuMwjkDYW462
         NBsb5kDKJxjMNMDxAq7GoK7CAc3nFT6gQNtdw=
MIME-Version: 1.0
In-Reply-To: <20090824182713.GB9785@elte.hu>
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils>
	 <4A92D029.8090807@kernel.org> <20090824182713.GB9785@elte.hu>
Date: Sat, 5 Sep 2009 23:56:18 -0700
Message-ID: <86802c440909052356nf1b93a2mfe3ef0f04825e843@mail.gmail.com>
Subject: Re: linux-next: reservetop fix disables mem=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Xiao Guangrong <xiaooguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174a094eea8cfb0472e33aac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174a094eea8cfb0472e33aac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2009 at 11:27 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Hugh Dickins wrote:
>> > I find the "mem=3D" boot parameter disabled in today's linux-next:
>> > reverting the tip commit below fixes that.
>> >
>> > Hugh
>> >
>> > From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> > Date: Thu, 20 Aug 2009 12:23:11 +0000 (+0800)
>> > Subject: x86: Fix system crash when loading with "reservetop" paramete=
r
>> > X-Git-Url: http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Fmingo%2Fl=
inux-2.6-x86.git;a=3Dcommitdiff_plain;h=3D8126dec32738421afa362114337331337=
b4be17f
>> >
>> > x86: Fix system crash when loading with "reservetop" parameter
>> >
>> > The system will die if the kernel is booted with "reservetop"
>> > parameter, in present code, parse "reservetop" parameter after
>> > early_ioremap_init(), and some function still use
>> > early_ioremap() after it.
>> >
>> > The problem is, "reservetop" parameter can modify
>> > 'FIXADDR_TOP', then the virtual address got by early_ioremap()
>> > is base on old 'FIXADDR_TOP', but the page mapping is base on
>> > new 'FIXADDR_TOP', it will occur page fault, and the IDT is not
>> > prepare yet, so, the system is dead.
>> >
>> > So, put parse_early_param() in the front of
>> > early_ioremap_init() in this patch.
>> >
>> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> > Cc: yinghai@kernel.org
>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > LKML-Reference: <4A8D402F.4080805@cn.fujitsu.com>
>> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> > ---
>> >
>> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> > index 63f32d2..02643cc 100644
>> > --- a/arch/x86/kernel/setup.c
>> > +++ b/arch/x86/kernel/setup.c
>> > @@ -711,6 +711,11 @@ void __init setup_arch(char **cmdline_p)
>> > =A0 =A0 printk(KERN_INFO "Command line: %s\n", boot_command_line);
>> > =A0#endif
>> >
>> > + =A0 strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
>> > + =A0 *cmdline_p =3D command_line;
>> > +
>> > + =A0 parse_early_param();
>> > +
>> > =A0 =A0 /* VMI may relocate the fixmap; do this before touching iorema=
p area */
>> > =A0 =A0 vmi_init();
>> >
>> > @@ -793,11 +798,6 @@ void __init setup_arch(char **cmdline_p)
>> > =A0#endif
>> > =A0#endif
>> >
>> > - =A0 strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
>> > - =A0 *cmdline_p =3D command_line;
>> > -
>> > - =A0 parse_early_param();
>> > -
>> > =A0#ifdef CONFIG_X86_64
>> > =A0 =A0 check_efer();
>> > =A0#endif
>>
>> yes, that patch will break other built-in command too.
>>
>> need drop that patch.
>
> done. Was nervous about the patch already:
>
> =A0http://lkml.org/lkml/2009/8/21/127
>
>> also the problem was caused by vmi patch, and that commit should
>> be reverted.
>>
>> commit ae8d04e2ecbb233926860e9ce145eac19c7835dc
>> Author: Zachary Amsden <zach@vmware.com>
>> Date: =A0 Sat Dec 13 12:36:58 2008 -0800
>>
>> =A0 =A0 x86 Fix VMI crash on boot in 2.6.28-rc8
>>
>> =A0 =A0 VMI initialiation can relocate the fixmap, causing early_ioremap=
 to
>> =A0 =A0 malfunction if it is initialized before the relocation. =A0To fi=
x this,
>> =A0 =A0 VMI activation is split into two phases; the detection, which mu=
st
>> =A0 =A0 happen before setting up ioremap, and the activation, which must=
 happen
>> =A0 =A0 after parsing early boot parameters.
>>
>> =A0 =A0 This fixes a crash on boot when VMI is enabled under VMware.
>>
>> =A0 =A0 Signed-off-by: Zachary Amsden <zach@vmware.com>
>> =A0 =A0 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 9d5674f..bdec76e 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -794,6 +794,9 @@ void __init setup_arch(char **cmdline_p)
>> =A0 =A0 =A0 =A0 printk(KERN_INFO "Command line: %s\n", boot_command_line=
);
>> =A0#endif
>>
>> + =A0 =A0 =A0 /* VMI may relocate the fixmap; do this before touching io=
remap area */
>> + =A0 =A0 =A0 vmi_init();
>> +
>> =A0 =A0 =A0 =A0 early_cpu_init();
>> =A0 =A0 =A0 =A0 early_ioremap_init();
>>
>> @@ -880,13 +883,8 @@ void __init setup_arch(char **cmdline_p)
>> =A0 =A0 =A0 =A0 check_efer();
>> =A0#endif
>>
>> -#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
>> - =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0* Must be before kernel pagetables are setup
>> - =A0 =A0 =A0 =A0* or fixmap area is touched.
>> - =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 vmi_init();
>> -#endif
>> + =A0 =A0 =A0 /* Must be before kernel pagetables are setup */
>> + =A0 =A0 =A0 vmi_activate();
>>
>> =A0 =A0 =A0 =A0 /* after early param, so could get panic from serial */
>> =A0 =A0 =A0 =A0 reserve_early_setup_data();
>>
>>
>> and according to
>> http://lkml.org/lkml/2008/12/10/388
>> http://lkml.org/lkml/2008/12/10/456
>>
>> Zachary should split reserve_top_address() to two functions...
>> before sending that patch to Linus
>
> mind looking at this yourself if interested? Zachary has not been
> active for quite some time.
>

please check attached patch...

still need to make early_dbgp and early_console that would use early_iorema=
p?

YH

--0015174a094eea8cfb0472e33aac
Content-Type: text/x-patch; charset=US-ASCII; name="fix_early_param.patch"
Content-Disposition: attachment; filename="fix_early_param.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fz9fgvwi0

W1BBVENIXSB4ODY6IGZpeCBlYXJseV9wYXJhbSBoYW5sZSBtb3ZlZCBtb3JlIGVhcmx5Cgp0aGUg
cGF0Y2ggdGhlIG1vdmUgZWFybHlfcGFyYW1fcGFyc2UgZWFybHkgdG8gbWFrZSByZXNlcnZldG9w
IHRvIHdvcmsgYWdhaW4sCml0IGlzIHJlcG9ydGVkIHRvIGJyZWFrIG1lbT0uLi4KCmFmdGVyIGNs
b3NlIGxvb2tpbmcsIGl0IHdpbGwgYnJlYWsKMS4gc29tZSBjcHUgZmVhdHVyZSAgaW4gZWFybHkg
c3RhZ2UgdG9vLCBsaWtlIGNwdV9oYXNfeDJhcGljCjIuIHdpbGwgYnJlYWsgYnVpbHQtaW4tY29t
bWFuZCBsaW5lCjMuIHdpbGwgYnJlYWsgb3RoZXIgbWVtbWFwPSBhbmQgbWVtPQo0LiBlYXJseV9k
YmdwIGFuZCBlYXJseV9jb25zb2xlIHRoYXQgd2lsbCB1c2UgZWFybHlfaW9yZW1hcCB0byBhY2Nl
c3MgbW1pbyAoPykKCnNvIHRyeSB0bwoxLiBtb3ZlIGVhcmx5X2NwdV9pbml0IGVhcmx5CjIuIG1v
dmUgYnVpbHQtaW4tY29tbWFuZCBjb3B5aW5nIGVhcmx5CjMuIGFkZCB1c2VyZGVmX21lbV9zaXpl
IHRvIHJlbWVtYmVyIG1lbT0KLiAgYWRkIGU4MjBfdXNlciB0byByZW1lbWJlciBtZW1tYXAKICAg
dG8gdXNlIHVzZXJkZWZfbWVtX3NpemUgYW5kIGU4MjBfdXNlciBpbiBmaW5hbGl6ZV9tYXAKNDog
PwoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBh
cmNoL3g4Ni9rZXJuZWwvZTgyMC5jICB8ICAgNTIgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tLS0tLS0tLS0tCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyB8ICAgMzkgKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDU1IGlu
c2VydGlvbnMoKyksIDM2IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9r
ZXJuZWwvZTgyMC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5l
bC9lODIwLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCkBAIC00NCw2ICs0
NCw3IEBACiAgKi8KIHN0cnVjdCBlODIwbWFwIGU4MjA7CiBzdHJ1Y3QgZTgyMG1hcCBlODIwX3Nh
dmVkOworc3RhdGljIHN0cnVjdCBlODIwbWFwIGU4MjBfdXNlciBfX2luaXRkYXRhOwogCiAvKiBG
b3IgUENJIG9yIG90aGVyIG1lbW9yeS1tYXBwZWQgcmVzb3VyY2VzICovCiB1bnNpZ25lZCBsb25n
IHBjaV9tZW1fc3RhcnQgPSAweGFlZWRiYWJlOwpAQCAtMTIyNywxMSArMTIyOCwxMSBAQCBzdGF0
aWMgdm9pZCBlYXJseV9wYW5pYyhjaGFyICptc2cpCiB9CiAKIHN0YXRpYyBpbnQgdXNlcmRlZiBf
X2luaXRkYXRhOworc3RhdGljCXU2NCB1c2VyZGVmX21lbV9zaXplIF9faW5pdGRhdGE7CiAKIC8q
ICJtZW09bm9wZW50aXVtIiBkaXNhYmxlcyB0aGUgNE1CIHBhZ2UgdGFibGVzLiAqLwogc3RhdGlj
IGludCBfX2luaXQgcGFyc2VfbWVtb3B0KGNoYXIgKnApCiB7Ci0JdTY0IG1lbV9zaXplOwogCiAJ
aWYgKCFwKQogCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTEyNDQsMTMgKzEyNDUsMTMgQEAgc3RhdGlj
IGludCBfX2luaXQgcGFyc2VfbWVtb3B0KGNoYXIgKnApCiAjZW5kaWYKIAogCXVzZXJkZWYgPSAx
OwotCW1lbV9zaXplID0gbWVtcGFyc2UocCwgJnApOwotCWU4MjBfcmVtb3ZlX3JhbmdlKG1lbV9z
aXplLCBVTExPTkdfTUFYIC0gbWVtX3NpemUsIEU4MjBfUkFNLCAxKTsKKwl1c2VyZGVmX21lbV9z
aXplID0gbWVtcGFyc2UocCwgJnApOwogCiAJcmV0dXJuIDA7CiB9CiBlYXJseV9wYXJhbSgibWVt
IiwgcGFyc2VfbWVtb3B0KTsKIAorc3RhdGljIGludCB1c2VyZGVmX2V4YWN0bWFwIF9faW5pdGRh
dGE7CiBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9tZW1tYXBfb3B0KGNoYXIgKnApCiB7CiAJY2hh
ciAqb2xkcDsKQEAgLTEyNjAsMTYgKzEyNjEsOSBAQCBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9t
ZW1tYXBfb3B0KGNoYXIKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAlpZiAoIXN0cm5jbXAocCwgImV4
YWN0bWFwIiwgOCkpIHsKLSNpZmRlZiBDT05GSUdfQ1JBU0hfRFVNUAotCQkvKgotCQkgKiBJZiB3
ZSBhcmUgZG9pbmcgYSBjcmFzaCBkdW1wLCB3ZSBzdGlsbCBuZWVkIHRvIGtub3cKLQkJICogdGhl
IHJlYWwgbWVtIHNpemUgYmVmb3JlIG9yaWdpbmFsIG1lbW9yeSBtYXAgaXMKLQkJICogcmVzZXQu
Ci0JCSAqLwotCQlzYXZlZF9tYXhfcGZuID0gZTgyMF9lbmRfb2ZfcmFtX3BmbigpOwotI2VuZGlm
Ci0JCWU4MjAubnJfbWFwID0gMDsKKwkJZTgyMF91c2VyLm5yX21hcCA9IDA7CiAJCXVzZXJkZWYg
PSAxOworCQl1c2VyZGVmX2V4YWN0bWFwID0gMTsKIAkJcmV0dXJuIDA7CiAJfQogCkBAIC0xMjgx
LDE1ICsxMjc1LDE2IEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW1hcF9vcHQoY2hhcgog
CXVzZXJkZWYgPSAxOwogCWlmICgqcCA9PSAnQCcpIHsKIAkJc3RhcnRfYXQgPSBtZW1wYXJzZShw
KzEsICZwKTsKLQkJZTgyMF9hZGRfcmVnaW9uKHN0YXJ0X2F0LCBtZW1fc2l6ZSwgRTgyMF9SQU0p
OworCQlfX2U4MjBfYWRkX3JlZ2lvbigmZTgyMF91c2VyLCBzdGFydF9hdCwgbWVtX3NpemUsIEU4
MjBfUkFNKTsKIAl9IGVsc2UgaWYgKCpwID09ICcjJykgewogCQlzdGFydF9hdCA9IG1lbXBhcnNl
KHArMSwgJnApOwotCQllODIwX2FkZF9yZWdpb24oc3RhcnRfYXQsIG1lbV9zaXplLCBFODIwX0FD
UEkpOworCQlfX2U4MjBfYWRkX3JlZ2lvbigmZTgyMF91c2VyLCBzdGFydF9hdCwgbWVtX3NpemUs
IEU4MjBfQUNQSSk7CiAJfSBlbHNlIGlmICgqcCA9PSAnJCcpIHsKIAkJc3RhcnRfYXQgPSBtZW1w
YXJzZShwKzEsICZwKTsKLQkJZTgyMF9hZGRfcmVnaW9uKHN0YXJ0X2F0LCBtZW1fc2l6ZSwgRTgy
MF9SRVNFUlZFRCk7CisJCV9fZTgyMF9hZGRfcmVnaW9uKCZlODIwX3VzZXIsIHN0YXJ0X2F0LCBt
ZW1fc2l6ZSwKKwkJCSBFODIwX1JFU0VSVkVEKTsKIAl9IGVsc2UKLQkJZTgyMF9yZW1vdmVfcmFu
Z2UobWVtX3NpemUsIFVMTE9OR19NQVggLSBtZW1fc2l6ZSwgRTgyMF9SQU0sIDEpOworCQl1c2Vy
ZGVmX21lbV9zaXplID0gbWVtX3NpemU7CiAKIAlyZXR1cm4gKnAgPT0gJ1wwJyA/IDAgOiAtRUlO
VkFMOwogfQpAQCAtMTI5OCw3ICsxMjkzLDMwIEBAIGVhcmx5X3BhcmFtKCJtZW1tYXAiLCBwYXJz
ZV9tZW1tYXBfb3B0KTsKIHZvaWQgX19pbml0IGZpbmlzaF9lODIwX3BhcnNpbmcodm9pZCkKIHsK
IAlpZiAodXNlcmRlZikgewotCQl1MzIgbnIgPSBlODIwLm5yX21hcDsKKwkJdTMyIG5yOworCisJ
CWlmICh1c2VyZGVmX2V4YWN0bWFwKSB7CisjaWZkZWYgQ09ORklHX0NSQVNIX0RVTVAKKwkJCS8q
CisJCQkgKiBJZiB3ZSBhcmUgZG9pbmcgYSBjcmFzaCBkdW1wLCB3ZSBzdGlsbCBuZWVkIHRvIGtu
b3cKKwkJCSAqIHRoZSByZWFsIG1lbSBzaXplIGJlZm9yZSBvcmlnaW5hbCBtZW1vcnkgbWFwIGlz
CisJCQkgKiByZXNldC4KKwkJCSAqLworCQkJc2F2ZWRfbWF4X3BmbiA9IGU4MjBfZW5kX29mX3Jh
bV9wZm4oKTsKKyNlbmRpZgorCQkJLyogZ29vZCwganVzdCB1c2UgZTgyMF91c2VyIGluc3RlYWQg
Ki8KKwkJCW1lbWNweSgmZTgyMCwgJmU4MjBfdXNlciwgc2l6ZW9mKHN0cnVjdCBlODIwbWFwKSk7
CisJCX0gZWxzZSB7CisJCQkvKiBvaywgbmVlZCB0byBhcHBlbmQgZTgyMF91c2VyIHRvIGU4MjAg
Ki8KKwkJCV9fYXBwZW5kX2U4MjBfbWFwKGU4MjBfdXNlci5tYXAsIGU4MjBfdXNlci5ucl9tYXAp
OworCQl9CisKKwkJbnIgPSBlODIwLm5yX21hcDsKKworCQlpZiAodXNlcmRlZl9tZW1fc2l6ZSkK
KwkJCWU4MjBfcmVtb3ZlX3JhbmdlKHVzZXJkZWZfbWVtX3NpemUsCisJCQkJCSAgVUxMT05HX01B
WCAtIHVzZXJkZWZfbWVtX3NpemUsCisJCQkJCSAgRTgyMF9SQU0sIDEpOwogCiAJCWlmIChzYW5p
dGl6ZV9lODIwX21hcChlODIwLm1hcCwgQVJSQVlfU0laRShlODIwLm1hcCksICZucikgPCAwKQog
CQkJZWFybHlfcGFuaWMoIkludmFsaWQgdXNlciBzdXBwbGllZCBtZW1vcnkgbWFwIik7CkluZGV4
OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgt
Mi42Lm9yaWcvYXJjaC94ODYva2VybmVsL3NldHVwLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9r
ZXJuZWwvc2V0dXAuYwpAQCAtNjkzLDEzICs2OTMsMjggQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJj
aChjaGFyICoqY21kbGluZV9wKQogI2lmZGVmIENPTkZJR19YODZfMzIKIAltZW1jcHkoJmJvb3Rf
Y3B1X2RhdGEsICZuZXdfY3B1X2RhdGEsIHNpemVvZihuZXdfY3B1X2RhdGEpKTsKIAl2aXN3c19l
YXJseV9kZXRlY3QoKTsKKyNlbmRpZgorCisjaWZkZWYgQ09ORklHX0NNRExJTkVfQk9PTAorI2lm
ZGVmIENPTkZJR19DTURMSU5FX09WRVJSSURFCisJc3RybGNweShib290X2NvbW1hbmRfbGluZSwg
YnVpbHRpbl9jbWRsaW5lLCBDT01NQU5EX0xJTkVfU0laRSk7CiAjZWxzZQotCXByaW50ayhLRVJO
X0lORk8gIkNvbW1hbmQgbGluZTogJXNcbiIsIGJvb3RfY29tbWFuZF9saW5lKTsKKwlpZiAoYnVp
bHRpbl9jbWRsaW5lWzBdKSB7CisJCS8qIGFwcGVuZCBib290IGxvYWRlciBjbWRsaW5lIHRvIGJ1
aWx0aW4gKi8KKwkJc3RybGNhdChidWlsdGluX2NtZGxpbmUsICIgIiwgQ09NTUFORF9MSU5FX1NJ
WkUpOworCQlzdHJsY2F0KGJ1aWx0aW5fY21kbGluZSwgYm9vdF9jb21tYW5kX2xpbmUsIENPTU1B
TkRfTElORV9TSVpFKTsKKwkJc3RybGNweShib290X2NvbW1hbmRfbGluZSwgYnVpbHRpbl9jbWRs
aW5lLCBDT01NQU5EX0xJTkVfU0laRSk7CisJfQorI2VuZGlmCiAjZW5kaWYKIAorCXByaW50ayhL
RVJOX0lORk8gIkNvbW1hbmQgbGluZTogJXNcbiIsIGJvb3RfY29tbWFuZF9saW5lKTsKKwogCXN0
cmxjcHkoY29tbWFuZF9saW5lLCBib290X2NvbW1hbmRfbGluZSwgQ09NTUFORF9MSU5FX1NJWkUp
OwogCSpjbWRsaW5lX3AgPSBjb21tYW5kX2xpbmU7CiAKKwllYXJseV9jcHVfaW5pdCgpOworCiAj
aWZkZWYgQ09ORklHX1g4Nl82NAogCS8qCiAJICogTXVzdCBjYWxsIHRoaXMgdHdpY2U6IE9uY2Ug
anVzdCB0byBkZXRlY3Qgd2hldGhlciBoYXJkd2FyZSBkb2Vzbid0CkBAIC03MTIsMTAgKzcyNywx
MyBAQCB2b2lkIF9faW5pdCBzZXR1cF9hcmNoKGNoYXIgKipjbWRsaW5lX3ApCiAKIAlwYXJzZV9l
YXJseV9wYXJhbSgpOwogCisjaWZkZWYgQ09ORklHX1g4Nl82NAorCWNoZWNrX2VmZXIoKTsKKyNl
bmRpZgorCiAJLyogVk1JIG1heSByZWxvY2F0ZSB0aGUgZml4bWFwOyBkbyB0aGlzIGJlZm9yZSB0
b3VjaGluZyBpb3JlbWFwIGFyZWEgKi8KIAl2bWlfaW5pdCgpOwogCi0JZWFybHlfY3B1X2luaXQo
KTsKIAllYXJseV9pb3JlbWFwX2luaXQoKTsKIAogCVJPT1RfREVWID0gb2xkX2RlY29kZV9kZXYo
Ym9vdF9wYXJhbXMuaGRyLnJvb3RfZGV2KTsKQEAgLTc4MSwyMyArNzk5LDYgQEAgdm9pZCBfX2lu
aXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogCWJzc19yZXNvdXJjZS5zdGFydCA9IHZp
cnRfdG9fcGh5cygmX19ic3Nfc3RhcnQpOwogCWJzc19yZXNvdXJjZS5lbmQgPSB2aXJ0X3RvX3Bo
eXMoJl9fYnNzX3N0b3ApLTE7CiAKLSNpZmRlZiBDT05GSUdfQ01ETElORV9CT09MCi0jaWZkZWYg
Q09ORklHX0NNRExJTkVfT1ZFUlJJREUKLQlzdHJsY3B5KGJvb3RfY29tbWFuZF9saW5lLCBidWls
dGluX2NtZGxpbmUsIENPTU1BTkRfTElORV9TSVpFKTsKLSNlbHNlCi0JaWYgKGJ1aWx0aW5fY21k
bGluZVswXSkgewotCQkvKiBhcHBlbmQgYm9vdCBsb2FkZXIgY21kbGluZSB0byBidWlsdGluICov
Ci0JCXN0cmxjYXQoYnVpbHRpbl9jbWRsaW5lLCAiICIsIENPTU1BTkRfTElORV9TSVpFKTsKLQkJ
c3RybGNhdChidWlsdGluX2NtZGxpbmUsIGJvb3RfY29tbWFuZF9saW5lLCBDT01NQU5EX0xJTkVf
U0laRSk7Ci0JCXN0cmxjcHkoYm9vdF9jb21tYW5kX2xpbmUsIGJ1aWx0aW5fY21kbGluZSwgQ09N
TUFORF9MSU5FX1NJWkUpOwotCX0KLSNlbmRpZgotI2VuZGlmCi0KLSNpZmRlZiBDT05GSUdfWDg2
XzY0Ci0JY2hlY2tfZWZlcigpOwotI2VuZGlmCi0KIAkvKiBNdXN0IGJlIGJlZm9yZSBrZXJuZWwg
cGFnZXRhYmxlcyBhcmUgc2V0dXAgKi8KIAl2bWlfYWN0aXZhdGUoKTsKIAo=
--0015174a094eea8cfb0472e33aac--
