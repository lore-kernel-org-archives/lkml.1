Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbYBASab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbYBASab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYBASaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:30:22 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:18057 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbYBASaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:30:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=WolTh3yGwxnjLDwRp4exFQO3Byu3PB6nhuV2QQYKCicJNjQBC0Dn6kOOsXOzD3E9W8Cl8z8vYmO74U7LIWXaQFrId9ORcnwnsNVoqb7dcR/KIAv9S0zpq+/PmIERSsbwO1j6EQRN66jwyf+tHNf7iingXqUpziEMpFEzKDYPm5E=
Date: Fri, 1 Feb 2008 19:29:09 +0100
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, nai.xia@gmail.com, rdreier@cisco.com,
       bzolnier@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
	-g8561b089
Message-ID: <20080201182909.GA7837@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	jens.axboe@oracle.com, nai.xia@gmail.com, rdreier@cisco.com,
	bzolnier@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
	j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org
References: <20080131213740.GA4500@gollum.tnic> <20080131.173556.38717303.k-ueda@ct.jp.nec.com> <20080201075117.GC4500@gollum.tnic> <20080201.123927.71085228.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080201.123927.71085228.k-ueda@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 12:39:27PM -0500, Kiyoshi Ueda wrote:

<snip>

> > > end_that_request_last() is not called when __blk_end_reuqest()
> > > returns 1.  Then, the issuer isn't waken up.
> > > So I think the BUG() or error messages should be there.
> > 
> > you mean, end_that_request_last() isn't called when __end_that_request_first()
> > returns an error and this is the case only for fs and pc requests.
> > Otherwise it _is_ called, thus simulating somewhat the previous behavior.
> > However, we never BUG()'ged on residual byte counts before and
> > this driver has been in the kernel tree for ages, so what puzzles
> > me now is how is BUG()'ing here better than before and shouldn't we
> > simply issue a warning instead of killing the interrupt handler...
> 
> The Jens' patch passes the residual byte counts to __blk_end_request(),
> so __end_that_reqeust_first() should never return 1 and we should never
> BUG() on the residual byte counts, unless inconsistency happens such as
> the size of remaining bios is bigger than the residual byte counts.

yep.

> So if __blk_end_request() returns 1 even with the Jens' patch,
> it means that the block layer or the driver really have a bug.
> And then, the request and the bios could leak or the issuer
> would wait forever because end_that_request_last() isn't called.
> 
> The previous behavior might ignore such inconsistency and leak only
> the bios because it was calling end_that_request_last() anyway.
> I would like to BUG() in such cases personally, but I don't object
> strongly if you prefer not to BUG().

BUG() is definitely what we should do here to catch this case of sizeof(bios) >
rq->data_len. Putting a brown paper bag over the issue will never get it fixed
if it really leaks bios. Thanks for clarifying that.

By the way, shouldn't we be doing a little branch prediction here:

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 74c6087..bee05a3 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1722,7 +1722,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
         */
        if ((stat & DRQ_STAT) == 0) {
                spin_lock_irqsave(&ide_lock, flags);
-               if (__blk_end_request(rq, 0, 0))
+               if (unlikely(__blk_end_request(rq, 0, rq->data_len)))
                        BUG();
                HWGROUP(drive)->rq = NULL;
                spin_unlock_irqrestore(&ide_lock, flags);


-- 
Regards/Gruﬂ,
    Boris.
