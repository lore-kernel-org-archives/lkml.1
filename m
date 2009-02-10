Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZBJDH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZBJDH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZBJDHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:07:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZBJDHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:07:16 -0500
Message-ID: <4990EF3F.3010501@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 11:06:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com>	 <20090209112321.GW28946@ZenIV.linux.org.uk> <1234180131.5951.85.camel@laptop>
In-Reply-To: <1234180131.5951.85.camel@laptop>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems to me we can simply put the new s_umount instance in a
> different subclass. Its a bit unusual to use _nested for the outer lock,
> but lockdep doesn't particularly cares about subclass order.
> 
> If there's any issue with the callers of sget() assuming the s_umount
> lock being of sublcass 0, then there is another annotation we can use to
> fix that, but lets not bother with that if this is sufficient.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Tested-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks!

a minor comment

> +		 * lock of the old one. Since these are clearly distrinct

s/distrinct/distinct


BTW, I found another bug in current code:

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 10:55:53 +0800
Subject: [PATCH] vfs: add missing unlock in sget()

We should release s->s_umount before calling destroy_super(s).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 61dce00..8bdf981 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -356,8 +356,10 @@ retry:
 				continue;
 			if (!grab_super(old))
 				goto retry;
-			if (s)
+			if (s) {
+				up_write(&s->s_umount);
 				destroy_super(s);
+			}
 			return old;
 		}
 	}
-- 
1.5.4.rc3


