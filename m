Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZEIMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZEIMCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 08:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZEIMCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 08:02:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59200 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZEIMCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 08:02:06 -0400
Message-ID: <4A0570B1.30401@novell.com>
Date: Sat, 09 May 2009 08:01:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>
In-Reply-To: <4A0448DF.90705@codemonkey.ws>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9AD2643FC4599BA059909BF7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9AD2643FC4599BA059909BF7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Avi Kivity wrote:
>>
>> Hmm, reminds me of something I thought of a while back.
>>
>> We could implement an 'mmio hypercall' that does mmio reads/writes
>> via a hypercall instead of an mmio operation.  That will speed up
>> mmio for emulated devices (say, e1000).  It's easy to hook into Linux
>> (readl/writel), is pci-friendly, non-x86 friendly, etc.
>
> By the time you get down to userspace for an emulated device, that 2us
> difference between mmio and hypercalls is simply not going to make a
> difference.

I don't care about this path for emulated devices.  I am interested in
in-kernel vbus devices.

>   I'm surprised so much effort is going into this, is there any
> indication that this is even close to a bottleneck in any circumstance?=


Yes.  Each 1us of overhead is a 4% regression in something as trivial as
a 25us UDP/ICMP rtt "ping".
>
>
> We have much, much lower hanging fruit to attack.  The basic fact that
> we still copy data multiple times in the networking drivers is clearly
> more significant than a few hundred nanoseconds that should occur less
> than once per packet.
for request-response, this is generally for *every* packet since you
cannot exploit buffering/deferring.

Can you back up your claim that PPC has no difference in performance
with an MMIO exit and a "hypercall" (yes, I understand PPC has no "VT"
like instructions, but clearly there are ways to cause a trap, so
presumably we can measure the difference between a PF exit and something
more explicit).

We need numbers before we can really decide to abandon this
optimization.  If PPC mmio has no penalty over hypercall, I am not sure
the 350ns on x86 is worth this effort (especially if I can shrink this
with some RCU fixes).  Otherwise, the margin is quite a bit larger.

-Greg




--------------enig9AD2643FC4599BA059909BF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoFcLEACgkQlOSOBdgZUxniNQCghcjrsw/2f+3vAhvFZ/EauajY
0koAnRgcxrrmJYCW7hqewDbgiGNgoCbT
=MTcX
-----END PGP SIGNATURE-----

--------------enig9AD2643FC4599BA059909BF7--
