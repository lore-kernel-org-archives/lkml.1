Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZFBRl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZFBRl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZFBRlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:41:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57906 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbZFBRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:41:15 -0400
Message-ID: <4A256431.2080101@novell.com>
Date: Tue, 02 Jun 2009 13:41:05 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com>
In-Reply-To: <20090602165949.GD6827@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC97E0E85518CE7FCC63077F1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC97E0E85518CE7FCC63077F1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2009 at 12:34:12PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Tue, Jun 02, 2009 at 12:14:15PM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> Michael S. Tsirkin wrote:
>>>>    =20
>>>>        =20
>>>>> On Tue, Jun 02, 2009 at 11:15:28AM -0400, Gregory Haskins wrote:
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>>>> (Applies to kvm.git/master:25deed73)
>>>>>>
>>>>>> Please see the header for 2/2 for a description.  This patch serie=
s has
>>>>>> been fully tested and appears to be working correctly.  I have it =
as an RFC
>>>>>> for now because it needs Davide's official submission/SOB for patc=
h 1/2, and
>>>>>> it should get some eyeballs/acks on my SRCU usage before going in.=

>>>>>>
>>>>>> I will submit the updated irqfd userspace which eschews the deassi=
gn() verb
>>>>>> since we can now just use the close(fd) method alone.  I will also=
 address
>>>>>> the userspace review comments from Avi.
>>>>>>    =20
>>>>>>        =20
>>>>>>            =20
>>>>> We are not killing the deassign though, do we?
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Yes, it is not needed any more now that we have proper
>>>> release-notification from eventfd.
>>>>
>>>>    =20
>>>>        =20
>>>>> It's good to have that option e.g. for when we pass
>>>>> the fd to another process.
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Passing the fd to another app should up the underlying file referenc=
e
>>>> count.  If the producer app wants to "deassign" it simply calls
>>>> close(fd) (as opposed to today where it calls DEASSIGN+close), but t=
he
>>>> reference count will allow the consuming app to leave the eventfd's =
file
>>>> open.  Or am I misunderstanding you?
>>>>
>>>> -Greg
>>>>
>>>>
>>>>    =20
>>>>        =20
>>> I think we want to keep supporting the deassign ioctl. This, even tho=
ugh
>>> close overlaps with it functionally somewhat.
>>>
>>> This allows qemu to pass eventfd to another process/device, and then
>>> block/unblock interrupts as seen by that process by
>>> assigning/deassigning irq to it. This is much easier and lightweight
>>> than asking another process to close the fd and passing another fd
>>> later.
>>>
>>>  =20
>>>      =20
>> Perhaps, but if that is the case we should just ignore this series and=

>> continue with the DEASSIGN+close methodology since it already provides=

>> that separation. Trying to do a hybrid is just messy.
>>    =20
>
> As I see it, it's the least evil.
>  =20

Which?  Leaving the code as is, or a hybrid?
> One-way ioctl operations on file descriptors are messier still. What's
> another example of an ioctl that can't be undone without closing the fd=
?
>  =20
-ENOPARSE

> And having close not clean up the state unless you do an ioctl first is=

> very messy IMO - I don't think you'll find any such examples in kernel.=

>
>  =20

I agree, and that is why I am advocating this POLLHUP solution.  It was
only this other way to begin with because the technology didn't exist
until Davide showed me the light.

Problem with your request is that I already looked into what is
essentially a bi-directional reference problem (for a different reason)
when I started the POLLHUP series.  Its messy to do this in a way that
doesn't negatively impact the fast path (introducing locking, etc) or
make my head explode making sure it doesn't race.  Afaict, we would need
to solve this problem to do what you are proposing (patches welcome).

If this hybrid decoupled-deassign + unified-close is indeed an important
feature set, I suggest that we still consider this POLLHUP series for
inclusion, and then someone can re-introduce DEASSIGN support in the
future as a CAP bit extension.  That way we at least get the desirable
close() properties that we both seem in favor of, and get this advanced
use case when we need it (and can figure out the locking design).


>> But in any case, I think that approach is flawed.  DEASSIGN shouldn't =
be
>> used as a mask in my opinion, and we shouldn't be reassigning a
>> channel's meaning under the covers like that.  If this is in fact a
>> valid use case, we should have a separate "GSI_MASK" type operation th=
at
>> is independent of irqfd.
>>  Likewise, we really should pass a new fd if
>> the gsi-routing is changing.  Today there is a tight coupling of
>> fd-to-gsi, and I think that makes sense to continue this association.
>>
>> -Greg
>>
>>    =20
>
> I'm not arguing that this use-case is not theoretical. Just that if you=

> don't create the fd to connect to GSI, you shouln't ask the user to
> destroy it to disconnect.

Well, thats just it.  Today, you *do* create the eventfd to bundle with
the gsi (take a look at my userspace patches..I posted some new ones
today).   The eventfd is returned after you specify the GSI via
kvm_irqfd().  Thats why I am arguing that it is natural for close() to
terminate the assignment.  To me, this is consistent with other
interfaces that return an fd (socket(), open(), etc).

That said, if we are going to support your proposal going forward, we
should probably change libkvm::kvm_irqfd() to take the fd as a
parameter, instead of returning it.


>  Who knows what else this eventfd descriptor
> can be used for?
>  =20

Perhaps, but you are exceeding the original design specifications of
irqfd as it is, so we can't really predict what limitations it will have
for other esoteric uses either.   While I think the masking use case is
bogus, I guess I don't specifically object to what you are proposing
w.r.t. gsi remapping.  Fwiw, this use-case you are presenting would have
been more useful if proposed during the 10+ revisions of design review
on irqfd instead of now, but se la vie.

-Greg



--------------enigC97E0E85518CE7FCC63077F1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkolZDUACgkQlOSOBdgZUxkHGgCeNaeMotTNOu7rKxh2A6eQE5iM
QBwAoIiat26HYHwKbvlyrw+GRT3kBncX
=+0GK
-----END PGP SIGNATURE-----

--------------enigC97E0E85518CE7FCC63077F1--
