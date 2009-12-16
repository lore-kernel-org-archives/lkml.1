Return-Path: <linux-kernel-owner+w=401wt.eu-S934270AbZLPAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270AbZLPAJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934279AbZLPAJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:09:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45187 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934270AbZLPAJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:09:30 -0500
Date: Wed, 16 Dec 2009 00:09:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091216000924.GZ14381@ZenIV.linux.org.uk>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com> <20091207132009.GI18989@one.firstfloor.org> <20091215222134.GA27892@ZenIV.linux.org.uk> <20091215233841.GE22392@basil.fritz.box> <1260921277.3219.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260921277.3219.18.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 06:54:37PM -0500, Trond Myklebust wrote:

> > nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
> > hold and taking i_mutex inside mmap_sem is not allowed by the VFS.

VM, actually...

> If you want to work around the problem rather than going for something
> like Peter's split up of the mmap() callback, then I'd suggest changing
> to using nfs_revalidate_mapping_nolock() instead. The fact that we are
> seeing these lock misordering warnings is proof that the call to
> nfs_revalidate_mapping() is not always a no-op.
> 
> By not taking the i_mutex your call to invalidate_inode_pages2() can
> potentially end up racing with another process that is writing to the
> file, but that should be a rare occurrence. The effect will be that the
> two processes can end up fighting to alternatively dirty and then clean
> the pages...

Um...  The really interesting question is whether it's a false positive;
*can* we hit the deadlock here?  getdents() is a red herring; write() and
truncate() are real candidates.

What happens if we have one thread do mmap() while another (sharing the
address space with it) does write() or truncate() on the same file?
