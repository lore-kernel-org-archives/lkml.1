Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbYEILzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbYEILzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYEILz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:55:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16940 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbYEILz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:55:26 -0400
Date: Fri, 9 May 2008 13:55:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux specific scsi CDBs vs REQ_TYPE_LINUX_BLOCK requests
Message-ID: <20080509115520.GS16217@kernel.dk>
References: <87r6ccadzd.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6ccadzd.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08 2008, Elias Oltmanns wrote:
> Hi Jens,
> 
> way back you introduced REQ_TYPE_LINUX_BLOCK requests as some sort of
> generic block layer messages. As it turns out, it is not quite obvious
> how to add support for this type of requests in the scsi subsystem
> properly. On the other hand, Boaz Harrosh has recently added support for
> variable length and in particular vendor specific CDBs to the scsi mid
> layer. My question to you and James is this: Would it make sense, in
> your opinion, to (ab)use BLOCK_PC requests carrying linux specific CDBs
> for those purposes you had in mind when introducing LINUX_BLOCK
> requests? This would make things much easier as far as scsi is concerned
> and it would still be possible to add suport for this kind of requests
> to non scsi drivers. On the other hand, this might constitute too
> serious a violation of the layers and subsystems involved as I'm
> not quite sure, for instance, where to keep the list of those linux
> specific opcodes -- include/linux/blkdev.h and include/scsi/scsi.h both
> don't seem quite right.

Large cdb support is just a direct extension of REQ_BLOCK_PC as far as
I'm concerned, it doesn't fit well with the REQ_TYPE_LINUX_BLOCK.

> The reason why I'm bothering you with all this is that I'm trying to get
> disk shock protection merged into mainline eventually; see the subthread
> starting at [1] for a preliminary patch series. Since I want to make
> this feature available to both, libata as well as ide, it is appealing
> to put the common bits (the timer and the user interface) into the block
> layer, thus avoiding code duplication. However, given the difficulties
> to realise this approach sanely, it might be better to leave the block
> layer out of it as far as possible. After all, it's the ATA specific
> feature (immediate disk head unloading) I really care for and by means
> of ioctls we could still provide an interface to userspace which doesn't
> depend on whether the device is managed by libata or ide.

So wrt opcodes, the space from 0x40 and up should be generic Linux
sanctioned opcodes. For the disk shock protection, you would like
something like REQ_LB_OP_PARKHEAD?

> In fact, unless you are definitely in favour of the block layer approach
> (as realised in [2]) and can give me a hint as to how I could solve the
> problems described above, I will probably prepare a patch series using
> ioctls and post it on linux-ide. The reason is that this approach might
> even solve another problem I see further down the road.

There isn't going to be a lot of common code, since all the park
handling will be driver/device specific. It still makes sense to use the
queue as the transport for the command though, using an ioctl is both
ugly from a design POV and (more importantly) has serialization issues
since it's an out-of-band signalling mechanism. If you pass down a
request as the park request, then you need only deal with the device
specific details of parking the head.

-- 
Jens Axboe

