Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbXJaKTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbXJaKTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXJaKTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:19:30 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8001 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754164AbXJaKT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:19:29 -0400
Message-ID: <4728569D.9080502@panasas.com>
Date: Wed, 31 Oct 2007 12:19:09 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] "killing" sg_last(), and discussion
References: <20071031084920.GA25202@havoc.gtf.org>
In-Reply-To: <20071031084920.GA25202@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2007 10:18:30.0608 (UTC) FILETIME=[627FA500:01C81BA7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007 at 10:49 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> I looked into killing sg_last(), but really, this is the best its gonna
> get (moving sg_last to libata-core.c).
> 
> You could maybe kill one use with caching, but in the other sg_last()
> callsites there isn't another s/g loop we can stick a "last_sg = sg;"
> into.
> 
> libata is stuck because we undertake the highly unusual operation of
> fiddling with the final S/G element, to enforce 32-bit alignment.
> 
> Of course we could eliminate all that nasty fiddling/padding
> completely, including sg_last(), if other areas of the kernel would
> guarantee ahead of time that buffer lengths are always a multiple
> of 4........
> 
> 	Jeff
> 
OK Now I'm confused. I thought that ULD's can give you SG's 
that are actually longer than bufflen and that, at the end, the 
bufflen should govern the transfer length.

Now FS_PC commands are sector aligned so you do not have
problems with that.

The BLOCK_PC commands have 2 main sources that I know of
one is sg && bsg from user mode that can easily enforce
4 bytes alignment. The second is kernel services which 80%
of these are done by scsi_execute(). All These can be found
and fixed. Starting with scsi_execute(). Another place can be
blk_rq_map_sg(), since all IO's are bio based. It can enforce 
alignment too.

I would start by sticking a WARN_ON(qc->pad_len) and
see if it triggers, what are the sources of that.

Please note that the code already has a 4 bytes alignment
assumption about the start of the transfer, other wise
the first SG can also have a none aligned length, which
is not checked for.

Boaz
