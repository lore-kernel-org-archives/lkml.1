Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYDCVvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYDCVvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760936AbYDCVuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:50:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:59171 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760831AbYDCVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=tjohuk7qZga31iBrlAJj5+m3KjmnPwWMaSpzrEgAFRU62DUfAz4SKAZh0xCN5+vjzZOiFl9wV43yfLILL/hYNm8NQvSZsbx4LX7q8ju/ssTku5+5RTVgxXDyia1fzUxOPl5SxkN5v45E2zv8LNBm+HaB9R1XY964ce6N0jCiJ6o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 5/5] ide-tape: remove the last remains of pipelining
Date: Fri, 4 Apr 2008 00:04:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com> <1206812769-10065-6-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1206812769-10065-6-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804040004.50531.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 29 March 2008, Borislav Petkov wrote:
> This patch converts the tape->merge_stage pipeline stage into tape->bh, a singly
> linked list of idetape_bh's, each of which is a tag attached to one or more pages
> serving as a data buffer for chrdev requests. In particular,
> 
> 1. makes tape->bh the data buffer of size tape->buffer_size which is computed
> from the Continuous Transfer Limit value in the caps page and the tape block
> size. The chrdev rw routines use this buffer as an intermediary location to
> shuffle data to and from.

ide-tape supports write buffering (if number of bytes written to character
device is < tape->buffer_size) and it seems to be the main reason behind
tape->merge_stage.  It seems that this feature gets killed by the above
change (we may actually want to kill it later in order to implement direct
mapping of user pages but this shouldn't be done unless really necessary
since it may negatively affect performance of some "poorly" written apps).

Also:
tape->bh serves as the current bh pointer in idetape_chrdev_{read,write}()
so it doesn't seem like we can mix it with merge_stage->bh (OTOH we should
be fine with having tape->merge_bh).

> 2. mv tape->merge_stage_size => tape->cur_buf_size as it contains the offset
> within tape->bh
> 
> 3. get rid of pipeline stage idetape_stage_t, tape->merge_stage
> and pipeline-related functions __idetape_discard_read_pipeline(),
> idetape_discard_read_pipeline(), idetape_empty_write_pipeline()

Existing tape->merge_stage is first taken care of at the beggining of
idetape_chrdev_{read,write}() and only then the new one is allocated,
the above functions play important part in handling write buffering
(which is _independent_ from pipelined-mode) and idetape_discard...()
seems to play some part in tape positioning for some ioctls - I worry
that they can't be just simply deleted.

> 4. code chunk "if (tape->merge_stage_size) {...}" in idetape_chrdev_read() is not
> needed since tape->merge_stage_size, tape->cur_buf_size resp., is zeroed out in
> idetape_init_read() couple of lines above

Unless the previous user request was also idetape_chrdev_read() since in this
case idetape_init_read() returns early and existing ->merge_stage is re-used.

[...]

I like very much the general direction that this patch is going but the above
details need to be taken care of.  I suggest splitting the patch on many
smaller ones (i.e. starting with 'tape->merge_stage -> tape->merge_bh', then
inlining __idetape_discard_read_pipeline() etc.) so we may closely review
such fine-grained and _obvious_ steps.

[ ide-tape got _much_ better after your rewrites but some old parts are still
  quite puzzling & mined with gotchas - we shouldn't let guard down yet. ;) ]

Thanks,
Bart
