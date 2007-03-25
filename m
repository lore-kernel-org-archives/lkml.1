Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXCYXlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXCYXlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 19:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXCYXlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 19:41:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbXCYXls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 19:41:48 -0400
Date: Sun, 25 Mar 2007 15:41:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] remove throttle_vm_writeout()
Message-Id: <20070325154143.54e40200.akpm@linux-foundation.org>
In-Reply-To: <E1HVEEw-0006cP-00@dorka.pomaz.szeredi.hu>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<E1HVEEw-0006cP-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 22:57:34 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Remove this function.  It's purpose was to limit the global number of
> writeback pages from submitted by direct reclaim.  But this is equally
> well accomplished by limited queue lengths.  When this function was
> added, the device queues had much larger default lengths (8192
> requests, now it's 128), causing problems.

This changelog is wrong.

Yes, the _default_ depth of CFQ was decreased.  But it is trivial for the
user to inrcrease the queue depth again, and we'd prefer that the VM not
shit itself in response.

Plus, more significantly, the queue is per-disk.  A system with many disks
will easily be able to cover all memory with under-writeback pages. 
Which is why the level of under-writeback memory is controlled at a higher
level.

These variables are why we must not reply upon per-queue throttling in
VFS/MM/VM.


All that being said, the patch (with a new, correct changlog) is OK.  This
is because we now control the amount of dirty memory in the machine by
running balance_dirty_pages() at first-write-fault time.  So we can no
longer get into the situation where all memory is dirty+writeback.


That being said, this patch is only correct if we don't apply "[patch 1/3]
fix illogical behavior in balance_dirty_pages()".  If we _do_ apply that
patch then we can again get all memory under-writeback and we again need
throttle_vm_writeout().


