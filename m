Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYA2XVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYA2XVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbYA2XVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:21:35 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:33944 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbYA2XVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:21:33 -0500
Message-ID: <479FB4F6.90901@web.de>
Date: Wed, 30 Jan 2008 00:21:26 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][KGDB] Re:  KGDB: 8250_kgdb warnings
References: <479DAC35.60308@siemens.com> <479FAECF.8090308@windriver.com>
In-Reply-To: <479FAECF.8090308@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF8DA01D3EE602A8677C137A7"
X-Provags-ID: V01U2FsdGVkX1/s3piD9puFeHIi75Fv997fMSaFk3ClZt/Wqbk+
	ksan1xbcYEwPv24XeehetaqxLz2PpEi6e3vnnTkcVnZPLWrM35
	3vxGUC9cs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF8DA01D3EE602A8677C137A7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> Jan Kiszka wrote:
>> Hi Jason,
>>
>> so far I ignored this because it worked, but I know my customer will
>> complain later anyway: What is the deeper meaning of this warning whic=
h
>> shows up once per registered UART port on my (x86) boxes?
>>
>> void kgdb8250_add_port(int i, struct uart_port *serial_req)
>> {
>> #ifdef CONFIG_KGDB_SIMPLE_SERIAL
>> 	if (should_copy_rs_table)
>> 		printk(KERN_ERR "8250_kgdb: warning will over write serial"
>> 			   " port definitions at kgdb init time\n");
>> #endif
>> ...
>>
>> When I look at kgdb8250_add_platform_port, it starts with a call to
>> kgdb8250_copy_rs_table, and I'm wondering now if that wouldn't be more=

>> appropriate here.
>>
>> Jan
>>
>=20
>=20
> This was the result of a race condition between the init code of the
> platform vs the init code in kgdb.  The init code in the arch platform
> could register serial ports prior to the kgdb module being configured
> by the kernel while the kernel is processing all the __init functions.
> It would have been easy to fix this with another call to
> kgdb8250_copy_rs_table() but you cannot do that because a non-__init
> function cannot call an __init function.
>=20
>=20
> We might as well go ahead and fix the problem by adding in some checks
> so as not to overwrite the dynamic registrations, because eventually
> the SERIAL_PORT_DFNS will be gone.  Below is the patch with the fix to
> add some saftey checks as well as to remove the warning.
>=20
> --------Cut here-----------
>=20
>=20
> Fix the initialization of the kgdb port structure such that
> dynamically registered ports will not be later overwritten by the
> SERIAL_PORT_DFNS table.  With this problem fixed, the printk about the
> overwriting of the kgdb serial definitions at init time can be
> removed.
>=20
> Also add in additional runtime safety checks to make sure UART_NR was
> statically allocated by the kernel at compile time to be large enough
> for all the dynamic registered ports.

I'm currently preparing to post a larger patch series for KGDB which
also addresses this problem - but quite differently. Therefore this
question in advance:

What use case could not be covered by polling the (8250) config via
serial8250_get_port_def() when there were no kgdb8250_add_port()? That's
in fact what I did in my patch because I found none and the result
appears much more consistent to me. But I'm not claiming to be a UART
expert across all those various embedded platforms.

Jan


--------------enigF8DA01D3EE602A8677C137A7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHn7T7niDOoMHTA+kRAuHjAJ9CxtuiVY+CcTIbZ648nbhkSt1h4QCeJLrE
D9t8f7PUEvxsOhDf0YNYNzE=
=ygS4
-----END PGP SIGNATURE-----

--------------enigF8DA01D3EE602A8677C137A7--
