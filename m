Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXJOCCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXJOCCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 22:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXJOCB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 22:01:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42141 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXJOCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 22:01:58 -0400
Date: Mon, 15 Oct 2007 03:01:57 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] vivi, videobuf_to_vmalloc() and related breakage
Message-ID: <20071015020157.GC8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	AFAICS, videobuf-vmalloc use of mem->vma and mem->vmalloc is
bogus.

You obtain the latter with vmalloc_user(); so far, so good.  Then you have
        retval=remap_vmalloc_range(vma, mem->vmalloc,0);
where vma is given to you by mmap(); again, fine - we get the memory
pointed to be mem->vmalloc() mapped at vma->vm_start.

Now we get the trouble: things like

static void vivi_fillbuff(struct vivi_dev *dev,struct vivi_buffer *buf)
{
	...
	void *vbuf=videobuf_to_vmalloc (&buf->vb);
	...
	copy_to_user(vbuf + ..., ..., ...)

get vbuf equal to ->vmalloc of buf->vp.priv and that is _not_ a userland
address.  Giving it to copy_to_user() is not going to do anything good.
On some targets it'll fail, on some - write to unrelated user memory.
What is going on there?  If that's an attempt to copy into that buffer
allocated by vmalloc_user(), why are we doing copy_to_user() at all?

But there's more; we have made a copy of vma (kmalloc+memcpy), stored it in
mem->vma and later we cheerfully do remap_vmalloc_range(mem->vma,....).
And kfree that mem->vma immediately afterwards.  What the hell?  It might
not break now, but that seems to be playing very fast and loose with the
warranties provided by VM.
