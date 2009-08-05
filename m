Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZHEV70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZHEV70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZHEV7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:59:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56691 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZHEV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=FpaczT3ib5mB1php+i57+oV//znAP6fZlaKX83vHFZ4En7ygvO4dDKtXot+Kxss0uf
         KAPGfdG4pJ48Vw8MIhe4wIbXJF5e/FoXhUlGX1RUasBVIxFGUHNb45mFE2/sDEAN4qed
         is/rZX5PmaR7tUJ4XmIrpLeGVX67t3eUuXegg=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>, mplayer-users@mplayerhq.hu
Subject: Re: sound: -EPERM on first mplayer invocation
Date: Thu, 6 Aug 2009 00:00:01 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <200908022336.48898.vda.linux@googlemail.com> <s5hd47aes85.wl%tiwai@suse.de> <s5hab2ees0v.wl%tiwai@suse.de>
In-Reply-To: <s5hab2ees0v.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908060000.01922.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added mplayer-users@mplayerhq.hu to To:]

On Wednesday 05 August 2009 07:41, Takashi Iwai wrote:
> At Wed, 05 Aug 2009 07:37:30 +0200,
> > > I modified 2.6.31-rc2 source as follows:
> > > 
> > > static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
> > >                               struct snd_ctl_elem_value *control)
> > > {
> > >         struct snd_kcontrol *kctl;
> > >         struct snd_kcontrol_volatile *vd;
> > >         unsigned int index_offset;
> > >         int result;
> > > 
> > >         down_read(&card->controls_rwsem);
> > >         kctl = snd_ctl_find_id(card, &control->id);
> > >         if (kctl == NULL) {
> > >                 result = -ENOENT;
> > >         } else {
> > >                 index_offset = snd_ctl_get_ioff(kctl, &control->id);
> > >                 vd = &kctl->vd[index_offset];
> > > if (file && vd->owner)
> > >  printk("file:%p vd->owner:%p\n", file, vd->owner);
> > >                 if (!(vd->access & SNDRV_CTL_ELEM_ACCESS_WRITE) ||
> > >                     kctl->put == NULL ||
> > >                     (file && vd->owner && vd->owner != file)) {
> > > if (file && vd->owner)
> > >  printk("vd->owner_pid:%d vd->owner->pid:%d file->pid:%d\n", vd->owner_pid, vd->owner->pid, file->pid);
> > >                         result = -EPERM;
> > >                 } else {
> > > ...
> > > 
> > > and when I start mplayer, I see this:
> > > 
> > > dmesg:
> > > file:ffff8800798af940 vd->owner:ffff8800798af940
> > > file:ffff8800798af940 vd->owner:ffff8800798af940
> > > 
> > > I assume it's some sort of initialization, no EPERM here.
> > > Then I press "lower the volume" key (keypad "/")
> > > in mplayer window, twice:
> > > 
> > > dmesg:
> > > file:ffff8800798af8c0 vd->owner:ffff8800798af940
> > > vd->owner_pid:0 vd->owner->pid:2067 file->pid:2067
> > > file:ffff8800798af740 vd->owner:ffff8800798af940
> > > vd->owner_pid:0 vd->owner->pid:2067 file->pid:2067
> > 
> > The file instances are different.  It implies that mplayer opens the
> > device at each time but doesn't close.
> > It sounds like a bug in mplayer to me.
> 
> ... or the first control handle keeps opened and blocks it.
> A question is how is your PCM configuration and which control element
> is locked?  The latter can be seen by adding a printk of kctl->id.name.

I see this in dmesg:

file:ffff88007d28e7c0 vd->owner:ffff88007d28e7c0 kctl->id.name:'PCM Playback Volume'
file:ffff88007d28e7c0 vd->owner:ffff88007d28e7c0 kctl->id.name:'PCM Playback Volume'
file:ffff88007d28e740 vd->owner:ffff88007d28e7c0 kctl->id.name:'PCM Playback Volume'
vd->owner_pid:0 vd->owner->pid:2086 file->pid:2086
file:ffff88007d28e5c0 vd->owner:ffff88007d28e7c0 kctl->id.name:'PCM Playback Volume'
vd->owner_pid:0 vd->owner->pid:2086 file->pid:2086

I straced mplayer. I pressed "lower the volume" key
twice within about 3 seconds, then exited mplayer.

I see this in strace (filtered using
"grep -e open -e close -e error -e /dev/ STRACE_LOG"):

...
23:38:19.825798 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.825951 close(6)                = 0
23:38:19.826325 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.826445 close(6)                = 0
23:38:19.826543 open("/dev/snd/controlC0", O_RDWR) = 6
23:38:19.826870 close(6)                = 0
...
23:38:19.844860 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.844973 close(6)                = 0
23:38:19.845282 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.845390 close(6)                = 0
23:38:19.845500 open("/dev/snd/controlC0", O_RDWR) = 6
23:38:19.845797 close(6)                = 0
23:38:19.855205 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.855338 close(6)                = 0
23:38:19.855647 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.855755 close(6)                = 0
23:38:19.855848 open("/dev/snd/controlC0", O_RDWR) = 6
23:38:19.856145 close(6)                = 0
23:38:19.856323 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.856440 close(6)                = 0
23:38:19.856762 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.856870 close(6)                = 0
23:38:19.856964 open("/dev/snd/controlC0", O_RDWR) = 6
23:38:19.857257 close(6)                = 0
23:38:19.857442 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.857549 close(6)                = 0
23:38:19.857836 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.857943 close(6)                = 0
23:38:19.858038 open("/dev/snd/controlC0", O_RDWR) = 6
23:38:19.858329 close(6)                = 0
...
23:38:19.874866 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.874977 close(6)                = 0
23:38:19.876461 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.876574 close(6)                = 0
23:38:19.876675 open("/dev/snd/controlC0", O_RDWR) = 6
23:38:19.876977 open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK) = 7
23:38:19.877202 close(6)                = 0
23:38:19.891060 open("/dev/snd/controlC0", O_RDONLY) = 6
23:38:19.891177 close(6)                = 0
23:38:19.891278 open("/dev/snd/timer", O_RDONLY|O_NONBLOCK) = 6
23:38:19.891781 open("/proc/cpuinfo", O_RDONLY) = 8
23:38:19.892409 close(8)                = 0
23:38:19.892727 open("/dev/snd/controlC0", O_RDONLY) = 8
23:38:19.892834 close(8)                = 0
23:38:19.893166 open("/dev/snd/controlC0", O_RDONLY) = 8
23:38:19.893274 close(8)                = 0
23:38:19.893369 open("/dev/snd/controlC0", O_RDWR) = 8
23:38:19.894819 write(1, "alsa-init: pcm opend in blocking"..., 38) = 38
...
...
	Here I press "lower the volume" key:
23:38:28.343401 open("/dev/snd/controlC0", O_RDONLY) = 9
23:38:28.343530 close(9)                = 0
23:38:28.343630 open("/dev/snd/controlC0", O_RDWR) = 9
23:38:28.354506 close(9)                = 0
23:38:28.354908 open("/dev/snd/controlC0", O_RDONLY) = 9
23:38:28.355024 close(9)                = 0
23:38:28.355119 open("/dev/snd/controlC0", O_RDWR) = 9
23:38:28.365707 write(2, "alsa-control: error setting left"..., 66) = 66
23:38:28.367310 open("/dev/snd/controlC0", O_RDONLY) = 10
23:38:28.367427 close(10)               = 0
23:38:28.367539 open("/dev/snd/controlC0", O_RDWR) = 10
23:38:28.381267 close(10)               = 0
	And again:
23:38:31.503361 open("/dev/snd/controlC0", O_RDONLY) = 10
23:38:31.503489 close(10)               = 0
23:38:31.503589 open("/dev/snd/controlC0", O_RDWR) = 10
23:38:31.514280 close(10)               = 0
23:38:31.514690 open("/dev/snd/controlC0", O_RDONLY) = 10
23:38:31.514805 close(10)               = 0
23:38:31.514899 open("/dev/snd/controlC0", O_RDWR) = 10
23:38:31.525305 write(2, "alsa-control: error setting left"..., 66) = 66
23:38:31.526167 open("/dev/snd/controlC0", O_RDONLY) = 11
23:38:31.526283 close(11)               = 0
23:38:31.526382 open("/dev/snd/controlC0", O_RDWR) = 11
23:38:31.539630 close(11)               = 0
	I press ESC:
23:38:34.385307 close(3)                = 0
23:38:34.403561 close(6)                = 0
23:38:34.403883 close(7)                = 0
23:38:34.404767 close(8)                = 0
23:38:34.404921 write(1, "alsa-uninit: pcm closed\n", 24) = 24
23:38:34.405961 close(5)                = 0

Obviously, mplayer forgets to close fds opened to /dev/snd/controlC0:
first, fd 8; it opens a new one (fd 9) and gets error out of it.
Then, after 1st error, it similarly does not close or reuse fd 9
but opens fd 10.

For mplayer folks: my ~/.mplayer/config is:

msglevel=all=6
ao=alsa
monitoraspect=5:4

And command line is just:

mplayer The_league_of_extraordinary_gentlemen.avi

For completeness, here is unabridged strace from the moment
I press "\" for the 1st time until -EPERM is seen:

23:38:28.342959 read(0, "/", 256)       = 1
23:38:28.343136 stat64("/usr/app/alsa-lib-1.0.17a/share/alsa/alsa.conf", {st_mode=S_IFREG|0644, st_size=9008, ...}) = 0
23:38:28.343401 open("/dev/snd/controlC0", O_RDONLY) = 9
23:38:28.343530 close(9)                = 0
23:38:28.343630 open("/dev/snd/controlC0", O_RDWR) = 9
23:38:28.343736 ioctl(9, USBDEVFS_CONTROL, 0xffd31984) = 0
23:38:28.343846 fcntl64(9, F_GETFL)     = 0x2 (flags O_RDWR)
23:38:28.343984 fcntl64(9, F_SETFL, O_RDWR|O_NONBLOCK) = 0
23:38:28.344112 ioctl(9, USBDEVFS_RELEASEINTERFACE, 0xffd31a00) = 0
23:38:28.344214 ioctl(9, USBDEVFS_RELEASEINTERFACE, 0xffd31a00) = 0
23:38:28.344461 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.344606 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.344713 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.344819 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.344916 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.345013 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.345127 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.345226 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.345326 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.345425 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.345535 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.345633 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.345730 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.345830 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.345928 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.346026 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.346123 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.346220 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.346319 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.346417 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.346524 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.346620 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.346717 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.346816 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.346914 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.347012 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.347108 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.347205 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.347304 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.347402 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.347508 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.347604 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.347701 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.347800 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.347898 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.347996 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.348092 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.348188 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.348288 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.348387 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.348493 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.348590 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.348687 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.348787 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.348885 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.348982 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.349079 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.349176 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.349277 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.349373 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.349479 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.349579 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.349677 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.349775 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.349872 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.349969 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.350069 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.350169 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.350269 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.350368 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.350475 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.350573 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.350670 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.350769 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.350866 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.350990 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351091 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.351190 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351286 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351381 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351486 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351586 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.351685 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351780 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.351878 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.351975 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.352072 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.352173 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.352271 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.352369 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.353085 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.353208 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.353330 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.353450 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.353554 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.353653 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.353754 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.353852 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.353953 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.354052 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31760) = 0
23:38:28.354151 ioctl(9, USBDEVFS_IOCTL, 0xffd31320) = 0
23:38:28.354248 ioctl(9, USBDEVFS_IOCTL, 0xffd31330) = 0
23:38:28.354348 ioctl(9, USBDEVFS_DISCONNECT, 0xffd319e8) = 0
23:38:28.354506 close(9)                = 0
23:38:28.354639 stat64("/usr/app/alsa-lib-1.0.17a/share/alsa/alsa.conf", {st_mode=S_IFREG|0644, st_size=9008, ...}) = 0
23:38:28.354908 open("/dev/snd/controlC0", O_RDONLY) = 9
23:38:28.355024 close(9)                = 0
23:38:28.355119 open("/dev/snd/controlC0", O_RDWR) = 9
23:38:28.355226 ioctl(9, USBDEVFS_CONTROL, 0xffd31924) = 0
23:38:28.355321 fcntl64(9, F_GETFL)     = 0x2 (flags O_RDWR)
23:38:28.355415 fcntl64(9, F_SETFL, O_RDWR|O_NONBLOCK) = 0
23:38:28.355519 ioctl(9, USBDEVFS_RELEASEINTERFACE, 0xffd319a0) = 0
23:38:28.355620 ioctl(9, USBDEVFS_RELEASEINTERFACE, 0xffd319a0) = 0
23:38:28.355811 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.355913 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.356013 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.356111 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.356208 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.356304 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.356404 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.356511 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.356610 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.356709 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.356809 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.356906 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.357003 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.357104 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.357203 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.357301 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.357398 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.357504 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.357604 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.357702 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.357800 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.357897 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.357993 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.358093 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.358191 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.358289 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.358385 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.358490 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.358590 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.358689 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.358824 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.358921 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.359018 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.359117 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.359215 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.359313 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.359410 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.359515 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.359631 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.359730 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.359827 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.359924 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.360021 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.360121 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.360220 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.360317 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.360414 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.360521 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.360622 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.360719 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.360816 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.360916 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.361014 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.361112 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.361209 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.361307 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.361407 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.361515 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.361616 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.361715 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.361814 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.361971 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.362069 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.362169 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.362266 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.362363 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.362473 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.362572 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.362668 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.362914 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.363010 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.363112 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.363211 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.363307 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.363405 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.363511 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.363608 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.363744 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.363844 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.363943 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.364040 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.364138 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.364242 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.364342 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.364453 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.364552 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.364652 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.364750 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.364850 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.364948 ioctl(9, USBDEVFS_CONNECTINFO, 0xffd31700) = 0
23:38:28.365046 ioctl(9, USBDEVFS_IOCTL, 0xffd312c0) = 0
23:38:28.365143 ioctl(9, USBDEVFS_IOCTL, 0xffd312d0) = 0
23:38:28.365238 ioctl(9, USBDEVFS_DISCONNECT, 0xffd31988) = 0
23:38:28.365343 ioctl(9, USBDEVFS_IOCTL, 0xffd316b0) = 0
23:38:28.365456 ioctl(9, USBDEVFS_HUB_PORTINFO, 0xffd316b0) = -1 EPERM (Operation not permitted)
23:38:28.365565 ioctl(9, USBDEVFS_IOCTL, 0xffd315b0) = 0
23:38:28.365707 write(2, "alsa-control: error setting left"..., 66) = 66


--
vda
