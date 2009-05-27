Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbZE0Upn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbZE0Upn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbZE0UpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:45:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:59859 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbZE0UpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Dd9KrYsH3iV3f4+Df8mKElDSmUbN50PkkBbqBHXsPmMYTN5cZFovCSMFwtOtQB//oS
         3j4F8tpevsLOnZT22BWn6kAbR21UkX/B5J/mUrZjTtMydsiSCespi3q2VsZnG2reiC/h
         yaSvJQl6A8vJE/R5NjzWXJ2KGu/IBaLlZSBRk=
Message-ID: <4A1DA653.4050109@gmail.com>
Date: Wed, 27 May 2009 16:45:07 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net>	 <20090526191539.20860.1385.stgit@dev.haskins.net>	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>	 <4A1D7AFD.40004@novell.com> <1243446484.4852.13.camel@blaa>
In-Reply-To: <1243446484.4852.13.camel@blaa>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig185E1A75A85018C764F6CA13"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig185E1A75A85018C764F6CA13
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mark McLoughlin wrote:
> On Wed, 2009-05-27 at 13:40 -0400, Gregory Haskins wrote:
>  =20
>> Mark McLoughlin wrote:
>>    =20
>>> On Wed, 2009-05-27 at 15:11 +0300, Avi Kivity wrote:
>>>
>>>  =20
>>>      =20
>>>> Multiple cookies on the same address are required by virtio.  You ca=
n't=20
>>>> mux since the data doesn't go anywhere.
>>>>
>>>> Virtio can survive by checking all rings on a notify, and we can lat=
er=20
>>>> add a mechanism that has a distinct address for each ring, but let's=
 see=20
>>>> if we can cope with multiple cookies.  Mark?
>>>>    =20
>>>>        =20
>>> Trying to catch up, but you're talking about replacing virtio-pci
>>> QUEUE_NOTIFY handling with iosignalfd ?
>>>
>>> For a perfect replacement, what you really need is to be able to
>>> register multiple cookies per address range, but only have them trigg=
er
>>> if the written data matches a provided value.
>>>  =20
>>>      =20
>> Hmm..thats an interesting idea.  To date, the "cookie" has really been=

>> for identifying the proper range selected for deassignment.  I never
>> thought of using it as an actual trigger value at run-time.
>>
>>    =20
>>> If the data is lost, virtio has no way of knowing which queue is bein=
g
>>> notified, so we either end up with per-device, rather than per-queue,=

>>> notifications (probably not too bad for net, at least) or a different=

>>> notify address per queue (limiting the number of queues per device).
>>>  =20
>>>      =20
>> The addr-per-queue is how I was envisioning it, but the trigger value
>> concept hadn't occurred to me.  I could make this an option during
>> assignment (e.g. "COOKIE" flag means only trigger on writes of the
>> provided cookie, otherwise trigger on any write).  Sound good?
>>    =20
>
> Ah, I'd been thinking of the trigger data being provided separately to
> the cookie.
>  =20

Yeah, that shouldn't be a problem.  Its probably cleaner, too.  Perhaps
I can simplify things and make the trigger width fixed (say, always
32bit) just so I dont have to support 8,16,32 and 64 variants.

> The virtio ABI is fixed, so we couldn't e.g. have the guest use a cooki=
e
> to identify a queue - it's just going to continue using a per-device
> queue number.=20

Actually, I was originally thinking this would be exposed as a virtio
FEATURE bit anyway, so there were no backwards-compat constraints.  That
said, we can possibly make it work in a backwards compat way, too.=20
IIRC, today virtio does a PIO cycle to a specific register with the
queue-id when it wants to signal guest->host, right?  What is the width
of the write?


> So, if the cookie was also the trigger, we'd need an
> eventfd per device.
>  =20

I'm having trouble parsing this one.  The cookie namespace is controlled
by the userspace component that owns the corresponding IO address, so
there's no reason you can't make "queue-id =3D 0" use cookie =3D 0, or
whatever.  That said, I still think a separation of the cookie and
trigger as suggested above is a good idea, so its probably moot to
discuss this point further.

-Greg



--------------enig185E1A75A85018C764F6CA13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodplMACgkQP5K2CMvXmqGp/ACfWuJhNCiRc92Ia1i+NmCVTa4v
bvAAnR3T7u8+IerBFnB15LgSwAUzR/hO
=yh34
-----END PGP SIGNATURE-----

--------------enig185E1A75A85018C764F6CA13--
