Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXIIOA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXIIOA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbXIIOAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:00:13 -0400
Received: from mx3.mail.ru ([194.67.23.149]:33512 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXIIOAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:00:10 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sun, 9 Sep 2007 18:00:04 +0400
User-Agent: KMail/1.9.7
Cc: michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200706302237.50567.rjw@sisk.pl>
In-Reply-To: <200706302237.50567.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1261561.u87SpF2SHh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709091800.05756.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1261561.u87SpF2SHh
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> On Saturday, 30 June 2007 06:59, Andrey Borzenkov wrote:
> > Since 2.6.18 I do not have suspend to RAM; now I am starting to lose
> > suspend to disk :)
> >
> > Environment - vanilla kernel (2.6.22-rc6 currently + squashfs + single
> > pata_ali patch to switch off DMA on CD-ROM), single root on reiserfs,
> > libata with pata_ali driver.
> >
> > Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-rc
> > system hung at least once in every rcX. Up to rc6 those lockups were
> > absolutely silent (black screen without reaction to any key). In rc6 I
> > just got something different. After resume I got on screem:
> >
> > swsusp: Marking nosave pages: 000000000009f000-0000000000100000
> > swsusp: Basic memory bitmaps created
> > swsusp: Basic memory bitmaps freed
> >
> > After that it just sits there doing nothing. Ther was brief sound of HDD
> > but I suspect it was related more to power-on. System was responding to
> > power-on button press:
> >
> > ACPI Error (event-0305): No installed handler for fixed event [00000002
> > 20070125]
> >
> > And SysRq was functioning.
>
> That probably means that there's a deadlock somewhere in there.
>
> > Unfortunately I do not have serial console so I
> > copy manually stacks from several last screens of output; I have tried to
> > make a photo but right now my kbluetooth is refusing to work at all so I
> > cannot transfer them :( (but I suspect quality would be too bad anyway)
> >
> > laptop_mode D
> > 	io_schedule+0xe/0x20
>
> Looks suspicious to me.  Can you identify what line of code this points to?
>
> > 	sync_buffer+0x35/0x40
> > 	__wait_on_bit+0x45/0x70
> > 	out_of_line_wait_on_bit+0x6c/0x80
> > 	__wait_on_buffer+0x27/0x30
> > 	search_by_key+0x15e/0x1250 [reiserfs]
> > 	reiserfs_read_locked_inode+0x64/0x570 [reiserfs]
> > 	reiserfs_iget+0x7e/0xa0 [reiserfs]
> > 	reiserfs_lookup+0xc7/0x120 [reiserfs]
> > 	do_lookup+0x138/0x180
> > 	__link_path_walk+0x787/0xce0
> > 	link_path_walk+0x44/0xc0
> > 	path_walk+0x18/0x20
> > 	do_path_lookup_0x88/0x210
> > 	__path_lookupintent_open+0x4d/0x90
> > 	path_lookup_open+0x1f/0x30
> > 	open_exec+0x28/0xb0
> > 	do_execve+0x36/0x1d0
> > 	sys_execve+0x2e/0x80
> > 	sysenter_past_esp+0x5f/0x99
> >
> > 90clock D
> > 	__mutex_lock_slow_path+0xa1/0x290
> > 	mutex_lock+0x21/0x30
> > 	do_lookup+0xa1/0x180
> > 	__link_path_walk+0x44/0xc0
> > 	path_walk+0x18/0x20
> > 	do_path_lookup+0x78/0x210
> > 	__user_walk_fd+0x38/0x50
> > 	vfs_stat_fd+0x21/0x50
> > 	vfs_stat+0x11/0x20
> > 	sys_stat64+0x14/0x30
> > 	sysenter_past_esp+0x5f/0x99
> >
> > alsactl D
> > 	io_schedule+0xe/0x20
>
> Same here.  Hmm.
>
> > 	sync_page+0x35/0x40
> > 	__wait_on_bit_lock+0x3f/0x70
> > 	__lock_page+0x68/0x70
> > 	filemap_nopage+0x16c/0x300
> > 	__handle_mm_faul+0x1d7/0x610
> > 	do_page_fault+0x1d7/0x610
> > 	error_code+0x6a/0x70
> > 	padzero+0x1f/0x30
> > 	load_elf_binary+0x743/0x1ab0
> > 	search_binary_handler+0x7b/0x1f0
> > 	do_execve+0x137/0x1d0
> > 	sys_execve+0x2e/0x80
> > 	sysenter_past_esp+0x5f/0x90
> >
> > After that I could remount, sync and reboot using SysRq (well, after
> > reboot it still insisted on replaying insane number of transactions so
> > may be it did *not* remount / ro after all). Before reboot there was
> > brief output that resembled lockdep warnings, but it went too fast to be
> > readable.
> >
> > usual stuff follows
>
> I see you're using CFQ as the default IO scheduler.  Can you please switch
> to AS and see if that changes anything?
>

I just had the same lockup on resume using AS with 2.6.23-rc5.

--nextPart1261561.u87SpF2SHh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBG4/xlR6LMutpd94wRAqCUAJ0f3M0o8/NV4ElOY6P8nYayfkUrHgCeOu6F
r/ryv0meIJMk2alw4BcVvhc=
=nHug
-----END PGP SIGNATURE-----

--nextPart1261561.u87SpF2SHh--
