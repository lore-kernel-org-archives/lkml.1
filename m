Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbXEWPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbXEWPGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXEWPGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:06:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42171 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbXEWPGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:06:05 -0400
Date: Wed, 23 May 2007 16:06:02 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523150602.GZ4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk> <20070523121620.GU4095@ftp.linux.org.uk> <E1HqqTC-00023W-00@dorka.pomaz.szeredi.hu> <20070523135140.GW4095@ftp.linux.org.uk> <E1HqrtF-0002Fb-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqrtF-0002Fb-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 04:32:37PM +0200, Miklos Szeredi wrote:
> > Umm...  It is related to detached subtrees, but I'm not sure if it is what
> > you are thinking about.
> 
> I was thinking of a similar one by Mike Waychison.  It had the problem
> of requiring a spinlock for mntget/mntput.  It was also different in
> that it did not gradually dissolve detached trees, but kept them as
> whole blobs until the last ref went away.
 
Here the spinlock is needed only when mnt_busy goes to 0, so presumably
it won't be a serious problem on more or less common setups; however,
it certainly would need serious profiling.

> How will this work with copy_tree() and namespace duplication, which
> currently walk the tree with only namespace_sem held?

Easy - grab namespace_sem, grab vfsmount_lock, walk the subtree and bump
mnt_busy on everything (by 1 + number of non-busy children).  Then drop
vfsmount_lock and do as usual, dropping references in tree being copied
as you go.  Nothing will get attached or detached due to namespace_sem,
nothing will get evicted by anybody other than you since you've got all
that stuff pinned down.  End of story...
