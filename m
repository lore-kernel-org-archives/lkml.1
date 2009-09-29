Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZI2Hgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZI2Hgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZI2Hgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:36:36 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:49629 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZI2Hgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ji+9vwcafPOXDztixrjrp/PgauRaswmB/Y1ZH8zDe5uPPx7tHZiuL/47oQPTLB28rA
         Ky/ZZdIWhqKJJPtE67KxsrAAvO4cviyh/Mv5DlH8bvy8l/PJ38B6kW+BCCOCF9bGYj8K
         RyPJkhcUrn328WiQUoy3L/UfcrLzNYvyPxjg4=
Date: Tue, 29 Sep 2009 07:36:12 +0000
From: Andy Spencer <andy753421@gmail.com>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Privilege dropping security module
Message-ID: <20090929073612.GA18032@c.hsd1.tn.comcast.net>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
 <20090923213109.GA936@c.hsd1.tn.comcast.net>
 <4ABB9D6D.8000607@schaufler-ca.com>
 <20090925100630.GD10098@c.hsd1.tn.comcast.net>
 <h9jb1a$url$2@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-18066-1254209796-0001-2"
Content-Disposition: inline
In-Reply-To: <h9jb1a$url$2@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-18066-1254209796-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Can 'length+1' overflow?
> (Can the caller arrange to pass MAX_SIZE_T as the length parameter?
> If yes, that's a vulnerability.)
> I haven't checked how dpriv_stage_write() is called, to see whether
> this is possible.

It's called by vfs_write so it could be a problem. I couldn't find any
standard macros, I added a check to ensure that

  (length < (ssize_t)(~0ULL))
 =20
which should fix this and ensure that length will fit in the returned
value.


> What if kbuffer isn't '\0'-terminated?  Won't this read past the end
> of kbuffer?

Allocating kbuffer to length+1 zeros should ensure that it's '\0'
terminated, but it changed it to use kmalloc and explicitly set the
terminator instead.


> Are you certain that perm_end and path_start will be within bounds?
> If the user supplies a sufficiently large string (more than MAX_INT
> characters long), could perm_end or path_start be negative?

Limiting length should fix this as well. I also change the markers to
size_t.


Unfortunately I only noticed a few of these things after posting the
second patch against the mainline, so not all of these changes are
included in that post..

--=_c-18066-1254209796-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrBuQQACgkQz1OYJ/s1XTC78gCdEnqLfUJZH/ugv4ZT6yzoTqW3
fgkAnA9cwbJd1b2rR4dAVL8oGzQSOvGJ
=QMgj
-----END PGP SIGNATURE-----

--=_c-18066-1254209796-0001-2--
