Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbYFXGIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbYFXGIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYFXGI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:08:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:42350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYFXGI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:08:26 -0400
From: Neil Brown <neilb@suse.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 24 Jun 2008 16:08:15 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18528.36687.631672.462076@notabene.brown>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: message from Mikulas Patocka on Tuesday June 24
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday June 24, mpatocka@redhat.com wrote:
> Hi
> 
> bio_endio calls bi_end_io callback. In case of stacked devices (raid, dm), 
> bio_end_io may call bio_endio again, up to an unspecified length.
> 
> The crash because of stack overflow was really observed on sparc64. And 
> this recursion was one of the contributing factors (using 9 stack frames 
> --- that is 1728 bytes).
> 
> This patch removes the recursion.

This is very cool, thanks!  A close mirror of the recursion
avoidance in generic_make_request.

You use a per-cpu queue were generic_make_request uses a per-task
queue.  This is fitting as bi_end_io doesn't have a process context,
but is supposed to be fast and able to run with interrupts disabled,
so tying to a cpu is no problem.

> +
> +	bio_queue = NULL;
> +queue_empty_next_bio:
> +	*bio_end_queue_ptr = &bio_queue;
> +next_bio:
> +
>   	if (error)
>   		clear_bit(BIO_UPTODATE, &bio->bi_flags);
>   	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> @@ -1175,6 +1196,17 @@
> 
>   	if (bio->bi_end_io)
>   		bio->bi_end_io(bio, error);
> +
> +	if (bio_queue) {
> +		bio = bio_queue;
> +		bio_queue = bio->bi_next;
> +		if (!bio_queue) goto queue_empty_next_bio;
> +		goto next_bio;

checkpatch.pl doesn't like that:
ERROR: trailing statements should be on next line

and I don't either.  I would not bother with the mini-optimisation at
all.
Discard the queue_empty_next_bio label and replace the "if () goto"
with
       if (!bio_queue)
		*bio_end_queue_ptr = &bio_queue;

and leave gcc to optimise the assignment if it wants to.

Reviewed-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown
