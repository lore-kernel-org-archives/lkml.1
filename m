Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0BPKBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:01:05 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:38105 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0BPKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:01:01 -0500
Message-ID: <4B7A6CD9.10903@ladisch.de>
Date: Tue, 16 Feb 2010 11:00:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Dan Carpenter <error27@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bug list: range checking issues
References: <20100215124046.GB18821@bicker>
In-Reply-To: <20100215124046.GB18821@bicker>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> sound/core/seq/oss/seq_oss_init.c +276 snd_seq_oss_open(102) error: buffer overflow 'client_table' 16 <= 16

False positive, probably because the source of the assignment is checked
for overflow:

195:	dp->index = i;
	if (i >= SNDRV_SEQ_OSS_MAX_CLIENTS) {
		...
		goto _error;
	...
276:	client_table[dp->index] = dp;

> sound/oss/sequencer.c +1638 compute_finetune(45) error: buffer overflow 'semitone_tuning' 24 <= 99

False positive; bend is at most 2399, so semitones is at most 23.
The "if (semitones > 99) semitones = 99;" check is completely bogus.

> sound/core/pcm_native.c +320 snd_pcm_hw_refine(159) warn: buffer overflow 'params->masks' 3 <= 10

This looks correct; the channels parameter is an interval, not a mask.

	if (!params->fifo_size) {
		if (snd_mask_min(&params->masks[SNDRV_PCM_HW_PARAM_FORMAT]) ==
		    snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_FORMAT]) &&
		    snd_mask_min(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS]) ==
		    snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS])) {

Jaroslav, I guess this should have been snd_interval_min/max?
And shouldn't the parameters be accessed with hw_param_mask/interval?


Regards,
Clemens
