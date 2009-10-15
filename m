Return-Path: <linux-kernel-owner+w=401wt.eu-S934711AbZJONBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711AbZJONBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 09:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494AbZJONBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 09:01:47 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:51310 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbZJONBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 09:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type;
        b=tE/w5sBrvJ12Sn8+VQ38pX34lvajLl0VTUQv+gEvp+jyv8UILpaB5E/NfPU+/ysIGN
         01Nav/9wiEoR+PFJv8eC8RJfTLOuPzCEc9Xd3rO64bnfgOFPeq2JZ3k7r6OhxjuHcjsq
         63pUt4WERCGqPfRHURwEn6YVadtgytttrJGSw=
Message-ID: <4AD71D12.9060203@gmail.com>
Date: Thu, 15 Oct 2009 09:01:06 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Tips for module_init() dependencies
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig59BAD44915D5807DD1AA425C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59BAD44915D5807DD1AA425C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,

General question about the best-practices for dealing with intermodule
initialization dependencies.

The problem I am seeing arises when two features are enabled as built-in
but are available also as modules.

For instance, say I have feature "foo" and "bar".

Foo may do:

---------

static int foostate;

foo()
{
	/* do something with foostate */
}
EXPORT_SYMBOL_GPL(foo);

foo_init()
{
	foostate =3D 0;
}

module_init(foo_init);

--------------

likewise, bar may do

--------------

bar_init()
{
	foo();
}

module_init(bar_init);

--------------

If I build this system with

CONFIG_FOO=3Dm
CONFIG_BAR=3Dm

everything works, because modprobe will ensure that foo loads first

However:

CONFIG_FOO=3Dy
CONFIG_BAR=3Dy

may break, because the kernel seems to have no concept of
interdependency between foo_init() and bar_init(), and therefore
bar_init() may call foo() before foo_init() has executed.

There are various ways to solve this problem, such as deferring calling
foo() with a workqueue or something, but I was wondering if there was a
better/standard way to do this that I am missing?

The problem I am having specifically is that I am trying to call
configfs_register_subsystem() in a module_init(), but this breaks when
built into the kernel based on sheer bad luck that configfs gets
initialized after me.  To date I have worked around this by forcing my
code to only support built-in, and using late_initcall() instead or
module_init.  This works, but it only means I am putting the problem off
(code that depends on *me* has to use similar tricks, etc.

Any suggestions appreciated.

Kind Regards,
-Greg



--------------enig59BAD44915D5807DD1AA425C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrXHRIACgkQP5K2CMvXmqH7HwCeMn3w9JWfcTeIqWkyFyFaBzn/
q74An3PpwKYX4daSEOpf/Z+AaKY6dYZJ
=5zfn
-----END PGP SIGNATURE-----

--------------enig59BAD44915D5807DD1AA425C--
