Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZEHDNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZEHDNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZEHDNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:13:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48604 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZEHDNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:13:22 -0400
Message-ID: <4A03A34C.3000109@novell.com>
Date: Thu, 07 May 2009 23:13:16 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet>
In-Reply-To: <20090507233503.GA9103@amt.cnet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig73A9A3EBCBAFD4DFD80678E7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73A9A3EBCBAFD4DFD80678E7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Marcelo Tosatti wrote:
> On Thu, May 07, 2009 at 01:03:45PM -0400, Gregory Haskins wrote:
>  =20
>> Chris Wright wrote:
>>    =20
>>> * Gregory Haskins (ghaskins@novell.com) wrote:
>>>  =20
>>>      =20
>>>> Chris Wright wrote:
>>>>    =20
>>>>        =20
>>>>> VF drivers can also have this issue (and typically use mmio).
>>>>> I at least have a better idea what your proposal is, thanks for
>>>>> explanation.  Are you able to demonstrate concrete benefit with it =
yet
>>>>> (improved latency numbers for example)?
>>>>>      =20
>>>>>          =20
>>>> I had a test-harness/numbers for this kind of thing, but its a bit
>>>> crufty since its from ~1.5 years ago.  I will dig it up, update it, =
and
>>>> generate/post new numbers.
>>>>    =20
>>>>        =20
>>> That would be useful, because I keep coming back to pio and shared
>>> page(s) when think of why not to do this.  Seems I'm not alone in tha=
t.
>>>
>>> thanks,
>>> -chris
>>>  =20
>>>      =20
>> I completed the resurrection of the test and wrote up a little wiki on=

>> the subject, which you can find here:
>>
>> http://developer.novell.com/wiki/index.php/WhyHypercalls
>>
>> Hopefully this answers Chris' "show me the numbers" and Anthony's "Why=

>> reinvent the wheel?" questions.
>>
>> I will include this information when I publish the updated v2 series
>> with the s/hypercall/dynhc changes.
>>
>> Let me know if you have any questions.
>>    =20
>
> Greg,
>
> I think comparison is not entirely fair. You're using
> KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes tha=
t
> (on Intel) to only one register read:
>
>         nr =3D kvm_register_read(vcpu, VCPU_REGS_RAX);
>
> Whereas in a real hypercall for (say) PIO you would need the address,
> size, direction and data.
>  =20

Hi Marcelo,
   I'll have to respectfully disagree with you here.  What you are
proposing is actually a different test: a 4th type I would call  "PIO
over HC".  It is distinctly different than the existing MMIO, PIO, and
HC tests already present.

I assert that the current HC test remains valid because for pure
hypercalls, the "nr" *is* the address.  It identifies the function to be
executed (e.g. VAPIC_POLL_IRQ =3D null), just like the PIO address of my
nullio device identifies the function to be executed (i.e.
nullio_write() =3D null)

My argument is that the HC test emulates the "dynhc()" concept I have
been talking about, whereas the PIOoHC is more like the
pv_io_ops->iowrite approach.

That said, your 4th test type would actually be a very interesting
data-point to add to the suite (especially since we are still kicking
around the notion of doing something like this).  I will update the
patches.


> Also for PIO/MMIO you're adding this unoptimized lookup to the=20
> measurement:
>
>         pio_dev =3D vcpu_find_pio_dev(vcpu, port, size, !in);
>         if (pio_dev) {
>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>                 complete_pio(vcpu);=20
>                 return 1;
>         }
>
> Whereas for hypercall measurement you don't.

In theory they should both share about the same algorithmic complexity
in the decode-stage, but due to the possible optimization you mention
you may have a point.  I need to take some steps to ensure the HC path
isn't artificially simplified by GCC (like making the execute stage do
some trivial work like you mention below).

>  I believe a fair comparison
> would be have a shared guest/host memory area where you store guest/hos=
t
> TSC values and then do, on guest:
>
> 	rdtscll(&shared_area->guest_tsc);
> 	pio/mmio/hypercall
> 	... back to host
> 	rdtscll(&shared_area->host_tsc);
>
> And then calculate the difference (minus guests TSC_OFFSET of course)?
>
>  =20
I'm not sure I need that much complexity.  I can probably just change
the test harness to generate an ioread32(), and have the functions
return the TSC value as a return parameter for all test types.  The
important thing is that we pick something extremely cheap (yet dynamic)
to compute so the execution time doesn't invalidate the measurement
granularity with a large constant.

Regards,
-Greg



--------------enig73A9A3EBCBAFD4DFD80678E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDo0wACgkQlOSOBdgZUxk02ACfVq1ZAQ/UUSjM830ltsDgVtn1
7TAAniRtwLSW9T9JkvuHH2S9XrviLtUc
=41pj
-----END PGP SIGNATURE-----

--------------enig73A9A3EBCBAFD4DFD80678E7--
