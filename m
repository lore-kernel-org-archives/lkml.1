Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZDPG3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZDPG3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZDPG3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:29:12 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45799 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZDPG3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=kdL1hKID48Xe4JI0nAiuJ9F+YoMkfO+jSdneX0p6wdkJw1eS3fgqFjSQDAH7XxV5PD
         4puHIGa1MYO5+E4evwJVQ4+1ttIRCOgFVz5xUhDX88sbyBR/Pxk+Tc8X+jUmkfWUrUt+
         Eg7/SOQaiGA+SuIlpFjx3jpmmMxz4DbNMY2lI=
Date: Thu, 16 Apr 2009 08:29:04 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com,
       James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Message-ID: <20090416062904.GA13487@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	bharrosh@panasas.com, James.Bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org
References: <49E6A0B5.2090704@kernel.org> <20090416054457.GA13226@liondog.tnic> <49E6CB0D.3060307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49E6CB0D.3060307@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, Apr 16, 2009 at 03:07:09PM +0900, Tejun Heo wrote:

[..]

> There was another problem.  If we use blk_rq_map_kern() the failed rq
> must be finished after the sense rq is finished because that's when
> the bio is copied back if it was copied.  Before sense_rq completion,
> the sense buffer doesn't contain any valid data.

Well, as an idea, we could just postpone the completion of the failed rq
in:

if (sense && uptodate)
        ide_cd_complete_failed_rq(drive, rq);

and put that just after

ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);

line in cdrom_newpc_intr(). This way, we can copy back the sense data
safely and then kill the rq.

The only problem I fear with changes like that is that later some subtle
interactions come about with some device which shouldn't normally
happen. This is old code, you know, which still needs lots of scrubbing.
It's like walking on a minefield :).

Thanks.

-- 
Regards/Gruss,
    Boris.
