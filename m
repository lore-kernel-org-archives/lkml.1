Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbYAaMbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbYAaMbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbYAaMbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:31:23 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51941
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYAaMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:31:22 -0500
Date: Thu, 31 Jan 2008 13:31:18 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/3] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080131123118.GK7185@v2.random>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131045812.785269387@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 08:57:52PM -0800, Christoph Lameter wrote:
> @@ -211,7 +212,9 @@ asmlinkage long sys_remap_file_pages(uns
>  		spin_unlock(&mapping->i_mmap_lock);
>  	}
>  
> +	mmu_notifier(invalidate_range_begin, mm, start, start + size, 0);
>  	err = populate_range(mm, vma, start, size, pgoff);
> +	mmu_notifier(invalidate_range_end, mm, 0);
>  	if (!err && !(flags & MAP_NONBLOCK)) {
>  		if (unlikely(has_write_lock)) {
>  			downgrade_write(&mm->mmap_sem);

This can't be enough for GRU, infact it can't work for KVM either. You
got 1) to have some invalidate_page for GRU before freeing the page,
and 2) to pass start, end to range_end (if you want kvm to use it
instead of invalidate_page).

mremap still missing as a whole.
