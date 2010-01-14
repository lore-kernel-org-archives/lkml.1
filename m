Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209Ab0ANGps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0ANGps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313Ab0ANGpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:45:47 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40839 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0ANGpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:45:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BP5LSqnnap7G83HhiZ30FJ4Zq/2H6+cr9G7SnkcNlAMRPXkk8dt9A8yKva88dNLOUh
         YGC7iiPYRIIHc2gXiwibEu+SJBuD7W1n0iQnn4lFtng1cUpN5y5FyqmKtU/homxMbyby
         4SB3hDqQ0jKmqRAjT1/KbDZt2QVK6gDeVEj34=
MIME-Version: 1.0
In-Reply-To: <4B4D65B1.3010204@redhat.com>
References: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
	 <4B4D65B1.3010204@redhat.com>
Date: Thu, 14 Jan 2010 14:45:45 +0800
Message-ID: <ce2c83091001132245q2b42b533vd6519cb3fd0d01af@mail.gmail.com>
Subject: Re: Did we really need to clear the IF flag at prepare_singlestep() 
	of x86 kprobes?
From: Dongdong Deng <libfetion@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       arjan@infradead.org, jkenisto@us.ibm.com, prasanna@in.ibm.com
Content-Type: multipart/mixed; boundary=00504502acad94b5c9047d1a3cc9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502acad94b5c9047d1a3cc9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2010 at 2:18 PM, Masami Hiramatsu <mhiramat@redhat.com> wro=
te:
> Dongdong Deng wrote:
>> Hi Kprobe experts,
>>
>> I have a doubt about the handling "X86_EFLAGS_IF" at prepare_singlestep(=
),
>> Could you give me some suggestions?
>>
>>
>> arch/x86/kernel/kprobes.c:
>> 406 static void __kprobes prepare_singlestep(struct kprobe *p, struct
>> pt_regs *regs)
>> 407 {
>> 408 =C2=A0 =C2=A0clear_btf();
>> 409 =C2=A0 =C2=A0regs->flags |=3D X86_EFLAGS_TF;
>> 410 =C2=A0 =C2=A0regs->flags &=3D ~X86_EFLAGS_IF;
>> =C2=A0 ...
>> }
>>
>>
>> for 410 line: Kprobe is intend to disable interrupt during the single st=
ep.
>>
>> I think it is enough that just setting X86_EFLAGS_TF as following reason=
s.
>>
>>
>> ******************
>> Reason 1: "debug trap" was initalized as an interrupt gate
>>
>> arch/x86/kernel/traps.c:892: set_intr_gate_ist(1, &debug, DEBUG_STACK);
>>
>> The "debug trap" was initalized as an interrupt gate, thereby during the
>> hanld function of debug exceptions, the X86_EFLAGS_IF have been
>> cleared automatically.
>>
>>
>> ******************
>> Reason 2: the priority among debug exceptions and interrupts
>>
>> Intel=C2=AE 64 and IA-32 Architectures Software Developer=E2=80=99s Manu=
al Volume
>> 3A, page 5-11:
>>
>> If more than one exception or interrupt is pending at an instruction
>> boundary, the
>> processor services them in a predictable order. Table 5-2 shows the
>> priority among
>> classes of exception and interrupt sources.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Table 5-2. Priority Among Simultaneou=
s Exceptions and Interrupts
>> Priority =C2=A0 =C2=A0 =C2=A0 Description
>> 1 (Highest) =C2=A0 =C2=A0Hardware Reset and Machine Checks
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- RESET
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Machine Check
>> 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Trap on Task Switch
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- T flag in TSS i=
s set
>> 3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0External Hardware Inte=
rventions
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- FLUSH
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- STOPCLK
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- SMI
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- INIT
>> 4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Traps on the Previous =
Instruction
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Breakpoints
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Debug Trap Exce=
ptions (TF flag set or data/I-O breakpoint)
>> 5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Nonmaskable Interrupts (NMI)
>> 6 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Maskable Hardware Interrupts
>>
>>
>> From the table we could see debug exceptions lies in priority 4 and
>> external interrupt lies
>> in priority 6.
>>
>> Thereby the processor will handle Debug Trap Exceptions first, then
>> handle external interrupt.
>
> Hi Dongdong,
>
> Hmm, can that be applied on other x86 compat cpus too?
> And, when is the debug trap exception actually happened?

> 1: int3 ->
> 2: =C2=A0-> pre_kprobe_handler
> 3: =C2=A0-> prepare_singlestep
> 4: <- iret
> 5: execute instruction
> 6: debug trap ->
> 7: -> post_kprobe_handler
> ...
>
> If we have an interrupt before step4, does that interrupt
> really executed *after* step5? or step4?


Hi Masami,

Thanks for your detail explain, it is the key of my question. :)

I write a test case to proving it.

The test case required run on uniprocessor systems,

My machine is intel Xeon-Dual, so I disable the SMP support when
building kernel.


The test case works.

1: delay a long time during INT3 handler of kprobes.

2: add a printk at the net driver interrupt handler.(I am using
e10000e net-card)

3: startup system

4: using other PC to ping current machine all the while, thereby it
could generate net-card interrupt during INT3.

5: insmod the samples/kprobes/kprobe_example.ko .

6: using the following script to trigger kprobe.

#!/bin/bash
a=3D0 ; while [ $a !=3D 8000 ]; do(ls ./); a=3D$(( $a + 1 )); done


Test output result:

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5138  @ 2.13GHz
stepping        : 11
cpu MHz         : 2133.324
cache size      : 4096 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 4266.64
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

# insmod  kprobe_example.ko
Planted kprobe at ffffffff8022df60

# /bin/bash 1.sh
pre_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df61, flags=
 =3D 0x246
prepare_singlestep didn't clear X86_EFLAGS_IF
Got a e1000 intrrupt during kprobe single step!!!!
post_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df62, flag=
s =3D 0x246
pre_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df61, flags=
 =3D 0x246
prepare_singlestep didn't clear X86_EFLAGS_IF
Got a e1000 intrrupt during kprobe single step!!!!
post_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df62, flag=
s =3D 0x246
1.sh               kprobe_example.ko
pre_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df61, flags=
 =3D 0x246
prepare_singlestep didn't clear X86_EFLAGS_IF
Got a e1000 intrrupt during kprobe single step!!!!
post_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df62, flag=
s =3D 0x246
1.sh               kprobe_example.ko
pre_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df61, flags=
 =3D 0x246
prepare_singlestep didn't clear X86_EFLAGS_IF
Got a e1000 intrrupt during kprobe single step!!!!
post_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df62, flag=
s =3D 0x246
1.sh               kprobe_example.ko
pre_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df61, flags=
 =3D 0x246
prepare_singlestep didn't clear X86_EFLAGS_IF
Got a e1000 intrrupt during kprobe single step!!!!
post_handler: p->addr =3D 0xffffffff8022df60, ip =3D ffffffff8022df62, flag=
s =3D 0x246
1.sh               kprobe_example.ko


>From the result of test cause,  the processor really tries to execute
interrupt right after step4.


>
> If the processor really tries to execute interrupt
> right after step5, your logic seems correct, but if it
> is done right after step4, clearing IF seems correct.

But I couldn't make sure that this test case is suitable or not.
If the test case is OK, my logic seems wrong.


Thank you very much,
Dongdong


>
> Thank you,
>
> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>
>

--00504502acad94b5c9047d1a3cc9
Content-Type: text/x-diff; charset=US-ASCII; name="test_case_kprobe_IF_EFLAGS.patch"
Content-Disposition: attachment; filename="test_case_kprobe_IF_EFLAGS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4f68v5q0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9rcHJvYmVzLmMgYi9hcmNoL3g4Ni9rZXJuZWwv
a3Byb2Jlcy5jCmluZGV4IGE5NTQxY2IuLmQ4MWY1NDkgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tl
cm5lbC9rcHJvYmVzLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2twcm9iZXMuYwpAQCAtNTUsNiAr
NTUsNyBAQAogI2luY2x1ZGUgPGFzbS91YWNjZXNzLmg+CiAjaW5jbHVkZSA8YXNtL2FsdGVybmF0
aXZlLmg+CiAKK2ludCBkYnVnX2twcm9iX3BrOwogdm9pZCBqcHJvYmVfcmV0dXJuX2VuZCh2b2lk
KTsKIAogREVGSU5FX1BFUl9DUFUoc3RydWN0IGtwcm9iZSAqLCBjdXJyZW50X2twcm9iZSkgPSBO
VUxMOwpAQCAtNDIxLDcgKzQyMiw5IEBAIHN0YXRpYyB2b2lkIF9fa3Byb2JlcyBwcmVwYXJlX3Np
bmdsZXN0ZXAoc3RydWN0IGtwcm9iZSAqcCwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCiB7CiAJY2xl
YXJfYnRmKCk7CiAJcmVncy0+ZmxhZ3MgfD0gWDg2X0VGTEFHU19URjsKLQlyZWdzLT5mbGFncyAm
PSB+WDg2X0VGTEFHU19JRjsKKworCXByaW50ayhLRVJOX0VSUiAicHJlcGFyZV9zaW5nbGVzdGVw
IGRpZG4ndCBjbGVhciBYODZfRUZMQUdTX0lGXG4iKTsKKwkvKglyZWdzLT5mbGFncyAmPSB+WDg2
X0VGTEFHU19JRjsgKi8KIAkvKiBzaW5nbGUgc3RlcCBpbmxpbmUgaWYgdGhlIGluc3RydWN0aW9u
IGlzIGFuIGludDMgKi8KIAlpZiAocC0+b3Bjb2RlID09IEJSRUFLUE9JTlRfSU5TVFJVQ1RJT04p
CiAJCXJlZ3MtPmlwID0gKHVuc2lnbmVkIGxvbmcpcC0+YWRkcjsKQEAgLTQ0OSw2ICs0NTIsNyBA
QCBzdGF0aWMgdm9pZCBfX2twcm9iZXMgc2V0dXBfc2luZ2xlc3RlcChzdHJ1Y3Qga3Byb2JlICpw
LCBzdHJ1Y3QgcHRfcmVncyAqcmVncywKIAkJcmVzZXRfY3VycmVudF9rcHJvYmUoKTsKIAkJcmVn
cy0+aXAgPSAodW5zaWduZWQgbG9uZylwLT5haW5zbi5pbnNuOwogCQlwcmVlbXB0X2VuYWJsZV9u
b19yZXNjaGVkKCk7CisJCWRidWdfa3Byb2JfcGsgPSAwOwogCQlyZXR1cm47CiAJfQogI2VuZGlm
CkBAIC00NzUsNiArNDc5LDcgQEAgc3RhdGljIGludCBfX2twcm9iZXMgcmVlbnRlcl9rcHJvYmUo
c3RydWN0IGtwcm9iZSAqcCwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MsCiAJCXJlZ3MtPmlwID0gKHVu
c2lnbmVkIGxvbmcpcC0+YWRkcjsKIAkJcmVzZXRfY3VycmVudF9rcHJvYmUoKTsKIAkJcHJlZW1w
dF9lbmFibGVfbm9fcmVzY2hlZCgpOworCQlkYnVnX2twcm9iX3BrID0gMDsKIAkJYnJlYWs7CiAj
ZW5kaWYKIAljYXNlIEtQUk9CRV9ISVRfQUNUSVZFOgpAQCAtNTMxLDYgKzUzNiw3IEBAIHN0YXRp
YyBpbnQgX19rcHJvYmVzIGtwcm9iZV9oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKQogCQly
ZXR1cm4gMTsKIAl9CiAKKwlkYnVnX2twcm9iX3BrID0gMTsKIAkvKgogCSAqIFdlIGRvbid0IHdh
bnQgdG8gYmUgcHJlZW1wdGVkIGZvciB0aGUgZW50aXJlCiAJICogZHVyYXRpb24gb2Yga3Byb2Jl
IHByb2Nlc3NpbmcuIFdlIGNvbmRpdGlvbmFsbHkKQEAgLTUzOSw2ICs1NDUsMTAgQEAgc3RhdGlj
IGludCBfX2twcm9iZXMga3Byb2JlX2hhbmRsZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCiAJICov
CiAJcHJlZW1wdF9kaXNhYmxlKCk7CiAKKwlpbnQgaTsKKwlmb3IgKGkgPSAwOyBpPCAxMDA7IGkr
KykKKwkJdWRlbGF5KDgwMDApOworCiAJa2NiID0gZ2V0X2twcm9iZV9jdGxibGsoKTsKIAlwID0g
Z2V0X2twcm9iZShhZGRyKTsKIApAQCAtNTcxLDYgKzU4MSw3IEBAIHN0YXRpYyBpbnQgX19rcHJv
YmVzIGtwcm9iZV9oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKQogCX0gLyogZWxzZTogbm90
IGEga3Byb2JlIGZhdWx0OyBsZXQgdGhlIGtlcm5lbCBoYW5kbGUgaXQgKi8KIAogCXByZWVtcHRf
ZW5hYmxlX25vX3Jlc2NoZWQoKTsKKwlkYnVnX2twcm9iX3BrID0gMDsKIAlyZXR1cm4gMDsKIH0K
IApAQCAtODcwLDYgKzg4MSw3IEBAIHN0YXRpYyBpbnQgX19rcHJvYmVzIHBvc3Rfa3Byb2JlX2hh
bmRsZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCiAJcmVzZXRfY3VycmVudF9rcHJvYmUoKTsKIG91
dDoKIAlwcmVlbXB0X2VuYWJsZV9ub19yZXNjaGVkKCk7CisJZGJ1Z19rcHJvYl9wayA9IDA7CiAK
IAkvKgogCSAqIGlmIHNvbWVib2R5IGVsc2UgaXMgc2luZ2xlc3RlcHBpbmcgYWNyb3NzIGEgcHJv
YmUgcG9pbnQsIGZsYWdzCkBAIC05MDQsNiArOTE2LDcgQEAgaW50IF9fa3Byb2JlcyBrcHJvYmVf
ZmF1bHRfaGFuZGxlcihzdHJ1Y3QgcHRfcmVncyAqcmVncywgaW50IHRyYXBucikKIAkJZWxzZQog
CQkJcmVzZXRfY3VycmVudF9rcHJvYmUoKTsKIAkJcHJlZW1wdF9lbmFibGVfbm9fcmVzY2hlZCgp
OworCQlkYnVnX2twcm9iX3BrID0gMDsKIAkJYnJlYWs7CiAJY2FzZSBLUFJPQkVfSElUX0FDVElW
RToKIAljYXNlIEtQUk9CRV9ISVRfU1NET05FOgpAQCAtOTQyLDYgKzk1NSw3IEBAIGludCBfX2tw
cm9iZXMga3Byb2JlX2ZhdWx0X2hhbmRsZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIGludCB0cmFw
bnIpCiAJcmV0dXJuIDA7CiB9CiAKKwogLyoKICAqIFdyYXBwZXIgcm91dGluZSBmb3IgaGFuZGxp
bmcgZXhjZXB0aW9ucy4KICAqLwpAQCAtOTYwLDggKzk3NCwxMCBAQCBpbnQgX19rcHJvYmVzIGtw
cm9iZV9leGNlcHRpb25zX25vdGlmeShzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnNlbGYsCiAJCQly
ZXQgPSBOT1RJRllfU1RPUDsKIAkJYnJlYWs7CiAJY2FzZSBESUVfREVCVUc6Ci0JCWlmIChwb3N0
X2twcm9iZV9oYW5kbGVyKGFyZ3MtPnJlZ3MpKQorCQlpZiAocG9zdF9rcHJvYmVfaGFuZGxlcihh
cmdzLT5yZWdzKSkgeworCQkJZGJ1Z19rcHJvYl9wayA9IDA7CiAJCQlyZXQgPSBOT1RJRllfU1RP
UDsKKwkJfQogCQlicmVhazsKIAljYXNlIERJRV9HUEY6CiAJCS8qCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9lMTAwMGUvbmV0ZGV2LmMgYi9kcml2ZXJzL25ldC9lMTAwMGUvbmV0ZGV2LmMKaW5k
ZXggMThhMTJjNC4uZTY3MTA0YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZTEwMDBlL25ldGRl
di5jCisrKyBiL2RyaXZlcnMvbmV0L2UxMDAwZS9uZXRkZXYuYwpAQCAtMTIwNCw2ICsxMjA0LDEw
IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBlMTAwMF9pbnRyKGludCBpcnEsIHZvaWQgKmRhdGEpCiAJ
c3RydWN0IGUxMDAwX2h3ICpodyA9ICZhZGFwdGVyLT5odzsKIAl1MzIgcmN0bCwgaWNyID0gZXIz
MihJQ1IpOwogCisJZXh0ZXJuIGludCBkYnVnX2twcm9iX3BrOworCWlmIChkYnVnX2twcm9iX3Br
KQorCQlwcmludGsoS0VSTl9FUlIgIkdvdCBhIGUxMDAwIGludHJydXB0IGR1cmluZyBrcHJvYmUg
c2luZ2xlIHN0ZXAhISEhXG4iKTsKKwogCWlmICghaWNyKQogCQlyZXR1cm4gSVJRX05PTkU7ICAv
KiBOb3Qgb3VyIGludGVycnVwdCAqLwogCg==
--00504502acad94b5c9047d1a3cc9--
