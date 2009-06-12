Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbZFLTWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbZFLTWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759103AbZFLTVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:21:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:18982 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZFLTVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pSMLc9/34NH/rEzyk0cQLxfnsMOamrYZSUNl2nL9cdgFzUEF3dWL2ZbGEs6j69fUt5
         EdFS7/6mY3miUhskgWzD26zjzUTOIjybA9lvAxONK6LTBNRmjMm8eFttnksex3aZo09d
         zcJmgc6OpXrjh77gUdwylelHZhxLzep0sXt5w=
MIME-Version: 1.0
In-Reply-To: <4A27CA0A.7060400@pentek.com>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk>
	 <4A0AFC62.3090002@pentek.com>
	 <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com>
	 <20090604073218.GT11363@kernel.dk> <4A27CA0A.7060400@pentek.com>
Date: Fri, 12 Jun 2009 21:21:54 +0200
Message-ID: <c384c5ea0906121221p6a20d92fg6716f560164c46bf@mail.gmail.com>
Subject: Re: splice methods in character device driver
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Steve Rottinger <steve@pentek.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve, Jens,

another few questions:

On Thu, Jun 4, 2009 at 3:20 PM, Steve Rottinger<steve@pentek.com> wrote:
> ...
> - The performance is poor, and much slower than transferring directly from
> main memory with O_DIRECT.  I suspect that this has a lot to do with
> large amount of systems calls required to move the data, since each call moves only
> 64K.  Maybe I'll try increasing the pipe size, next.
>
> Once I get past these issues, and I get the code in a better state, I'll
> be happy to share what
> I can.
>
I've been experimenting a bit using mostly-empty functions to learn
understand the function call flow:

splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_device);
pipe_to_device(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
struct splice_desc *sd)

So some back-of-a-coaster calculations:

If I understand correctly, a pipe_buffer never spans more than one
page (typically 4kB).

The SPLICE_BUFFERS is 16, thus splice_from_pipe() is called every 64kB.

The actor "pipe_to_device" is called on each pipe_buffer, so for every 4kB.

For my case, I have a DMA engine that does say 200 MB/s, resulting in
50000 actor calls per second.

As my use case would be to splice from an acquisition card to disk,
splice() made an interesting approach.

However, if the above is correct, I assume splice() is not meant for
my use-case?


Regards,

Leon.






/* the actor which takes pages from the pipe to the device
 *
 * it must move a single struct pipe_buffer to the desired destination
 * Existing implementations are pipe_to_file, pipe_to_sendpage, pipe_to_user.
 */
static int pipe_to_device(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
		 struct splice_desc *sd)
{
	int rc;
	printk(KERN_DEBUG "pipe_to_device(buf->offset=%d, sd->len=%d)\n",
		buf->offset, sd->len);
	/* make sure the data in this buffer is up-to-date */
	rc = buf->ops->confirm(pipe, buf);
	if (unlikely(rc))
		return rc;
	/* create a transfer for this buffer */
	
}
/* kernel wants to write from the pipe into our file at ppos */
ssize_t splice_write(struct pipe_inode_info *pipe, struct file *out,
loff_t *ppos, size_t len, unsigned int flags)
{
	int ret;
	printk(KERN_DEBUG "splice_write(len=%d)\n", len);
	ret = splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_device);
	return 0;
}

-- 
Leon
