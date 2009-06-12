Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZFLT7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZFLT7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZFLT7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:59:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33829 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbZFLT7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:59:39 -0400
Date: Fri, 12 Jun 2009 21:59:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090612195940.GM11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com> <20090604073218.GT11363@kernel.dk> <4A27CA0A.7060400@pentek.com> <c384c5ea0906121221p6a20d92fg6716f560164c46bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c384c5ea0906121221p6a20d92fg6716f560164c46bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12 2009, Leon Woestenberg wrote:
> Steve, Jens,
> 
> another few questions:
> 
> On Thu, Jun 4, 2009 at 3:20 PM, Steve Rottinger<steve@pentek.com> wrote:
> > ...
> > - The performance is poor, and much slower than transferring directly from
> > main memory with O_DIRECT.  I suspect that this has a lot to do with
> > large amount of systems calls required to move the data, since each call moves only
> > 64K.  Maybe I'll try increasing the pipe size, next.
> >
> > Once I get past these issues, and I get the code in a better state, I'll
> > be happy to share what
> > I can.
> >
> I've been experimenting a bit using mostly-empty functions to learn
> understand the function call flow:
> 
> splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_device);
> pipe_to_device(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
> struct splice_desc *sd)
> 
> So some back-of-a-coaster calculations:
> 
> If I understand correctly, a pipe_buffer never spans more than one
> page (typically 4kB).

Correct

> The SPLICE_BUFFERS is 16, thus splice_from_pipe() is called every 64kB.

Also correct.

> The actor "pipe_to_device" is called on each pipe_buffer, so for every 4kB.

Ditto.

> For my case, I have a DMA engine that does say 200 MB/s, resulting in
> 50000 actor calls per second.
> 
> As my use case would be to splice from an acquisition card to disk,
> splice() made an interesting approach.
> 
> However, if the above is correct, I assume splice() is not meant for
> my use-case?

50000 function calls per second is not a lot. We do lots of things on a
per-page basis in the kernel. Batching would of course speed things up,
but it's not been a problem thus far. So I would not worry about 50k
function calls per second to begin with.

-- 
Jens Axboe

