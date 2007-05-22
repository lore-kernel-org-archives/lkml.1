Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbXEVBad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbXEVBad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbXEVBaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:30:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbXEVBaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:30:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lKFPATZQcMGIJaQEgnPA9rzfacU9U/f94eHpj4MuKz83bU2m+G4Vo0row1cs7Ci2q
	fstL4SbmZ1ui08ad7A0Bw==
Message-ID: <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
Date: Mon, 21 May 2007 18:30:15 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20070522001851.GE4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
	 <20070522001851.GE4095@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Mon, May 21, 2007 at 03:00:55PM -0700, akpm@linux-foundation.org wrote:
> > +     if (register_blkdev(LOOP_MAJOR, "loop"))
> > +             return -EIO;
> > +     blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
> > +                               THIS_MODULE, loop_probe, NULL, NULL);
> > +
> > +     for (i = 0; i < nr; i++) {
> > +             if (!loop_init_one(i))
> > +                     goto err;
> > +     }
> > +
> > +     printk(KERN_INFO "loop: module loaded\n");
> > +     return 0;
> > +err:
> > +     loop_exit();
>
> This isn't good.  You *can't* fail once a single disk has been registered.
> Anyone could've opened it by now.
>
> IOW, you need to
>         * register region *after* you are past the point of no return

That option is a lot harder than I thought.  This requires an array to
keep intermediate result of preallocated "lo" device, blk_queue, and
disk structure before calling add_disk() or register region.  And this
array could be potentially 1 million entries.  Maybe I will use
vmalloc for it, but seems rather sick.
