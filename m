Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYKMLzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYKMLzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYKMLzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:55:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:33335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYKMLzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:55:07 -0500
Message-ID: <491C1588.2060907@kernel.org>
Date: Thu, 13 Nov 2008 20:54:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 11:54:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
>> Why do you think using separate poll handle would be better?  And do you
>> still think the overhead is justifiable?
> 
> Because it would be a change in the semantics of the file handle.
> Previously it was just an opaque cookie that the kernel stored for the
> filesystem, not making any assumptions about it (like uniqueness).
> 
> OK, we can say that if the filesystems wants to implement poll, it has
> to make the file handle unique.  Also now the filesystem (or
> something) has to deal with races between poll notification and
> reuse of the file handle (release/open).
> 
> With a new poll handle we'd have more room to properly deal with these
> without overloading the file handle with extra requirements.
> 
> How about this: the poll handle is allocated by the kernel, not by the
> filesystem.  This guarantees uniqueness, so the filesystem cannot get
> this wrong.  Releasing the poll handle is still tricky, there could be
> various races... only the userspace filesystem knows if it has no
> outstanding notificiatons on a poll handle, so the release has to come
> after all outstanding notifications have been ack'ed.  Something like
> this:
> 
> (userspace <- kernel)
> 
> <- POLL-request(pollhandle) (alloc handle)
> -> POLL-reply
> ...
> -> POLL-notification(pollhandle)
> <- POLL-ack
> ...
> <- POLL_RELEASE(pollhandle)
> -> POLL_RELEASE-reply (free handle)

Hmm... yeah, allocating handle from kernel should work fine, but I
wouldn't worry about race here.  We can just use 64 bit and guarantee
that any handle won't be reused ever.

Thanks.

-- 
tejun
