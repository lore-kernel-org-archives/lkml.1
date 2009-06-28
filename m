Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbZF1M7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbZF1M7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZF1M7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:59:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47634 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1M7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:59:33 -0400
Message-ID: <4A476927.4010900@novell.com>
Date: Sun, 28 Jun 2009 08:59:19 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 0/4] irqfd fixes and enhancements
References: <20090625132441.26748.641.stgit@dev.haskins.net> <4A4382AE.8000508@novell.com> <4A474E04.3070608@redhat.com>
In-Reply-To: <4A474E04.3070608@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig49AF9EACAE485CFBC2ECEB22"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig49AF9EACAE485CFBC2ECEB22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/25/2009 04:59 PM, Gregory Haskins wrote:
>> Gregory Haskins wrote:
>>  =20
>>> (Applies to kvm.git/master:4631e094)
>>>
>>> The following is the latest attempt to fix the races in
>>> irqfd/eventfd, as
>>> well as restore DEASSIGN support.  For more details, please read the
>>> patch
>>> headers.
>>>
>>> This series has been tested against the kvm-eventfd unit test, and
>>> appears to be functioning properly.  You can download this test here:=

>>>
>>> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>>>
>>> I've included version 4 of Davide's eventfd patch (ported to
>>> kvm.git) so
>>> that its a complete reviewable series.  Note, however, that there
>>> may be
>>> later versions of his patch to consider for merging, so we should
>>> coordinate with him.
>>>
>>>     =20
>>
>> So I know we talked yesterday in the review session about whether it w=
as
>> actually worth all this complexity to deal with the POLLHUP or if we
>> should just revert to the prior "two syscall" model and be done with
>> it.  Rusty reflected these same sentiments this morning in response to=

>> Davide's patch in a different thread.
>>
>> I am a bit torn myself, tbh.  I do feel as though I have a good handle=

>> on the issue and that it is indeed now fixed (at least, if this series=

>> is applied and the slow-work issue is fixed, still pending upstream
>> ACK).  I have a lot invested in going the POLLHUP direction having spe=
nt
>> so much time thinking about the problem and working on the patches, so=
 I
>> a bit of a biased opinion, I know.
>>
>> The reason why I am pushing this series out now is at least partly so =
we
>> can tie up these loose ends.  We have both solutions in front of us an=
d
>> can make a decision either way.  At least the solution is formally
>> documented in the internet archives forever this way ;)
>>
>> I took the review comments to heart that the shutdown code was
>> substantially larger and more complex than the actual fast-path code. =
 I
>> went though last night and simplified and clarified it.  I think the
>> latest result is leaner and clearer, so please give it another review
>> (particularly for races) before dismissing it.
>>   =20
>
> Yes, it's much nicer.  I can't say I'm certain it's race free but it's
> a lot more digestible
>
>> Ultimately, I think the concept of a release notification for eventfd =
is
>> a good thing for all eventfd users, so I don't think this thing should=

>> go away per se even if irqfd decides to not use it.
>>   =20
>
> I agree that we want POLLHUP support, it's better than holding on to
> the eventfd.  But I think we can make it even cleaner by merging it
> with deassign.  Basically, when we get POLLHUP, we launch a slow_work
> (or something) that does a regular deassign.  That slow_work can grab
> a ref to the vm, so we don't race with the VM disappearing.
>
> But given that the current slow_work does almost nothing, I'm not sure
> it's worth it.

Yeah, and also note that the algorithm to unhook each side is not quite
symmetrical.  I think I've captured all the common parts (in things like
irqfd_deactivate(), etc).  A minor change in kvm_irqfd_release() could
technically use a deferred job to release instead of doing it inline,
but I do not think it buys us very much to do so (as you pointed out,
the defered part is actually fairly simple).  The important parts of the
protocol lie outside of the work we can do in the work-item anyway.


-Greg


--------------enig49AF9EACAE485CFBC2ECEB22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpHaSwACgkQlOSOBdgZUxl+xQCfX6XB9hOOkUsqsqfkZWQUEQKx
MQwAniOiYDC929qFWY9tB0cH8qcj2QL9
=uXLy
-----END PGP SIGNATURE-----

--------------enig49AF9EACAE485CFBC2ECEB22--
