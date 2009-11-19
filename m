Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZKSPzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZKSPzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZKSPzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:55:50 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41978 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZKSPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dIP/t3X2pe6mhCMu+kLnnmywdd0CVRWvGlOw9UfzgFwLiOvxOpgXbME7i6zCE1XAJi
         IZjfpSuzr7VhdKGlSp2qUXmuOhmiWjas0vYKCAZLNZQNdfxbphp+I6iTFeKiPyDpcvbP
         gT+np461KwTbQCDd5iwnbwY5PCngrn4oU/DZc=
Date: Thu, 19 Nov 2009 16:55:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2] lockdep: Don't only check recursive read locks
	once in a sequence
Message-ID: <20091119155549.GB4967@nowhere>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com> <1258506398-5151-3-git-send-email-fweisbec@gmail.com> <4B03C1A7.4070305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B03C1A7.4070305@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:43:03PM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > Say we have the following locks:
> > A (rwlock, Aw: writelock, Ar: recursive read lock)
> > B (normal lock)
> > 
> > and the following sequences:
> > Ar -> B -> Ar
> > Aw -> B
> > 
> > This won't be detected as a lock inversion
> 
> """
> read-preference <==> read-recursive ability  (rwlock)
> otherwise ==> read-recursive disability      (rwsem)
> """



I don't understand the idea of "read-preference". And btw I
don't understand why rwsem read locks are not considered as
recursive in lockdep.


 
> If "B -> Ar" is always after "Ar", it's NOT a really
> lock inversion because rwlock is read-preference, we
> can ignore all "Ar" which are after "B".



It's not a lock inversion in itself because it's legal to have:

Ar -> B -> Ar



> If sometimes "B -> Ar" is not after "Ar",
> then we have these sequences:
> B -> Ar
> Aw -> B
> 
> Lockdep can detects it now(without this patch applied).
> 
> Maybe I have misunderstood your patch.



Well.
In my example we have this sequence first:

Ar -> B -> Ar

And this second one:

Aw -> B

In the lockdep tree, the read lock won't even be registered,
so we'll just have Aw -> B in the tree.

If we insert these in the tree, we'll have one branch that will
look like that:

			Aw
                         |
                         B
                         |
                         Ar

Like we do with any other kind of lock. We just plug the dependencies
between them. We know that B depends on Aw, but Ar also depends on B.
Although the merged sequence might never happen, there is still a risk
and the above is not legal.

