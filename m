Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYBOQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYBOQxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYBOQxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:53:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58912 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYBOQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:53:03 -0500
Date: Fri, 15 Feb 2008 17:52:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <andyw@uk.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [patch] checkpatch.pl: revert wrong --file message
Message-ID: <20080215165244.GA28358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Revert the incorrect, 6-line "WARNING" message that "checkpatch.pl 
--file" started emitting since commit 13214adf738ab, which was merged 
yesterday:

    Andi Kleen (1):
              Introduce a warning when --file mode is used

The message warns against sending "pure code style patches":

   $ scripts/checkpatch.pl --file arch/x86/mm/init_64.c
   total: 0 errors, 0 warnings, 789 lines checked

   arch/x86/mm/init_64.c has no obvious style problems and is ready for submission.

   WARNING: Using --file mode. Please do not send patches to linux-kernel
   that change whole existing files if you did not significantly change most
   of the the file for other reasons anyways or just wrote the file newly
   from scratch. Pure code style patches have a significant cost in a
   quickly changing code base like Linux because they cause rejects
   with other changes.

this new "WARNING" is wrong, what it suggests could not be farther from 
the truth.

In the past few months we frequently mentioned checkpatch.pl --file to 
arch/x86 newbies and it's been a great source of cleanup patches and it 
has become an integral part of our workflow. Newbies should start with 
small baby steps, with trivial patches, they should learn to write clean 
code, they should learn how to interact with other Linux developers and 
then they'll evolve over time towards larger changes.

So this new checkpatch.pl --file message is not just incorrect, the 
change is outright _damaging_ to Linux and to our arch/x86 workflow in 
particular.

Sometimes cleanliness problems in files are so distracting that not even 
very apparent bugs are visible "at a glance". People change such files 
only if they really are forced to, and they bitrot all the time.

arch/x86 was particularly affected by this problem so we have decided to 
put an end to that and have started doing wide-scale cleanups, backed by 
checkpatch --file. We have learned how to deal with even large-scope 
cleanup patches, we've learned how to check their correctness via size 
comparisons and .o file md5 sums. We have learned how to port fixes back 
and forth across cleanups without much effort, how to avoid rejects, 
etc. We dont apply it rigidly, but checkpatch.pl is a constant and 
reliable background force that helps us constantly improve the quality 
of arch/x86.

And this method is working out really well for us.

While nothing beats the value of old-fashioned code review, i have also 
found that reviewing patches that are against clean files is _easier_, 
because the cleanliness problems and inconsistencies in a file do not 
act as a constant "information noise" that distract from the real 
purpose of source code: to map intent to functionality.

So i can only recommend checkpatch.pl to all Linux maintainers, and a 
scripts/checkpatch.pl --file output is also a particularly funny sight 
when one applies it to a file one has written a long time ago and which 
one was proud about how clean it was back then ;-)

Lastly, even if someone were to disagree about how relevant 
checkpatch.pl --file errors are, dealing with the resulting cleanups is 
a policy matter up to the current maintainers of the files in question. 
Emitting a thick "WARNING" message by default easily kills cleanups at 
their source, before maintainers even had a chance to express their 
wishes.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 scripts/checkpatch.pl |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux/scripts/checkpatch.pl
===================================================================
--- linux.orig/scripts/checkpatch.pl
+++ linux/scripts/checkpatch.pl
@@ -1828,15 +1828,6 @@ sub process {
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
 	}
-	print <<EOL if ($file == 1 && $quiet == 0);
-
-WARNING: Using --file mode. Please do not send patches to linux-kernel
-that change whole existing files if you did not significantly change most
-of the the file for other reasons anyways or just wrote the file newly
-from scratch. Pure code style patches have a significant cost in a
-quickly changing code base like Linux because they cause rejects
-with other changes.
-EOL
 
 	return $clean;
 }
