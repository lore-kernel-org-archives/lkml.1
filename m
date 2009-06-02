Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZFBQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZFBQee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZFBQe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:34:26 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50437 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZFBQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:34:25 -0400
Message-ID: <4A255484.6060401@novell.com>
Date: Tue, 02 Jun 2009 12:34:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com>
In-Reply-To: <20090602162021.GB6827@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58F3DA7366B755CF7149431A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58F3DA7366B755CF7149431A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2009 at 12:14:15PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Tue, Jun 02, 2009 at 11:15:28AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> (Applies to kvm.git/master:25deed73)
>>>>
>>>> Please see the header for 2/2 for a description.  This patch series =
has
>>>> been fully tested and appears to be working correctly.  I have it as=
 an RFC
>>>> for now because it needs Davide's official submission/SOB for patch =
1/2, and
>>>> it should get some eyeballs/acks on my SRCU usage before going in.
>>>>
>>>> I will submit the updated irqfd userspace which eschews the deassign=
() verb
>>>> since we can now just use the close(fd) method alone.  I will also a=
ddress
>>>> the userspace review comments from Avi.
>>>>    =20
>>>>        =20
>>> We are not killing the deassign though, do we?
>>>  =20
>>>      =20
>> Yes, it is not needed any more now that we have proper
>> release-notification from eventfd.
>>
>>    =20
>>> It's good to have that option e.g. for when we pass
>>> the fd to another process.
>>>  =20
>>>      =20
>> Passing the fd to another app should up the underlying file reference
>> count.  If the producer app wants to "deassign" it simply calls
>> close(fd) (as opposed to today where it calls DEASSIGN+close), but the=

>> reference count will allow the consuming app to leave the eventfd's fi=
le
>> open.  Or am I misunderstanding you?
>>
>> -Greg
>>
>>
>>    =20
>
> I think we want to keep supporting the deassign ioctl. This, even thoug=
h
> close overlaps with it functionally somewhat.
>
> This allows qemu to pass eventfd to another process/device, and then
> block/unblock interrupts as seen by that process by
> assigning/deassigning irq to it. This is much easier and lightweight
> than asking another process to close the fd and passing another fd
> later.
>
>  =20
Perhaps, but if that is the case we should just ignore this series and
continue with the DEASSIGN+close methodology since it already provides
that separation.  Trying to do a hybrid is just messy.

But in any case, I think that approach is flawed.  DEASSIGN shouldn't be
used as a mask in my opinion, and we shouldn't be reassigning a
channel's meaning under the covers like that.  If this is in fact a
valid use case, we should have a separate "GSI_MASK" type operation that
is independent of irqfd.  Likewise, we really should pass a new fd if
the gsi-routing is changing.  Today there is a tight coupling of
fd-to-gsi, and I think that makes sense to continue this association.

-Greg


--------------enig58F3DA7366B755CF7149431A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkolVIcACgkQlOSOBdgZUxmUqgCeJ53bI0Hfw1iDOB4/OPnGaGC+
VKEAnRHEkVaiwFyehYyTIYA8e26AEpf8
=94eC
-----END PGP SIGNATURE-----

--------------enig58F3DA7366B755CF7149431A--
