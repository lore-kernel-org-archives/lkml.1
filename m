Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYADJWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYADJWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYADJV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:21:59 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:64580 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754271AbYADJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:21:58 -0500
Subject: Re: [2.6.22] circular lock detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       folkert@vanheusden.com, linux-kernel@vger.kernel.org
In-Reply-To: <477DE2F9.2050208@simon.arlott.org.uk>
References: <20070824210033.GB13237@vanheusden.com>
	 <20070902045529.c66eddc9.akpm@linux-foundation.org>
	 <20070903122702.GC29908@atrey.karlin.mff.cuni.cz>
	 <20070903054959.3ecd9576.akpm@linux-foundation.org>
	 <20070903140135.GE7524@duck.suse.cz> <20070925100243.2ceebd9e@twins>
	 <20070925084630.GA412@duck.suse.cz>  <477DE2F9.2050208@simon.arlott.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MmEwwznKLQ4gjQPGOGJF"
Date: Fri, 04 Jan 2008 10:21:55 +0100
Message-Id: <1199438515.7143.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MmEwwznKLQ4gjQPGOGJF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-01-04 at 07:40 +0000, Simon Arlott wrote:
> On 25/09/07 09:46, Jan Kara wrote:
> > On Tue 25-09-07 10:02:43, Peter Zijlstra wrote:
> >> On Mon, 3 Sep 2007 16:01:35 +0200 Jan Kara <jack@suse.cz> wrote:
> >>=20
> >> > On Mon 03-09-07 05:49:59, Andrew Morton wrote:
> >> > > > On Mon, 3 Sep 2007 14:27:02 +0200 Jan Kara <jack@suse.cz> wrote:
> >> > > > > > On Fri, 24 Aug 2007 23:00:33 +0200 Folkert van Heusden <folk=
ert@vanheusden.com> wrote:
> >>=20
> >> > > > > Has been reported before, but I don't recall whether we fixed =
it.  Jan,
> >> > > > > do you know>?
> >> > > >   I think we at least found a solution: Teach lockdep that I_MUT=
EX for
> >> > > > different filesystems is different. Peter Zilstra wrote a patch =
for that
> >> > > > and Folkert even confirmed that it fixes the problem for him. I'=
m not
> >> > > > sure what happened with the patch afterwards though. Adding Pete=
r to CC
> >> > > > :).
> >> > >=20
> >> > > But this is a tty_lock-versus-dqptr_sem ranking error.  Unrelated =
to i_mutex?
> >> >   The final report is for this ranking but the locking chain (if I u=
nderstand it
> >> > right) is:
> >> > tty_mutex (con_close) -> i_mutex (sysfs: remove_subdir)
> >> > i_mutex (do_truncate) -> i_alloc_sem (notify_change) -> truncate_mut=
ex (ext3_truncate)
> >> > truncate_mutex (ext3_get_blocks_handle) -> dqptr_sem (dquot_alloc_sp=
ace)
> >> >=20
> >> > So it complains about tty_mutex vs dqptr_sem (I don't know why it do=
es not
> >> > complain about tty_mutex vs i_mutex) but the wrong link in the chain=
 is
> >> > that i_mutex from remove_subdir() [sysfs] and i_mutex from do_trunca=
te()
> >> > [ext3] are different and should never depend on each other...
> >> >=20
> >>=20
> >> Found it again.
> >   Cool, thanks Peter. Andrew, would you put it into -mm? This should ta=
ke care of
> > the false lockdep warnings from the quota code. If I recall correctly, =
one
> > of the reporters even confirmed it fixes the problem for him.
> >   The patch looks fine. You can add:
> > Signed-off-by: Jan Kara <jack@suse.cz>
> >=20
> > 									Honza
> >=20
> >> Give each filesystem its own inode lock class. The various filesystems=
 have
> >> different locking order wrt the inode locks; esp. the pseudo filesyste=
ms
> >> differ from the rest.
> >>=20
> >> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>=20
> This patch still doesn't exist in 2.6.23.9 and the warning isn't fixed...

It would have been if you'd used .24-rc :-)

--=-MmEwwznKLQ4gjQPGOGJF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHffqzXA2jU0ANEf4RAkm4AKCFCUCiXlajuLCZEYhlgV0yeybK9ACeKe/z
k6w1aowCWKuBSLlw1PoerqU=
=jPID
-----END PGP SIGNATURE-----

--=-MmEwwznKLQ4gjQPGOGJF--

