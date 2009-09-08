Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbZIHRwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbZIHRwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZIHRw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:52:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51339 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZIHRw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:52:28 -0400
In-Reply-To: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Subject: Re: [PATCH 0/8] VFS name lookup permission checking cleanup
X-KeepSent: 236B5154:055BAA84-8525762B:00616AA7;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF236B5154.055BAA84-ON8525762B.00616AA7-8525762B.0062309A@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Tue, 8 Sep 2009 13:52:29 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 09/08/2009 13:52:29,
	Serialize complete at 09/08/2009 13:52:29
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote on 09/07/2009 
05:01:14 PM:

> This is a series of eight trivial patches that I'd like people to take a 

> look at, because I am hoping to eventually do multiple path component 
> lookups in one go without taking the per-dentry lock or incrementing 
(and 
> then decrementing) the per-dentry atomic count for each component.
> 
> The aim would be to try to avoid getting that annoying cacheline 
ping-pong 
> on the common top-level dentries that everybody looks up (ie root and 
home 
> directories, /usr, /usr/bin etc).
> 
> Right now I have some simple (but real) loads that show the contention 
on 
> dentry->d_lock to be a roughly 3% performance hit on a single-socket 
> nehalem, and I assume it can be much worse on multi-socket machines.
> 
> And the thing is, it should be entirely possible to do everything but 
the 
> last component lookup with just a single read_seqbegin()/read_seqretry() 

> around the whole lookup. Yes, the last component is special and 
absolutely 
> needs locking and counting - but the last component also doesn't tend to 

> be shared, so locking it is fine.
> 
> Now, I may never actually get there, but when looking at it, the biggest 

> problem is actually not so much the path lookup itself, as the security 
> tests that are done for each path component. And it should be noted that 

> in order for a lockless seq-lock only lookup make sense, any such 
> operations would have to be totally lock-free too. They certainly can't 
> take mutexes etc, but right now they do.
> 
> Those security tests fall into two categories:
> 
>  - actual security layer callouts: ima_path_check().
> 
>    This one looks totally pointless. Path component lookup is a horribly 

>    timing-critical path, and we will only do a successful lookup on a 
>    directory (inode needs to have a ->lookup operation), yet in the 
middle 
>    of that is a call to "ima_path_check()".
> 
>    Now, it looks like ima_path_check() is very much designed to only 
check 
>    the _final_ path anyway, and was never meant to be used to check the 
>    directories we hit on the way. In fact, the whole function starts 
with
> 
>    if (!ima_initialized || !S_ISREG(inode->i_mode))
>       return 0;
> 
>    so it's totally pointless to do that thing on a directory where 
>    that !S_ISREG() test will trigger.
> 
>    So just remove it. IMA should never have put that check in there to 
>    begin with, it's just way too performance-sensitive.

You're right.  We don't need to call ima_path_check() here, as IMA
only measures the integrity of the file itself, and not directories.

Mimi
