Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbYDURbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbYDURbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbYDURbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:31:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851AbYDURbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:31:43 -0400
Date: Mon, 21 Apr 2008 10:30:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
In-Reply-To: <20080421170526.GC9153@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.1.10.0804211023090.2779@woody.linux-foundation.org>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com>
 <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org> <20080421170526.GC9153@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Apr 2008, Paul E. McKenney wrote:
> 
> I did take a quick look for improperly freeing dentries -- unhashed
> dentries are freed directly, so if there is a code path that somehow
> unhashes dentries and then d_free()s them without a grace period, we
> have a problem.

No, not even then.

We *always* unhash the dentries before freeing them, but we very 
consciously use "hlist_del_rcu()" on them, not "hlist_del_init()".

That, in turn, will mean that the "pprev" pointer will still be set, so 
the "hlist_unhashed()" thing will *not* trigger.

IOW, when we do that direct-free with:

	if (hlist_unhashed(&dentry->d_hash))
		__d_free(dentry);

the "hlist_unhashed()" will literally guarantee that i has *never* been on 
a hash-list at all!

(If you want to test whether it is currently unhashed or not, you actually 
have to use "d_unhashed()" on the dentry under the dentry lock, which 
tests the DCACHE_UNHASHED bit).

Of course, there could be some bug in there, but the thing is, none of 
this has even changed in a long time, certainly not since 2.6.25. Which is 
why I think the dcache code is all fine, and the bug comes from somewhere 
else corrupting the data structures.

		Linus
