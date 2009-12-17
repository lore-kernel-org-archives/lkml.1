Return-Path: <linux-kernel-owner+w=401wt.eu-S1763692AbZLQBqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763692AbZLQBqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763077AbZLQBTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:19:54 -0500
Received: from kroah.org ([198.145.64.141]:47751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763547AbZLQBTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:58 2009
Message-Id: <20091217011558.481887504@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [05/90] ALSA: hrtimer - Fix lock-up
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit fcfdebe70759c74e2e701f69aaa7f0e5e32cf5a6 upstream.

The timer stop callback can be called from snd_timer_interrupt(), which
is called from the hrtimer callback.  Since hrtimer_cancel() waits for
the callback completion, this eventually results in a lock-up.

This patch fixes the problem by just toggling a flag at stop callback
and call hrtimer_cancel() later.

Reported-and-tested-by: Wojtek Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/hrtimer.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -37,14 +37,22 @@ static unsigned int resolution;
 struct snd_hrtimer {
 	struct snd_timer *timer;
 	struct hrtimer hrt;
+	atomic_t running;
 };
 
 static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 {
 	struct snd_hrtimer *stime = container_of(hrt, struct snd_hrtimer, hrt);
 	struct snd_timer *t = stime->timer;
+
+	if (!atomic_read(&stime->running))
+		return HRTIMER_NORESTART;
+
 	hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
 	snd_timer_interrupt(stime->timer, t->sticks);
+
+	if (!atomic_read(&stime->running))
+		return HRTIMER_NORESTART;
 	return HRTIMER_RESTART;
 }
 
@@ -58,6 +66,7 @@ static int snd_hrtimer_open(struct snd_t
 	hrtimer_init(&stime->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	stime->timer = t;
 	stime->hrt.function = snd_hrtimer_callback;
+	atomic_set(&stime->running, 0);
 	t->private_data = stime;
 	return 0;
 }
@@ -78,16 +87,18 @@ static int snd_hrtimer_start(struct snd_
 {
 	struct snd_hrtimer *stime = t->private_data;
 
+	atomic_set(&stime->running, 0);
+	hrtimer_cancel(&stime->hrt);
 	hrtimer_start(&stime->hrt, ns_to_ktime(t->sticks * resolution),
 		      HRTIMER_MODE_REL);
+	atomic_set(&stime->running, 1);
 	return 0;
 }
 
 static int snd_hrtimer_stop(struct snd_timer *t)
 {
 	struct snd_hrtimer *stime = t->private_data;
-
-	hrtimer_cancel(&stime->hrt);
+	atomic_set(&stime->running, 0);
 	return 0;
 }
 


