Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYHXKKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYHXKKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 06:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYHXKKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 06:10:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41320 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHXKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 06:10:20 -0400
Date: Sun, 24 Aug 2008 11:10:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080824101014.GN28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 09:58:31AM -0700, Linus Torvalds wrote:

> because the "filldir()" functions should all do the right thing anyway. 
> But there's certainly nothing wrong with doing it either.

Not all, but those won't hit coda.
 
> However, I think the real fix is something like this. This 
> 
>  - fixes all the callers
> 
>  - removes more lines than it adds
> 
>  - simplifies and clarifies the code
> 
>  - avoids pointless goto's
> 
>  - makes error handling of vfs_readdir() consistent among the callers
>    (some callers already did the error handling _correctly_ before this 
>    patch - this makes everybody do it the same way)

One obvious note: that'll break old_readdir() on coda.  There you need to
change the existing check (you need to check buf.result, then ignore error
unless buf.result ended up 0).

I agree that such transition plan makes sense, but that'll take more
preliminary work than in your patch; there are other vfs_readdir() and
->readdir() callers, not just the obvious syscall ones.

BTW, there are several places that call specific foo_readdir() or its helper
functions, passing odd stuff as filldir (afs implements ->lookup() that way,
for one; ocfs2 checks that directory is empty; gfs2 does ->get_name() -
with filldir returning 1 on match, at that; etc.).  We obviously do not care
about those in the beginning of patch series - they won't be affected,
but once we start converting foofs_readdir() to returning what filldir had
returned, we'll need to watch out for complications from those (BTW, another
fun place in that respect is __fat_readdir())
