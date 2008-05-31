Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYEaKAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYEaKAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYEaKAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:00:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbYEaKAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:00:09 -0400
Date: Sat, 31 May 2008 02:59:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on
 the resume path
Message-Id: <20080531025949.7c8b17bc.akpm@linux-foundation.org>
In-Reply-To: <48411F70.5020100@goop.org>
References: <c692f3a12da1e99a4a43.1212192095@localhost>
	<4840B0C5.4020606@pobox.com>
	<48411F70.5020100@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 10:50:40 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Does __GFP_HIGH necessarily mean that it won't try to 
> do IO to push pages out?

Nope.

__GFP_FS: may enter filesystems
__GFP_IO: may perform IO

__GFP_IO also means "may do swapout".  Even when swap is on a regular
file.  This is because we do all the fs-related operations up-front
during swapon.  So at alloc_pages()-time we can go direct-to-disk-blocks.

So I assume for this application you'll need GFP_NOIO.  That's still
heaps better than GFP_ATOMIC, because it can sleep and wait for kswapd
to do stuff, and it can reclaim clean pagecache and clean swapcache.

Whether you should also add __GFP_HIGH to cause the page allocation to
bite harder into the page reserves is unclear to me, sorry.

