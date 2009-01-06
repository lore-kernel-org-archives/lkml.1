Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbZAFW57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbZAFW57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZAFW5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:57:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZAFW5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:57:45 -0500
Date: Tue, 6 Jan 2009 17:57:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> mm-invoke-oom-killer-from-page-fault.patch
> mm-invoke-oom-killer-from-page-fault-fix.patch
> mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch

Just implementing this behaviour for x86 and uml is extremly
counter-productive.  Please fix up all architectures as this
behaviour needs to be the same on all ports (at least those
with a MMU)


> fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
> fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch

Btw, this code is still not quite right.  We really need to call
->setattr instead of vmtruncate here.  Complex filesystem need
transaction to properly free blocks, and those transactions are in
->setattr not inside vmtruncate where ->truncate doesn't even have
a chance to get the handle to the transaction passed.

As these patches don't make it worse this is not a NACK, but more of
a heads up.

> fs-sys_sync-fix.patch

I'm not sure this is a good idea.  Concurrent syncs are a bad idea
to start with and we should just synchronyze do_sync completely.
sync_filesystems as one of the main components of do_sync already
is synchronized in that way, and taking that to a higher level would
get rid of all the worries about concurrent syncs.

> softirq-introduce-statistics-for-softirq.patch
> proc-export-statistics-for-softirq-to-proc.patch
> proc-update-document-for-proc-softirqs-and-proc-stat.patch

Why is this in procfs?

> ecryptfs-filename-encryption-tag-70-packets.patch
> ecryptfs-filename-encryption-header-updates.patch
> ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
> ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
> ecryptfs-filename-encryption-mount-option.patch
> ecryptfs-replace-%z-with-%z.patch
> ecryptfs-fix-data-types-int-size_t.patch
> ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
> ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
> fs-ecryptfs-inodec-cleanup-kerneldoc.patch

By using lookup_one_len on an arbitrary underlying filesystem this
breaks the assumption that a nameidata is always available.  Please
redo to use proper lookup helpers.  Also whole code feels rather
fragile from a 10000 feet view, but beeing plsit in so many
patches it's almost impossible to properly review it anywya.


> hfs-add-basic-export-support.patch

I'm pretty sure we already had a version better than that in your
tree on the list.  But I've lost track and we should just restart
the review cycle on -fsdevel.

> linuxpps-core-support.patch

looks generally good, but the comments should get a little loving.
Please remove the stupid filenames that always get out of sync in
the top of file comments, and make the documentation of exported
symbols kernel-doc instead of it's weird own format.

Does checkpatch.pl still not catch these things?

Also the ioctl certainly should be an unlocked_ioctl and not the
old BKL-locked variant. The !uarg checks in the ioctls can go,
copy_to/from_users does this automatically.

pps.h shoulkd be split into one header only defining the
kernel<->userspace ABI, and a kernel-internal one.  That way
also the conditional includes can go away.

> pps-documentation-programs-and-examples.patch

Once again this stuff is in and utterly wrong place where it can't
easily be package for distros.  ppsfind belongs into util-linux and
needs a proper mangage, ppsldisc is not nessecary but ldattach in
util-linux needs to grow support for N_PPS instead, and ppstest
should probably go into util-linux in a more polished version, too.

> pps-userland-header-file-for-pps-api.patch

This one is utterly wrong.  It provides what should be a userspace
library as inlines in a kernel header. 

Please do a proper libpps library package.
> generic-swap-sparc-rename-swap-to-swap_ulong.patch
> generic-swap-iphase-rename-swap-to-swap_byte_order.patch
> generic-swap-lib-sortc-rename-swap-to-swap_func.patch
> generic-swap-introduce-global-macro-swapa-b.patch
> generic-swap-ext3-remove-local-swap-macro.patch
> generic-swap-ext4-remove-local-swap-macro.patch
> generic-swap-sched-remove-local-swap-macro.patch
> generic-swap-dcache-use-swap-instead-of-private-do_switch.patch
> 
>   Add a kernel-wide swap() macro, use it.  Merge.

Hmm, must have missed this when it went to lkml.  Having this helper
generic is a good idea, but swap is far too generic for something
in kernel.h as indicated by the various renaming patches. How about
swap_vars?


> nilfs2-add-document.patch
> nilfs2-disk-format-and-userland-interface.patch
> nilfs2-add-inode-and-other-major-structures.patch
> nilfs2-integrated-block-mapping.patch
> nilfs2-b-tree-based-block-mapping.patch
> nilfs2-direct-block-mapping.patch
> nilfs2-b-tree-node-cache.patch
> nilfs2-buffer-and-page-operations.patch
> nilfs2-meta-data-file.patch
> nilfs2-persistent-object-allocator.patch
> nilfs2-disk-address-translator.patch
> nilfs2-inode-map-file.patch
> nilfs2-checkpoint-file.patch
> nilfs2-segment-usage-file.patch
> nilfs2-inode-operations.patch
> nilfs2-inode-operations-fix.patch
> nilfs2-file-operations.patch
> nilfs2-directory-entry-operations.patch
> nilfs2-pathname-operations.patch
> nilfs2-pathname-operations-fix.patch
> nilfs2-operations-for-the_nilfs-core-object.patch
> nilfs2-super-block-operations.patch
> nilfs2-super-block-operations-fix.patch
> nilfs2-segment-buffer.patch
> nilfs2-segment-constructor.patch
> nilfs2-recovery-functions.patch
> nilfs2-another-dat-for-garbage-collection.patch
> nilfs2-block-cache-for-garbage-collection.patch
> nilfs2-ioctl-operations.patch
> nilfs2-update-makefile-and-kconfig.patch
> #
> nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
> nilfs2-cleanup-nilfs_clear_inode.patch
> nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
> nilfs2-insert-explanations-in-gcinode-file.patch
> nilfs2-add-maintainer.patch
> nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
> 
>   Dunno.   Has this been reviewed enough?

No.  I might eventually take a look, but looking into btrfs has a little
higher priority right now, and split into gazillions of
non-selfcontained patches certainly doesn't help reviewing it.

BTW, the current influx of higher-complexity filesystems certainly worries
me a little.
