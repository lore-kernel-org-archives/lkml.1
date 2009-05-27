Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbZE0Mym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbZE0Mym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761247AbZE0Myc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:54:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51262 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760224AbZE0Myc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:54:32 -0400
Message-ID: <4A1D37FF.9080402@novell.com>
Date: Wed, 27 May 2009 08:54:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191539.20860.1385.stgit@dev.haskins.net> <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com> <4A1D2DD8.2050709@redhat.com>
In-Reply-To: <4A1D2DD8.2050709@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC47BBB80BA26C6156715CFCA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC47BBB80BA26C6156715CFCA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>
>>> What happens if you register to iosignalfds for the same address but
>>> with different cookies (a very practical scenario)?
>>>    =20
>>
>> This is really only supported at the iosignal interface level.  Today,=

>> you can do this and the registration will succeed, but at run-time an
>> IO-exit will stop at the first in_range() hit it finds.  Therefore, yo=
u
>> will only get service on the first/lowest registered range.
>>
>> I knew this was a limitation of the current io_bus, but I put the
>> feature into iosignalfd anyway so that the user/kern interface was
>> robust enough to support the notion should we ever need it (and can th=
us
>> patch io_bus at that time).  Perhaps that is short-sighted because
>> userspace would never know its ranges weren't really registered
>> properly.
>>
>> I guess its simple enough to have io_bus check all devices for a match=

>> instead of stopping on the first.  Should I just make a patch to fix
>> this, or should I fix iosignalfd to check for in_range matches and fai=
l
>> if it finds overlap?  (We could then add a CAP_OVERLAP_IO bit in the
>> future if we finally fix the io_bus capability).  I am inclined to lea=
n
>> towards option 2, since its not known whether this will ever be useful=
,
>> and io_bus scanning is in a hot-path.
>>
>> Thinking about it some more, I wonder if we should just get rid of the=

>> notion of overlap to begin with.  Its a slippery slope (should we also=

>> return to userspace after scanning and matching io_bus to see if it ha=
s
>> any overlap too?).  I am not sure if it would ever be used (real
>> hardware doesn't have multiple devices at the same address), and we ca=
n
>> always have multiple end-points mux from one iosignalfd if we really
>> need that.  Thoughts?
>>  =20
>
> Multiple cookies on the same address are required by virtio.  You
> can't mux since the data doesn't go anywhere.

Hmm..well, I might not be understanding properly, but I think we are
still ok.  IIUC, the concept is that we can register multiple
iosignalfds to trigger when a single range of [MM|P]IO is touched.  I.e.
one iowrite() triggers multiple eventfd_signal()s to go out.  You could
do this directly by having io_bus support multiple matches for
in_range().  You could also use a mux concept where one registration
fans out to multiple iosignalfds (either like you suggest below, or by
having one iosignalfd mux/relay to the others...I like your idea below
better, btw).

Or am I missing something?

>
>
> Virtio can survive by checking all rings on a notify, and we can later
> add a mechanism that has a distinct address for each ring, but let's
> see if we can cope with multiple cookies.  Mark?

I am confused by this.  I can totally see the use case for one
iosignalfd (w/ one address) for all rings (in a device), and one
iosignalfd per ring (each with a unique address).  But when would we
want to have one address serve multiple rings each with their own
notification?  Just curious.

>
>
> You could search existing iosignalfds for the same address and re-use
> the same iodevice.  I don't want to search the entire list since that
> precludes tricks like using hashtables or sorting the list by
> frequency of access.
>
Yeah, I like this idea best.  I can basically have my own "in_range"
mechanism inside the _iosignalfd structure.  I only register one range
with io_bus, but then I may have multiple targets within that.  I will
do this for v5.

-Greg




--------------enigC47BBB80BA26C6156715CFCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodOAMACgkQlOSOBdgZUxm7dgCeN+mgrWGzr8+HPIG94oOB0AQN
4JIAn30vUtci3IKeC9blLs7z2sZLO2bK
=c+qT
-----END PGP SIGNATURE-----

--------------enigC47BBB80BA26C6156715CFCA--
