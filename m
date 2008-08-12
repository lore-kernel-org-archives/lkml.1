Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbYHLSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbYHLSLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYHLSLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:11:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYHLSLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:11:00 -0400
Date: Tue, 12 Aug 2008 19:10:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812181057.GR28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 10:18:49AM -0700, Linus Torvalds wrote:

> If we actually want to change the readdir() thing, then we should just 
> make the rule be:
> 
>  - if the callback returns a non-zero value, the filesystem "readdir()" 
>    function should return that value (right now they are taught to return 
>    zero, and return errors on internal fatal things). And get rid of 
>    "buf.error" entirely.

Doesn't work well for readdir(2)...

> 	error = vfs_readdir(file, filldir, &buf);
> 	lastdirent = buf.previous;
> 	if (lastdirent) {
> 		error = count - buf.count;
> 		if (put_user(file->f_pos, &lastdirent->d_off))
> 			error = -EFAULT;
> 	}
> 	fput(file);
> 	return error;
> 
>    and we wouldn't need any other logic at all.

you've just lost e.g. -EIO for getdents().  And if you bail out on
non-zero return value from vfs_readdir(), you are back to -EINVAL
on full buffer.

Frankly, I'd rather keep ->readdir() instances simpler.  There are far
more of those, for one thing.  As it is, we only have "stop"/"continue"
->readdir() has to care about...

There's one more thing in that mess: a bunch of vfs_readdir() callers
end up playing very sick games to make sure they get the entire
directory.  The trick is to find whether the damn thing has reached
the end; as it is, there are instances of ->readdir() that do _not_
(e.g. call filldir only once and let the caller repeat).

I'm certainly not too fond of buf->error.  If you see a better interface
I'd love to hear about it, but I don't think that "just return anything
non-zero we'd got from callback" is going to be good.  And if we go for
flagday changes in ->readdir(), we'd better get it right...
