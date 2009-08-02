Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZHBVgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZHBVgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZHBVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:36:09 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36432 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZHBVgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=c1n6VxUYk0TD9FXGWV8ZrG/yyHs4mGla+VbcaxcDDU0PpSJtuepp8r+ALK2lk6s+l+
         iudBEH36zJxpP+ij1FgKYa+E7gPl3kH3WdOzyeZmRgk/MHbEZCeJ5mNsczXcDBnBLykP
         jgKWISPgRCj8na6ciU86BaCeSNnMqF9OWhAmk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: sound: -EPERM on first mplayer invocation
Date: Sun, 2 Aug 2009 23:36:48 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908022336.48898.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For a long time I observe the following nuisance:
when I run mplayer for the very first time after boot,
I can't adjust the volume. mplayer spews this to stderr:

alsa-control: error setting left channel, Operation not permitted

This happens even if I login as root and run mplayer as root.

I tracked it down to snd_ctl_elem_write in sound/core/control.c

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
                if (!(vd->access & SNDRV_CTL_ELEM_ACCESS_WRITE) ||
                    kctl->put == NULL ||
                    (file && vd->owner && vd->owner != file)) {
 printk("EPERM:\n");
 printk("vd->access & SNDRV_CTL_ELEM_ACCESS_WRITE:%x\n", vd->access & SNDRV_CTL_ELEM_ACCESS_WRITE);
 printk("kctl->put:%p\n", kctl->put);
 printk("file:%p vd->owner:%p\n", file, vd->owner);
                        result = -EPERM;
                } else {

The above printk triggers and prints:

EPERM:
vd->access & SNDRV_CTL_ELEM_ACCESS_WRITE:2
kctl->put:ffffffffa009e8de
file:ffff88007c56a5c0 vd->owner:ffff88007bc34740

Thus, vd->owner != file.

As I said, it only happens on very first run of mplayer,
and it isn't a recent change, I think I saw it at least
for one year with different kernels.

Takashi, any idea what might be happening here?
How can I help you more with tracking it down?
-- 
vda
