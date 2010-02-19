Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0BSARh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:17:37 -0500
Received: from mga05.intel.com ([192.55.52.89]:4440 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609Ab0BSARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:17:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,500,1262592000"; 
   d="scan'208,223";a="541935456"
Message-ID: <4B7DD89F.4050003@linux.intel.com>
Date: Thu, 18 Feb 2010 16:17:35 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm: Make copy_from_user() in migrate.c statically predictable
References: <1266533033-24457-1-git-send-email-hpa@linux.intel.com> <alpine.LFD.2.00.1002181447080.4141@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002181447080.4141@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------050706080602000605020904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050706080602000605020904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/18/2010 03:02 PM, Linus Torvalds wrote:
> 
> Hmm. When making simplifications like this, I would really suggest you 
> also move the declaration of the variable itself into the block where it 
> is now used, rather than leaving it be function-wide.
> 
> Yes, it's used in the final condition of the for-loop, but that whole loop 
> is just screwy. The 'err' handling is insane. Sometimes 'err' is a return 
> value form copy_to/from_user, and sometimes it's a errno. The two are 
> _not_ the same thing, they don't even have the same type!
> 
> And 'i' is totally useless too.
> 
> So that whole loop should be rewritten.
> 

OK, I was trying to make the minimal set of changes given the late -rc
status.

> I don't even have page migration enabled, so I haven't even compile-tested 
> this, but wouldn't something like this work? It's smaller, gets rid of two 
> pointless variables, and looks simpler to me. Hmm?

The code definitely looks cleaner, and it's a much more standard
"chunked data loop" form.  Weirdly enough, though, gcc 4.4.2 can't
figure out the copy_from_user() that way... despite having the same
min() structure as my code.

However, if I change it to:

		chunk_nr = nr_pages;
		if (chunk_nr > DO_PAGES_STAT_CHUNK_NR)
			chunk_nr = DO_PAGES_STAT_CHUNK_NR;

... then it works!

Overall, it looks like gcc is rather fragile with regards to its ability
to constant-propagate.  It's probably no coincidence that chunked loops
is the place where we really have problems with this kind of stuff.

Updated patch, which compile-tests for me, attached.

	-hpa

--------------050706080602000605020904
Content-Type: text/x-patch;
 name="0001-mm-Make-copy_from_user-in-migrate.c-statically-predi.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-mm-Make-copy_from_user-in-migrate.c-statically-predi.pa";
 filename*1="tch"

>From 90585838c29ef62fd80e776d0985c40bbffd852a Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Thu, 18 Feb 2010 16:13:40 -0800
Subject: [PATCH] mm: Make copy_from_user() in migrate.c statically predictable
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

x86-32 has had a static test for copy_on_user() overflow for a while.
This test currently fails in mm/migrate.c resulting in an
allyesconfig/allmodconfig build failure on x86-32:

In function ‘copy_from_user’,
    inlined from ‘do_pages_stat’ at
    /home/hpa/kernel/git/mm/migrate.c:1012:
/home/hpa/kernel/git/arch/x86/include/asm/uaccess_32.h:212: error:
    call to ‘copy_from_user_overflow’ declared

Make the logic more explicit and therefore easier for gcc to
understand.

v2: rewrite the loop entirely using a more normal structure for a
    chunked-data loop (Linus Torvalds)

Reported-by: Len Brown <lenb@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/migrate.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 9a0db5b..880bd59 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1002,33 +1002,27 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 #define DO_PAGES_STAT_CHUNK_NR 16
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
+		chunk_nr = nr_pages;
+		if (chunk_nr > DO_PAGES_STAT_CHUNK_NR)
+			chunk_nr = DO_PAGES_STAT_CHUNK_NR;
+
+		if (copy_from_user(chunk_pages, pages, chunk_nr * sizeof(*chunk_pages)))
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
-- 
1.6.5.2


--------------050706080602000605020904--
