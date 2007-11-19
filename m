Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXKSMvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXKSMvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXKSMvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:51:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57022 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXKSMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:51:46 -0500
Date: Mon, 19 Nov 2007 12:51:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       devel@openvz.org
Subject: Re: [PATCH 1/4] proc: fix NULL ->i_fop oops
Message-ID: <20071119125139.GB15942@infradead.org>
References: <20071116150651.GC19517@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116150651.GC19517@localhost.sw.ru>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 06:06:51PM +0300, Alexey Dobriyan wrote:
> proc_kill_inodes() can clear ->i_fop in the middle of vfs_readdir resulting in
> NULL dereference during "file->f_op->readdir(file, buf, filler)".
> 
> The solution is to remove proc_kill_inodes() completely:
> a) we don't have tricky modules implementing their tricky readdir hooks which
>    could keeping this revoke from hell.
> b) In a situation when module is gone but PDE still alive, standard readdir
>    will return only "." and "..", because pde->next was cleared by
>    remove_proc_entry().
> c) the race proc_kill_inode() destined to prevent is not completely fixed, just
>    race window made smaller, because vfs_readdir() is run without sb_lock held and
>    without file_list_lock held. Effectively, ->i_fop is cleared at random moment,
>    which can't fix properly anything.

Nice, getting rid of this is a very good step formwards.  Unfortunately
we have another copy of this junk in
security/selinux/selinuxfs.c:sel_remove_entries() which would need the
same treatment.
