Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZFROxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZFROxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZFROxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:53:09 -0400
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:34462 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZFROxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:53:09 -0400
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
In-Reply-To: <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com> (Borislav Petkov's message of "Thu\, 18 Jun 2009 16\:39\:40 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	<9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Thu, 18 Jun 2009 16:52:57 +0200
Message-ID: <87vdmt8ugm.fsf@fever.mssgmbh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (mss-uk.mssgmbh.com [217.174.251.109]); Thu, 18 Jun 2009 16:53:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <petkovbb@googlemail.com> writes:
> On Thu, Jun 18, 2009 at 3:48 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
>> From: Rainer Weikusat <rweikusat@mssgmbh.com>
>>
>> With 2.6.30, the error handling code in cdrom_newpc_intr was changed
>> to deal with partial request failures by normally completing the 'good'
>> parts of a request and only 'error' the last (and presumably,
>> incompletely transferred) bio associated with a particular
>> request. This doesn't work for requests which don't have bios
>> associated with them ('GPCMD_READ_DISC_INFO'), because the first call
>> to ide_end_rq, done via ide_complete_rq in order to do the
>> partial completion part, returns with a code of zero for all non-bio
>> requests, causing the drive->hwif->rq pointer to be set to NULL.
>
> This is a bit misleading, it should be more like: "ide_complete_rq is
> called over ide_cd_error_cmd() to partially complete the rq but the rq
> is without a bio and the block layer does partial completion only for
> requests with bio's so this request is completed as a whole and the rq
> freed."

Technically, this is not quite correct (assuming I haven't overlooked
something), because ide_cd_queue_pc still has a reference to the rq.

> please fix.

I will send a modified 'patch e-mail' soon.

Something I would like to add: The DVD-ROM mentioned below has exactly
the same 32/30 issue w/ READ DISC INFO. This used to just be an
unnoticed failure in older kernels.

[...]

>> This is fixed in the linux-ide tree since at about 2009/06/10 [Bug
>> 13399, also happens w/ TSSTcorpDVD-ROM SH-D162C],
>
> really, because I can't find it in Bart's trees. Do you have a commit
> id?

No, I just assumed that, since I found the bio-check among beginnings
of code intended to deal with the 32/30 issue.
