Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbZDAJla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbZDAJla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZDAJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:41:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZDAJlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:41:17 -0400
Subject: Re: lockdep report at resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <alpine.LNX.2.00.0903311039480.14346@wotan.suse.de>
References: <1234022517.4175.107.camel@johannes.local>
	 <1237536764.5100.124.camel@johannes.local>
	 <alpine.LNX.2.00.0903201535470.14346@wotan.suse.de>
	 <1237800572.19647.97.camel@johannes.local>
	 <alpine.LNX.2.00.0903311034560.14346@wotan.suse.de>
	 <1238488692.5970.80.camel@johannes.local>
	 <alpine.LNX.2.00.0903311039480.14346@wotan.suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Nxt48SurQDaPuM6oaIQD"
Date: Wed, 01 Apr 2009 11:40:40 +0200
Message-Id: <1238578840.5970.178.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Nxt48SurQDaPuM6oaIQD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 10:40 +0200, Jiri Kosina wrote:

> > > Could you please send me your config?
> > Sure, attached. I haven't yet tried to reproduce on .29 though, which=20
> > this config is for (but I haven't changed it since, only taken it=20
> > forward).

I've now gotten it again on 2.6.29-wl-20327-g8f2487d-dirty.

I've analysed a bit more.

Let's start from the bottom:

-> #0 (&dev->mutex){--..}:
       [<ffffffff80276e87>] check_prev_add+0x57/0x770=20
       [<ffffffff80277b96>] validate_chain+0x5f6/0x6b0
       [<ffffffff8027808f>] __lock_acquire+0x43f/0xa10
       [<ffffffff802786f1>] lock_acquire+0x91/0xc0
       [<ffffffff805cb56c>] mutex_lock_nested+0xfc/0x390
       [<ffffffff804d19e1>] input_disconnect_device+0x31/0xf0
       [<ffffffff804d1aba>] input_unregister_device+0x1a/0x110
       [<ffffffffa00df329>] bcm5974_disconnect+0x29/0x90 [bcm5974]
       [<ffffffffa001c9ed>] usb_unbind_interface+0x6d/0x180 [usbcore]
       [<ffffffff80498661>] __device_release_driver+0x81/0xc0
       [<ffffffff804987c0>] device_release_driver+0x30/0x50
       [<ffffffffa001ce48>] usb_driver_release_interface+0xc8/0xf0 [usbcore=
]
       [<ffffffffa001cf99>] usb_forced_unbind_intf+0x39/0x90 [usbcore]
       [<ffffffffa00121a5>] usb_reset_device+0xd5/0x220 [usbcore]
       [<ffffffffa00957fa>] hid_reset+0x18a/0x280 [usbhid]
       [<ffffffff8025d28d>] run_workqueue+0x10d/0x250


Here we have hid_reset being called off schedule_work. It eventually
calls into bcm5974 which will, from its usb_driver disconnect call, call
input_unregister_device(), which acquires &dev->mutex.


-> #1 (polldev_mutex){--..}:
       [<ffffffff802771e7>] check_prev_add+0x3b7/0x770
       [<ffffffff80277b96>] validate_chain+0x5f6/0x6b0
       [<ffffffff8027808f>] __lock_acquire+0x43f/0xa10
       [<ffffffff802786f1>] lock_acquire+0x91/0xc0
       [<ffffffff805cb12c>] mutex_lock_interruptible_nested+0xec/0x430
       [<ffffffffa0058151>] input_open_polled_device+0x21/0xd0 [input_polld=
ev]
       [<ffffffff804d1528>] input_open_device+0x98/0xc0
       [<ffffffffa009f468>] evdev_open+0x1c8/0x1f0 [evdev]
       [<ffffffff804d099f>] input_open_file+0x10f/0x200
       [<ffffffff802e6e47>] chrdev_open+0x147/0x220
       [<ffffffff802e18eb>] __dentry_open+0x11b/0x350
       [<ffffffff802e1c37>] nameidata_to_filp+0x57/0x70
       [<ffffffff802f0e6e>] do_filp_open+0x1fe/0x970
       [<ffffffff802e16d0>] do_sys_open+0x80/0x110
       [<ffffffff802e17a0>] sys_open+0x20/0x30

This is another code path -- evdev triggered here. Any input polldev
will acquire polldev_mutex within its struct input_dev->open() callback,
and thus create a dependency of &dev->mutex on polldev_mutex because
input_open_device() is called with &dev->mutex held.

-> #2 (cpu_add_remove_lock){--..}:
       [<ffffffff802771e7>] check_prev_add+0x3b7/0x770
       [<ffffffff80277b96>] validate_chain+0x5f6/0x6b0
       [<ffffffff8027808f>] __lock_acquire+0x43f/0xa10
       [<ffffffff802786f1>] lock_acquire+0x91/0xc0
       [<ffffffff805cb56c>] mutex_lock_nested+0xfc/0x390
       [<ffffffff8024a447>] cpu_maps_update_begin+0x17/0x20
       [<ffffffff8025d7c8>] destroy_workqueue+0x38/0xb0
       [<ffffffffa0058115>] input_close_polled_device+0x45/0x60 [input_poll=
dev]
       [<ffffffff804d145c>] input_close_device+0x5c/0x90
       [<ffffffffa009f1e9>] evdev_release+0xa9/0xd0 [evdev]
       [<ffffffff802e4e25>] __fput+0xd5/0x1e0
       [<ffffffff802e4f55>] fput+0x25/0x30
       [<ffffffff802e14f8>] filp_close+0x58/0x90
       [<ffffffff802e15ee>] sys_close+0xbe/0x120 =20
       [<ffffffff8020bf0b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

This is cute.
So input-polldev uses its own workqueue, and it's singlethread. But
destroy_workqueue must stop CPU hotplug anyway, calls
cpu_map_update_begin() which locks cpu_add_remove_lock.

-> #3 (events){--..}:
       [<ffffffff802771e7>] check_prev_add+0x3b7/0x770
       [<ffffffff80277b96>] validate_chain+0x5f6/0x6b0
       [<ffffffff8027808f>] __lock_acquire+0x43f/0xa10
       [<ffffffff802786f1>] lock_acquire+0x91/0xc0
       [<ffffffff8025d722>] cleanup_workqueue_thread+0x42/0x90
       [<ffffffff805bca8d>] workqueue_cpu_callback+0x9d/0x132
       [<ffffffff805d1205>] notifier_call_chain+0x65/0xa0 =20
       [<ffffffff80267626>] raw_notifier_call_chain+0x16/0x20
       [<ffffffff805ba91b>] _cpu_down+0x1db/0x350
       [<ffffffff8024a5b5>] disable_nonboot_cpus+0xe5/0x170
       [<ffffffff80287ef5>] hibernation_snapshot+0x135/0x170
       [<ffffffff8028b8a5>] snapshot_ioctl+0x425/0x620
       [<ffffffff802f27a6>] vfs_ioctl+0x36/0xb0
       [<ffffffff802f2b89>] do_vfs_ioctl+0x89/0x350
       [<ffffffff802f2e9f>] sys_ioctl+0x4f/0x80  =20
       [<ffffffff8020bf0b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

Here we have hibernation, which needs to call disable_nonboot_cpus. This
takes down all CPUs, and causes the workqueue code, now running off the
workqueue_cpu_callback, to call cleanup_workqueue_thread(), which
"acquires" the workqueue. I suspect this will also happen if you go into
sysfs and disable a CPU manually, which may help you reproduce this.

disable_nonboot_cpus calls cpu_map_update_begin() to avoid other things
interfering, and thus creates the dependency of the workqueue on that.


-> #4 (&usbhid->reset_work){--..}:
       [<ffffffff802771e7>] check_prev_add+0x3b7/0x770
       [<ffffffff80277b96>] validate_chain+0x5f6/0x6b0
       [<ffffffff8027808f>] __lock_acquire+0x43f/0xa10
       [<ffffffff802786f1>] lock_acquire+0x91/0xc0  =20
       [<ffffffff8025d287>] run_workqueue+0x107/0x250
       [<ffffffff8025d47f>] worker_thread+0xaf/0x130
       [<ffffffff80261dae>] kthread+0x4e/0x90=20
       [<ffffffff8020cfba>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

Now, of course, usbhid->reset_work runs off the schedule_work workqueue,
which was stopped during hibernation, so it depends on that workqueue.


Finally, we're back at the top, with input_disconnect_device() acquiring
&dev->mutex.



Now, how can a deadlock happen?

I think it cannot -- unless you have a polled USB device. The two
"&dev->mutex" instances here are from difference devices, but lockdep
cannot tell them apart, and if you have a polled USB device then the
same can happen.

Assume you had a polled USB driver using input_unregister_polled_device,
and thus input_unregister_device, in its usb_driver disconnect call. In
that case you could potentially trigger the deadlock when you manage to
get that usb device reset very very close before calling
disable_nonboot_cpus, so close that the usb reset_work is still
scheduled or something like that...


I don't really see a good way to solve it -- but I hope the analysis
helps some -- also adding lots of people to CC.

johannes

--=-Nxt48SurQDaPuM6oaIQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0zaVAAoJEKVg1VMiehFYrrkP/1T57i/RwMoXLOea7RN5bReK
wANyV0352VnKmdPgsMMTHN2p2/uot614WU+0lJ+yowvxb+YYLTu4bgI4vBsiYTbG
Tci16ey9LRAu4jYNZ/MNxtl9iwGwY8YqAktZiQ6vhI2VU88PHQ1wpWvDJtNXRmMO
Krr2epZzo5sw8Yc+Q0cw4Pfj8Ygt17TDXgWiMuThHBu+yL6zvH7aMI4Mc2Sktm87
MsDiH9ZsuRe2Ko0fKy0K+FRDAN6xKTnWNlQJpKsz3ADiShpBXu36sXXMPKVoU2tD
kthfA6DBm6SIqsPnhHPUFl7MNWn3fYCPXgvEUQYLLxisvTFBmCe1F6duZuKRMCC4
XBM+my1HRA/u87TCHdk1DHg2mguGwHyeLL8lHETNz2Q/Ox4iNLZTnBYp3qjAIVX7
N9rqVeLoRP4J1Yn3Po5XLzxtJXqKIwqMRK73pbBpsvzzMunb0ORcOXag4TD7t9j1
2M8kWHOAXd9Tw9hjFmyF1WURe8IgSXcKU2Ylz0492Pd23R3Nz98v3Ar37urkB1fv
Ql4mt1h7PItMBoVPT6u4hd4X/kPb4E56r3g6HaEMpkzRGj77Z65Vfs25vhXKC1+F
lo2zzmQnduGJy5bVa/1kqRQlFZoD/CN5a1DnROSl/fp2wmFT31MZIPoSz4MHYMUe
sAVVagLTc0tJrrLc1Mc7
=vDrA
-----END PGP SIGNATURE-----

--=-Nxt48SurQDaPuM6oaIQD--

