Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYJXObn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYJXObn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYJXObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:31:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYJXObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:31:33 -0400
Date: Fri, 24 Oct 2008 12:31:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by
 uvcvideo stress test
Message-ID: <20081024123129.3c373b90@pedra.chehab.org>
In-Reply-To: <48F710F7.9030608@tuffmail.co.uk>
References: <gbiduj$9p3$1@ger.gmane.org>
	<200810152017.47347.laurent.pinchart@skynet.be>
	<48F63C4E.3070103@tuffmail.co.uk>
	<200810152319.17925.laurent.pinchart@skynet.be>
	<48F710F7.9030608@tuffmail.co.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 11:01:27 +0100
Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> Laurent Pinchart wrote:
> > Hi Alan,
> >
> > On Wednesday 15 October 2008, Alan Jenkins wrote:
> >   
> >> Laurent Pinchart wrote:
> >>     
> >>> On Wednesday 15 October 2008, Alan Jenkins wrote:
> >>>       
> >>>> If you look at the trace, it happens as "hald-probe-video" opens the
> >>>> video device.  This is from Ubuntu 8.04.  Possibly it's significant that
> >>>> I use the camera first, to make sure it works (I use Kopete, the
> >>>> settings dialogue includes a video test).
> >>>>         
> >>> The NULL pointer (or rather 0x00000030 pointer) dereference happens in
> >>> video_open:
> >>>
> >>>         file->f_op = fops_get(vfl->fops);
> >>>         if (file->f_op->open)
> >>>                 err = file->f_op->open(inode, file);
> >>>
> >>> file->f_op ends up being NULL. Either vfl->fops is NULL to begin with, or
> >>> fops_get failed to get a reference to the file_operations structure.
> >>>
> >>> I'd be surprised if vfl->fops was NULL. To rule out that case, can you
> >>> add a BUG_ON(vfl->fops == NULL) before the call to fops_get ?
> >>>
> >>> I'm not too familiar with the module loader, but a quick look at the code
> >>> shows that the module could be marked as being unloaded
> >>> (MODULE_STATE_GOING) before its exit function is called. If this is the
> >>> case video_open would still be called, as the video device would still be
> >>> registered, but fops_get would fail in try_module_get and return a NULL
> >>> pointer. It seems the pointer returned by fops_get should be tested in
> >>> video_open.
> >>>
> >>> I've CC'ed the v4l maintainer to get his opinion on this.

Sorry for being late with this. Too much work here...

I suspect that you only hit this bug due to BKL removal from open/close fops.
maybe you're calling open() before having the device fully initialized?

Anyway, I think that the proposed check is interesting on other places where
there are similar code.

Cheers,
Mauro
