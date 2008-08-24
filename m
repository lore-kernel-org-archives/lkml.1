Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYHXXwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYHXXwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 19:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYHXXvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 19:51:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbYHXXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 19:51:51 -0400
Date: Sun, 24 Aug 2008 16:51:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080824195908.GQ28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808241644330.3363@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk>
 <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org> <20080824101014.GN28946@ZenIV.linux.org.uk>
 <alpine.LFD.1.10.0808241017580.3363@nehalem.linux-foundation.org> <20080824195908.GQ28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Aug 2008, Al Viro wrote:
>
> The fact that coda_readdir() will _not_ be returning 0 with your change
> when called with the arguments old_readdir() gives it?  You'll get ret
> from filldir, i.e. what you'll normally see will be -EINVAL in case of
> fillonedir as callback.

Ahh. A light finally goes on. No on the first filldir() callback, but on 
the second.

Yeah, so this should fix it.

		Linus
---
 fs/readdir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 4e026e5..4899ba4 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -115,7 +115,7 @@ asmlinkage long old_readdir(unsigned int fd, struct old_linux_dirent __user * di
 	buf.dirent = dirent;
 
 	error = vfs_readdir(file, fillonedir, &buf);
-	if (error >= 0)
+	if (buf.result || error >= 0)
 		error = buf.result;
 
 	fput(file);
