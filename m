Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZGAMb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZGAMb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZGAMbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:31:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53889 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZGAMbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:31:12 -0400
Message-ID: <4A4B570B.3000209@novell.com>
Date: Wed, 01 Jul 2009 08:31:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Davide Libenzi <davidel@xmailserver.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the kvm tree with Linus' tree
References: <20090701145711.1c9c8935.sfr@canb.auug.org.au> <alpine.DEB.1.10.0907010007020.8745@makko.or.mcafeemobile.com> <4A4B1106.8000506@redhat.com>
In-Reply-To: <4A4B1106.8000506@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD70267FF0322A8AFAF7CC498"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD70267FF0322A8AFAF7CC498
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 07/01/2009 10:10 AM, Davide Libenzi wrote:
>> On Wed, 1 Jul 2009, Stephen Rothwell wrote:
>>
>>  =20
>>> Hi Avi,
>>>
>>> Today's linux-next merge of the kvm tree got a conflict in fs/eventfd=
=2Ec
>>> between commit 133890103b9de08904f909995973e4b5c08a780e ("eventfd:
>>> revised interface and cleanups") from Linus' tree and commit
>>> 28ddf0aebbf546e56efd1951725d5457ce1ebf98 ("eventfd: Allow waiters to =
be
>>> notified about the eventfd file* going away") from the kvm tree.
>>>
>>> Overlapping changes.  I fixed it up (see below), but don't know if th=
is
>>> is the correct fix.
>>>
>>> --=20
>>> Cheers,
>>> Stephen Rothwell                    sfr@canb.auug.org.au
>>>
>>> diff --cc fs/eventfd.c
>>> index 31d12de,72f5f8d..0000000
>>> --- a/fs/eventfd.c
>>> +++ b/fs/eventfd.c
>>> @@@ -105,8 -63,13 +105,13 @@@ static int eventfd_release(struct inod
>>>    {
>>>        struct eventfd_ctx *ctx =3D file->private_data;
>>>
>>> -     wake_up_poll(&ctx->wqh, POLLHUP);
>>> +     /*
>>> +      * No need to hold the lock here, since we are on the file
>>> cleanup
>>> +      * path and the ones still attached to the wait queue will be
>>> +      * serialized by wake_up_locked_poll().
>>> +      */
>>> +     wake_up_locked_poll(&ctx->wqh, POLLHUP);
>>>   -    kfree(ctx);
>>>   +    eventfd_ctx_put(ctx);
>>>        return 0;
>>>    }
>>>     =20
>>
>> That's fine.
>> There are a couple of extra spaces before the last two -+ in that patc=
h
>> though ;)
>>   =20
>
> No, that's a git N-way diff format.  The first column shows the
> changes relative to mainline by kvm.git, and the second the changes to
> kvm.git made by mainline.
>
> I've merged and will push soon, which will resolve the conflict, but I
> think the patch wake_up_locked_poll() is better off in mainline rather
> than kvm.git.

Just to be clear: the final form will need to be wake_up_poll(), not
wake_up_locked_poll.  However, I think what Steven did was optimal
because converting to the locked form without coordinating with kvm.git
would break bisectability.

In the irqfd-fixes series, I had 3 patches related to this situation
(1/5 to prepare to change, 2/5 was Davide's patch, and 3/5 did the final
change-over).  Now that the vast majority of Davide's work is in
mainline+kvm.git, here is my proposal:

*) drop 2/5 (already upstream, sans the locked POLLHUP)
*) fold 1/5 + 3/5, and add new fs/eventfd.c hunk to convert to locked
variant
*) drop 5/5

Sound good?
-Greg




--------------enigD70267FF0322A8AFAF7CC498
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpLVwsACgkQlOSOBdgZUxlGHwCfRctWOT0Lh89r5vEodNkr7z1r
3QQAmgI6IaNkeV3jf+Ain9bIy3cT+QPX
=E+PV
-----END PGP SIGNATURE-----

--------------enigD70267FF0322A8AFAF7CC498--
