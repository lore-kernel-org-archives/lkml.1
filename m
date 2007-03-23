Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbXCWKPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbXCWKPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934276AbXCWKPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:15:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58870 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934046AbXCWKO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:14:59 -0400
Date: Fri, 23 Mar 2007 10:14:52 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Message-ID: <20070323101452.GA15144@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ken Chen <kenchen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 05:51:11PM -0700, Ken Chen wrote:
> It is really sad that we always call kmap and friends for every pipe
> buffer page on 64-bit arch that doesn't use HIGHMEM, or on
> configuration that doesn't turn on HIGHMEM.
> 
> The effect of calling kmap* is visible in the execution profile when
> pipe code is being stressed.  It is especially true on amd's x86-64
> platform where kmap() has to traverse through numa node index
> calculation in order to convert struct page * to kernel virtual
> address.  It is fairly pointless to perform that calculation repeatly
> on system with no highmem (i.e., 64-bit arch like x86-64).  This patch
> caches kernel pipe buffer page's kernel vaddr to speed up pipe buffer
> mapping functions.
> 
> There is another suboptimal block in pipe_read() where wake_up is
> called twice.  I think it was an oversight since in pipe_write(), it
> looks like it is doing the right thing.

I think you're fixing the symptom here and not the cause.  If calculating
the virtual address of a page is so expensive on your setup it should
define WANT_PAGE_VIRTUAL and we should always cache the virtual address
in struct page.  There's a lot more code, epecially in filesystems that's
rather upset about a slow page_address.

