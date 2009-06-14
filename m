Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbZFNMij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbZFNMij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZFNMib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:38:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42427 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZFNMia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:38:30 -0400
Message-ID: <4A34EF41.3020301@novell.com>
Date: Sun, 14 Jun 2009 08:38:25 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 0/2] irqfd: use POLLHUP notification for close()
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090612040837.GA8862@redhat.com>
In-Reply-To: <20090612040837.GA8862@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig73AA5C42C449B21EC3135320"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73AA5C42C449B21EC3135320
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> [ Resending with correct address for Davide. Pls don't reply
>   to the original one, you'll get bounces. ]
>
> On Thu, Jun 04, 2009 at 08:48:02AM -0400, Gregory Haskins wrote:
>  =20
>> (Applies to kvm.git/master:25deed73)
>>
>> Please see the header for 2/2 for a description.  This patch series ha=
s been
>> fully tested and appears to be working correctly.
>>
>> [Review notes:
>>       *) Paul has looked at the SRCU design and, to my knowledge, didn=
't find
>>          any holes.
>>       *) Michael, Avi, and myself agree that while the removal of the =
DEASSIGN
>>          vector is not desirable, the fix on close() is more important=
 in
>>          the short-term.  We can always add DEASSIGN support again in =
the
>> 	 future with a CAP bit.
>> ]
>>    =20
>
> So, I've been thinking about this, and this approach has another
> problem: it depends on pollhup on close which is AFAIK an
> eventfd-specific feature.

Thats ok with me, as we are already married to eventfd for other reasons
(see eventfd_fget()).

>  This will prevent us from supporting polling
> other useful file types, such as sockets and pipes, down the road, with=

> this interface.
>  =20
I am thinking that we would add explicit support in the future if there
are other fd types that might want to also inject interrupts.  For
instance, perhaps POLLHUP is added to pipes if/when they are patched as
a valid transport for irqfd.   Or perhaps irqfd is abstracted such that
eventfd_fget/POLLHUP are eventfd specific assign/deassign implementation
details.

Another option is that we s/irqfd/irq-eventfd to leave room for other
interfaces like irq-pollfd, irq-socketfd, etc.  IOW, there is no reason
to make the current irqfd code "one-fd-interface to rule them all" per
se.  The real abstraction is the kvm_set_irq() + gsi interface anyway.=20
The current irqfd code is a thin shim in front of that.  Perhaps each fd
type would be better served with code to specifically handle each type,
for its hard to predict what the requirements for translating, say, a
pipe-write into a gsi-inject will be apriori.

> And there's DEASSIGN issue which is needed for migration

Can you elaborate?  I would think you would need a new fd in the
migration case anyway and therefore a close()/kvm_irqfd() sequence is
required.

>  and MSI vector
> remapping.
>  =20

I would think this can be worked around with close()/kvm_irqfd()
workaround unitl the DEASSIGN cap bit is in place, but I may be
misunderstanding.
> I didn't realise these implications when I suggested deassign on close.=

> To me, it now looks like we are better off reverting this patch.
> We can later add 'deassign on close' support with CAP bit after all :)
>
> Avi, Gregory, what's your take?
>
>  =20
I like the design with the single-call close in place, so my vote is to
keep it as it is now.

Thanks Michael,
-Greg


--------------enig73AA5C42C449B21EC3135320
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko070EACgkQlOSOBdgZUxl08gCeIIw9EcptdjsTpTwLZVxc/Uet
7ZwAnRbWZbI9ftyprOD2hIN7vEeXLLq8
=FzT9
-----END PGP SIGNATURE-----

--------------enig73AA5C42C449B21EC3135320--
