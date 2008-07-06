Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYGFUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYGFUXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYGFUXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:23:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:41526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbYGFUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:23:00 -0400
Date: Sun, 6 Jul 2008 13:23:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Cc: akpm@linux-foundation.org
Subject: Kernel oops (bug) in fs/buffers.c:create_empty_buffers
Message-ID: <20080706132302.5ca87f4f@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

caught this one on kerneloops.org: 
http://www.kerneloops.org/searchweek.php?search=create_empty_buffers

void create_empty_buffers(struct page *page,
                        unsigned long blocksize, unsigned long b_state)
{
        struct buffer_head *bh, *head, *tail;

        head = alloc_page_buffers(page, blocksize, 1);
        bh = head;
        do {
                bh->b_state |= b_state;
                tail = bh;
                bh = bh->b_this_page;
        } while (bh);


turns out, alloc_page_buffers() can fail and return NULL (for AIO for
example)... yet this code blindly dereferences the result, getting a
predictable NULL pointer fault.

It's not directly clear what to do about... make this function return
the failure to the caller?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
