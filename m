Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbXGRNbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbXGRNbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbXGRNaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:30:55 -0400
Received: from holomorphy.com ([66.93.40.71]:59025 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758727AbXGRNay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:30:54 -0400
Date: Wed, 18 Jul 2007 06:32:22 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070718133222.GM11781@holomorphy.com>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717193308.GD25301@v2.random>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:47:37AM -0700, William Lee Irwin III wrote:
>> You may rest assured that it's technically feasible. It's been done.
>> The larger obstacles to all this are nontechnical.

On Tue, Jul 17, 2007 at 09:33:08PM +0200, Andrea Arcangeli wrote:
> Back then there was no variable order page size proposal, no slub,
> generally nothing of that kind.
> I think these days it worth to get it working again and solve the
> technical obstacles once more time. Then we should plug into it a
> pagecache logic to handle small files. That means if the soft page
> size is 64k, we should kmalloc 32k of pagecache if the file is < 64k
> but >= 32k, or kmalloc 16k if the file is < 32k but >= 16k, etc...

Actually I'd worked on what was called MPSS (Multiple Page Size Support)
before I ever started on pgcl. Some large portion of the pgcl proposal
as I presented it internally was to reduce the order of large page
allocations and provide a promotion and demotion mechanism enabling
different processes to have different sized translations for the same
large page, and hence no out-of-context pagetable/TLB updates during
promotion and demotion, essentially by making the TLB translation to
page relation M:N. ISTR describing this in a KS presentation for which
IIRC you were present. But that's neither here nor there.


On Tue, Jul 17, 2007 at 09:33:08PM +0200, Andrea Arcangeli wrote:
> Down to 32bytes if we memcpy the 32bytes away to a 64k page, and we
> disable the logic the moment somebody attempts to mmap the "kmalloced"
> pagecache (which I think it's a lot simpler than trying to mmap a
> kmalloced 4k naturally aligned object into userland). I wouldn't call
> it tail packing, it's more a fine-granular pagecache with the already
> available kmalloc granularities. That will maximize pagecache
> utilization with read syscall for hg/git compared to current 2.6.22
> plus memory will be allocated faster in 64k chunks etc... Ideally it
> should be possible to disable the finer-granular-kmalloc-pagecache on
> the big irons with lots of memory and only working with big files.

In any event, that is a sound strategy for mitigating internal
fragmentation of pagecache, though internal fragmentation of anonymous
memory has more severe consequences and is less easily mitigated.


-- wli
