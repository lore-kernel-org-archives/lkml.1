Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZFRPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZFRPnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZFRPnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:43:31 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:49890 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZFRPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TWx6lu4Dkp5DIqk5XTKyjXeWZqKHbUCMq1crclmQy8ujTA9HSdmlbUPFsuH57YY6jY
         GsOmNNmpXCI2n3qP0pif11RVlJpP3bVe4Mg6S4yQq3p1ArhTB42UmGNnavznSWDucacn
         bROolNEfHQIwbcw01HeLtSIyPOli+L9UnlbzE=
MIME-Version: 1.0
In-Reply-To: <87vdmt8ugm.fsf@fever.mssgmbh.com>
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	 <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
	 <87vdmt8ugm.fsf@fever.mssgmbh.com>
Date: Thu, 18 Jun 2009 17:43:31 +0200
Message-ID: <9ea470500906180843w73435e74sade8a78894f75be5@mail.gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rainer Weikusat <rweikusat@mssgmbh.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 4:52 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> Borislav Petkov <petkovbb@googlemail.com> writes:
>> On Thu, Jun 18, 2009 at 3:48 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
>>> From: Rainer Weikusat <rweikusat@mssgmbh.com>
>>>
>>> With 2.6.30, the error handling code in cdrom_newpc_intr was changed
>>> to deal with partial request failures by normally completing the 'good'
>>> parts of a request and only 'error' the last (and presumably,
>>> incompletely transferred) bio associated with a particular
>>> request. This doesn't work for requests which don't have bios
>>> associated with them ('GPCMD_READ_DISC_INFO'), because the first call
>>> to ide_end_rq, done via ide_complete_rq in order to do the
>>> partial completion part, returns with a code of zero for all non-bio
>>> requests, causing the drive->hwif->rq pointer to be set to NULL.
>>
>> This is a bit misleading, it should be more like: "ide_complete_rq is
>> called over ide_cd_error_cmd() to partially complete the rq but the rq
>> is without a bio and the block layer does partial completion only for
>> requests with bio's so this request is completed as a whole and the rq
>> freed."
>
> Technically, this is not quite correct (assuming I haven't overlooked
> something), because ide_cd_queue_pc still has a reference to the rq.

That doesn't matter because the OOPS happens after the command has been
issued and _before_ ide_cd_queue_pc() gets to access the rq ptr again.

ide_cd_queue_pc() does blk_execute_rq() which does wait for completion
of the request so it doesn't access the rq pointer before the IRQ
handler has completed. Even if it would reach the blk_put_request part,
the OOPS would have already happened.

ide_complete_rq simply does

blk_end_request
|->blk_end_bidi_request
   |->blk_finish_request

after checking the rq->bio pointer through blk_update_bidi_request() and
if the prior is NULL it does __blk_put_request in blk_finish_request and
this is where the thing vanishes.

The second time ide_complete_rq() comes to run at the end of the IRQ
handler the rq is already 0xdeadbeef :).

(this is all latest git but the old code (without the bidi stuff) did
the same thing wrt to rq->bio).


-- 
Regards/Gruss,
Boris
