Return-Path: <linux-kernel-owner+w=401wt.eu-S1766986AbXDENyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766986AbXDENyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766988AbXDENyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:54:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28127 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766986AbXDENx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=nhw6SZQpRc2W9woO+vTPnyfoh6RCs40DPwCQrm9MTE87rnfxH9mMzHcDQvAwbDdspigEtobG8LK+9UJ5LxwyxQZn1ALgRZ3Lv51Klm36/N6Ccy00LzmxqAGEyD0QPmuPPVDeuH9yinlTr5A4yXR0cAh4WYQjBMsJbR/oDDMGgIU=
Date: Thu, 5 Apr 2007 15:53:50 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, perex@suse.cz
Subject: [-mm patch] pcm_native: lockdep warning when launching jack
Message-ID: <20070405135350.GB1917@slug>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 10:47:45PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
Hi,

When launching "jackd -d alsa", lockdep issues the following warning:
[39701.405086] =============================================
[39701.405093] [ INFO: possible recursive locking detected ]
[39701.405107] 2.6.21-rc5-mm4 #2
[39701.405109] ---------------------------------------------
[39701.405112] jackd/17366 is trying to acquire lock:
[39701.405114]  (&substream->self_group.lock){....}, at: [<c034d3c0>] snd_pcm_action_group+0x90/0x240
[39701.405131]
[39701.405131] but task is already holding lock:
[39701.405134]  (&substream->self_group.lock){....}, at: [<c034d63f>] snd_pcm_action_lock_irq+0x3f/0xb0
[39701.405141]
[39701.405142] other info that might help us debug this:
[39701.405145] 3 locks held by jackd/17366:
[39701.405147]  #0:  (snd_pcm_link_rwlock){....}, at: [<c034d627>] snd_pcm_action_lock_irq+0x27/0xb0
[39701.405155]  #1:  (&substream->group->lock){....}, at: [<c034d638>] snd_pcm_action_lock_irq+0x38/0xb0
[39701.405163]  #2:  (&substream->self_group.lock){....}, at: [<c034d63f>] snd_pcm_action_lock_irq+0x3f/0xb0
[39701.405171]
[39701.405171] stack backtrace:
[39701.405174]  [<c0103b8a>] show_trace_log_lvl+0x1a/0x30
[39701.405179]  [<c0104912>] show_trace+0x12/0x20
[39701.405183]  [<c01049c6>] dump_stack+0x16/0x20
[39701.405187]  [<c013b980>] __lock_acquire+0xbd0/0x1040
[39701.405193]  [<c013be60>] lock_acquire+0x70/0x90
[39701.405197]  [<c0407846>] _spin_lock+0x36/0x50
[39701.405203]  [<c034d3c0>] snd_pcm_action_group+0x90/0x240
[39701.405207]  [<c034d653>] snd_pcm_action_lock_irq+0x53/0xb0
[39701.405211]  [<c035046f>] snd_pcm_common_ioctl1+0x35f/0xfb0
[39701.405215]  [<c0351544>] snd_pcm_playback_ioctl1+0x34/0x420
[39701.405219]  [<c03519f3>] snd_pcm_playback_ioctl+0x43/0x50
[39701.405223]  [<c017ecc8>] do_ioctl+0x28/0x80
[39701.405229]  [<c017ed77>] vfs_ioctl+0x57/0x290
[39701.405233]  [<c017efe9>] sys_ioctl+0x39/0x60
[39701.405237]  [<c0102bf4>] sysenter_past_esp+0x5d/0x99
[39701.405240]  =======================

The attached lockdep annotation silences the warning.
Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

--- 2.6.21-rc5-mm3/sound/core/pcm_native.c	2007-03-30 21:41:18.000000000 +0200
+++ 2.6.21-rc5-mm4/sound/core/pcm_native.c	2007-04-05 15:01:19.000000000 +0200
@@ -718,7 +718,8 @@ static int snd_pcm_action_group(struct a
 
 	snd_pcm_group_for_each_entry(s, substream) {
 		if (do_lock && s != substream)
-			spin_lock(&s->self_group.lock);
+			spin_lock_nested(&s->self_group.lock,
+					 SINGLE_DEPTH_NESTING);
 		res = ops->pre_action(s, state);
 		if (res < 0)
 			goto _unlock;
