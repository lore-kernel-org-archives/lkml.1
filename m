Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbZHECbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbZHECbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbZHECbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:31:48 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62061 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbZHECbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=A4XeN2VFyHAWPya2euCg/NlgCDlNdpN70Ohb+kAJwX3ooKt/bTETBGdZgXMZ/C2SCl
         dB1mvZblc7CILQy7vzGeNoOTC9jVME5l/HgNtanHblq/xuuOMpxHRCfYPjRGflJIddv6
         etmkq6ht3B+Kdroh++lMfcBce+5sMSDMl5zck=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: sound: -EPERM on first mplayer invocation
Date: Wed, 5 Aug 2009 04:32:34 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <200908022336.48898.vda.linux@googlemail.com> <200908041101.43252.vda.linux@googlemail.com> <s5hskg8aqhr.wl%tiwai@suse.de>
In-Reply-To: <s5hskg8aqhr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908050432.35016.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009 11:16, Takashi Iwai wrote:
> > > > For a long time I observe the following nuisance:
> > > > when I run mplayer for the very first time after boot,
> > > > I can't adjust the volume. mplayer spews this to stderr:
> > > > 
> > > > alsa-control: error setting left channel, Operation not permitted
> > > > 
> > > > This happens even if I login as root and run mplayer as root.
> > > > 
> > > > I tracked it down to snd_ctl_elem_write in sound/core/control.c
> > > > 
> > ...
> > > > 
> > > > Thus, vd->owner != file.
> > > > 
> > > > As I said, it only happens on very first run of mplayer,
> > > > and it isn't a recent change, I think I saw it at least
> > > > for one year with different kernels.
> > > > 
> > > > Takashi, any idea what might be happening here?
> > > > How can I help you more with tracking it down?
> > > 
> > > This implies that another process (e.g. a sound daemon like PA)
> > > already opened the device and locked this specific control element.
> > > If so, this is no bug but the right behavior.
> > > Check "fuser /dev/snd/controlC*".
> > 
> > Nothing uses them:
> > 
> > shadow:~# lsof -nP | grep '/dev/.*control'
> > shadow:~# fuser /dev/snd/controlC*
> > shadow:~#
> > 
> > I tried running bare X with only xterm and mplayer,
> 
> Hm, but according to your debug session, the vd->owner is set
> to a different value, right?  Check vd->owner_pid in the error path.
> It'll show the pid blocking that control element.

I modified 2.6.31-rc2 source as follows:

static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
                              struct snd_ctl_elem_value *control)
{
        struct snd_kcontrol *kctl;
        struct snd_kcontrol_volatile *vd;
        unsigned int index_offset;
        int result;

        down_read(&card->controls_rwsem);
        kctl = snd_ctl_find_id(card, &control->id);
        if (kctl == NULL) {
                result = -ENOENT;
        } else {
                index_offset = snd_ctl_get_ioff(kctl, &control->id);
                vd = &kctl->vd[index_offset];
if (file && vd->owner)
 printk("file:%p vd->owner:%p\n", file, vd->owner);
                if (!(vd->access & SNDRV_CTL_ELEM_ACCESS_WRITE) ||
                    kctl->put == NULL ||
                    (file && vd->owner && vd->owner != file)) {
if (file && vd->owner)
 printk("vd->owner_pid:%d vd->owner->pid:%d file->pid:%d\n", vd->owner_pid, vd->owner->pid, file->pid);
                        result = -EPERM;
                } else {
...

and when I start mplayer, I see this:

dmesg:
file:ffff8800798af940 vd->owner:ffff8800798af940
file:ffff8800798af940 vd->owner:ffff8800798af940

I assume it's some sort of initialization, no EPERM here.
Then I press "lower the volume" key (keypad "/")
in mplayer window, twice:

dmesg:
file:ffff8800798af8c0 vd->owner:ffff8800798af940
vd->owner_pid:0 vd->owner->pid:2067 file->pid:2067
file:ffff8800798af740 vd->owner:ffff8800798af940
vd->owner_pid:0 vd->owner->pid:2067 file->pid:2067

mplayer:
alsa-control: error setting left channel, Operation not permitted

The pid is mplayer's pid:

# ps -A | grep mpl
 2067 root       0:01 mplayer The_league_of_extraordinary_gentlemen.avi
 2081 root       0:00 grep mpl

It has one thread, btw, no funky multithreading stuff:

# ls -l /proc/2067/task
dr-xr-xr-x    4 root     root            0 Aug  5 04:28 2067

-- 
vda
