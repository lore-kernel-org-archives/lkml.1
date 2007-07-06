Return-Path: <linux-kernel-owner+w=401wt.eu-S1762451AbXGFBh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762451AbXGFBh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbXGFBhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:37:48 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:48166 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbXGFBhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:37:47 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 11:37:45 +1000
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <200707060935.12706.nigel@nigel.suspend2.net> <CF60EC03-0171-4052-924D-57555A393168@mac.com>
In-Reply-To: <CF60EC03-0171-4052-924D-57555A393168@mac.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1301732.G6m746St7O";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061137.46684.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1301732.G6m746St7O
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 11:19:32 Kyle Moffett wrote:
> On Jul 05, 2007, at 19:35:11, Nigel Cunningham wrote:
> > On Friday 06 July 2007 09:20:43 Benjamin Herrenschmidt wrote:
> >> No, the freezer creates all those places what are harmful for a =20
> >> task to block because they will break the freezer :-)
> >
> > Nice try :) Okay then, you remove the freezer, try hibernating, =20
> > then get back to me after you've fixed your filesystem because some =20
> > process that wasn't frozen started writing things after the atomic =20
> > copy (making the on disk filesystem inconsistent with the snapshot).
>=20
> Umm, this thread is NOT ABOUT HIBERNATING!!!  Please go back and read =20
> the subject, specifically the "suspend to RAM" parts :-D.  When your =20
> hardware can put itself to sleep and atomically preserve memory as it =20
> does so, you don't need an atomic copy.  For Real Suspend(TM) (IE: =20
> Suspend-to-RAM), the list of things to do is short and simple:

We agreed a while back that you don't need the freezer for suspend to ram. =
As=20
far as I was aware, we went off-topic, so the topic is out of date.

> 1)  Stop DMA and put most hardware into low-power states (stops all =20
> interrupt sources)
> 2)  Ensure that the other CPUs have finished any trailing interrupt =20
> handlers and put them to sleep
> 3)  Put the interrupt-controllers into low-power state
> 4)  Go to sleep
>=20
> > As Pavel rightly said, you can get rid of the freezer, but you're =20
> > only going to have to implement another one that does the =20
> > essentially the same thing, even if it is at some other level.
>=20
> How about a freezer whose job it is to "wait for pending hard =20
> interrupts to complete when we have already guaranteed that we won't =20
> get any more"?  That part should be really *REALLY* easy.  You don't =20
> need to care about either userspace processes or kernel threads at =20
> all.  Specifically, Step 1 consists of:
>=20
> suspend_device(dev)
> {
> 	set_no_bind_flag(dev);
> 	for (dev->subdevices)
> 		suspend_device(dev);
> 	set_no_io_flag(dev);
> 	wait_for_in_progress_dma(dev);
> 	turn_off_interrupts(dev);
> 	go_to_low_power_state(dev);
> }
>=20
> After you've set the "no_bind" flag, you won't get any *new* =20
> subdevices trying to bind, therefore it's safe to iterate over the =20
> list of present sub-devices and suspend them.  Once those are =20
> suspended and in low-power states you can set a "no_io" flag to =20
> prevent the driver from submitting more IO.  At that point you can =20
> lazily wait for existing DMA/IO/interrupts to finish on the device, =20
> since *NOBODY* will be submitting them anymore, and we certainly =20
> aren't probing for new devices.  Then you can just turn off the power =20
> to the device.  When all the leaf devices are off, the parent device =20
> can be turned off because everything waiting on the leaf devices is =20
> blocked on them and won't unblock until the parent device *AND* the =20
> leaf device are turned on again, in that order.

=46or suspending, yes. For hibernating, that's not enough, because other=20
processes can still be happily allocating and freeing memory, and will only=
=20
get stopped when they try to do i/o or such like. If you're trying to make=
=20
hibernation reliable, you need to be able to reliably check whether you're=
=20
going to have enough storage for the image you're preparing, and enough=20
memory for the atomic copy and so on. That's why the freezer is needed for=
=20
hibernation. If you don't have it, any hibernation implementation you make =
is=20
going to be only as reliable as the extent to which the system is otherwise=
=20
idle.
=20
> Scheduling and userspace are all still fully enabled in this =20
> scenario.  Once all your devices are turned off, the only remaining =20
> running threads will be those which haven't done IO since the =20
> beginning of the suspend.  We can then disable preemption, turn off =20
> the timer interrupts, and tell the other CPUs to park all their =20
> remaining threads in schedule() and sleep.  Then we put the IRQ =20
> controller to sleep and go to sleep ourselves.  If our driver model =20
> locking is sufficient to handle putting a parent device to sleep =20
> while threads are sleeping on a child device then there are exactly 0 =20
> problems.
>=20
> Resuming is basically running the whole process in reverse.  Runtime-=20
> suspend is achieved by not setting the 'no_io' or 'no_bind' flags and =20
> putting selective device-subtrees to sleep without doing anything to =20
> the rest of the system.

=46ully agree when it comes to suspend to ram. There, this process should w=
ork,=20
so far as I can see. But as I said, we went - to one degree or another - of=
f=20
topic, and did discuss hibernation too.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1301732.G6m746St7O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjZzqN0y+n1M3mo0RAnvKAKDlp791E2U4gCdkZgrNJE9iqvipJQCeNqOX
3//3+7/vq8iHEyRIdj9hABE=
=auYP
-----END PGP SIGNATURE-----

--nextPart1301732.G6m746St7O--
