Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbYBVVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbYBVVy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbYBVVoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:44:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:60624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933996AbYBVVoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:44:10 -0500
Date: Fri, 22 Feb 2008 13:40:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jonathan Corbet <corbet@lwn.net>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 21/23] Be more robust about bad arguments in
	get_user_pages()
Message-ID: <20080222214057.GV8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="be-more-robust-about-bad-arguments-in-get_user_pages.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------


From: Jonathan Corbet <corbet@lwn.net>

MAINLINE: 900cf086fd2fbad07f72f4575449e0d0958f860f

So I spent a while pounding my head against my monitor trying to figure
out the vmsplice() vulnerability - how could a failure to check for
*read* access turn into a root exploit? It turns out that it's a buffer
overflow problem which is made easy by the way get_user_pages() is
coded.

In particular, "len" is a signed int, and it is only checked at the
*end* of a do {} while() loop.  So, if it is passed in as zero, the loop
will execute once and decrement len to -1.  At that point, the loop will
proceed until the next invalid address is found; in the process, it will
likely overflow the pages array passed in to get_user_pages().

I think that, if get_user_pages() has been asked to grab zero pages,
that's what it should do.  Thus this patch; it is, among other things,
enough to block the (already fixed) root exploit and any others which
might be lurking in similar code.  I also think that the number of pages
should be unsigned, but changing the prototype of this function probably
requires some more careful review.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -983,6 +983,8 @@ int get_user_pages(struct task_struct *t
 	int i;
 	unsigned int vm_flags;
 
+	if (len <= 0)
+		return 0;
 	/* 
 	 * Require read or write permissions.
 	 * If 'force' is set, we only require the "MAY" flags.

-- 
