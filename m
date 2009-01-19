Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZASN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZASN7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZASN67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:58:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:41056 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZASN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=LKEin1Xo04bRKLYWhwvl1S4fTo6vZPw7DmfMsX4Ivl6rBMQ8Ba9bRxRVD+u6zRf+iZ
         462y60fqWuzLVvcjX2z6i4DrMs7iSssdsvEsPq5GDLi3BfFZ3SBNNIOxvrmLfGvbO70g
         dGb6lfOlvmKVdH/5P3WDImVb69Gjbt7DgoYS8=
Date: Mon, 19 Jan 2009 13:58:51 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: 2.6.27.9: splice_to_pipe() hung (blocked for more than 120
	seconds)
Message-ID: <20090119135851.GC4788@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0901180544g617b29c1nc41c760f8803de0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-01-2009 14:44, Vegard Nossum wrote:
...
> 
> I have one theory. We have this skeleton:
> 
> ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
>                          loff_t *ppos, size_t len, unsigned int flags,
>                          splice_actor *actor)
> {
> ...
>         inode_double_lock(inode, pipe->inode);
>         ret = __splice_from_pipe(pipe, &sd, actor);
>         inode_double_unlock(inode, pipe->inode);
> ...
> }
> 
> ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
>                            splice_actor *actor)
> {
> ...
>                 pipe_wait(pipe);
> ...
> }
> 
> void pipe_wait(struct pipe_inode_info *pipe)
> {
>         if (pipe->inode)
>                 mutex_unlock(&pipe->inode->i_mutex);
> ...
>         if (pipe->inode)
>                 mutex_lock(&pipe->inode->i_mutex);
> }
> 
> So in short: Is it possible that inode_double_lock() in
> splice_from_pipe() first locks the pipe mutex, THEN locks the
> file/socket mutex? In that case, there should be a lock imbalance,
> because pipe_wait() would unlock the pipe while the file/socket mutex
> is held.

I guess you mean a lock inversion.

> 
> That would possibly explain the sporadicity of the lockup; it depends
> on the actual order of the double lock.
> 
> Why doesn't lockdep report that? Hm. I guess it is because these are
> both inode mutexes and lockdep can't detect a locking imbalance within
> the same lock class?

Looks like you are right. Since there is used mutex_lock_nested() for
these locks in inode_double_lock(), lockdep could be mislead by this
"common" mutex_lock() later (but I didn't check this too much).

Jarek P.
