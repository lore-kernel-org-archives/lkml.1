Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbZGPXHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbZGPXHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933536AbZGPXHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:07:52 -0400
Received: from ms01.sssup.it ([193.205.80.99]:46102 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933533AbZGPXHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:07:51 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <20090716223440.GD27757@cs.fsu.edu>
References: <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	 <4A5C9ABA.9070909@nortel.com> <1247590112.9086.936.camel@Palantir>
	 <4A5CCD5A.80108@nortel.com> <20090715221410.GE14993@cs.fsu.edu>
	 <4A5F3D5C.1070704@nortel.com>  <20090716223440.GD27757@cs.fsu.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Gp49ik+z28ue2PbRldHw"
Date: Fri, 17 Jul 2009 01:07:45 +0200
Message-Id: <1247785665.4929.24.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gp49ik+z28ue2PbRldHw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 18:34 -0400, Ted Baker wrote:
> > In this scenario, we're going to disrupt B's scheduling pattern by
> > forcing it to borrow from its future cpu allocation in order to free up
> > the lock.  It will then be forced to block for a while to make up for
> > the over-use of it's cpu budget.
>=20
> I guess by "disrupting" B's scheduling pattern, you mean only in
> the sense of delayed budget enforcement.  That is, finishing the
> critical sections is something that B would do next in any case,
> and something that B would need to consume CPU time to do in any
> case.  It is B doing its own normal work, but just getting
> a chance to complete that work sooner than it might otherwise.
>=20
> In this situation, you do want to allow B's budget to go negative
> (borrowing against B's future CPU budget to do B's work) rather
> than charging the task A who loaned B priority, since otherwise B
> ends up getting a still bigger windfall (charging B's work to A's
> budget).
>=20
When bandwidth and budget are in place, allowing a task to cross these
boundaries if executing inside a critical section is another approach I
always have liked... Provided you have a mean to make it pay back for
its borrowed bandwidth, as you are properly saying.

However, I also think this raises an issue: what if something weird
happen inside the critical section, such that the task overcame its
declared/estimated duration? If no enforcing is in place, aren't we, at
least temporary, breaking the isolation?
And I think bandwidth isolation between a possibly "failing" task and
the rest of the system is exactly what we are trying to achieve when we
use bandwidth reservation mechanisms?

Thus, in scenarios where component isolation is what we care most, and
especially if good estimations of execution, critical section duration
and blocking times are hardly possible, proxy execution/bandwidth
inheritance approaches ensures the following:
1. the task executing the critical section gets some "bonus bandwidth"
   to speedup the completion of that code, but not in an uncontrolled
   manner: i.e., it can use _only_ the bandwidths of tasks blocked on
   that cs;
2. whatever goes on inside a task, including critical sections, it
   _only_ will affect the capability of making their deadline of:
   - the task executing the cs;
   - the tasks interacting with him, i.e., accessing the same cs.
Any other component/task in the system will be completely unaware of
anything!

Obviously, this comes at the price of overhead, tricky implementation,
etc. ... I don't know if it is always worth, probably it is not, but I
think it is yet something remarkable! :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Gp49ik+z28ue2PbRldHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpfsrkACgkQk4XaBE3IOsQ0XQCfT/pB8/VBsBLoqG7QE8itOzqE
UykAnipYkoX4zdCmithgCcNPgGL64ezO
=68/P
-----END PGP SIGNATURE-----

--=-Gp49ik+z28ue2PbRldHw--

