Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbYJTG1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbYJTG1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYJTG1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:27:39 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:33988 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbYJTG1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:27:38 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <20081017123207.GA14979@rabbit.intern.cm-ag>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gom01crPDbTaxmNL4AV3"
Date: Mon, 20 Oct 2008 07:27:26 +0100
Message-Id: <1224484046.23068.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=D19gQVrFAAAA:8 a=O8_nzQF5PmrUOzceW9AA:9 a=KjFKThN6ucd3sPJkmo2P8uLaSgcA:4 a=uKpIxoUXYIsA:10 a=7aVLIEA-14N97DOov7kA:9 a=Dl-nfj_NTkTXiFPvxJOF7xdQebQA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gom01crPDbTaxmNL4AV3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

(adding back some CC's, please don't drop people)

On Fri, 2008-10-17 at 14:32 +0200, Max Kellermann wrote:
> Ian: this is a follow-up to your post "NFS regression? Odd delays and
> lockups accessing an NFS export" a few weeks ago
> (http://lkml.org/lkml/2008/9/27/42).
>
> I am able to trigger this bug within a few minutes on a customer's
> machine (large web hoster, a *lot* of NFS traffic).
>=20
> Symptom: with 2.6.26 (2.6.27.1, too), load goes to 100+, dmesg says
> "INFO: task migration/2:9 blocked for more than 120 seconds." with
> varying task names.  Except for the high load average, the machine
> seems to work.
>=20
> With git bisect, I was finally able to identify the guilty commit,
> it's not "Ensure we zap only the access and acl caches when setting
> new acls" like you guessed, Ian.  According to my bisect,
> 6becedbb06072c5741d4057b9facecb4b3143711 is the origin of the problem.
> e481fcf8563d300e7f8875cae5fdc41941d29de0 (its parent) works well.

The issue I see still occurs well before those changesets. I have seen
it with v2.6.25 but v2.6.24 survived for 7 days without issue (my
threshold for a good kernel is 7 days, hence bisecting is a bit
slow...).=20

So far I have bisected down to this range and am currently testing
acee478 which has been up for >4days.

$ git bisect visualize  --pretty=3Doneline =20
bdc7f021f3a1fade77adf3c2d7f65690566fddfe NFS: Clean up the (commit|read|wri=
te)_setup() callback routines
3ff7576ddac06c3d07089e241b40826d24bbf1ac SUNRPC: Clean up the initialisatio=
n of priority queue scheduling info.
c970aa85e71bd581726c42df843f6f129db275ac SUNRPC: Clean up rpc_run_task
84115e1cd4a3614c4e566d4cce31381dce3dbef9 SUNRPC: Cleanup of rpc_task initia=
lisation
ef818a28fac9bd214e676986d8301db0582b92a9 NFS: Stop sillyname renames and un=
mounts from racing
2f74c0a05612b9c2014b5b67833dba9b9f523948 NFSv4: Clean up the OPEN/CLOSE ser=
ialisation code
acee478afc6ff7e1b8852d9a4dca1ff36021414d NFS: Clean up the write request lo=
cking.
8b1f9ee56e21e505a3d5d3e33f823006d1abdbaf NFS: Optimise nfs_vm_page_mkwrite(=
)
77f111929d024165e736e919187cff017279bebe NFS: Ensure that we eject stale in=
odes as soon as possible
d45b9d8baf41acb177abbbe6746b1dea094b8a28 NFS: Handle -ENOENT errors in unli=
nk()/rmdir()/rename()
609005c319bc6062b95ed82e132884ed7e22cdb9 NFS: Sillyrename: in the case of a=
 race, check aliases are really positive
fccca7fc6aab4e6b519e2d606ef34632e4f50e33 NFS: Fix a sillyrename race...

note that this bisect is over fs/nfs only so it's possible the I might
drop off the beginning and have to bisect the 3878 commits between
v2.6.24 and fccca7f. I hope not! acee478 looks good so far.

$ git bisect log
# bad: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
# good: [49914084e797530d9baaf51df9eda77babc98fa8] Linux 2.6.24
git-bisect start 'v2.6.25' 'v2.6.24' '--' 'fs/nfs'
# bad: [4c5680177012a2b5c0f3fdf58f4375dd84a1da67] NFS: Support non-IPv4 add=
resses in nfs_parsed_mount_data
git-bisect bad 4c5680177012a2b5c0f3fdf58f4375dd84a1da67
# bad: [d45273ed6f4613e81701c3e896d9db200c288fff] NFS: Clean up address com=
parison in __nfs_find_client()
git-bisect bad d45273ed6f4613e81701c3e896d9db200c288fff
# bad: [bdc7f021f3a1fade77adf3c2d7f65690566fddfe] NFS: Clean up the (commit=
|read|write)_setup() callback routines
git-bisect bad bdc7f021f3a1fade77adf3c2d7f65690566fddfe

Ian.
--=20
Ian Campbell

"It is easier to fight for principles than to live up to them."
		-- Alfred Adler

--=-gom01crPDbTaxmNL4AV3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj8JMoACgkQM0+0qS9rzVnYIgCbB69JBXOpTuR9tDUtkg/79fkk
J60An1D3GXV90bL6pysp3NOiD1YDNGWz
=3N6M
-----END PGP SIGNATURE-----

--=-gom01crPDbTaxmNL4AV3--

