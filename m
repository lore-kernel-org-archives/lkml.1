Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbXBPFxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbXBPFxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932602AbXBPFxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:53:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51176 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585AbXBPFxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:53:52 -0500
Date: Thu, 15 Feb 2007 21:53:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Cullen <timcullen2001@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible bug in page allocation mechanism
Message-Id: <20070215215350.4dbd04ca.akpm@linux-foundation.org>
In-Reply-To: <490976.56324.qm@web43116.mail.sp1.yahoo.com>
References: <490976.56324.qm@web43116.mail.sp1.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 14:11:42 -0800 (PST) Tim Cullen <timcullen2001@yahoo.com> wrote:

> There appears to be a inconsistenancy with reference
> counts on pages allocated with alloc_pages when order
> is greater than zero. In buffered_rmqueue when order
> != 0 then __rmqueue is called. This returns a page
> pointer that is really a pointer to the first page in
> a group of pages. Subsequently prep_new_page is called
> on the first page of the group but not on any others.
> This results in the first page having a reference
> count of 1 while all other pages in the allocation
> have a reference count of 0. I would think that all
> pages in the same allocation should all have the same
> reference count at the end of the allocation.
> 
> I've looked at this in the 2.6.20, 2.6.19.1, and the
> 2.6.17.7 kernels. They contain the same code in this
> area.
> 

That's as-designed.  All page refcount manipulations on a higher-order page
are supposed to be against the head pageframe.

Also, we have the compound page logic in there to force code which tries to
manipulate the refcount of a tail page to be redirected to the head page.

