Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZEIIAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZEIIAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZEIIAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:00:35 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:49790 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZEIIAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:00:34 -0400
Date: Sat, 9 May 2009 10:02:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] ide-tape: fix potential fs requests bug
Message-ID: <20090509080245.GB22617@uranus.ravnborg.org>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-2-git-send-email-petkovbb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241855134-4984-2-git-send-email-petkovbb@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 09:45:21AM +0200, Borislav Petkov wrote:
> ide-tape had a potential bug for fs requests when preparing the command
> packet: it was writing the transfer length as a number of fixed blocks.
> However, the block layer implies 512 byte blocks and ide-tape can have
> other block sizes so account for that too.
> 
> ide-floppy does this calculation properly with the block size factor
> (floppy->bs_factor).
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index e166045..fc79cf4 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -586,7 +586,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
>  				   struct ide_atapi_pc *pc, struct request *rq,
>  				   u8 opcode)
>  {
> -	unsigned int length = blk_rq_sectors(rq);
> +	unsigned int length = blk_rq_sectors(rq) / (tape->blk_size >> 9);

If tape->blk_size equals 256 or less then we get a divide-by-zero.

	Sam
