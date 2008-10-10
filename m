Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbYJJUeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbYJJUeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbYJJUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:33:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758977AbYJJUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:33:56 -0400
Message-ID: <48EFBBE9.5000703@linux-foundation.org>
Date: Fri, 10 Oct 2008 15:32:41 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nathalie.furmento@labri.fr
Subject: Re: [PATCH] mm: use a radix-tree to make do_move_pages() complexity
 linear
References: <48EDF9DA.7000508@inria.fr> <20081010125010.164bcbb8.akpm@linux-foundation.org> <48EFB6E6.4080708@inria.fr>
In-Reply-To: <48EFB6E6.4080708@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:

> Just try sys_move_pages() on a 10-100MB buffer, you'll get something
> like 50MB/s on a recent Opteron machine. This throughput decreases
> significantly with the number of pages. With this patch, we get about
> 350MB/s and the throughput is stable when the migrated buffer gets
> larger. I don't have detailled numbers at hand, I'll send them by monday.

Migration throughput is optimal for sys_move_pages() and the cpuset migration.
Some comparison would be useful.

With 100MB you have ~250k pages which will require a vmalloc of 4MB for the
struct pm struct array to control the migration of each individual page.

Would it be possible to restructure this in such a way that we work in chunks
of 100 or so pages each so that we can avoid the vmalloc?

We also could do a kmalloc for each individual struct pm_struct with the radix
tree which would also avoid the vmalloc but still keep the need to allocate
4MB for temporary struct pm_structs.

Or get rid of the pm_struct altogether by storing the address of the node
vector somewhere and retrieve the node as needed from the array. This would
allow storing the struct page * pointers in the radix tree.
