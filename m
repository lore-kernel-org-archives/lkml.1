Return-Path: <linux-kernel-owner+w=401wt.eu-S940835AbXHIRiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940835AbXHIRiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbXHIRhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:37:53 -0400
Received: from canadatux.org ([85.214.62.144]:36330 "EHLO
	zoidberg.canadatux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764975AbXHIRhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:37:51 -0400
Date: Thu, 9 Aug 2007 19:37:35 +0200
From: Matthias Hensler <matthias@wspse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070809173735.GA21546@kobayashi-maru.wspse.de>
Reply-To: Matthias Hensler <matthias@wspse.de>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org> <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de> <20070809095534.25ae1c42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20070809095534.25ae1c42.akpm@linux-foundation.org>
Organization: WSPse (http://www.wspse.de/)
X-Gummibears: Bouncing here and there and everywhere
X-Face: &Tv]9SsNpb/$w8\G-O%>W02aApFW^P>[x+Upv9xQB!2;iD9Y1-Lz'qlc{+lL2Y>J(u76 Jk,cJ@$tP2-M%y?^'jn2J]3C'ss_~"u?kA^X&{]h?O?@*VwgSGob73I9r}&S%ktup0k2 !neScg3'HO}PU#Ac>jwNL|P@f|f*sz*cP'hi)/<JQC4|Q[$D@aQ"C{$>a=6.rc-P1vXa rjVXlzClmNfcSy/$4tQz
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2007 at 09:55:34AM -0700, Andrew Morton wrote:
> On Thu, 9 Aug 2007 11:59:43 +0200 Matthias Hensler <matthias@wspse.de> wr=
ote:
> > On Sat, Aug 04, 2007 at 10:44:26AM +0200, Matthias Hensler wrote:
> > > On Fri, Aug 03, 2007 at 11:34:07AM -0700, Andrew Morton wrote:
> > > [...]
> > > I am also willing to try the patch posted by Richard.
> >=20
> > I want to give some update here:
>=20
> Did we ever see the /proc/meminfo and /proc/vmstat output during the stal=
l?

So far not, sorry. The problem did not reoccur since I am running the
kernel with that patch now.

> As you're seeing this happening when multiple disks are being written
> to it is possible that the per-device-dirty-threshold patches which
> recently went into -mm (and which appear to have a bug) will fix it.

All affected systems have two devices which are cross mounted, eg. it
has /home on disk 1 and /var/spool/imap on disk 2.

On the respectively device there is the mirror partition (mirror of
/home on disk 2 and mirror of /var/spool/imap on disk 1).

Normally the system hangs when running rsync from /var/spool/imap to its
corresponding mirror partition.

We have around 10 different partitions (all in LVM), but so far the hang
mostly started running rsync on the imapspool (which has by far most of
the files on the system).

_However_: we also had this hang while running a backup to an external
FTP server (so only reading the filesystems apart from the usual system
activity).

And: the third system we had this problem on has no IMAP spool at all.
The hang occured while running a backup together with "yum update".

It might be related that all the systems uses these crossmounts over two
different disks. I wasn't not able to reproduce that on my homesystem
with only one disk, either because the activity-pattern was different,
or it really needs two disks to run into that issue.

> But I worry that the stall appears to persist *forever*.  That would indi=
cate
> that we have a dirty-memory accounting leak, or that for some reason the
> system has decided to stop doing writeback to one or more queues (might be
> caused by an error in a lower-level driver's queue congestion state manag=
ement).

Well, all the time I was still connected to one of that machines it was
possible to clear the situation by killing a lot of processes. That is
mostly killing all httpd, smtpd, imapd, amavisd, crond, spamassassin and
rsync processes. Eventually the system responded normal again (and I
could cleanly reboot it). However the final killed process which
resolved the issue was non deterministic so far.

The workload is different on all the servers:

Server 1 processes around 10-20k mails per day but also servers a lot
         of HTTP requests.
Server 2 is only a mailserver processing around 5-10k mails per day.
Server 3 just serves HTTP requests (and a bit DNS).

> If it is the latter, then it could be that running "sync" will clear
> the problem.  Temporarily, at least.  Because sync will ignore the
> queue congestion state.

I have to admit that I never tried to sync in such a case, since mostly
I had only one open SSH session and tried to find the root cause.

So far the problem occured first on server 2 around march or april
without changes to the machine (we have a Changelog for every server:
there was a single kernel update that time, however we reverted back
after the first issue and run a kernel which was stable for several
weeks before and encountered the problem again). In the beginning we
encountered the problem maybe twice a week, getting worse within the
next weeks. Several major updates (kernel and distribution were made)
without resolving the problem.

Since end of april server 1 began showing the same problem (running a
different Fedora version and kernel at that time), first slowly (once a
week or so) then more regular.

Around july we had a hang nearly every day.

Server 3 had the problem only once now, but that server has no high
workload.

We spent a lot of time investigating the issue, but since all servers
use a different hardware, different setups (beside from the crossmounts
with noatime) and even different base systems (Fedora Core 5+6, Fedora
7, different kernels: 2.6.18, .19, .20, .21 and .22) I think that we can
rule out hardware problems. I think the issue might be there some time
now, but is hit more often now since the workload increased a lot over
the last months.

We ruled a lot out over the month (eg. syslog was replaced, many not so
important services were stopped, schedular was changed), without
changes. Just reverting from "noatime" in the fstab to "default" fixed
it reliable so far.

As said I am still running "vmstat 1" and catting of /proc/meminfo just
in case. If there is anything I can do beside that to clearify the
problem I will try to help.

Regards,
Matthias

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUBRrtQ2oagCBsispUdAQLlkQP/b50vg9BUunEJA6QlYKYSydX0Il2fOmG5
L46S5G7Y4hp4t4I3cQiZuiVklwgdyHuHHGhdwT2NaWxiUlUnJy9zWaNhn7oVBsIk
+vyWRBEdLfeBUYmjaBPPYSLCo074ZFJ3OjALNXCN5D4iagZ76gXG6SxlrsCUVR+d
pR76aTjkYok=
=qS+q
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
