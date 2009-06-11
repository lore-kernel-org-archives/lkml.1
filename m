Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbZFKJU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbZFKJU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZFKJUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:20:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54912 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZFKJUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:20:14 -0400
Date: Thu, 11 Jun 2009 11:20:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
Message-ID: <20090611092016.GL11363@kernel.dk>
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk> <4A2F1741.8090100@ct.jp.nec.com> <20090610043034.GW11363@kernel.dk> <4A307745.9060306@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A307745.9060306@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11 2009, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> On 06/10/2009 01:30 PM +0900, Jens Axboe wrote:
> > On Wed, Jun 10 2009, Kiyoshi Ueda wrote:
> >> On 06/10/2009 03:03 AM +0900, Jens Axboe wrote:
> >>> On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
> >>>> Hi Jens,
> >>>>
> >>>> +/*
> >>>> + * Copy request information of the original request to the clone request.
> >>>> + */
> >>>> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
> >>>> +{
> >>>> +	dst->cpu = src->cpu;
> >>>> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
> >>>> +	dst->cmd_type = src->cmd_type;
> >>>> +	dst->__sector = blk_rq_pos(src);
> >>>> +	dst->__data_len = blk_rq_bytes(src);
> >>>> +	dst->nr_phys_segments = src->nr_phys_segments;
> >>>> +	dst->ioprio = src->ioprio;
> >>>> +	dst->buffer = src->buffer;
> >>>> +	dst->cmd_len = src->cmd_len;
> >>>> +	dst->cmd = src->cmd;
> >>> Are you making sure that 'src' always exists while 'dst' is alive?
> >> Yes.
> >> Request-based dm is the owner of 'src' (original) and
> >> it never frees 'src' until the 'dst' (clone) are completed.
> >>
> >> I avoided deep-copying __cmd/buffer/sense as it's costly
> >> (additional allocation and memcpy).
> >> And I don't think there are any needs for that.
> >> But if anyone really wants that even with the copying cost,
> >> please speak up.
> > 
> > I just worry that the interface is easy to misuse. You don't document
> > the requirement that the src request may not go away while dst is used,
> > yet it's an important fact. The function advertises itself as a copy,
> > you would not normally expect any such restrictions.
> 
> OK, I see.
> Since forcing such restrictions by code-level is pretty difficult
> (e.g. bio also points pages which are not copied), I'd like to put

That's not really an issue, since the IO path doesn't deal with
references on the pages. In the case where it does, it has allocated the
page itself and the clone and original end IO must of course deal with
releasing them properly.

I'm not saying that linking to the src->__cmd is necessarily a problem,
if you stack nicely and release the original when the clone is done
(like you normally would), then it's all peachy. It just needs to be
made explicit :-)

> documents for this.
> Please see the updated patch also reflecting Boaz's comments:
>     http://marc.info/?l=dm-devel&m=124468991432260&w=2
> 
> Thanks,
> Kiyoshi Ueda

-- 
Jens Axboe

