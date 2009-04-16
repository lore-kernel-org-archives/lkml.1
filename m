Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZDPTCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZDPTCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZDPTCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:02:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:63541 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbZDPTCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:02:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: corbet@lwn.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tytso@mit.edu
Subject: [PATCH] documentation: list common guidelines for commit log content
Date: Thu, 16 Apr 2009 15:00:56 -0400
Message-Id: <1239908456-24871-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.6.2.3
X-OriginalArrivalTime: 16 Apr 2009 19:01:03.0366 (UTC) FILETIME=[B05F9A60:01C9BEC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent discussions on lkml have brought to light that it is
probably worthwhile documenting some of the common (yet up to
now implicit) requirements that exist for commit log content.
This is by no means exhaustive, but it is a start.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[I've added some folks to the CC who I thought might be interested
 based on their input to the original discussion in the quilt/ACPI thread...]

 Documentation/development-process/5.Posting |   80 +++++++++++++++++++++++++--
 1 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index dd48132..5aa1622 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -133,15 +133,27 @@ that end, each patch will be composed of the following:
  - A one-line description of what the patch does.  This message should be
    enough for a reader who sees it with no other context to figure out the
    scope of the patch; it is the line that will show up in the "short form"
-   changelogs.  This message is usually formatted with the relevant
-   subsystem name first, followed by the purpose of the patch.  For
-   example:
+   changelogs.
 
-	gpio: fix build on CONFIG_GPIO_SYSFS=n
+   Always capture the most significant part of your change in the words of
+   this subject/shortlog.  For example, don't say "fix compile warning in
+   foo" when the compiler warning was really telling us that we were
+   dereferencing complete garbage off in the weeds that could possibly
+   cause an OOPS under some circumstances.  When people are choosing
+   commits for backports to stable or distro kernels, the shortlog will be
+   what they use for an initial sorting selection.  If they see "Fix possible
+   OOPS in...." then these people will look closer, whereas they will most
+   likely skip over simple warning fixes.
+
+   This subject/shortlog message is usually formatted with the relevant
+   subsystem name first, followed by the purpose of the patch.  For example:
+
+	gpio: fix build of libpins.c for CONFIG_GPIO_SYSFS=n
 
  - A blank line followed by a detailed description of the contents of the
    patch.  This description can be as long as is required; it should say
-   what the patch does and why it should be applied to the kernel.
+   what the patch does and why it should be applied to the kernel.  More
+   information and recommendations on patch descriptions are given below.
 
  - One or more tag lines, with, at a minimum, one Signed-off-by: line from
    the author of the patch.  Tags will be described in more detail below.
@@ -158,6 +170,64 @@ the build process, for example, or editor backup files) in the patch.  The
 file "dontdiff" in the Documentation directory can help in this regard;
 pass it to diff with the "-X" option.
 
+The detailed patch description is not something to be treated as a mere
+transient bit of information that only goes out with your e-mail.  It will
+be permanently stored in the kernel archive along with your source changes.
+As such, you should try to make the description as useful as possible.
+Here are some general guidelines that should assist you in making your
+patch description the best that it can be.
+
+  - Don't simply translate your C code change into English for a commit
+    log.  The log "Change compare from zero to one" is bad because it
+    describes only the code change in the patch; we can see that from
+    reading the patch itself.  Let the code tell the story of the mechanics
+    of the change (as much as possible), and let your comment tell the
+    other details -- i.e. what the problem was, how it manifested itself
+    (symptoms), and if necessary, the justification for why the fix was
+    done in the manner that it was.
+
+  - Don't start your commit log with "This patch..."   -- we already know
+    it is a patch.
+
+  - Don't repeat your short log in the long log.  If you really really
+    don't have anything new and informational to add in as a long log,
+    then don't put a long log at all.  This should be uncommon -- i.e.
+    the only acceptable cases for no long log would be something like
+    "Documentation: Fix spelling mistakes in foo/README" or similar.
+
+  - Don't put data in that is meaningless to others (i.e. internal tracking
+    numbers, commit IDs from private or rebased repositories, etc.)
+
+  - Don't put absolute paths to source files that are specific to your site,
+    i.e. if you get a compile error on "fs/exec.c" then tidy up the parts
+    of the compile output to just show that portion.  We don't need to see
+    that it was /home/wally/src/git/linux/devel/2009/Nov/linux-2.6/fs/exec.c
+    or similar - that full path has no value to others.
+
+  - Don't put in the full 20 or more lines of a backtrace when really it is
+    just the last 5 or so function calls that are relevant to the crash/fix.
+    If the entry point, or start of the trace is relevant (i.e. a syscall
+    or similar), you can leave that, and then replace a chunk of the
+    intermediate calls in the middle with a single [...]
+
+  - Don't include timestamps on a chunk of a printk log, unless they are
+    relevant to the situation (i.e. indicating an unacceptable delay in
+    a driver initialization etc.)
+
+  - If a complex change is likely to cause a maintainer to inquire about
+    the testing that you've done, or you feel that your testing is relevant
+    in terms of proving the validity of the change then summarize what
+    testing you have done.
+
+  - If there are known limitations (i.e. patch is a temporary work around
+    for some problem, or doesn't work on all architectures) then list them.
+
+  - Limit yourself to a reasonsable line length for wrapping lines on your
+    commit log.  Most developers will use something like "git show" to
+    look at your patch (once it has been accepted) and that adds an
+    indent of 4 spaces.  So if you push line lengths out beyond 75 chars,
+    chances are it won't appear as professional as you'd have liked it to.
+
 The tags mentioned above are used to describe how various developers have
 been associated with the development of this patch.  They are described in
 detail in the SubmittingPatches document; what follows here is a brief
-- 
1.6.2.3

