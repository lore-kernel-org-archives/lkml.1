Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZD2IdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZD2IdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZD2Icv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:32:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbZD2Ict (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:32:49 -0400
Date: Wed, 29 Apr 2009 10:36:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       hugh@veritas.com, npiggin@suse.de, riel@redhat.com,
       lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in the VM II
Message-ID: <20090429083655.GA23223@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org> <1239210239.28688.15.camel@think.oraclecorp.com> <20090409072949.GF14687@one.firstfloor.org> <20090409075805.GG14687@one.firstfloor.org> <1239283829.23150.34.camel@think.oraclecorp.com> <20090409140257.GI14687@one.firstfloor.org> <1239287859.23150.57.camel@think.oraclecorp.com> <20090429081616.GA8339@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429081616.GA8339@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'll have to read harder next week, the FS invalidatepage may expect
> > truncate to be the only caller.
> 
> If direct de-dirty is hard for some pages, how about just ignore them?

You mean just ignoring it for the pages where it is hard?
Yes that is what it is essentially doing right now. But at least
some dirty pages need to be handled because most user space
pages tend to be dirty.

> There are the PG_writeback pages anyway. We can inject code to
> intercept them at the last stage of IO request dispatching.

That would require adding error out code through all the file systems,
right?

> 
> Some perceivable problems and solutions are
> 1) the intercepting overheads could be costly => inject code at runtime.
> 2) there are cases that the dirty page could be copied for IO:

At some point we should probably add poison checks before these operations
yes. At least for read it should be the same code path as EIO --
you have to check PG_error anyways  (or at least you ought to)
The main difference is that for write you have to check it too.

>    2.1) jbd2 has two copy-out cases => should be rare. just ignore them?
>      2.1.1) do_get_write_access(): buffer sits in two active commits
>      2.1.2) jbd2_journal_write_metadata_buffer(): buffer happens to start
>             with JBD2_MAGIC_NUMBER
>    2.2) btrfs have to read page for compress/encryption
>      Chris: is btrfs_zlib_compress_pages() a good place for detecting
>      poison pages? Or is it necessary at all for btrfs?(ie. it's
>      already relatively easy to de-dirty btrfs pages.)

I think btrfs' IO error handling is not very great right now. But once
it matures i hope poison pages can be handled in the same way as
regular IO errors.

>    2.3) maybe more cases...

Undoubtedly. Goal is just to handle the common cases that cover a lot 
of memory. This will never be 100%.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
