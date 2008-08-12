Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbYHLUWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbYHLUWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYHLUWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:22:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbYHLUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:22:00 -0400
Date: Tue, 12 Aug 2008 13:21:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080812181057.GR28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Al Viro wrote:
> 
> you've just lost e.g. -EIO for getdents().  And if you bail out on
> non-zero return value from vfs_readdir(), you are back to -EINVAL
> on full buffer.

Btw, this whole sentence, and the one from your next email seems to really 
show a fundamental misunderstanding of the whole readdir() error handling:

> PS: we might get away with both, if we used _positive_ values as well.
> E.g. have getdents() filldir return 1 if we are out of buffer *and*
> have ->previous != NULL (and -EINVAL if we are out of buffer on the
> first call)...  And have some other positive constant for "->readdir()
> didn't feel like going all the way to the end of directory".

We *must* handle partial returns by returning "success". And we do, 
except for our _confusion_ about ->readdir() returning error and that 
somehow "overriding" the fact that it already returned non-errors earlier 
through the callback.

All your blathering about "positive values as well" seems to ttoally 
misunderstand how readdir() works. We absolutely do *not* need positive 
return values, because the fact is, the only positive return value we ever 
need is the "we already filled _earlier_ buffers". And that's the one 
that we already do.

The fact is, NO ERROR VALUE CAN POSSIBLY MATTER if we already returned one 
or more entries to getdents/readdir(). We should return a success value.

			Linus
