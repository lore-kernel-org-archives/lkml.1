Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbXEKA4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbXEKA4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbXEKA4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:56:33 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:35456 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbXEKA4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M77bfNi73s8YNS5yLOGlFemw0DxDFzL2DODcX5D3eICeyMiE4FhLjF46qpOawzVsjSkkD+MLsHVpZ8uoZmD63NbnZ4CN8ltTr1lzhj7IMWXJo/50Vhad857kMmsoJBqon+8Quam6bi/m7yVy0vOvg5MuAu9StaatHQFMPwQw/hw=
Message-ID: <6880bed30705101756nb5bd0c5s97935b97d07f846a@mail.gmail.com>
Date: Fri, 11 May 2007 02:56:31 +0200
From: "Bas Westerbaan" <bas.westerbaan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Conveying memory pressure to userspace?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Quite a lot of userspace applications cache.  Firefox caches pages;
mySQL caches queries;  libc' free (like practically all other
userspace allocators) won't directly return the first byte of memory
freed, etc.

These applications are unaware of memory pressure.  While the kernel
is trying its best to to free memory by for instance dropping,
possibly more valuable caches, userspace is left blissfully unaware.

Obviously this isn't a really big problem, given that we've still got
swap to swap out those rarely used caches, except for when the caches
aren't _that_ rarely used and of which the backing store (eg.
precomputed values) might be faster than the disk to swap back the
pages from.

A solution would be to either

  a) let the application make the kernel aware of pages that, when in
memory pressure, may be dropped.  This would be tricky to implement
for the userspace: it's hard to avoid an application to race into a
dropped page.  However, the kernel can directly free a page from
userspace, which makes it use full when under real pressure.  This in
contrast to
 b) letting the application register itself with a cache share
priority.  The application (and other aware applications) would then
be able to query how fair they are at the moment proportional to their
cache share priority.  Freeing would still be completely in their own
hands.


The only relevant related matter I could find were madvise and mincore.

With madvise pages can be marked to be unnecessary and these should be
swapped out earlier.  With mincore one can determine whether pages are
resident (not cached).  This would make an existing alternative to
solution a.  However, this doesn't eliminate the writes to the swap
and polling everytime before accessing a cache isn't really pretty.

I did consider guessing the memory pressure by looking at
/proc/meminfo, but I think it isn't that accurate.

Before hacking something together (and being uncertain about the
thoroughness with which I searched for existing work, sorry), I would
like your thoughts on this.

Please CC me, I'm not in the list.

  Bas

-- 
Bas Westerbaan
GPG 99BA289B | SINP bas@w-nz.com
http://blog.w-nz.com/
