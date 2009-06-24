Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbZFXRob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbZFXRob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbZFXRoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:44:18 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34230 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760863AbZFXRoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VLh36DfUoURWAlMuHMDo9t03f+7U2+nZvInf6xLhVsoCDaY78LXAqn6H3SYVXm5EL4
         ssK5PWFms7exzTUmUnGGYDlePOJMi6pCelTm8Knmi8z5fTx+YHzGA+D+gJ36KVA6/Ik3
         DG1ggfVJa+IXR6x+6pJNS0dYrYZs+JxI3jc7E=
Date: Wed, 24 Jun 2009 19:44:11 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special
	ide-{floppy,tape} driver requests
Message-ID: <20090624174411.GA5729@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	David Miller <davem@davemloft.net>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	htejun@gmail.com
References: <200906232326.06830.bzolnier@gmail.com> <20090623.234929.32348223.davem@davemloft.net> <200906241209.53891.bzolnier@gmail.com> <20090624.033909.147195176.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090624.033909.147195176.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 03:39:09AM -0700, David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Wed, 24 Jun 2009 12:09:53 +0200
> 
> > The obscure reasons is just the fact that both ide-floppy and ide-tape
> > had a they own duplicated/buggy request completion routines.
> > 
> > While they were being unified the whole bunch of similar class of bugs
> > were fixed so I agree that there may still be more issues to deal with
> > there.
> 
> I see, the ->pc_callback() of these things set rq->errors and then
> ide_pc_intr() happily overrides whatever was set there, either on it's
> own or via ide_complete_rq().
> 
> I'll look over this some more while I wait for the testing results
> from Borislav.

Ok, let's see now, I did some testing but can't seem to hit that
particular path because it is taken relatively rarely - it can be
reached from start_request() and ide_atapi_error() via ide_error for
ide-floppy and ide-tape.

If my code staring doesn't mislead me, the start_request()-one has to
happen during an IDE reset operation, while we're polling for reset
completion _and_ when drive->failures has reached drive->max_failures
since this is the only site the drive->failures counter is increased.

The ide_atapi_error() cannot happen because (!blk_fs_request(rq))
requests are being completed in ide_error() with the respective error
status.

It is possible that I've missed something so feel free to correct me
and/or suggest a different testing approach.

Thanks.

-- 
Regards/Gruss,
    Boris.
