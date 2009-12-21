Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZLURo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZLURo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZLURoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:44:25 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37606 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZLURoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=SwlzLa7QFbAOueWADTYVFUaAS1PasmNW6O0FvSRXtXgO0frdhS85N2saA1OM/jKz2i
         B9y7yw5KDjgjG8RAcAVKK2jbaDHrpiHMFXqkd7DFDYYy/HCPaaZCAjrO6BOISEOJQ9On
         P1wiUwmcUIlsvQR2fZRdKDlJ/jLqCITlzmsG0=
Message-ID: <4B2FB3F1.5080808@gmail.com>
Date: Mon, 21 Dec 2009 12:44:17 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA655.6030205@gmail.com> <4B2FAE7B.9030005@codemonkey.ws>
In-Reply-To: <4B2FAE7B.9030005@codemonkey.ws>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB62B8801782B5A8A07FEA861"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB62B8801782B5A8A07FEA861
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/21/09 12:20 PM, Anthony Liguori wrote:
> On 12/21/2009 10:46 AM, Gregory Haskins wrote:
>> The very best you can hope to achieve is 1:1 EOI per signal (though
>> today virtio-pci is even worse than that).  As I indicated above, I ca=
n
>> eliminate more than 50% of even the EOIs in trivial examples, and even=

>> more as we scale up the number of devices or the IO load (or both).
>>   =20
>=20
> If optimizing EOI is the main technical advantage of vbus, then surely
> we could paravirtualize EOI access and get that benefit in KVM without
> introducing a whole new infrastructure, no?

No, because I never claimed optimizing EOI was the main/only advantage.
 The feature set has all been covered in extensive detail in the lists,
however, so I will defer you to google for the archives for your reading
pleasure.

>=20
>>> This is a
>>> light weight exit today and will likely disappear entirely with newer=

>>> hardware.
>>>     =20
>> By that argument, this is all moot.  New hardware will likely obsolete=

>> the need for venet or virtio-net anyway.
>=20
> Not at all.

Well, surely something like SR-IOV is moving in that direction, no?

> But let's focus on concrete data.  For a given workload,
> how many exits do you see due to EOI?

Its of course highly workload dependent, and I've published these
details in the past, I believe.  Off the top of my head, I recall that
virtio-pci tends to throw about 65k exits per second, vs about 32k/s for
venet on a 10GE box, but I don't recall what ratio of those exits are
EOI.  To be perfectly honest, I don't care.  I do not discriminate
against the exit type...I want to eliminate as many as possible,
regardless of the type.  That's how you go fast and yet use less CPU.

>  They should be relatively rare
> because obtaining good receive batching is pretty easy.

Batching is poor mans throughput (its easy when you dont care about
latency), so we generally avoid as much as possible.

> Considering
> these are lightweight exits (on the order of 1-2us),

APIC EOIs on x86 are MMIO based, so they are generally much heavier than
that.  I measure at least 4-5us just for the MMIO exit on my Woodcrest,
never mind executing the locking/apic-emulation code.

> you need an awfully
> large amount of interrupts before you get really significant performanc=
e
> impact.  You would think NAPI would kick in at this point anyway.
>

Whether NAPI can kick in or not is workload dependent, and it also does
not address coincident events.  But on that topic, you can think of
AlacrityVM's interrupt controller as "NAPI for interrupts", because it
operates on the same principle.  For what its worth, it also operates on
a "NAPI for hypercalls" concept too.

> Do you have data demonstrating the advantage of EOI mitigation?

I have non-scientifically gathered numbers in my notebook that put it on
average of about 55%-60% reduction in EOIs for inbound netperf runs, for
instance.  I don't have time to gather more in the near term, but its
typically in that range for a chatty enough workload, and it goes up as
you add devices.  I would certainly formally generate those numbers when
I make another merge request in the future, but I don't have them now.

Kind Regards,
-Greg


--------------enigB62B8801782B5A8A07FEA861
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksvs/IACgkQP5K2CMvXmqE3lACfU/MB++J44MGGilA1v+0/jVGN
D7YAoI1ohE5cdr5/MZJpsQFS7nPki1FW
=WA19
-----END PGP SIGNATURE-----

--------------enigB62B8801782B5A8A07FEA861--
