Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZEHLKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZEHLKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZEHLJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:09:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49098 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZEHLJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:09:49 -0400
Message-ID: <4A0412EF.2060204@novell.com>
Date: Fri, 08 May 2009 07:09:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A03E644.5000103@redhat.com>
In-Reply-To: <4A03E644.5000103@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1C1A81A9DBB2FCB360BE892C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C1A81A9DBB2FCB360BE892C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Marcelo Tosatti wrote:
>> I think comparison is not entirely fair. You're using
>> KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes th=
at
>> (on Intel) to only one register read:
>>
>>         nr =3D kvm_register_read(vcpu, VCPU_REGS_RAX);
>>
>> Whereas in a real hypercall for (say) PIO you would need the address,
>> size, direction and data.
>>  =20
>
> Well, that's probably one of the reasons pio is slower, as the cpu has
> to set these up, and the kernel has to read them.

Right, that was the point I was trying to make.  Its real-world overhead
to measure how long it takes KVM to go round-trip in each of the
respective trap types.

>
>> Also for PIO/MMIO you're adding this unoptimized lookup to the
>> measurement:
>>
>>         pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
>>         if (pio_dev) {
>>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>>                 complete_pio(vcpu);                 return 1;
>>         }
>>  =20
>
> Since there are only one or two elements in the list, I don't see how
> it could be optimized.

To Marcelo's point, I think he was more taking exception to the fact
that the HC path was potentially completely optimized out if GCC was
super-intuitive about the switch(nr) statement hitting the null vector.=20
In theory, both the io_bus and the select(nr) are about equivalent in
algorithmic complexity (and depth, I should say) which is why I think in
general the test is "fair".  IOW it represents the real-world decode
cycle function for each transport.

However, if one side was artificially optimized simply due to the
triviality of my NULLIO test, that is not fair, and that is the point I
believe he was making.  In any case, I just wrote a new version of the
test which hopefully addresses forces GCC to leave it as a more
real-world decode.  (FYI: I saw no difference).  I will update the
tarball/wiki shortly.

>
>> Whereas for hypercall measurement you don't. I believe a fair comparis=
on
>> would be have a shared guest/host memory area where you store guest/ho=
st
>> TSC values and then do, on guest:
>>
>>     rdtscll(&shared_area->guest_tsc);
>>     pio/mmio/hypercall
>>     ... back to host
>>     rdtscll(&shared_area->host_tsc);
>>
>> And then calculate the difference (minus guests TSC_OFFSET of course)?=

>>  =20
>
> I don't understand why you want host tsc?  We're interested in
> round-trip latency, so you want guest tsc all the time.

Yeah, I agree.  My take is he was just trying to introduce a real
workload so GCC wouldn't do that potential "cheater decode" in the HC
path.  After thinking about it, however, I realized we could do that
with a simple "state++" operation, so the new test does this in each of
the various test's "execute" cycle.  The timing calculation remains
unchanged.

-Greg



--------------enig1C1A81A9DBB2FCB360BE892C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEEvAACgkQlOSOBdgZUxlI0wCfcqiqzObH+IA6c1O8NuTenbQM
xzgAn3t05yeEx2JYU7y9P87g/brDF5oY
=RjKT
-----END PGP SIGNATURE-----

--------------enig1C1A81A9DBB2FCB360BE892C--
