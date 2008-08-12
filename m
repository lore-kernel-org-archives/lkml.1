Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYHLUDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYHLUDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYHLUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:03:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbYHLUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:03:33 -0400
Date: Tue, 12 Aug 2008 13:02:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080812181057.GR28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121259400.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Al Viro wrote:
> 
> Doesn't work well for readdir(2)...

Sure it does.

> > 	error = vfs_readdir(file, filldir, &buf);
> > 	lastdirent = buf.previous;
> > 	if (lastdirent) {
> > 		error = count - buf.count;
> > 		if (put_user(file->f_pos, &lastdirent->d_off))
> > 			error = -EFAULT;
> > 	}
> > 	fput(file);
> > 	return error;
> > 
> >    and we wouldn't need any other logic at all.
> 
> you've just lost e.g. -EIO for getdents().

No I've not.

If we returned a partial result, we _should_ return a partial result.

And if we got EIO on the first entry, we should return EIO.

The _current_ code is crap. It sometimes returns the error (if the 
->readdir() function returned error), and sometimes returns the partial 
result (if the "buf.error" was set).

> Frankly, I'd rather keep ->readdir() instances simpler.  There are far
> more of those, for one thing.  As it is, we only have "stop"/"continue"
> ->readdir() has to care about...

Keeping them simple (and not changing them - always returning zero is what 
the _original_ readdir() thing did!) is why the current situation exists.

So if we keep it that way, then we really *KEEP* it that way. Don't go 
around changing any of the existing rules. Just make sure that the 
callbacks keep on always returning negative or zero (and never positive).

			Linus
