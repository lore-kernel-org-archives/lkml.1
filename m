Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbZFROjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbZFROjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbZFROjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:39:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47121 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbZFROjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vCGdduP2Z6luC4gav7yxeQy/RfuY2NXxL8YVS0HsJbqHT5S+bXqKZEgHnW2inz8+AI
         55/SRtdQ0l6CUWUAhrudpF2m0qCRgI5n6Da/QWHPHuWq63BTGy7bpwyH5aERvaeShCc/
         y6D7ltGZS/x2LolQ0X8wm5jzN786gXWcZdOxU=
MIME-Version: 1.0
In-Reply-To: <87zlc58xgd.fsf@fever.mssgmbh.com>
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
Date: Thu, 18 Jun 2009 16:39:40 +0200
Message-ID: <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rainer Weikusat <rweikusat@mssgmbh.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we we're just debugging this and I was about to send the patches
tomorrow but you beat me to it :).

On Thu, Jun 18, 2009 at 3:48 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> From: Rainer Weikusat <rweikusat@mssgmbh.com>
>
> With 2.6.30, the error handling code in cdrom_newpc_intr was changed
> to deal with partial request failures by normally completing the 'good'
> parts of a request and only 'error' the last (and presumably,
> incompletely transferred) bio associated with a particular
> request. This doesn't work for requests which don't have bios
> associated with them ('GPCMD_READ_DISC_INFO'), because the first call
> to ide_end_rq, done via ide_complete_rq in order to do the
> partial completion part, returns with a code of zero for all non-bio
> requests, causing the drive->hwif->rq pointer to be set to NULL.

This is a bit misleading, it should be more like: "ide_complete_rq is
called over ide_cd_error_cmd() to partially complete the rq but the rq
is without a bio and the block layer does partial completion only for
requests with bio's so this request is completed as a whole and the rq
freed."

please fix.

> Upon
> calling ide_complete_rq a second time, it is attempted to de-reference
> this null pointer, resulting in a kernel crash.
>
> Signed-Off-By: Rainer Weikusat <rweikusat@mssgmbh.com>
>
> ---
>
> This is fixed in the linux-ide tree since at about 2009/06/10 [Bug
> 13399, also happens w/ TSSTcorpDVD-ROM SH-D162C],

really, because I can't find it in Bart's trees. Do you have a commit
id?

> but a patch
> against 2.6.30 AFAIK doesn't exist (and I didn't find the
> corresponding thread before digging through all of this ...).
> --- drivers/ide/ide-cd.c.orig   2009-06-18 15:10:24.000000000 +0200
> +++ drivers/ide/ide-cd.c        2009-06-18 14:10:16.000000000 +0200
> @@ -758,7 +758,7 @@ out_end:
>                                rq->errors = -EIO;
>                }
>
> -               if (uptodate == 0)
> +               if (uptodate == 0 && rq->bio)
>                        ide_cd_error_cmd(drive, cmd);
>
>                /* make sure it's fully ended */
>

-- 
Regards/Gruss,
Boris
