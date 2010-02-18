Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab0BRXEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:04:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab0BRXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:04:45 -0500
Date: Thu, 18 Feb 2010 15:02:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm: Make copy_from_user() in migrate.c statically
 predictable
In-Reply-To: <1266533033-24457-1-git-send-email-hpa@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1002181447080.4141@localhost.localdomain>
References: <1266533033-24457-1-git-send-email-hpa@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Feb 2010, H. Peter Anvin wrote:
> 
> Make the logic more explicit and therefore easier for gcc to
> understand.

Hmm. When making simplifications like this, I would really suggest you 
also move the declaration of the variable itself into the block where it 
is now used, rather than leaving it be function-wide.

Yes, it's used in the final condition of the for-loop, but that whole loop 
is just screwy. The 'err' handling is insane. Sometimes 'err' is a return 
value form copy_to/from_user, and sometimes it's a errno. The two are 
_not_ the same thing, they don't even have the same type!

And 'i' is totally useless too.

So that whole loop should be rewritten.

I don't even have page migration enabled, so I haven't even compile-tested 
this, but wouldn't something like this work? It's smaller, gets rid of two 
pointless variables, and looks simpler to me. Hmm?

		Linus

---
 mm/migrate.c |   36 ++++++++++++++----------------------
 1 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 9a0db5b..933d5b1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -999,36 +999,28 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 			 const void __user * __user *pages,
 			 int __user *status)
 {
-#define DO_PAGES_STAT_CHUNK_NR 16
+#define DO_PAGES_STAT_CHUNK_NR 16ul
 	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
 	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
-	unsigned long i, chunk_nr = DO_PAGES_STAT_CHUNK_NR;
-	int err;
 
-	for (i = 0; i < nr_pages; i += chunk_nr) {
-		if (chunk_nr > nr_pages - i)
-			chunk_nr = nr_pages - i;
+	while (nr_pages) {
+		unsigned long chunk_nr;
 
-		err = copy_from_user(chunk_pages, &pages[i],
-				     chunk_nr * sizeof(*chunk_pages));
-		if (err) {
-			err = -EFAULT;
-			goto out;
-		}
+		chunk_nr = min(nr_pages, DO_PAGES_STAT_CHUNK_NR);
+
+		if (copy_from_user(chunk_pages, pages, chunk_nr * sizeof(*pages)))
+			break;
 
 		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
 
-		err = copy_to_user(&status[i], chunk_status,
-				   chunk_nr * sizeof(*chunk_status));
-		if (err) {
-			err = -EFAULT;
-			goto out;
-		}
-	}
-	err = 0;
+		if (copy_to_user(status, chunk_status, chunk_nr * sizeof(*status)))
+			break;
 
-out:
-	return err;
+		pages += chunk_nr;
+		status += chunk_nr;
+		nr_pages -= chunk_nr;
+	}
+	return nr_pages ? -EFAULT : 0;
 }
 
 /*
