Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbZJIUhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbZJIUhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZJIUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:37:05 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:52162 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZJIUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:37:04 -0400
Message-ID: <4ACF9EC3.2050901@web.de>
Date: Fri, 09 Oct 2009 22:36:19 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4: kvm 2/4] Kill the confusing tsc_ref_khz and ref_freq
 variables.
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com> <1254260317-3490-2-git-send-email-zamsden@redhat.com> <4ACE734D.10600@web.de> <4ACF9C9B.2040006@redhat.com>
In-Reply-To: <4ACF9C9B.2040006@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig936F390CBEBB2E47DFA3B650"
X-Provags-ID: V01U2FsdGVkX1/+sfBTQx7Y0ndRuA0qYjehCUcVMOyTv9ot4eKw
	f/KFgSWhMB9LkyCynMrqF8kTsq4JZlj9W62REwOw4KgrPG+81r
	2GWp3l97s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig936F390CBEBB2E47DFA3B650
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Zachary Amsden wrote:
> On 10/08/2009 01:18 PM, Jan Kiszka wrote:
>> Zachary Amsden wrote:
>>  =20
>>> They are globals, not clearly protected by any ordering or locking, a=
nd
>>> vulnerable to various startup races.
>>>
>>> Instead, for variable TSC machines, register the cpufreq notifier and=

>>> get
>>> the TSC frequency directly from the cpufreq machinery.  Not only is i=
t
>>> always right, it is also perfectly accurate, as no error prone
>>> measurement
>>> is required.
>>>
>>> On such machines, when a new CPU online is brought online, it isn't
>>> clear what
>>> frequency it will start with, and it may not correspond to the
>>> reference, thus
>>> in hardware_enable we clear the cpu_tsc_khz variable to zero and make=

>>> sure
>>> it is set before running on a VCPU.
>>>
>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>> ---
>>>   arch/x86/kvm/x86.c |   26 ++++++++++++++++----------
>>>   1 files changed, 16 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 15d2ace..de4ce8f 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1326,6 +1326,8 @@ out:
>>>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>   {
>>>       kvm_x86_ops->vcpu_load(vcpu, cpu);
>>> +    if (unlikely(per_cpu(cpu_tsc_khz, cpu) =3D=3D 0))
>>> +        per_cpu(cpu_tsc_khz, cpu) =3D cpufreq_quick_get(cpu);
>>>       kvm_request_guest_time_update(vcpu);
>>>   }
>>>
>>> @@ -3061,9 +3063,6 @@ static void bounce_off(void *info)
>>>       /* nothing */
>>>   }
>>>
>>> -static unsigned int  ref_freq;
>>> -static unsigned long tsc_khz_ref;
>>> -
>>>   static int kvmclock_cpufreq_notifier(struct notifier_block *nb,
>>> unsigned long val,
>>>                        void *data)
>>>   {
>>> @@ -3072,14 +3071,11 @@ static int kvmclock_cpufreq_notifier(struct
>>> notifier_block *nb, unsigned long va
>>>       struct kvm_vcpu *vcpu;
>>>       int i, send_ipi =3D 0;
>>>
>>> -    if (!ref_freq)
>>> -        ref_freq =3D freq->old;
>>> -
>>>       if (val =3D=3D CPUFREQ_PRECHANGE&&  freq->old>  freq->new)
>>>           return 0;
>>>       if (val =3D=3D CPUFREQ_POSTCHANGE&&  freq->old<  freq->new)
>>>           return 0;
>>> -    per_cpu(cpu_tsc_khz, freq->cpu) =3D cpufreq_scale(tsc_khz_ref,
>>> ref_freq, freq->new);
>>> +    per_cpu(cpu_tsc_khz, freq->cpu) =3D freq->new;
>>>
>>>       spin_lock(&kvm_lock);
>>>       list_for_each_entry(kvm,&vm_list, vm_list) {
>>> @@ -3120,12 +3116,14 @@ static void kvm_timer_init(void)
>>>   {
>>>       int cpu;
>>>
>>> -    for_each_possible_cpu(cpu)
>>> -        per_cpu(cpu_tsc_khz, cpu) =3D tsc_khz;
>>>       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>>> -        tsc_khz_ref =3D tsc_khz;
>>>           cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,=

>>>                         CPUFREQ_TRANSITION_NOTIFIER);
>>> +        for_each_online_cpu(cpu)
>>> +            per_cpu(cpu_tsc_khz, cpu) =3D cpufreq_get(cpu);
>>>     =20
>> This doesn't build for !CONFIG_CPU_FREQ.
>>   =20
>=20
> And did it before?

Yes, because cpufreq_get, which is undefined without CONFIG_CPU_FREQ,
did not exist so far. One may argue that this is a deficit of the
cpufreq API. However, it needs fixing.

Jan


--------------enig936F390CBEBB2E47DFA3B650
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkrPnsgACgkQitSsb3rl5xQS7wCgyXXVw3idLT/TCkyPKGGG/LMS
1dEAn0cgUcrJQgkwZr+8+8l7qqm8u1rq
=Jhm+
-----END PGP SIGNATURE-----

--------------enig936F390CBEBB2E47DFA3B650--
