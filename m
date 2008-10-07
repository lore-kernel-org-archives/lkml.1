Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYJGAqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYJGAqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbYJGAnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:60377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbYJGAnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:05 -0400
Date: Mon, 6 Oct 2008 17:38:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 15/71] ALSA: fix locking in snd_pcm_open*() and
	snd_rawmidi_open*()
Message-ID: <20081007003806.GP3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-fix-locking-in-snd_pcm_open-and-snd_rawmidi_open.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Takashi Iwai <tiwai@suse.de>

Upstream-commit-id: 399ccdc1cd4e92e541d4dacbbf18c52bd693418b

The PCM and rawmidi open callbacks have a lock against card->controls_list
but it takes a wrong one, card->controls_rwsem, instead of a right one
card->ctl_files_rwlock.  This patch fixes them.

This change also fixes automatically the potential deadlocks due to
mm->mmap_sem in munmap and copy_from/to_user, reported by Sitsofe
Wheeler:

  A: snd_ctl_elem_user_tlv(): card->controls_rwsem => mm->mmap_sem
  B: snd_pcm_open(): card->open_mutex => card->controls_rwsem
  C: munmap: mm->mmap_sem => snd_pcm_release(): card->open_mutex

The patch breaks the chain.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm.c     |    4 ++--
 sound/core/rawmidi.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -781,7 +781,7 @@ int snd_pcm_attach_substream(struct snd_
 		return -ENODEV;
 
 	card = pcm->card;
-	down_read(&card->controls_rwsem);
+	read_lock(&card->ctl_files_rwlock);
 	list_for_each_entry(kctl, &card->ctl_files, list) {
 		if (kctl->pid == current->pid) {
 			prefer_subdevice = kctl->prefer_pcm_subdevice;
@@ -789,7 +789,7 @@ int snd_pcm_attach_substream(struct snd_
 				break;
 		}
 	}
-	up_read(&card->controls_rwsem);
+	read_unlock(&card->ctl_files_rwlock);
 
 	switch (stream) {
 	case SNDRV_PCM_STREAM_PLAYBACK:
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -418,7 +418,7 @@ static int snd_rawmidi_open(struct inode
 	mutex_lock(&rmidi->open_mutex);
 	while (1) {
 		subdevice = -1;
-		down_read(&card->controls_rwsem);
+		read_lock(&card->ctl_files_rwlock);
 		list_for_each_entry(kctl, &card->ctl_files, list) {
 			if (kctl->pid == current->pid) {
 				subdevice = kctl->prefer_rawmidi_subdevice;
@@ -426,7 +426,7 @@ static int snd_rawmidi_open(struct inode
 					break;
 			}
 		}
-		up_read(&card->controls_rwsem);
+		read_unlock(&card->ctl_files_rwlock);
 		err = snd_rawmidi_kernel_open(rmidi->card, rmidi->device,
 					      subdevice, fflags, rawmidi_file);
 		if (err >= 0)

-- 
