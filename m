Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYJBMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYJBMVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYJBMVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:21:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64744 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYJBMVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:21:12 -0400
Subject: Re: [PATCH] Improve buffered streaming write ordering
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20081001215239.ee2ae63f.akpm@linux-foundation.org>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081001215239.ee2ae63f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 08:20:54 -0400
Message-Id: <1222950054.6745.18.camel@think.oraclecorp.com>
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

On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> On Wed, 01 Oct 2008 14:40:51 -0400 Chris Mason <chris.mason@oracle.com> wrote:
> 
> > The patch below changes write_cache_pages to only use writeback_index
> > when current_is_pdflush().  The basic idea is that pdflush is the only
> > one who has concurrency control against the bdi, so it is the only one
> > who can safely use and update writeback_index.
> 
> Another approach would be to only update mapping->writeback_index if
> nobody else altered it meanwhile.
> 

Ok, I can give that a short.

> That being said, I don't really see why we get lots of seekiness when
> two threads start their writing the file from the same offset.

For metadata, it makes sense.  Pages get dirtied in strange order, and
if writeback_index is jumping around, we'll get the seeky metadata
writeback.

Data makes less sense, especially the very high extent count from ext4.
An extra printk shows that ext4 is calling redirty_page_for_writepage
quite a bit in ext4_da_writepage.  This should be enough to make us jump
around in the file.

For a 4.5GB streaming buffered write, this printk inside
ext4_da_writepage shows up 37,2429 times in /var/log/messages.

	if (page_has_buffers(page)) {
		page_bufs = page_buffers(page);
		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
					ext4_bh_unmapped_or_delay)) {
			/*
			 * We don't want to do  block allocation
			 * So redirty the page and return
			 * We may reach here when we do a journal commit
			 * via journal_submit_inode_data_buffers.
			 * If we don't have mapping block we just ignore
			 * them. We can also reach here via shrink_page_list
			 */
			redirty_page_for_writepage(wbc, page);

printk("redirty page %Lu\n", page_offset(page));

			unlock_page(page);
			return 0;
		}
	} else {

-chris


