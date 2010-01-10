Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506Ab0AJUsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0AJUsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234Ab0AJUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:48:46 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:39572 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0AJUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:48:45 -0500
Date: Sun, 10 Jan 2010 21:48:38 +0100
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100110214838.05778a26@rechenknecht2k7>
In-Reply-To: <20100110195641.GA27553@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
	<20100108075054.GA3696@core.coreip.homeip.net>
	<20100108112610.0b78785b@piBook>
	<20100110075615.GC16057@core.coreip.homeip.net>
	<20100110191112.5c66dc94@rechenknecht2k7>
	<20100110195641.GA27553@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uYQaEThYlx_=n3kkRODy8r1"; protocol="application/pgp-signature"
X-Originating-IP: 87.123.114.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uYQaEThYlx_=n3kkRODy8r1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sun, 10 Jan 2010 11:56:41 -0800
schrieb Dmitry Torokhov <dmitry.torokhov@gmail.com>:

> On Sun, Jan 10, 2010 at 07:11:12PM +0100, Benjamin Valentin wrote:
> > On Sat, 9 Jan 2010 23:56:16 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >=20
> > > > --- /usr/src/linux-source-2.6.33/drivers/input/joystick/xpad.c
> > > > 2010-01-08 02:56:59.365851076 +0100 +++ xpad.c	2010-01-08
> > > > 03:13:38.477835651 +0100 @@ -505,7 +505,7 @@
> > > >  	struct usb_endpoint_descriptor *ep_irq_out;
> > > >  	int error =3D -ENOMEM;
> > > > =20
> > > > -	if (xpad->xtype !=3D XTYPE_XBOX360)
> > > > +	if (xpad->xtype !=3D XTYPE_XBOX360 && xpad->xtype !=3D
> > > > XTYPE_XBOX) return 0;
> > > > =20
> > > >  	xpad->odata =3D usb_buffer_alloc(xpad->udev,
> > > > XPAD_PKT_LEN, @@ -535,13 +535,13 @@
> > > > =20
> > > >  static void xpad_stop_output(struct usb_xpad *xpad)
> > > >  {
> > > > -	if (xpad->xtype =3D=3D XTYPE_XBOX360)
> > > > +	if (xpad->xtype =3D=3D XTYPE_XBOX360 || xpad->xtype !=3D
> > > > XTYPE_XBOX)
> > >=20
> > > This should cretainly be "... || xpad->xtype =3D=3D XTYPE_XBOX)",
> > > I'll fix it up locally.
> >=20
> > Thank you, this made me discover another bug that eventually leads
> > to a kernel oops when the device is unplugged while an effect is
> > playing (or the effect is somehow else interrupted).
> > This should be fixed by taking the mutex when modifying xpad->odata
> > as well as checking whether it has been freed before writing to it.
> >=20
>=20
> No, you may not take mutex in xpad_play_effect because it is called
> with interrupts off and dev->event_lock spinlock held.

Does that mean that xpad_disconnect and xpad_play_effect never can get
executed concurrently? In that case, none of the introduced mutexes
would be necessary. (I was already wondering since there were none in
other joystick drivers)
I think it's possible that the strange behaviour when unplugging the
device while playing several effects might be introduced by VirtualBox
- I was unable to reproduce it on a physical machine.

[  968.247266] BUG: scheduling while atomic: swapper/0/0x10000100
[  968.247271] Modules linked in: joydev xpad led_class ff_memless binfmt_m=
isc snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm =
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi iptable_filter snd_seq_m=
idi_event ip_tables x_tables snd_seq snd_timer snd_seq_device ppdev parport=
_pc snd psmouse serio_raw i2c_piix4 soundcore lp snd_page_alloc parport flo=
ppy pcnet32 mii
[  968.247357] Modules linked in: joydev xpad led_class ff_memless binfmt_m=
isc snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm =
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi iptable_filter snd_seq_m=
idi_event ip_tables x_tables snd_seq snd_timer snd_seq_device ppdev parport=
_pc snd psmouse serio_raw i2c_piix4 soundcore lp snd_page_alloc parport flo=
ppy pcnet32 mii
[  968.247386]=20
[  968.247409] Pid: 0, comm: swapper Not tainted 2.6.33-999-generic #201001=
091003 /VirtualBox
[  968.247413] EIP: 0060:[<c010a400>] EFLAGS: 00000246 CPU: 0
[  968.247448] EIP is at mwait_idle+0x50/0x90
[  968.247451] EAX: 00000000 EBX: c0790000 ECX: 00000000 EDX: 00000000
[  968.247454] ESI: 00000000 EDI: c0793000 EBP: c0791f9c ESP: c0791f98
[  968.247457]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  968.247461] Process swapper (pid: 0, ti=3Dc0790000 task=3Dc0797120 task.=
ti=3Dc0790000)
[  968.247464] Stack:
[  968.247466]  c07dc384 c0791fb4 c0101bb4 9ecc1b86 5298b144 f616da4d 0008d=
800 c0791fbc
[  968.247480] <0> c0581ee2 c0791fe0 c07df9ca 000000c0 c07df530 00100000 50=
4f88cd f616da4d
[  968.247487] <0> c0820900 00000000 c0791ff8 c07df08b 37feff9d 00000000 c0=
6e5c40 00000800
[  968.247495] Call Trace:
[  968.247501]  [<c0101bb4>] ? cpu_idle+0x84/0xc0
[  968.247517]  [<c0581ee2>] ? rest_init+0x62/0x70
[  968.247532]  [<c07df9ca>] ? start_kernel+0x26a/0x300
[  968.247537]  [<c07df530>] ? unknown_bootoption+0x0/0x150
[  968.247542]  [<c07df08b>] ? i386_start_kernel+0x5b/0x90
[  968.247544] Code: c0 f6 44 02 27 02 75 26 89 e3 31 c9 81 e3 00 e0 ff ff =
89 ca 8d 43 08 0f 01 c8 0f ae f0 89 f6 f6 43 08 08 75 16 89 c8 fb 0f 01 c9 =
<5b> 5d c3 89 e0 25 00 e0 ff ff 0f ae 78 08 eb cd fb 90 8d 74 26=20
[  968.247584] Call Trace:
[  968.247587]  [<c0101bb4>] cpu_idle+0x84/0xc0
[  968.247599]  [<c0581ee2>] rest_init+0x62/0x70
[  968.247603]  [<c07df9ca>] start_kernel+0x26a/0x300
[  968.247607]  [<c07df530>] ? unknown_bootoption+0x0/0x150
[  968.247611]  [<c07df08b>] i386_start_kernel+0x5b/0x90
[  975.023581] usb 2-1: USB disconnect, address 6

--Sig_/uYQaEThYlx_=n3kkRODy8r1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktKPScACgkQg4D7JNscH9pwaACfb1DZ8sMK0+pgjfAmHd9LQHyJ
vJQAniJYaN43VTUsa4PP6lvPLmvX/3Lq
=3cDM
-----END PGP SIGNATURE-----

--Sig_/uYQaEThYlx_=n3kkRODy8r1--
