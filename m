Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYILNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYILNqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYILNqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:46:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbYILNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:46:33 -0400
Message-ID: <48CA727F.1050405@linux-foundation.org>
Date: Fri, 12 Sep 2008 08:45:35 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [PATCH] mm: make do_move_pages() complexity linear
References: <48CA611A.8060706@inria.fr>
In-Reply-To: <48CA611A.8060706@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:
> Page migration is currently very slow because its overhead is quadratic
> with the number of pages. This is caused by each single page migration
> doing a linear lookup in the page array in new_page_node().

Page migration in general is not affected by this issue. This is specific to
the sys_move_pages() system call. The API was so far only used to migrate a
limited number of pages. For more one would use either the cpuset or the
sys_migrate_pages() APIs since these do not require an array that describes
how every single page needs to be moved.

> Since pages are stored in the array order in the pagelist and do_move_pages
> process this list in order, new_page_node() can increase the "pm" pointer
> to the page array so that the next iteration will find the next page in
> 0 or few lookup steps.

I agree. It would be good increase the speed of sys_move_pages().

However, note that your patch assumes that new_page_node() is called in
sequence for each of the pages in the page descriptor array. new_page_node()
is skipped in the loop if

1. The page is not present
2. The page is reserved
3. The page is already on the intended node
4. The page is shared between processes.

If any of those cases happen then your patch will result in the association of
page descriptors with the wrong pages for the remaining pages in the array.
