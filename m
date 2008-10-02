Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYJBTpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYJBTpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYJBTpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:45:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbYJBTpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:45:21 -0400
Date: Thu, 2 Oct 2008 12:44:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Message-Id: <20081002124433.f6612036.akpm@linux-foundation.org>
In-Reply-To: <20081002181856.GB29613@skywalker>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	<20081001215239.ee2ae63f.akpm@linux-foundation.org>
	<1222950054.6745.18.camel@think.oraclecorp.com>
	<20081002181856.GB29613@skywalker>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 23:48:56 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> > 
> > For a 4.5GB streaming buffered write, this printk inside
> > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > 
> 
> Part of that can happen due to shrink_page_list -> pageout -> writepagee
> call back with lots of unallocated buffer_heads(blocks).

That workload shouldn't be using that code path much at all.  It's
supposed to be the case that pdflush and balance_dirty_pages() do most
of the writeback work.

And that _used_ to be the case, but we broke it.  It happened several
years ago and I wasn't able to provoke anyone into finding out why. 
iirc the XFS guys noticed it because their throughput was fairly badly
affected.

