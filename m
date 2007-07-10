Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbXGJCHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbXGJCHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXGJCHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:07:08 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:55990 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761954AbXGJCHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:07:05 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 10 Jul 2007 12:07:15 +1000
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <200707061403.15932.nigel@nigel.suspend2.net> <CF605B91-2425-4FC2-9434-5F8877EEEEEB@mac.com>
In-Reply-To: <CF605B91-2425-4FC2-9434-5F8877EEEEEB@mac.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5778178.dbUaeMSleF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707101207.16711.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5778178.dbUaeMSleF
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

Sorry for the long delay. Busy weekend and my motivation for working on=20
programming is almost zero at the moment...

On Friday 06 July 2007 15:01:48 Kyle Moffett wrote:
> On Jul 06, 2007, at 00:03:15, Nigel Cunningham wrote:
> > On Friday 06 July 2007 13:54:15 Benjamin Herrenschmidt wrote:
> >> On Fri, 2007-07-06 at 09:35 +1000, Nigel Cunningham wrote:
> >>>
> >>> Nice try :) Okay then, you remove the freezer, try hibernating, =20
> >>> then get back to me after you've fixed your filesystem because =20
> >>> some process that wasn't frozen started writing things after the =20
> >>> atomic copy (making the on disk filesystem inconsistent with the =20
> >>> snapshot).
> >>>
> >>> As Pavel rightly said, you can get rid of the freezer, but you're =20
> >>> only going to have to implement another one that does the =20
> >>> essentially the same thing, even if it is at some other level.
> >>
> >> I was mostly talking about STR... Regarding STD, we have a =20
> >> different problem and we all know it. The freezer is one somewhat =20
> >> horrible way to get it working for now, I would prefer something =20
> >> more along the way that blocks the page cache from writing out new =20
> >> dirty pages though, except those specifically flagged by the =20
> >> snapshot.
> >>
> >> That is, some kind of proper snapshotting facility, as linus was =20
> >> describing some time ago.
> >
> > The kind of thing Linus was talking about would limit you (as =20
> > swsusp and uswsusp do now) to only half the amount of memory.
>=20
> How so?  Suppose hibernate is implemented like this:
>=20
> (1) Userspace program calls sys_freeze_processes()
>    (a) Pokes all CPUs with IPMIs and tells them to finish the =20
> currently running timeslot then stop
>    (b) Atomically sends SIGSTOP to all userspace processes in a non-=20
> trappable way, except the calling process and any process which is =20
> ptracing it.
>    (c) Returns to the calling process.

Ok. First, I'll ignore the specification that userspace does this - I don't=
=20
think it matters whether it's userspace or kernel that does the suspending=
=20
and I'm yet to see a good reason for it to be [required to be] done from=20
userspace.

In this first step, you've reinvented the first part of the current freezer=
=20
implementation. The reason we don't use a real signal is precisely so we ca=
n=20
have an untrappable SIGSTOP. In this regard, I particularly remember Win4Li=
n=20
from a few years ago. It would die if you sent it a real signal, so we had =
to=20
do it this way. No doubt there are other instances I'm not aware of.
=20
> (2) Userspace process sends SIGCONT to only those processes which are =20
> necessary for sync and a device-mapper snapshot.

How do you determine which ones are needed? Why stop them in the first plac=
e?
=20
> (3) Userspace calls sys_snapshot_kernel(snapshot_overhead_pages)
>    (a) Kernel starts freeing memory and swapping stuff out to make =20
> room for a copy of *kernel* memory (not pagecache, not process RAM).  =20
> It does the same for at least snapshot_overhead_pages extra (used by =20
> userspace later).  It then allocates this memory to keep it from =20
> going away.  Since most processes are stopped we won't have much else =20
> competing with us for the RAM.

Ok. So now you also need processes running that are needed for swapping,=20
because freeing that memory might involve swapping. Fully agree with the=20
logic though (not really surprising - this is what I do in=20
Suspend2^wTuxOnIce).

>    (a) Kernel uses the device-mapper up-call-into-filesystem =20
> machinery to get all mounted filesystems synced and ready for a DM =20
> snapshot.  This may include sending data via the userspace processes =20
> resumed in (2).  Any deadlocks here are userspace's fault (see (2)).  =20
> Will need some modification to handle doing multiple blockdevs at a =20
> time.  Anything using FUSE is basically perma-synced anyways (no dep-=20
> handling needed), and anything using loop should already be handled =20
> by DM.  This includes allocating memory for the basic snapshot =20
> datastructures.
>    (b) At this point all blockdev operations should be halted and =20
> disk caches flushed; that's all we care about.
>    (c) Go through the device tree and quiesce DMA and shut off =20
> interrupts.  Since all the disks are synced this is easy.
>    (d) Use IPMIs again to get all the CPUs together, which should be =20
> easy as most processes are sleeping in IO or SIGSTOPed, and we're =20
> getting no interrupts.
>    (e) One CPU turns off all interrupts on itself and takes an atomic =20
> snapshot of kernel memory into the previously allocated storage.  =20
> Once again, does not include pagecache.  The kernel also records a =20
> list of what pages *are* included in the pagecache.  It then marks =20
> all userspace pages as copy-on-write.

Hotplugging cpus (when all those locking issues are taken care of) is simpl=
er.=20
Prior to cpu hotplugging, I used IMPIs to put secondary cpus into a tight=20
loop, so I know it's possible to do it this way too. That way, though, you=
=20
have less flexibility. What if a cpu really is plugged in between hibernate=
=20
and resume? With cpu hotplugging, it's handled properly and transparently.=
=20
Without cpu hotplugging, you could be using uninitialised data after the=20
atomic restore.

Marking userspace as COW makes things more complicated, too. You then have =
to=20
add code to the COW handling to update the list of pages that need to be=20
saved, and you reduce the reliability of the whole process. You can't predi=
ct=20
beforehand how many of these COW pages are going to be needed, and therefor=
e=20
can't know how much memory to free earlier on in the process. If you run ou=
t=20
of memory, what will be the effect?

>    (f) That CPU finalizes the modified DM snapshot using the =20
> previously-allocated memory.
>    (g) That CPU frees up the snapshot_overhead_pages memory allocated =20
> during step (a) for userspace to use.
>    (h) The CPU does the equivalent of a "swapoff -a" without =20
> overwriting any data already on any swap device(s).

You still need to remember what swap you're going to use to write the image=
=2E=20
You'll probably want to get this information (and allocate the swap) sooner=
=20
rather than later so that you're not racing against the memory freeing=20
earlier, and don't run into issues with bmapping the pages or having enough=
=20
memory to record the bdevs & sector numbers (not usually an issue, but if=20
swap is highly fragmented...).

>    (i) The CPU then IPMI-signals the other CPUs to wake them up
>    (j) The kernel returns a FD-reference to the snapshot and the read-=20
> only halves of the CoW pagecache to the process which called =20
> sys_snapshot_kernel().

Readonly halves? I don't get that, sorry.
=20
> (4) The userspace process now has a reference to the copy of the =20
> kernel pages and the unmodified pagecache pages.  Since 99% of the =20
> processes aren't running, we aren't going to be having to CoW many of =20
> the pagecache pages.

Mmm, but you still don't know how many.
=20
> (5) The userspace process uses read() or other syscalls to get data =20
> out of the kernel-snapshot FD in small chunks, within its =20
> snapshot_overhead_pages limit.  It compresses these and writes them =20
> out to the snapshot-storage blockdev (must not be mounted during =20
> snapshot), or to any network server.
>=20
> (6) The userspace process syncs the disks and halts the system.  Any =20
> changed filesystem pages after the pseudo-DM-snapshot should have =20
> been stored in semi-volatile storage somewhere and will be discarded =20
> on the next reboot.

Are you thinking the changed filesystem pages are caught by COW? (AFAIUI,=20
kernel writes aren't). If (as I expect), you're thinking about filesystem=20
writes to DM based storage, what about non DM-based filesystem pages?
=20
> So basically your hibernate-overhead would consist of:
>    (1) The pages necessary for the atomic snapshot of kernel memory =20
> and the list of pagecache pages at that time
>    (2) A little memory necessary for the kernel non-persistent DM =20
> snapshot datastructures.
>    (3) The snapshot_overhead_pages needed by userspace.
>=20
> If you're using swap devices then you can save 99% of the state of =20
> the running kernel with an initial swapout overhead of virtually =20
> nothing beyond the size of the unswappable kernel memory.

=46WIW, let me note an important variation from how Suspend2 works; it migh=
t=20
provide food for thought. In Suspend2, we treat the processes that remain=20
stopped throughout the whole process specially. We write their data to disk=
=20
before the atomic copy (usually 70 or 80% of memory), and then use the memo=
ry=20
they occupy for the destination of the atomic copy. This further reduces th=
e=20
amount of memory that has to be freed, almost always to zero.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart5778178.dbUaeMSleF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGkunUN0y+n1M3mo0RAgOfAJ9HcRIeFxo+rAjU19f91+UkRUJ4OQCguLu9
k44mxUwGBaiXrxHWOeIyty8=
=x/rl
-----END PGP SIGNATURE-----

--nextPart5778178.dbUaeMSleF--
