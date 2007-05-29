Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXE2M7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXE2M7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXE2M7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:59:48 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:36255 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbXE2M7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:59:47 -0400
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by
	default
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <200705291415.31970.rjw@sisk.pl>
References: <200705270012.59177.rjw@sisk.pl>
	 <200705282011.11526.rjw@sisk.pl> <20070529113114.GB23046@elf.ucw.cz>
	 <200705291415.31970.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PUNbmIfK1LOnRQaqK/rb"
Date: Tue, 29 May 2007 22:59:32 +1000
Message-Id: <1180443572.20718.29.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PUNbmIfK1LOnRQaqK/rb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-29 at 14:15 +0200, Rafael J. Wysocki wrote:
> Please have a look at the current version of the patch (appended).
>=20
> I have followed the Nigel's suggestion not to change the current behavior
> in this patch (I'll add a couple of patches removing the freezability fro=
m
> some kernel threads), with one exception: I couldn't figure out any reaso=
n
> to have try_to_freeze() called in net/sunrpc/svcsock.c:svc_recv() .

Thanks. IIRC, svcsock is related to the NFS server code.

> I've also added a piece of documentation, freezing-of-tasks.txt .  Please
> see if it's not missing anything (I'd like it to be quite complete).

[...]

Mostly just grammar and the odd typo. On the whole, it's really well
written and perfectly readable - great job!

> Index: linux-2.6.22-rc3/Documentation/power/freezing-of-tasks.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6.22-rc3/Documentation/power/freezing-of-tasks.txt
> @@ -0,0 +1,160 @@
> +Freezing of tasks
> +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
> +
> +I. What is the freezing of tasks?
> +
> +The freezing of tasks is a mechanism by which user space processes and s=
ome
> +kernel threads are controlled during hibernation or system-wide suspend =
(on some
> +architectures).
> +
> +II. How it works?

How does it work?

> +
> +There are four per-task flags used for that, PF_NOFREEZE, PF_FROZEN, TIF=
_FREEZE
> +and PF_FREEZER_SKIP (the last one is auxiliary).  The tasks that have
> +PF_NOFREEZE unset (all user space processes and some kernel threads) are
> +regarded as 'freezable' and treated in a special way before the system e=
nters a
> +suspend state as well as before a hibernation image is created (in what =
follows
> +we only consider hibernation, but the description also applies to suspen=
d).
> +
> +Namely, as the first step of the hibernation procedure the function
> +freeze_processes() (defined in kernel/power/process.c) is called.  It ex=
ecutes
> +try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable task=
s and
> +sends a fake signal to each of them.  A task that receives such a signal=
 and has
> +TIF_FREEZE set, should react to it by calling the refrigerator() functio=
n
> +(defined in kernel/power/process.c), which sets the task's PF_FROZEN fla=
g,
> +changes its state to TASK_UNINTERRUPTIBLE and makes it loop until PF_FRO=
ZEN is
> +cleared for it.  Then, we say that the task is 'frozen' and therefore th=
e set of
> +functions handling this mechanism is called 'the freezer' (these functio=
ns are
> +defined in kernel/power/process.c and include/linux/freezer.h).  User sp=
ace
> +processes are generally frozen before kernel threads.
> +
> +It is not recommended to call refrigerator() directly.  Instead, it is
> +recommended to use the try_to_freeze() function (defined in
> +include/linux/freezer.h), that checks the task's TIF_FREEZE flag and mak=
es the
> +task enter refrigerator() if the flag is set.
> +
> +For user space processes try_to_freeze() is called automatically from th=
e
> +signal-handling code, but the freezable kernel threads need to call it
> +explicitly in suitable places.  The code to do this may look like the fo=
llowing:
> +
> +	do {
> +		hub_events();
> +		wait_event_interruptible(khubd_wait,
> +					!list_empty(&hub_event_list));
> +		try_to_freeze();
> +	} while (!signal_pending(current));
> +
> +(from drivers/usb/core/hub.c::hub_thread()).
> +
> +If a freezable kernel thread fails to call try_to_freeze() after the fre=
ezer has
> +set TIF_FREEZE for it, the freezing of tasks will fail and the entire
> +hibernation operation will be cancelled.  For this reason, freezable ker=
nel
> +threads must call try_to_freeze() somewhere.
> +
> +After the system memory state has been restored from a hibernation image=
 and
> +devices have been reinitialized, the function thaw_processes() is called=
 in
> +order to clear the PF_FROZEN flag for each frozen task.  Then, the tasks=
 that
> +have been frozen leave refrigerator() and continue running.
> +
> +III. Which kernel threads are freezable?
> +
> +Kernel threads are not freezable by default.  However, a kernel thread m=
ay clear
> +PF_NOFREEZE for itself by calling set_freezable() (the resetting of PF_N=
OFREEZE
> +directly is strongly discouraged).  From this point it is regarded as fr=
eezable
> +and must call try_to_freeze() in a suitable place.
> +
> +IV. Why do we do that?
> +
> +Generally speaking, there is a couple of reasons to use the freezing of =
tasks:
> +
> +1. The principal reason is to prevent filesystems from being damaged aft=
er
> +hibernation.  Namely, for now we have no simple means of checkpointing

s/Namely, for now/At the moment/

No simple means or no means at all? Are you thinking of bdev freezing?

> +filesystems, so if there are any modifications made to filesystem data a=
nd/or
> +metadata on disks, we usually cannot bring them back to the state from b=
efore

If the above is changed, I'd remove 'usually' here.

> +the modifications.  At the same time each hibernation image contains som=
e
> +filesystem-related information that must be consistent with the state of=
 the
> +on-disk data and metadata after the system memory state has been restore=
d from
> +the image (otherwise the filesystems will be damaged in a nasty way, usu=
ally
> +making them almost impossible to repair).  Therefore we freeze tasks tha=
t might

s/Therefore we/We therefore/

> +cause the on-disk filesystems' data and metadata to be modified after th=
e
> +hibernation image has been created and before the system is finally powe=
red off.
> +The majority of them is user space processes, but if any of kernel threa=
ds may

s/them is/these are/

s/of kernel/of the kernel/

> +cause something like this to happen, they have to be freezable.
> +
> +2. The second reason is to prevent user space processes and some kernel =
threads
> +from interfering with the suspending and resuming of devices.  For examp=
le, a
> +user space process running on a second CPU while we are suspending devic=
es may

I'd shift the "For example" to after "may", giving "...may, for example,
be troublesome..."

> +be troublesome and without the freezing of tasks we would need some safe=
guards
> +against race conditions that might occur in such a case.
> +
> +Although Linus Torvalds doesn't like the freezing of tasks, he said this=
 in one
> +of the discussions on LKML (http://lkml.org/lkml/2007/4/27/608):
> +
> +'> Why we freeze tasks at all or why we freeze kernel threads?
> +
> +In many ways, "at all".

I found these first two lines confusing - I though the "Why we
freeze..." was Linus, rather than a quotation he was responding to. I'd
suggest starting the quote at what follows this point... but then as I
read further, I can see the quote is necessary to make sense of the
second paragraph below. Perhaps the best way would to put a line before
the "Why we freeze..." indicating that you're being quoted there.

> +I _do_ realize the IO request queue issues, and that we cannot actually =
do
> +s2ram with some devices in the middle of a DMA.  So we want to be able t=
o
> +avoid *that*, there's no question about that.  And I suspect that stoppi=
ng
> +user threads and then waiting for a sync is practically one of the easie=
r
> +ways to do so.
> +
> +So in practice, the "at all" may become a "why freeze kernel threads?" a=
nd
> +freezing user threads I don't find really objectionable.'

Oh, and double quotes should surround the whole quote, with single
quotes replacing the double quotes in the quotation. Hope all those
'quote's aren't confusing! :)

> +Still, there are kernel threads that may want to be freezable.  For exam=
ple, if
> +a kernel that belongs to a device driver accesses the device directly, i=
t in
> +principle needs to know when the device is suspended, so that it doesn't=
 try to
> +access it at that time.  However, if the kernel thread is freezable, it =
will be
> +frozen before the driver's .suspend() callback is executed and it will b=
e
> +thawed after the driver's .resume() callback has run, so it won't be acc=
essing
> +the device while it's suspended.
> +
> +3. Another reason for freezing tasks is to prevent user space processes =
from
> +realizing that hibernation (or suspend) operation takes place.  Ideally,=
 user
> +space processes should not notice that such a system-wide operation has =
occured

s/occured/occurred/. That word gets me too.

> +and should continue running without any problems after the restore (or r=
esume
> +from suspend).  Unfortunately, in the most general case this is quite di=
fficult
> +to achieve without the freezing of tasks.  Consider, for example, a proc=
ess
> +that depends on the number of CPUs being online while it's running.  Sin=
ce we

s/the number of/all/ (or secondary)

> +need to disable nonboot CPUs during the hibernation, if this process is =
not
> +frozen, it may notice that the number of CPUs has changed and may start =
to work
> +incorrectly because of that.
> +
> +V. Are there any problems related to the freezing of tasks?
> +
> +Yes, there are.
> +
> +First of all, the freezing of kernel threads may be tricky if they depen=
d one
> +on another.  For example, if kernel thread A waits for a completion (in =
the
> +TASK_UNINTERRUPTIBLE state) that needs to be done by freezable kernel th=
read B
> +and B is frozen in the meantime, then A will be blocked until B is thawe=
d, which
> +may be undesirable.  That's why kernel threads are not freezable by defa=
ult.
> +
> +Second, there are the following two problems related to the freezing of =
user
> +space processes:
> +1. Putting processes into an uninterruptible sleep stuffs up the load av=
erage.

s/stuffs up/distorts/ ('Stuffs up' is accurate as a colloquialism, but
I'm suggesting the change because the language in the remainder of the
file is more formal - this seems out of place).

> +2. Now that we have FUSE, plus the framework for doing device drivers in
> +userspace, it gets even more complicated because some userspace processe=
s are
> +now doing the sorts of things that kernel threads do
> +(https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012309.h=
tml).

Death to them all, I say! :)

> +The problem 1. seems to be fixable, although it hasn't been fixed so far=
.  The
> +other one is more serious, but it seems that we can work around it by us=
ing
> +hibernation (and suspend) notifiers (in that case, though, we won't be a=
ble to
> +avoid the realization by the user space processes that the hibernation i=
s taking
> +place).
> +
> +There also are problems that the freezing of tasks tends to expose, alth=
ough

s/also are/are also/

> +they are not directly related to it.  For example, if request_firmware()=
 is
> +called from a device driver's .resume() routine, it will timeout and eve=
ntually
> +fail, because the user land process that should respond to the request i=
s frozen
> +at this point.  So, seemingly, the failure is due to the freezing of tas=
ks.
> +Suppose, however, that the firmware file is located on a filesystem acce=
ssible
> +only through the device that needs the firmware.  In that case, the syst=
em won't
> +be able to work normally after the restore regardless of whether or not =
the
> +freezing of tasks is used.  Consequently, the problem is not really rela=
ted to
> +the freezing of tasks, since it generally exists regardless.  [The solut=
ion to
> +this particular problem is to keep the firmware in memory after it's loa=
ded for
> +the first time and upload if from memory to the device whenever necessar=
y.]

I understand the logic and agree with that you're trying to say in this
last example, but think the example is faulty. If the firmware is on a
filesystem accessible only through the device that needs the firmware,
then you wouldn't be able to bring it up in the first place.

Regards,

Nigel

--=-PUNbmIfK1LOnRQaqK/rb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXCO0N0y+n1M3mo0RAtLtAJ9aucIlBAeY0JwQrUTfIQFKXVvwCACggh0b
TmPfHp+DpsT6RnS4NfnGy+s=
=DIlR
-----END PGP SIGNATURE-----

--=-PUNbmIfK1LOnRQaqK/rb--

