Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYEOIzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYEOIzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYEOIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:55:26 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYEOIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:55:25 -0400
Subject: Re: Sparse annotation for "context imbalance" false positives?
From: Johannes Berg <johannes@sipsolutions.net>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <adaod78fe94.fsf@cisco.com> (sfid-20080515_051646_455778_42A2EDF3)
References: <adaod78fe94.fsf@cisco.com>
	 (sfid-20080515_051646_455778_42A2EDF3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XHPX6qtXCJCj2Aog5uOA"
Date: Thu, 15 May 2008 10:54:23 +0200
Message-Id: <1210841663.4282.9.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XHPX6qtXCJCj2Aog5uOA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

You could, for example, insert this:

> 	static void mlx4_ib_lock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_=
cq *recv_cq)
> 	{
> 		if (send_cq =3D=3D recv_cq)
		{
> 			spin_lock_irq(&send_cq->lock);
			 /* pretend to have acquired both for sparse */=09
			__acquire(&recv_cq->lock);
		}
> 		else if (send_cq->mcq.cqn < recv_cq->mcq.cqn) {
> 			spin_lock_irq(&send_cq->lock);
> 			spin_lock_nested(&recv_cq->lock, SINGLE_DEPTH_NESTING);
> 		} else {
> 			spin_lock_irq(&recv_cq->lock);
> 			spin_lock_nested(&send_cq->lock, SINGLE_DEPTH_NESTING);
> 		}
> 	}

and then declare that you take "both" locks. Not sure if that will bite
you in the callers again though.

The exact syntax is still a bit under discussion though, whether to use
&recv_cq->lock or leave out the "&" there, I'm favouring the approach
with & but the kernel uses no & in some places.

johannes

--=-XHPX6qtXCJCj2Aog5uOA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCv6PqVg1VMiehFYAQIc0RAAmxfNytGFfQn0Uua2XpahBdoppI71mNUY
7b25Cyq7aYpNGF3YSIWUhMHXFiz58XUvTZEzbb1a7CMP3e0nurmaY3SwATaDgUhD
tl84WNryZeKdLIqoDlIZVXD7rLD04rQ+aDmKoBVFAMBCV8e/FNJ9n+h14LNBr0O2
SKX9t+VmK5dc7TbfHHfeNZuyholdb1IVcAOCl7XdfmOPZ55Gz6ULilKPRRynvqUm
AZct0AK+eOJytTKezDZKm7jbL82EeO6Uq/y+JVbZpWYSgK4tDc6CluvpGWssWDBZ
DNNFDTl7YVVcazazRQ1cElrNJN0QmOvPk+t67MYAAvuq83jxvlhhS3MTrGfkvC3i
gIpatqQsv7JETn/M+wdu9NW1Tsiavy7/MJl+WEqjJTCeuynPxuNxM2RjGLwnmO8D
KTiK88VxuvQbK+knMtsGUzjq/ezpeZCgU0m0WCsHoKQ8krm3lv8tJRdz+vFuzMBw
wcBSoLmH+nmBc7EZHl7MZLuFPM0LaRINAIYwKIItZhl3qfOHLUZH9roXX9VRY1UF
eWYTATOwwTBeIKf+5v7wdSetQF+o5uCWW2pC3QFBfdlb1NVsq4cZ4a8NEkpN9PSN
ZaGif9YmGx8H2q2MljaLvmKnV1SQg8WtYYHzp6PbsMNkK4jC8fqpVsRznTWCPXOB
6sFtXUh5xtg=
=bgZU
-----END PGP SIGNATURE-----

--=-XHPX6qtXCJCj2Aog5uOA--

