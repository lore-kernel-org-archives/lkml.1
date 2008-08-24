Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYHXLDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYHXLDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 07:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYHXLDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 07:03:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39186 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYHXLD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 07:03:29 -0400
Date: Sun, 24 Aug 2008 12:03:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080824110326.GO28946@ZenIV.linux.org.uk>
References: <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org> <20080824101014.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824101014.GN28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 11:10:14AM +0100, Al Viro wrote:

> I agree that such transition plan makes sense, but that'll take more
> preliminary work than in your patch; there are other vfs_readdir() and
> ->readdir() callers, not just the obvious syscall ones.

BTW, nfsd4_list_rec_dir() is FUBAR.  Its users, actually - they try to use it
for lovely things like kernel-side rm -rf /var/lib/nfs/v4recovery/* and
screw up in rather amusing ways..  I'm not even talking about the effects
of OOM (dentry leak); if you rename something away from that directory,
you'll get vfs_rmdir(dir, dentry) with dentry not being a child of dir,
which means deadlock if you are lucky and underlying fs corruption if you
are not...

I really wonder WTF is that doing in the kernel, anyway.  Looks like an
obvious candidate for userland helper...
