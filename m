Return-Path: <linux-kernel-owner+w=401wt.eu-S933288AbZJHXTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbZJHXTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbZJHXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:19:22 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:34240 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbZJHXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:19:21 -0400
Message-ID: <4ACE734D.10600@web.de>
Date: Fri, 09 Oct 2009 01:18:37 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4: kvm 2/4] Kill the confusing tsc_ref_khz and ref_freq
 variables.
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com> <1254260317-3490-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254260317-3490-2-git-send-email-zamsden@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig84BEC9CFF08826DDD3E64060"
X-Provags-ID: V01U2FsdGVkX198CCcQGAr9xXu0v96Sq58zLxsa2cf7DoIMokDv
	UOf/qY8jDYH5p/iuoELxQOW+C+Bff42nIqFNKeapBMMEpvQ6EP
	yD+IB/6lA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig84BEC9CFF08826DDD3E64060
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Zachary Amsden wrote:
> They are globals, not clearly protected by any ordering or locking, and=

> vulnerable to various startup races.
>=20
> Instead, for variable TSC machines, register the cpufreq notifier and g=
et
> the TSC frequency directly from the cpufreq machinery.  Not only is it
> always right, it is also perfectly accurate, as no error prone measurem=
ent
> is required.
>=20
> On such machines, when a new CPU online is brought online, it isn't cle=
ar what
> frequency it will start with, and it may not correspond to the referenc=
e, thus
> in hardware_enable we clear the cpu_tsc_khz variable to zero and make s=
ure
> it is set before running on a VCPU.
>=20
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 15d2ace..de4ce8f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1326,6 +1326,8 @@ out:
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	kvm_x86_ops->vcpu_load(vcpu, cpu);
> +	if (unlikely(per_cpu(cpu_tsc_khz, cpu) =3D=3D 0))
> +		per_cpu(cpu_tsc_khz, cpu) =3D cpufreq_quick_get(cpu);
>  	kvm_request_guest_time_update(vcpu);
>  }
> =20
> @@ -3061,9 +3063,6 @@ static void bounce_off(void *info)
>  	/* nothing */
>  }
> =20
> -static unsigned int  ref_freq;
> -static unsigned long tsc_khz_ref;
> -
>  static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsign=
ed long val,
>  				     void *data)
>  {
> @@ -3072,14 +3071,11 @@ static int kvmclock_cpufreq_notifier(struct not=
ifier_block *nb, unsigned long va
>  	struct kvm_vcpu *vcpu;
>  	int i, send_ipi =3D 0;
> =20
> -	if (!ref_freq)
> -		ref_freq =3D freq->old;
> -
>  	if (val =3D=3D CPUFREQ_PRECHANGE && freq->old > freq->new)
>  		return 0;
>  	if (val =3D=3D CPUFREQ_POSTCHANGE && freq->old < freq->new)
>  		return 0;
> -	per_cpu(cpu_tsc_khz, freq->cpu) =3D cpufreq_scale(tsc_khz_ref, ref_fr=
eq, freq->new);
> +	per_cpu(cpu_tsc_khz, freq->cpu) =3D freq->new;
> =20
>  	spin_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> @@ -3120,12 +3116,14 @@ static void kvm_timer_init(void)
>  {
>  	int cpu;
> =20
> -	for_each_possible_cpu(cpu)
> -		per_cpu(cpu_tsc_khz, cpu) =3D tsc_khz;
>  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> -		tsc_khz_ref =3D tsc_khz;
>  		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>  					  CPUFREQ_TRANSITION_NOTIFIER);
> +		for_each_online_cpu(cpu)
> +			per_cpu(cpu_tsc_khz, cpu) =3D cpufreq_get(cpu);

This doesn't build for !CONFIG_CPU_FREQ.

Jan


--------------enig84BEC9CFF08826DDD3E64060
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkrOc1IACgkQitSsb3rl5xTnwwCff/U/3tB+jV9WTM2uVnZYuomp
JSYAni0vFT1G5X7kvtD9v6McVadyY3Y/
=eMUR
-----END PGP SIGNATURE-----

--------------enig84BEC9CFF08826DDD3E64060--
