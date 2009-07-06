Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZGFQmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZGFQmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZGFQmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:42:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35298 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZGFQmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:42:15 -0400
Message-ID: <4A522957.4070901@novell.com>
Date: Mon, 06 Jul 2009 12:41:59 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com> <4A50723E.6030305@redhat.com> <4A521082.40209@novell.com> <20090706161331.GB12399@redhat.com>
In-Reply-To: <20090706161331.GB12399@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig876F54E66A597CD768547591"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig876F54E66A597CD768547591
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jul 06, 2009 at 10:56:02AM -0400, Gregory Haskins wrote:
>  =20
>> Avi Kivity wrote:
>>    =20
>>> On 07/02/2009 06:50 PM, Avi Kivity wrote:
>>>      =20
>>>> On 07/02/2009 06:37 PM, Gregory Haskins wrote:
>>>>        =20
>>>>> (Applies to kvm.git/master:1f9050fd)
>>>>>
>>>>> The following is the latest attempt to fix the races in
>>>>> irqfd/eventfd, as
>>>>> well as restore DEASSIGN support.  For more details, please read th=
e
>>>>> patch
>>>>> headers.
>>>>>
>>>>> As always, this series has been tested against the kvm-eventfd unit=

>>>>> test
>>>>> and everything appears to be functioning properly. You can download=

>>>>> this
>>>>> test here:
>>>>>          =20
>>>> Applied, thanks.
>>>>
>>>>        =20
>>> ... and unapplied.  There's a refcounting mismatch in irqfd_cleanup: =
a
>>> reference is taken for each irqfd, but dropped for each guest.  This
>>> causes an oops if a guest with no irqfds is created and destroyed:
>>>      =20
>> I was able to reproduce this issue.  The problem turned out to be that=
 I
>> inadvertently always did a flush_workqueue(), even if the work-queue w=
as
>> never initialized.  =20
>>
>> The following interdiff applied to the reverted patch has been confirm=
ed
>> to fix the issue:
>>    =20
>
> Could you document the init boolean and its locking rules?
> The best place to put it would be where the field is declared btw.
>  =20

Will do

> Is it true that init =3D=3D=3D list_empty(&kvm->irqfds.items)?
> If yes maybe we don't need this field at all.
>
>  =20
No, because its more difficult to maintain the work-queue when
referenced against active irqfds (*).  So instead, its maintained
against guests that use irqfd, whether they have an active irqfd or
not.  Otherwise you have to contend with the eventfd-side release, which
is a little tricky.

(*) I'm sure its not rocket science to get this working, but it was
getting more complex than I thought it was worth, so I simplified the
model to be per-vm.  Note that this design decision/limitation is
declared in the patch header.
>  =20
>> -------------------
>>
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index fcc3469..52b0e04 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -318,6 +318,9 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gs=
i)
>>         struct _irqfd *irqfd, *tmp;
>>         struct eventfd_ctx *eventfd;
>> =20
>> +       if (!kvm->irqfds.init)
>> +               return -ENOENT;
>> +
>>         eventfd =3D eventfd_ctx_fdget(fd);
>>         if (IS_ERR(eventfd))
>>                 return PTR_ERR(eventfd);
>>    =20
>
> wouldn't it be cleaner to error out in the for each loop if we don't
> find an entry to deactivate?  Might be helpful for apps to get an error=

> if they didn't deassign anything.
>  =20

Again, irqfds.init is somewhat orthogonal to whether the list is
populated or not.  This check is for sanity (how can you deassign if you
didnt assign, etc).  Normally this would be a simple BUG_ON() sanity
check, but I don't want a malicious/broken userspace to gain an easy
attack vector ;)

>  =20
>> @@ -360,6 +363,9 @@ kvm_irqfd_release(struct kvm *kvm)
>>  {
>>         struct _irqfd *irqfd, *tmp;
>> =20
>> +       if (!kvm->irqfds.init)
>> +               return;
>> +
>>    =20
>
> So here, I recall some old comment that flush below was
> needed even if list is empty. Is this no longer true?
>  =20

If you are using irqfd, its true.  If irqfds.init =3D=3D false, you are n=
ot
using irqfd and thus the flush cannot be needed.

> If not it might be cleaner to only flush if list is not empty.
>
>  =20
You have to flush if irqfds.init =3D=3D true even if the list is empty
because you need to be sure that eventfd-side releases complete.  They
may have already removed themselves from the list, but the work-item is
still in flight.

Regards,
-Greg


--------------enig876F54E66A597CD768547591
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpSKVsACgkQlOSOBdgZUxljJQCghOtMagpLO1EX1Dt8+vD7Kl6d
vL0An2GMmDvxamfprTuHn2lcGa7aHOc6
=2CtY
-----END PGP SIGNATURE-----

--------------enig876F54E66A597CD768547591--
