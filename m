Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZEPHNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZEPHNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 03:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZEPHNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 03:13:13 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57902 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbZEPHNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 03:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DBXgYSIzjG9dSBgqnhOeiIHyIvRgEaUcxZs/RIGzk/QvlzI4ERNqvy+M4UfvouY1tR
         sr2+HH5/oMdhvvbDU2nspJbocMsdCSxJy9VvPEJ8yaQb/b/GMK9c1cxhIm2XxPMfRb0b
         GHytUK98g6crkBDc5JQ8W+/ggXv3RA3o4OJSM=
Date: Sat, 16 May 2009 09:13:05 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to
	blk_rq_bytes() on issue
Message-ID: <20090516071305.GA4921@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	Pete Zaitcev <zaitcev@redhat.com>,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Eric Moore <Eric.Moore@lsi.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A0D87D2.7090806@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 12:18:42AM +0900, Tejun Heo wrote:
> In commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f, while introducing
> rq->resid_len, the default value of residue count was changed from
> full count to zero.  The conversion was done under the assumption that
> when a request fails residue count wasn't defined.  However, Boaz and
> James pointed out that this wasn't true and the residue count should
> be preserved for failed requests too.
> 
> This patchset restores the original behavior by setting rq->resid_len
> to blk_rq_bytes(rq) on issue and restoring explicit clearing in
> affected drivers.  While at it, take advantage of the fact that
> rq->resid_len is set to full count where applicable.
> 
> * ide-cd: rq->resid_len cleared on pc success
> 
> * mptsas: req->resid_len cleared on success
> 
> * sas_expander: rsp/req->resid_len cleared on success
> 
> * mpt2sas_transport: req->resid_len cleared on success
> 
> * ide-cd, ide-tape, mptsas, sas_host_smp, mpt2sas_transport, ub: take
>   advantage of initial full count to simplify code

ACK the ide-{cd,tape} bits.

Acked-by: Borislav Petkov <petkovbb@gmail.com>

I've converted the ide-atapi part to rq->resid_len and from what I see,
the changes are compatible with the latest semantics of rq->resid_len
but it won't hurt if you could take a look too :) :

http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=commit;h=077e6dba20e74a455a0452379d2a965c7e1b01ad

On a side note, ide_pc_intr() does some transfer padding but that
doesn't affect rq->resid_len returning the remaining bytecount back up
to block layer.

[..]

Thanks.

-- 
Regards/Gruss,
    Boris.
