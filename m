Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYKKIHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYKKIHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYKKIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:07:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYKKIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:07:15 -0500
Date: Tue, 11 Nov 2008 00:06:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: allocation failure in b43/ssb
Message-Id: <20081111000652.f581671b.akpm@linux-foundation.org>
In-Reply-To: <20081107195403.GD3546@tuxdriver.com>
References: <20081107190944.GA18949@redhat.com>
	<20081107195403.GD3546@tuxdriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 14:54:03 -0500 "John W. Linville" <linville@tuxdriver.com> wrote:

> On Fri, Nov 07, 2008 at 02:09:44PM -0500, Dave Jones wrote:
> > We just had a report from a user who spotted a bunch of messages
> > of the form below in his logs..
> 
> <snip>
> 
> > The kernel is a little old (2.6.26).
> > 
> > Looking at it though, I'm puzzled..
> > 
> > It seems we failed to allocate an order-1 allocation, even though
> > we had memory available in the DMA and normal zones.
> > 
> > What am I missing?
> > 
> > Full logs at https://bugzilla.redhat.com/attachment.cgi?id=322882
> 
> Most of those traces look a little scrambled, but as best as I can
> tell that call to setup_rx_descbuffer comes from dma_rx.  That means
> that the call to __dev_alloc_skb is done with GFP_ATOMIC.  I don't
> know if that factors into the answer to what is happening or not.
> 

It does.  If there were not any two physically-contiguous free pages in
the page allocator reserves, __alloc_pages() will not be able to
satisfy that order-1 allocation request.

You can have plenty of free memory, but if it's all fragmented,
non-order-0 atomic allocations can still fail.

GFP_KERNEL allocations can run page reclaim to _make_ the allocation
request succeed in this situation.

