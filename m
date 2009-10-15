Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbZJOIOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbZJOIOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbZJOIOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:14:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:38361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762141AbZJOIOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:14:20 -0400
Date: Thu, 15 Oct 2009 10:13:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [patch 2/6] fs: no games with DCACHE_UNHASHED
Message-ID: <20091015081343.GC4262@wotan.suse.de>
References: <20091015044026.319860788@suse.de> <20091015050048.165912589@suse.de> <4AD6D2E3.9050105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD6D2E3.9050105@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 09:44:35AM +0200, Eric Dumazet wrote:
> npiggin@suse.de a écrit :
> > (this is in -mm)
> > 
> > Filesystems outside the regular namespace do not have to clear DCACHE_UNHASHED
> > in order to have a working /proc/$pid/fd/XXX. Nothing in proc prevents the
> > fd link from being used if its dentry is not in the hash.
> > 
> > Also, it does not get put into the dcache hash if DCACHE_UNHASHED is clear;
> > that depends on the filesystem calling d_add or d_rehash.
> > 
> > So delete the misleading comments and needless code.
> > 
> 
> This was added in commit 304e61e6fbadec586dfe002b535f169a04248e49
> 
>     [PATCH] net: don't insert socket dentries into dentry_hashtable
>     
>     We currently insert socket dentries into the global dentry hashtable.  This
>     is suboptimal because there is currently no way these entries can be used
>     for a lookup().  (/proc/xxx/fd/xxx uses a different mechanism).  Inserting
>     them in dentry hashtable slows dcache lookups.
>     
>     To let __dpath() still work correctly (ie not adding a " (deleted)") after
>     dentry name, we do :
>     
>     - Right after d_alloc(), pretend they are hashed by clearing the
>       DCACHE_UNHASHED bit.
>     
>     - Call d_instantiate() instead of d_add() : dentry is not inserted in
>       hash table.
>     
>       __dpath() & friends work as intended during dentry lifetime.
>     
>     - At dismantle time, once dput() must clear the dentry, setting again
>       DCACHE_UNHASHED bit inside the custom d_delete() function provided by
>       socket code, so that dput() can just kill_it.
>     
>     Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Acked-by: "David S. Miller" <davem@davemloft.net>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
> 
> 
> Back in 2006, we had to perform this hack in order to not leak '(deleted)' in __d_path()
> 
> if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
> 	(prepend(&end, &buflen, " (deleted)", 10) != 0)) 
> 		goto Elong;
> 
> In current kernel this part became :
> 
> if (d_unlinked(dentry) &&
> 	(prepend(&end, &buflen, " (deleted)", 10) != 0))
> 		goto Elong;
> 
> 
> So your cleanup seems good, thanks !
> 
> Acked-by: Eric Dumazet <dada1@cosmosbay.com>

Ahh, hmm d_unlinked() is exactly the same code. OK, so I think this shows
why I'm an idiot. I didn't think about the __d_path output. Though the
comments are still misleading, in my defence (and my test programs did not
use any anoninode fds)...

Now both sockets and pipes define a d_dname so they are OK, but anon_inodes
does not. I think they should probably be made to just provide a d_dname
anyway so we can have the familiar format of "pseudofs:[ino]" rather than
"[pseudofs]" that we have now.

That should make this patch work for anon_inodes.c as well.

