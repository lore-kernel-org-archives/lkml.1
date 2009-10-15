Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZJOHpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZJOHpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbZJOHpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:45:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:40182 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbZJOHpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:45:22 -0400
Message-ID: <4AD6D2E3.9050105@gmail.com>
Date: Thu, 15 Oct 2009 09:44:35 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: npiggin@suse.de
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [patch 2/6] fs: no games with DCACHE_UNHASHED
References: <20091015044026.319860788@suse.de> <20091015050048.165912589@suse.de>
In-Reply-To: <20091015050048.165912589@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 15 Oct 2009 09:44:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de a écrit :
> (this is in -mm)
> 
> Filesystems outside the regular namespace do not have to clear DCACHE_UNHASHED
> in order to have a working /proc/$pid/fd/XXX. Nothing in proc prevents the
> fd link from being used if its dentry is not in the hash.
> 
> Also, it does not get put into the dcache hash if DCACHE_UNHASHED is clear;
> that depends on the filesystem calling d_add or d_rehash.
> 
> So delete the misleading comments and needless code.
> 

This was added in commit 304e61e6fbadec586dfe002b535f169a04248e49

    [PATCH] net: don't insert socket dentries into dentry_hashtable
    
    We currently insert socket dentries into the global dentry hashtable.  This
    is suboptimal because there is currently no way these entries can be used
    for a lookup().  (/proc/xxx/fd/xxx uses a different mechanism).  Inserting
    them in dentry hashtable slows dcache lookups.
    
    To let __dpath() still work correctly (ie not adding a " (deleted)") after
    dentry name, we do :
    
    - Right after d_alloc(), pretend they are hashed by clearing the
      DCACHE_UNHASHED bit.
    
    - Call d_instantiate() instead of d_add() : dentry is not inserted in
      hash table.
    
      __dpath() & friends work as intended during dentry lifetime.
    
    - At dismantle time, once dput() must clear the dentry, setting again
      DCACHE_UNHASHED bit inside the custom d_delete() function provided by
      socket code, so that dput() can just kill_it.
    
    Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Acked-by: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>



Back in 2006, we had to perform this hack in order to not leak '(deleted)' in __d_path()

if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
	(prepend(&end, &buflen, " (deleted)", 10) != 0)) 
		goto Elong;

In current kernel this part became :

if (d_unlinked(dentry) &&
	(prepend(&end, &buflen, " (deleted)", 10) != 0))
		goto Elong;


So your cleanup seems good, thanks !

Acked-by: Eric Dumazet <dada1@cosmosbay.com>
