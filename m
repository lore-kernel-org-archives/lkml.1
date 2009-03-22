Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZCVOtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZCVOtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZCVOsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:48:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:20696 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZCVOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eGe9l8rpiAEvarPAD0LnOLncob7X1xzqYQEOs7qCz8u+u2F/oB7TWPEgFUZxb59QeL
         shHA4rdlk+qEzARU2kMAgqIs+xTACpelNydNAORc6FpGiLWTkQPj0fX4mUwhwOzHq2Rr
         wAk+ofjr1zH7mNvvmhYjTrM6qublOFKD/FBio=
From: Andrey Borzenkov <arvidjaar@gmail.com>
To: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH -mmotm] fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
Date: Sun, 22 Mar 2009 17:48:33 +0300
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-1avb; KDE/4.2.1; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <498817E2.3020008@gmail.com> <1233783983-28802-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1233783983-28802-1-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1581955.IR3QzKup4F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903221748.42871.arvidjaar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1581955.IR3QzKup4F
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 5 =D1=84=D0=B5=D0=B2=D1=80=D0=B0=D0=BB=D1=8F 2009 00:46:23 Andrea Righi =
wrote:
> Fix this circular locking dependencies in the frame buffer console
> driver pushing down the mutex fb_info->lock.
>
> Circular locking dependecies occur calling the blocking
> fb_notifier_call_chain() with fb_info->lock held. Notifier callbacks
> can try to acquire mm->mmap_sem, while fb_mmap() acquires the locks
> in the reverse order mm->mmap_sem =3D> fb_info->lock.
>
> Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

Hmm ... is it in current Linus tree? Because I happened to have this again=
=20
in rc8:

[47800.440873] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[47800.440950] [ INFO: possible circular locking dependency detected ]
[47800.440981] 2.6.29-rc8-1avb #35
[47800.440999] -------------------------------------------------------
[47800.441026] s2disk/19740 is trying to acquire lock:
[47800.441057]  (&fb_info->lock){--..}, at: [<c02175b7>] fb_mmap+0x97/0x170
[47800.441149]=20
[47800.441152] but task is already holding lock:
[47800.441183]  (&mm->mmap_sem){----}, at: [<c0106e2e>] sys_mmap2+0x8e/0xc0
[47800.441260]=20
[47800.441262] which lock already depends on the new lock.
[47800.441266]=20
[47800.441307]=20
[47800.441309] the existing dependency chain (in reverse order) is:
[47800.441345]=20
[47800.441347] -> #3 (&mm->mmap_sem){----}:
[47800.441426]        [<c014347f>] __lock_acquire+0x129f/0x1930
[47800.441466]        [<c0143b6c>] lock_acquire+0x5c/0x80
[47800.441500]        [<c0175f97>] might_fault+0x77/0xa0
[47800.441548]        [<c01fd746>] copy_to_user+0x36/0x120
[47800.441591]        [<c0199eb7>] filldir+0x97/0xe0
[47800.441627]        [<c01d2279>] sysfs_readdir+0x129/0x220
[47800.441668]        [<c019a066>] vfs_readdir+0x86/0xa0
[47800.441701]        [<c019a1a8>] sys_getdents+0x68/0xc0
[47800.441734]        [<c010340a>] syscall_call+0x7/0xb
[47800.441770]        [<ffffffff>] 0xffffffff
[47800.441839]=20
[47800.441842] -> #2 (sysfs_mutex){--..}:
[47800.441906]        [<c014347f>] __lock_acquire+0x129f/0x1930
[47800.441941]        [<c0143b6c>] lock_acquire+0x5c/0x80
[47800.441974]        [<c03556ba>] mutex_lock_nested+0xba/0x2f0
[47800.442012]        [<c01d260c>] sysfs_addrm_start+0x2c/0xc0
[47800.442012]        [<c01d2bc0>] create_dir+0x40/0x90
[47800.442012]        [<c01d2c3b>] sysfs_create_dir+0x2b/0x50
[47800.442012]        [<c01f74ec>] kobject_add_internal+0xbc/0x1b0
[47800.442012]        [<c01f76b1>] kobject_add_varg+0x31/0x50
[47800.442012]        [<c01f772c>] kobject_add+0x2c/0x60
[47800.442012]        [<c026c598>] device_add+0xa8/0x550
[47800.442012]        [<c026ca52>] device_register+0x12/0x20
[47800.442012]        [<c026cb0b>] device_create_vargs+0xab/0xc0
[47800.442012]        [<c026cb48>] device_create+0x28/0x30
[47800.442012]        [<c0265dfd>] register_con_driver+0xed/0x130
[47800.442012]        [<c02672eb>] take_over_console+0x1b/0x50
[47800.442012]        [<c02244fd>] fbcon_takeover+0x5d/0xb0
[47800.442012]        [<c0225170>] fbcon_event_notify+0x820/0x900
[47800.442012]        [<c0137183>] notifier_call_chain+0x53/0xa0
[47800.442012]        [<c0137444>] __blocking_notifier_call_chain+0x44/0x60
[47800.442012]        [<c013747a>] blocking_notifier_call_chain+0x1a/0x20
[47800.442012]        [<c0216f51>] fb_notifier_call_chain+0x11/0x20
[47800.442012]        [<c0217ed8>] register_framebuffer+0x168/0x220
[47800.442012]        [<c047e2f2>] vesafb_probe+0x542/0x783
[47800.442012]        [<c026f72f>] platform_drv_probe+0xf/0x20
[47800.442012]        [<c026e917>] driver_probe_device+0x87/0x1b0
[47800.442012]        [<c026ead8>] __device_attach+0x8/0x10
[47800.442012]        [<c026df5b>] bus_for_each_drv+0x5b/0x80
[47800.442012]        [<c026eb86>] device_attach+0x76/0x80
[47800.442012]        [<c026dd77>] bus_attach_device+0x47/0x70
[47800.442012]        [<c026c813>] device_add+0x323/0x550
[47800.442012]        [<c0270105>] platform_device_add+0x175/0x1c0
[47800.442012]        [<c047e5cd>] vesafb_init+0x9a/0x1ec
[47800.442012]        [<c010111a>] do_one_initcall+0x2a/0x160
[47800.442012]        [<c04694d5>] kernel_init+0x83/0xd5
[47800.442012]        [<c0103a37>] kernel_thread_helper+0x7/0x10
[47800.442012]        [<ffffffff>] 0xffffffff
[47800.442012]=20
[47800.442012] -> #1 ((fb_notifier_list).rwsem){----}:
[47800.442012]        [<c014347f>] __lock_acquire+0x129f/0x1930
[47800.442012]        [<c0143b6c>] lock_acquire+0x5c/0x80
[47800.442012]        [<c0355fb9>] down_read+0x49/0x90
[47800.442012]        [<c013742a>] __blocking_notifier_call_chain+0x2a/0x60
[47800.442012]        [<c013747a>] blocking_notifier_call_chain+0x1a/0x20
[47800.442012]        [<c0216f51>] fb_notifier_call_chain+0x11/0x20
[47800.442012]        [<c021856e>] do_fb_ioctl+0x2ae/0x5d0
[47800.442012]        [<c02188ad>] fb_ioctl+0x1d/0x20
[47800.442012]        [<c0199270>] vfs_ioctl+0x20/0x80
[47800.442012]        [<c0199482>] do_vfs_ioctl+0x72/0x570
[47800.442012]        [<c01999b9>] sys_ioctl+0x39/0x70
[47800.442012]        [<c0103331>] sysenter_do_call+0x12/0x31
[47800.442012]        [<ffffffff>] 0xffffffff
[47800.442012]=20
[47800.442012] -> #0 (&fb_info->lock){--..}:
[47800.442012]        [<c01435ec>] __lock_acquire+0x140c/0x1930
[47800.442012]        [<c0143b6c>] lock_acquire+0x5c/0x80
[47800.442012]        [<c03556ba>] mutex_lock_nested+0xba/0x2f0
[47800.442012]        [<c02175b7>] fb_mmap+0x97/0x170
[47800.442012]        [<c017cbc0>] mmap_region+0x2e0/0x440
[47800.442012]        [<c017ceea>] do_mmap_pgoff+0x1ca/0x2f0
[47800.442012]        [<c0106e4d>] sys_mmap2+0xad/0xc0
[47800.442012]        [<c0103331>] sysenter_do_call+0x12/0x31
[47800.442012]        [<ffffffff>] 0xffffffff
[47800.442012]=20
[47800.442012] other info that might help us debug this:
[47800.442012]=20
[47800.442012] 1 lock held by s2disk/19740:
[47800.442012]  #0:  (&mm->mmap_sem){----}, at: [<c0106e2e>]=20
sys_mmap2+0x8e/0xc0
[47800.442012]=20
[47800.442012] stack backtrace:
[47800.442012] Pid: 19740, comm: s2disk Not tainted 2.6.29-rc8-1avb #35
[47800.442012] Call Trace:
[47800.442012]  [<c0354324>] ? printk+0x18/0x1c
[47800.442012]  [<c0141d8f>] print_circular_bug_tail+0xcf/0xe0
[47800.442012]  [<c01435ec>] __lock_acquire+0x140c/0x1930
[47800.442012]  [<c0132936>] ? add_wait_queue+0x36/0x50
[47800.442012]  [<c013f375>] ? lock_release_holdtime+0x35/0x210
[47800.442012]  [<c0143b6c>] lock_acquire+0x5c/0x80
[47800.442012]  [<c02175b7>] ? fb_mmap+0x97/0x170
[47800.442012]  [<c03556ba>] mutex_lock_nested+0xba/0x2f0
[47800.442012]  [<c02175b7>] ? fb_mmap+0x97/0x170
[47800.442012]  [<c02175b7>] ? fb_mmap+0x97/0x170
[47800.442012]  [<c01892c5>] ? kmem_cache_alloc+0xa5/0x100
[47800.442012]  [<c02175b7>] fb_mmap+0x97/0x170
[47800.442012]  [<c017cbc0>] mmap_region+0x2e0/0x440
[47800.442012]  [<c017ceea>] do_mmap_pgoff+0x1ca/0x2f0
[47800.442012]  [<c0106e4d>] sys_mmap2+0xad/0xc0
[47800.442012]  [<c0103331>] sysenter_do_call+0x12/0x31
[47803.041426] Syncing filesystems ... done.
[47803.055587] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[47803.059328] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.


> ---
>  drivers/video/backlight/backlight.c |    3 +
>  drivers/video/backlight/lcd.c       |    3 +
>  drivers/video/console/fbcon.c       |   73
> ++++++++++++++++++++++++++++++----- drivers/video/fbmem.c           =20
>   |   11 +-----
>  4 files changed, 70 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/video/backlight/backlight.c
> b/drivers/video/backlight/backlight.c index 157057c..dd37cbc 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -35,6 +35,8 @@ static int fb_notifier_callback(struct
> notifier_block *self, return 0;
>
>  	bd =3D container_of(self, struct backlight_device, fb_notif);
> +	if (!lock_fb_info(evdata->info))
> +		return -ENODEV;
>  	mutex_lock(&bd->ops_lock);
>  	if (bd->ops)
>  		if (!bd->ops->check_fb ||
> @@ -47,6 +49,7 @@ static int fb_notifier_callback(struct
> notifier_block *self, backlight_update_status(bd);
>  		}
>  	mutex_unlock(&bd->ops_lock);
> +	unlock_fb_info(evdata->info);
>  	return 0;
>  }
>
> diff --git a/drivers/video/backlight/lcd.c
> b/drivers/video/backlight/lcd.c index b644947..0bb13df 100644
> --- a/drivers/video/backlight/lcd.c
> +++ b/drivers/video/backlight/lcd.c
> @@ -40,6 +40,8 @@ static int fb_notifier_callback(struct
> notifier_block *self, if (!ld->ops)
>  		return 0;
>
> +	if (!lock_fb_info(evdata->info))
> +		return -ENODEV;
>  	mutex_lock(&ld->ops_lock);
>  	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
>  		if (event =3D=3D FB_EVENT_BLANK) {
> @@ -51,6 +53,7 @@ static int fb_notifier_callback(struct
> notifier_block *self, }
>  	}
>  	mutex_unlock(&ld->ops_lock);
> +	unlock_fb_info(evdata->info);
>  	return 0;
>  }
>
> diff --git a/drivers/video/console/fbcon.c
> b/drivers/video/console/fbcon.c index 1657b96..2cd500a 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -2954,8 +2954,11 @@ static int fbcon_fb_unbind(int idx)
>
>  static int fbcon_fb_unregistered(struct fb_info *info)
>  {
> -	int i, idx =3D info->node;
> +	int i, idx;
>
> +	if (!lock_fb_info(info))
> +		return -ENODEV;
> +	idx =3D info->node;
>  	for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
>  		if (con2fb_map[i] =3D=3D idx)
>  			con2fb_map[i] =3D -1;
> @@ -2979,13 +2982,14 @@ static int fbcon_fb_unregistered(struct
> fb_info *info) }
>  	}
>
> -	if (!num_registered_fb)
> -		unregister_con_driver(&fb_con);
> -
> -
>  	if (primary_device =3D=3D idx)
>  		primary_device =3D -1;
>
> +	unlock_fb_info(info);
> +
> +	if (!num_registered_fb)
> +		unregister_con_driver(&fb_con);
> +
>  	return 0;
>  }
>
> @@ -3021,9 +3025,13 @@ static inline void fbcon_select_primary(struct
> fb_info *info)
>
>  static int fbcon_fb_registered(struct fb_info *info)
>  {
> -	int ret =3D 0, i, idx =3D info->node;
> +	int ret =3D 0, i, idx;
>
> +	if (!lock_fb_info(info))
> +		return -ENODEV;
> +	idx =3D info->node;
>  	fbcon_select_primary(info);
> +	unlock_fb_info(info);
>
>  	if (info_idx =3D=3D -1) {
>  		for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
> @@ -3124,7 +3132,7 @@ static void fbcon_get_requirement(struct
> fb_info *info, }
>  }
>
> -static int fbcon_event_notify(struct notifier_block *self,
> +static int fbcon_event_notify(struct notifier_block *self,
>  			      unsigned long action, void *data)
>  {
>  	struct fb_event *event =3D data;
> @@ -3132,7 +3140,7 @@ static int fbcon_event_notify(struct
> notifier_block *self, struct fb_videomode *mode;
>  	struct fb_con2fbmap *con2fb;
>  	struct fb_blit_caps *caps;
> -	int ret =3D 0;
> +	int idx, ret =3D 0;
>
>  	/*
>  	 * ignore all events except driver registration and deregistration
> @@ -3144,23 +3152,54 @@ static int fbcon_event_notify(struct
> notifier_block *self,
>
>  	switch(action) {
>  	case FB_EVENT_SUSPEND:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_suspended(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_RESUME:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_resumed(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_MODE_CHANGE:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_modechanged(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_MODE_CHANGE_ALL:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_set_all_vcs(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_MODE_DELETE:
>  		mode =3D event->data;
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		ret =3D fbcon_mode_deleted(info, mode);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_FB_UNBIND:
> -		ret =3D fbcon_fb_unbind(info->node);
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
> +		idx =3D info->node;
> +		unlock_fb_info(info);
> +		ret =3D fbcon_fb_unbind(idx);
>  		break;
>  	case FB_EVENT_FB_REGISTERED:
>  		ret =3D fbcon_fb_registered(info);
> @@ -3178,17 +3217,31 @@ static int fbcon_event_notify(struct
> notifier_block *self, con2fb->framebuffer =3D
> con2fb_map[con2fb->console - 1];
>  		break;
>  	case FB_EVENT_BLANK:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_fb_blanked(info, *(int *)event->data);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_NEW_MODELIST:
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_new_modelist(info);
> +		unlock_fb_info(info);
>  		break;
>  	case FB_EVENT_GET_REQ:
>  		caps =3D event->data;
> +		if (!lock_fb_info(info)) {
> +			ret =3D -ENODEV;
> +			goto done;
> +		}
>  		fbcon_get_requirement(info, caps);
> +		unlock_fb_info(info);
>  		break;
>  	}
> -
>  done:
>  	return ret;
>  }
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index cfd9dce..b64f061 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1086,13 +1086,8 @@ static long do_fb_ioctl(struct fb_info *info,
> unsigned int cmd, return -EINVAL;
>  		con2fb.framebuffer =3D -1;
>  		event.data =3D &con2fb;
> -
> -		if (!lock_fb_info(info))
> -			return -ENODEV;
>  		event.info =3D info;
>  		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
> -		unlock_fb_info(info);
> -
>  		ret =3D copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
>  		break;
>  	case FBIOPUT_CON2FBMAP:
> @@ -1109,12 +1104,8 @@ static long do_fb_ioctl(struct fb_info *info,
> unsigned int cmd, break;
>  		}
>  		event.data =3D &con2fb;
> -		if (!lock_fb_info(info))
> -			return -ENODEV;
>  		event.info =3D info;
> -		ret =3D fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP,
> -					      &event);
> -		unlock_fb_info(info);
> +		ret =3D fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
>  		break;
>  	case FBIOBLANK:
>  		if (!lock_fb_info(info))


--nextPart1581955.IR3QzKup4F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknGT8YACgkQR6LMutpd94x2agCePLyuuDr3Lb4hkEMPAbgpoKRa
dBMAn2HwzELJDGAxIBQoKI41cz3IKG9G
=cBhM
-----END PGP SIGNATURE-----

--nextPart1581955.IR3QzKup4F--
