Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYKNRul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYKNRul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYKNRud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:50:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYKNRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:50:32 -0500
Date: Fri, 14 Nov 2008 12:50:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@oss.sgi.com
Subject: Re: kernel BUG at fs/buffer.c:471! with 2.6.27.6
Message-ID: <20081114175031.GA11737@infradead.org>
References: <gfjqlf$kpt$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gfjqlf$kpt$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:24:19PM +0000, Alessandro Bono wrote:
> Hi all
> 
> second time I hit this bug, first time with 2.6.26.6 (reported to xfs ml 
> without response)
> Condition are similar: rsync from remote server via ssh to a local usb hd 
> with a xfs filesystem but connection this time is with a wired ethernet 
> not wifi
> Tell me if you need other info
> 
> kernel BUG at fs/buffer.c:471!

In 2.6.27.6 line 471 in fs/buffer.c is inside write and looks like this:

	first = page_buffers(page)

and page_buffers is defined as:

#define page_buffers(page)                              \
({                                                      \
	BUG_ON(!PagePrivate(page));			\
	((struct buffer_head *)page_private(page));     \
})

So we get a page without page_private set.

Now XFS always creates buffers in writepage when it doesn't have those
yet using the VFS helper create_empty_buffers which calls
attach_page_buffers, which sets the page private flag.


Given that the binary 3d driver always caused random VM problems can you
try to reproduce it with one loaded?
