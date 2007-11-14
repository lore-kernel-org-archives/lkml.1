Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbXKNPaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbXKNPaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXKNP37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:29:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34393 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbXKNP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:29:58 -0500
Date: Wed, 14 Nov 2007 15:29:52 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071114152952.GA4210@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114070400.GA25708@puku.stupidest.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 11:04:00PM -0800, Chris Wedgwood wrote:
> With 2.6.24-rc2 (amd64) I sometimes (usually but perhaps not always)
> see a hang when accessing some NFS exported XFS filesystems.  Local
> access to these filesystems ahead of time works without problems.
> 
> This does not occur with 2.6.23.1.  The filesystem does not appear to
> be corrupt.
> 

>     [ 1462.911360]  ffffffff80744020 ffffffff80746dc0 ffff81010129c140 ffff8101000ad100
>     [ 1462.911391] Call Trace:
>     [ 1462.911417]  [<ffffffff8052e638>] __down+0xe9/0x101
>     [ 1462.911437]  [<ffffffff8022cc80>] default_wake_function+0x0/0xe
>     [ 1462.911458]  [<ffffffff8052e275>] __down_failed+0x35/0x3a
>     [ 1462.911480]  [<ffffffff8035ac25>] _xfs_buf_find+0x84/0x24d
>     [ 1462.911501]  [<ffffffff8035ad34>] _xfs_buf_find+0x193/0x24d
>     [ 1462.911522]  [<ffffffff803599b1>] xfs_buf_lock+0x43/0x45

this is bp->b_sema which lookup wants.

>     [ 1462.915534]  [<ffffffff8032b6da>] xfs_readdir+0x91/0xb6
>     [ 1462.915557]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
>     [ 1462.915579]  [<ffffffff8035be9d>] xfs_file_readdir+0x31/0x40
>     [ 1462.915599]  [<ffffffff8028c9f8>] vfs_readdir+0x61/0x93
>     [ 1462.915619]  [<ffffffff8030415b>] nfs3svc_encode_entry_plus+0x0/0x13
>     [ 1462.915642]  [<ffffffff802fc78e>] nfsd_readdir+0x6d/0xc5

and this is the nasty nfsd case where a filldir callback calls back
into lookup.  I suspect we're somehow holding b_sema already.  Previously
this was okay because we weren't inside the actualy readdir code when
calling filldir but operate on a copy of the data.

This gem has bitten other filesystem before, I'll see if I can find a
way around it.

