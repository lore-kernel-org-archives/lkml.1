Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYB0ORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYB0ORR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYB0ORD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:17:03 -0500
Received: from mail2.shareable.org ([80.68.89.115]:50867 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYB0ORA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:17:00 -0500
Date: Wed, 27 Feb 2008 14:16:46 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080227141646.GA22850@shareable.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <47C441C1.5060305@garzik.org> <20080226170011.GB21203@shareable.org> <47C45267.4090105@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C45267.4090105@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> >It's not optimal even then.
> >
> >  Devices: On a software RAID, you ideally don't want to issue flushes
> >  to all drives if your database did a 1 block commit entry.  (But they
> >  probably use O_DIRECT anyway, changing the rules again).  But all that
> >  can be optimised in generic VFS code eventually.  It doesn't need
> >  filesystem assistance in most cases.
> 
> My own idea is that we create a FLUSH command for blkdev request queues, 
> to exist alongside READ, WRITE, and the current barrier implementation. 
>  Then FLUSH could be passed down through MD or DM.

I like your thought, and it has the benefit of being simple.

My thought is very similar, but with (hopefully not premature...)
optimisations:

  - I would merge FLUSH with a preceding write in some cases,
    converting to an FUA-write command.  Probably the generic request
    queue is the best place to detect and merge.  This is so that
    userspace filesystems (including guest VMs) and databases can do
    journal commits with the same I/O sequence as in kernel
    filesystems.

  - I would create BARRIER too, so that a userspace API can ask for
    this weaker form of fsync, which may improve throughput of
    userspace journalling.  

  - I would include a sector range in FLUSH and BARRIER, for MD and DM
    to flush _only_ relevant sub-devices.  This may improve performance
    for journalling both kernel and userspace filesystems, as journal
    commits are often very small and hit one or two sub-devices in RAID.

  - I would ask the nice MD and DM people to take tag-barriers rather
    than flush-barriers on the input queue, converting to
    tag-barriers, flush-barriers and independent FLUSH on the
    sub-device queues according to sector ranges and subsequent
    writes.  It's not obvious, but my barrier proposal which started
    this thread is designed to support an efficient inter-sub-device
    flush-barrier when necessary, and single-sub-device tag-barrier
    when possible.

-- Jamie
