Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbYFLMbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbYFLMbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbYFLMaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:30:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14774 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082AbYFLMac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:30:32 -0400
Subject: Re: [PATCH] ext2: Use page_mkwrite vma_operations to get mmap
	write notification.
From: Chris Mason <chris.mason@oracle.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com, jack@suse.cz,
       linux-ext4@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080612040643.GA5518@skywalker>
References: <1212685513-32237-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080605123045.445e380a.akpm@linux-foundation.org>
	 <20080611150845.GA21910@skywalker>
	 <20080611120749.d0c5a7de.akpm@linux-foundation.org>
	 <20080612040643.GA5518@skywalker>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 08:22:43 -0400
Message-Id: <1213273364.10187.281.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 09:36 +0530, Aneesh Kumar K.V wrote:
> On Wed, Jun 11, 2008 at 12:07:49PM -0700, Andrew Morton wrote:
> > On Wed, 11 Jun 2008 20:38:45 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> The idea is to have ext3/4_writepages. In writepages start a transaction
> and iterate over the pages take the lock and do block allocation. With
> that change we should be able to not do block allocation in the
> page_mkwrite path. We may still want to do block reservation there.
> 
> Something like.
> 
> ext4_writepages()
> {
> 	journal_start()
> 	for_each_page()

Even with delayed allocation, the vast majority of the pages won't need
any allocations.  You'll hit delalloc, do a big chunk with the journal
lock held and then do simple writepages that don't need anything
special.

I know the jbd journal_start is cheaper than the reiserfs one is, but it
might not perform well to hold it across the long writepages loop.  At
least reiser saw a good boost when I stopped calling journal_begin in
writepage unless the page really needed allocations.

With the loop you have in mind, it is easy enough to back out and start
the transaction only when required.

-chris


