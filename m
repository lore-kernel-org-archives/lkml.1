Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZFCWEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZFCWEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZFCWEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:04:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:4806 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZFCWEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=gq2ma+6td7LPUCUl20eJUOSa2UJfxuCv/6Wq7FUEnHmbsbIGDJaWwRGZfo2jzrx+Ig
         gaSz4Zo/SYowwTe2ugiE1NIjdLvYerOqBFh4ieGVS8x8Usi9VtYFL5IA6iCPIVdkNk7E
         79LlFAZsJGV8KlNx0LoKmKvCxXI4/uz68RzUo=
Message-ID: <4A26F35E.1090307@gmail.com>
Date: Wed, 03 Jun 2009 18:04:14 -0400
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
 boundary="------------enig74524F6DFFF19D72586B4148"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig74524F6DFFF19D72586B4148
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
>
> The virtio ABI is fixed, so we couldn't e.g. have the guest use a cooki=
e
> to identify a queue - it's just going to continue using a per-device
> queue number. So, if the cookie was also the trigger, we'd need an
> eventfd per device.
>
> And if this was a device where the guest writes similar values to
> multiple addresses, you'd need an eventfd per address.
>
>  =20

Hi Mark,
  So with the v5 release of iosignalfd, we now have the notion of a
"trigger", the API of which is as follows:

-----------------------
/*!
 * \brief Assign an eventfd to an IO port (PIO or MMIO)
 *
 * Assigns an eventfd based file-descriptor to a specific PIO or MMIO
 * address range.  Any guest writes to the specified range will generate
 * an eventfd signal.
 *
 * A data-match pointer can be optionally provided in "trigger" and only
 * writes which match this value exactly will generate an event.  The len=
gth
 * of the trigger is established by the length of the overall IO range, a=
nd
 * therefore must be in a natural byte-width for the IO routines of your
 * particular architecture (e.g. 1, 2, 4, or 8 bytes on x86_64).
 *
 * \param kvm Pointer to the current kvm_context
 * \param addr The IO address
 * \param len The length of the IO region at the address
 * \param fd The eventfd file-descriptor
 * \param trigger A optional pointer providing data-match token
 * \param flags FLAG_PIO: PIO, else MMIO
 */
int kvm_assign_iosignalfd(kvm_context_t kvm, unsigned long addr, size_t l=
en,
              int fd, void *trigger, int flags);
-----------------

in the kvm-eventfd test harness, I create three unique eventfd handles,
and do the following:


-------------------

    unsigned char matchA =3D 0xa5, matchB =3D 0x42;

    kvm_assign_iosignalfd(kvm_context, addr, 1, fd[0], NULL, 0);
    kvm_assign_iosignalfd(kvm_context, addr, 1, fd[1], &matchA, 0);
    kvm_assign_iosignalfd(kvm_context, addr, 1, fd[2], &matchB, 0);

-------------------

In otherwords, I register a "NULL" trigger (wildcarded) on the first
fd.  The second has a data-match trigger of 0xa5, and the third has
0x42.  All three of these eventfd's map to the same mmio address with a
width of 1 byte.

I also fork a task which selects all three fds, and will print out the
eventfd "count" value when tripped.

Then, in the guest, I do:

----------------------

    iowrite8(0, iosignalfd_mmio);
    iowrite8(0xa5, iosignalfd_mmio);
    iowrite8(0x42, iosignalfd_mmio);

-------------------

The result of which is:

IOSIGNALFD 0: event triggered with val 3
IOSIGNALFD 1: event triggered with val 1
IOSIGNALFD 2: event triggered with val 1

on the host, which is my expected outcome.  Let me know if you do not
think this is sufficient to implement a solution to your virtio-pci desig=
n.

-Greg


--------------enig74524F6DFFF19D72586B4148
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkom82UACgkQP5K2CMvXmqHynQCeO2yC6pYyRxqMIxDpswusqIsa
CwUAoIGMkdzjjhWchjXBhH1ORRgUVtvk
=Ry6r
-----END PGP SIGNATURE-----

--------------enig74524F6DFFF19D72586B4148--
