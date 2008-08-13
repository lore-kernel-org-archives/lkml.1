Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYHMBw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYHMBw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYHMBwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:52:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbYHMBwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:52:16 -0400
Date: Tue, 12 Aug 2008 18:51:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080813011909.GA28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121841030.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
 <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121708160.3462@nehalem.linux-foundation.org>
 <20080813011909.GA28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Al Viro wrote:
> 
> What _can_ a common helper do, anyway, when we are busy parsing an arseload of
> possibly corrupt data in whatever weird format fs insists upon?

Well, the parsing has to be done by the low-level filesystem code, yes.

However, the whole thing with races with "f_pos" and all the locking - 
that's only because we see the filesystem "readdir" code as being the 
primary source of data.

Quite frankly, if we had a "readdir page cache", the low-level filesystem 
would still have to parse the insane low-level data with corruption 
issues, but we could make it totally independent of f_pos (because we 
would never use in the _real_ file->f_pos - we would just populate the 
cache), and the locking issues would be only a cold-cache issue, with the 
hot-cache hopefully needing little locking at all.

For an exmple of that: you did a good job with all the "seq_file" helpers, 
which meant that the low-level "filesystem" ops didn't need to know 
_anything_ about partial results etc, and it automatically did the right 
thing wrt f_pos updates and lseek etc.

I'm not saying that readdir() would use the _same_ model, but I do suspect 
that a common format in between the disk format and the eventual readdir() 
output, that also could be cached, might mitigate a lot of the problems.

As to the issues with lookup() - yes, a lookup would need to get the lock 
for writing, but only for the last entry, and only if O_CREAT is set. 
There's nothing wrogn with concurrent read-only lookups, I think (apart 
from having to protect the dentries from being duplicated, of course, but 
that would be a per-dentry lock flag, not a directory lock, methinks).

I dunno.

That said, I think you are right that we could also just improve on the 
current non-caching version with soem higher-level semantics. Including 
flags like "yes, we've seen the end", so that we don't need to always call 
into the low-level filesystem one extra time to see that final zero 
return.

So yes, instead of separate "filldir_t" and "void *data" things, having a 
"struct filldir_t" with several fields in common might be worth it.

			Linus
