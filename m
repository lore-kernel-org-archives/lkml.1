Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYI1Uij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYI1Uij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYI1Uib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:38:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYI1Uia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:38:30 -0400
Date: Sun, 28 Sep 2008 13:38:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <m1bpyadlm0.fsf@frodo.ebiederm.org>
Message-ID: <alpine.LFD.1.10.0809281326240.3265@nehalem.linux-foundation.org>
References: <20080926152031.GA30831@x200.localdomain> <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org> <m1bpyadlm0.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 27 Sep 2008, Eric W. Biederman wrote:
> 
> We hold the directory mutex in real_lookup
> before calling i_op->lookup.

Irrelevant.

The d_compare function si called _before_ we get the directory mutex. It's 
done purely under dentry->dlock (and the RCU read lock).

So we have absolutely no directory-level locking here.

> So lookups should be serialized.

lookups are serialized before calling into the filesystem with ->lookup, 
but _not_ at the d_compare level. If we serialized d_compare, the dentry 
cache would be no use at all, we'd serialize all lookups, cached or not.

(Of course, sane filesystems will not have d_compare at all, just the 
memcmp, but we're talking /proc here - although I forget why it wants to 
do that insane d_compare thing)

So forget the directory mutex. d_compare is much more low-level than that. 
It can hit a dentry that is being unhashed at the same time for whatever 
reason (memory pressure, whatever).

The fact is, the "->lookup()" function is meant to be easy for filesystems 
to use, but d_compare i really low-level dentry magic and is meant to look 
at just the *name*. It's meant to be a replacement for memcpy() for things 
like case-independent comparisons or strange utf-8 rules (ie "equivalent" 
characters). It has no real locking, since the names are supposed to be 
"stable" anyway (the dentry->d_lock should guarantee that the dentry isn't 
being renamed etc).

I may be missing something, of course, but the dentry eas actually found 
_before_ takign even the dentry->d_lock, so the dentry we call compare on 
may not even be *valid* any more, because something might have unhashed it 
_after_ we found it, but _before_ we got d_lock.

d_compare() really is pretty special (d_revalidate is too, for that 
matter, although at least _slightly_ less so: by that time we have at 
least tested that the UNHASHED bit isn't set because we raced with 
removal etc).

		Linus
