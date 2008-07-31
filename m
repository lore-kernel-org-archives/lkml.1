Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYGaRRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYGaRRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYGaRRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:17:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:43346 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYGaRRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:17:12 -0400
Date: Thu, 31 Jul 2008 11:17:09 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       "Jochen =?ISO-8859-1?B?Vm/f?=" <jochen.voss@googlemail.com>
Subject: Re: [PATCH] A development process document, V2 (diff from V1)
Message-ID: <20080731111709.488b9fa7@bike.lwn.net>
In-Reply-To: <20080731111443.2179bf4c@bike.lwn.net>
References: <20080731111443.2179bf4c@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the changes from the first posted version of the development
process document.

jon

>From b7d9843de29afe63da93c1c4f0c7067963c6585d Mon Sep 17 00:00:00 2001
From: Jonathan Corbet <corbet@lwn.net>
Date: Thu, 31 Jul 2008 11:00:35 -0600
Subject: [PATCH] Various improvements in response to reviewer comments.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/development-process/1.Intro          |   19 +++++++--
 Documentation/development-process/2.Process        |   15 ++++++-
 Documentation/development-process/3.Early-stage    |   13 ++++--
 Documentation/development-process/4.Coding         |   19 +++++++--
 Documentation/development-process/5.Posting        |   40 ++++++++++++++------
 Documentation/development-process/6.Followthrough  |   16 ++++++-
 Documentation/development-process/7.AdvancedTopics |   21 +++++-----
 7 files changed, 101 insertions(+), 42 deletions(-)

diff --git a/Documentation/development-process/1.Intro b/Documentation/development-process/1.Intro
index 0bbf4d7..d6c948b 100644
--- a/Documentation/development-process/1.Intro
+++ b/Documentation/development-process/1.Intro
@@ -9,7 +9,7 @@ there is some technical material here, this is very much a process-oriented
 discussion which does not require a deep knowledge of kernel programming to
 understand.
 
-The Linux kernel, at over 6 million lines of code and 2000 active
+The Linux kernel, at over 6 million lines of code and well over 1000 active
 contributors, is one of the largest and most active free software projects
 in existence.  Since its humble beginning in 1991, this kernel has evolved
 into a best-of-breed operating system component which runs on pocket-sized
@@ -32,8 +32,8 @@ One of the most compelling features of Linux is that it is accessible to
 these developers; anybody with the requisite skills can improve Linux and
 influence the direction of its development.  Proprietary products cannot
 offer this kind of openness, which is a characteristic of the free software
-process.  But, if anything, the kernel is open even than most other free
-software projects.  A typical three-month kernel development cycle can
+process.  But, if anything, the kernel is even more open than most other
+free software projects.  A typical three-month kernel development cycle can
 involve over 1000 developers working for more than 100 different companies
 (or for no company at all).
 
@@ -65,8 +65,9 @@ join our community.
 1.1: CREDITS
 
 This document was written by Jonathan Corbet, corbet@lwn.net.  It has been
-improved by comments from Randy Dunlap, Jake Edge, Matt Mackall, and Amanda
-McPherson.
+improved by comments from Alex Chiang, Roland Dreier, Randy Dunlap, Jake
+Edge, Jiri Kosina, Matt Mackall, Amanda McPherson, Andrew Morton, and
+Jochen Voﬂ.
 
 This work was supported by the Linux Foundation; thanks especially to
 Amanda McPherson, who saw the value of this effort and made it all happen.
@@ -124,6 +125,14 @@ discussed in greater detail later in this document.  Consider:
   are heard, but active developers have a stronger voice - and the ability
   to implement changes which make the kernel work better for their needs.
 
+- When code is maintained separately, the possibility that a third party
+  will contribute a different implementation of a similar feature always
+  exists.  Should that happen, getting your code merged will become much
+  harder - to the point of impossibility.  Then you will be faced with the
+  unpleasant alternatives of either (1) maintaining a nonstandard feature
+  out of tree indefinitely, or (2) abandoning your code and migrating your
+  users over to the in-tree version.
+
 - Contribution of code is the fundamental action which makes the whole
   process work.  By contributing your code you can add new functionality to
   the kernel and provide capabilities and examples which are of use to
diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index ff0cd34..c9492ff 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -55,7 +55,10 @@ submitted to the mainline.  On occasion a more significant change will be
 allowed, but such occasions are rare; developers who try to merge new
 features outside of the merge window tend to get an unfriendly reception.
 As a general rule, if you miss the merge window for a given feature, the
-best thing to do is to wait for the next development cycle.
+best thing to do is to wait for the next development cycle.  (An occasional
+exception is made for drivers for previously-unsupported hardware; if they
+touch no in-tree code, they cannot cause regressions and should be safe to
+add at any time).
 
 As fixes make their way into the mainline, the patch rate will slow over
 time.  Linus releases new -rc kernels about once a week; a normal series
@@ -95,7 +98,7 @@ larger, creating even more regressions the next time around.  So most 2.6.x
 kernels go out with a handful of known regressions though, hopefully, none
 of them are serious.
 
-Once a stable release is made, its ongoing maintenance is passed of to the
+Once a stable release is made, its ongoing maintenance is passed off to the
 "stable team," currently comprised of Greg Kroah-Hartman and Chris Wright.
 The stable team will release occasional updates to the stable release using
 the 2.6.x.y numbering scheme.  To be considered for an update release, a
@@ -389,12 +392,18 @@ There are a few hints which can help with linux-kernel survival:
 - When responding to linux-kernel email (or that on other lists) preserve
   the Cc: header for all involved.  In the absence of a strong reason (such
   as an explicit request), you should never remove recipients.  Always make
-  sure that the person you are responding to is in the Cc: list.
+  sure that the person you are responding to is in the Cc: list.  This
+  convention also makes it unnecessary to explicitly ask to be copied on
+  replies to your postings.
 
 - Search the list archives (and the net as a whole) before asking
   questions.  Some developers can get impatient with people who clearly
   have not done their homework.
 
+- Avoid top-posting (the practice of putting your answer above the quoted
+  text you are responding to).  It makes your response harder to read and
+  makes a poor impression.
+
 - Ask on the correct mailing list.  Linux-kernel may be the general meeting
   point, but it is not the best place to find developers from all
   subsystems.
diff --git a/Documentation/development-process/3.Early-stage b/Documentation/development-process/3.Early-stage
index 23a353f..207c8e7 100644
--- a/Documentation/development-process/3.Early-stage
+++ b/Documentation/development-process/3.Early-stage
@@ -42,6 +42,8 @@ and posted this:
 	to communicate user requirements to these people is a waste of
 	time. They are much too "intelligent" to listen to lesser mortals.
 
+(http://lwn.net/Articles/131776/).
+
 The reality of the situation was different; the kernel developers were far
 more concerned about system stability, long-term maintenance, and finding
 the right solution to the problem than they were with a specific module.
@@ -85,7 +87,7 @@ communication can save time and trouble in a number of ways:
    problem; they may have ideas for a better solution, and may be willing
    to help in the creation of that solution.
 
-Years of experience with the kernel development community has taught a
+Years of experience with the kernel development community have taught a
 clear lesson: kernel code which is designed and developed behind closed
 doors invariably has problems which are only revealed when the code is
 released into the community.  Sometimes these problems are severe,
@@ -99,9 +101,9 @@ the kernel community's standards.  Some examples include:
    of this code (now called mac80211) was delayed for over a year.
 
  - The Reiser4 filesystem included a number of capabilities which, in the
-   core developers' opinion, should have been implemented in the virtual
-   filesystem layer instead.  It also included features which could not
-   easily be implemented without exposing the system to user-caused
+   core kernel developers' opinion, should have been implemented in the
+   virtual filesystem layer instead.  It also included features which could
+   not easily be implemented without exposing the system to user-caused
    deadlocks.  The late revelation of these problems - and refusal to
    address some of them - has caused Reiser4 to stay out of the mainline
    kernel.
@@ -136,6 +138,9 @@ patches, and who, if anybody, is attaching Signed-off-by lines to those
 patches.  Those are the people who be best placed to help with a new
 development project.
 
+If all else fails, talking to Andrew Morton can be an effective way to
+track down a maintainer for a specific piece of code.
+
 
 3.4: WHEN TO POST?
 
diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
index 86a00a9..c1443bc 100644
--- a/Documentation/development-process/4.Coding
+++ b/Documentation/development-process/4.Coding
@@ -185,6 +185,8 @@ breaks?  The best answer to this question was expressed by Linus in July,
 	progress at all. Is it two steps forwards, one step back, or one
 	step forward and two steps back?
 
+(http://lwn.net/Articles/243460/).
+
 An especially unwelcome type of regression is any sort of change to the
 user-space ABI.  Once an interface has been exported to user space, it must
 be supported indefinitely.  This fact makes the creation of user-space
@@ -280,13 +282,13 @@ user-space and kernel-space addresses, mixture of big-endian and
 small-endian quantities, the passing of integer values where a set of bit
 flags is expected, and so on.  Sparse must be installed separately (it can
 be found at http://www.kernel.org/pub/software/devel/sparse/ if your
-distributor does not package it); it can then be run on the code using the
-C=1 flag to make.
+distributor does not package it); it can then be run on the code by adding
+"C=1" to your make command.
 
 Other kinds of portability errors are best found by compiling your code for
 other architectures.  If you do not happen to have an S/390 system or a
 Blackfin development board handy, you can still perform the compilation
-step.  A full set of cross compilers for x86 systems can be found at 
+step.  A large set of cross compilers for x86 systems can be found at 
 
 	http://www.kernel.org/pub/tools/crosstool/
 
@@ -302,6 +304,12 @@ of new code into the kernel, make life easier for other developers, and
 will be helpful for your users.  In many cases, the addition of
 documentation has become essentially mandatory.
 
+The first piece of documentation for any patch is its associated
+changelog.  Log entries should describe the problem being solved, the form
+of the solution, the people who worked on the patch, any relevant
+effects on performance, and anything else that might be needed to
+understand the patch.
+
 Any code which adds a new user-space interface - including new sysfs or
 /proc files - should include documentation of that interface which enables
 user-space developers to know what they are working with.  See
@@ -321,9 +329,10 @@ in a number of ways by the "kernel-doc" script.  If you are working within
 a subsystem which has kerneldoc comments, you should maintain them and add
 them, as appropriate, for externally-available functions.  Even in areas
 which have not been so documented, there is no harm in adding kerneldoc
-comments for the future.  The format of these comments, along with some
+comments for the future; indeed, this can be a useful activity for
+beginning kernel developers.  The format of these comments, along with some
 information on how to create kerneldoc templates can be found in the file
-Documentation/kernel-doc-nano-HOWTO.txt. 
+Documentation/kernel-doc-nano-HOWTO.txt.
 
 Anybody who reads through a significant amount of existing kernel code will
 note that, often, comments are most notable by their absence.  Once again,
diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index 5443d7a..c6ac6ba 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -170,8 +170,8 @@ The tags in common use are:
  - Signed-off-by: this is a developer's certification that he or she has
    the right to submit the patch for inclusion into the kernel.  It is an
    agreement to the Developer's Certificate of Origin, the full text of
-   which can be found in SubmittingPatches.  Code without a proper signoff
-   cannot be merged into the mainline.
+   which can be found in Documentation/SubmittingPatches.  Code without a
+   proper signoff cannot be merged into the mainline.
 
  - Acked-by: indicates an agreement by another developer (often a
    maintainer of the relevant code) that the patch is appropriate for
@@ -181,7 +181,8 @@ The tags in common use are:
    it to work.
 
  - Reviewed-by: the named developer has reviewed the patch for correctness;
-   see the reviewer's statement in SubmittingPatches for more detail.
+   see the reviewer's statement in Documentation/SubmittingPatches for more
+   detail.
 
  - Reported-by: names a user who reported a problem which is fixed by this
    patch; this tag is used to give credit to the (often underappreciated)
@@ -216,6 +217,11 @@ take care of:
    look like, is not smarter than you.  If fixing a checkpatch.pl complaint
    would make the code worse, don't do it.
 
+Patches should always be sent as plain text.  Please do not send them as
+attachments; that makes it much harder for reviewers to quote sections of
+the patch in their replies.  Instead, just put the patch directly into your
+message.
+
 When mailing patches, it is important to send copies to anybody who might
 be interested in it.  Unlike some other projects, the kernel encourages
 people to err on the side of sending too many copies; don't assume that the
@@ -229,12 +235,18 @@ copies should go to:
    those who might be working there now.  Using git to see who else has
    modified the files you are working on can be helpful.
 
- - If you are responding to a bug report or a feature request, copy those
-   people as well.
+ - If you are responding to a bug report or a feature request, copy the
+   original poster as well.
 
  - Send a copy to the relevant mailing list, or, if nothing else applies,
    the linux-kernel list.
 
+ - If you are fixing a bug, think about whether the fix should go into the
+   next stable update.  If so, stable@kernel.org should get a copy of the
+   patch.  Also add a "Cc: stable@kernel.org" to the tags within the patch
+   itself; that will cause the stable team to get a notification when your
+   fix goes into the mainline.
+
 When selecting recipients for a patch, it is good to have an idea of who
 you think will eventually accept the patch and get it merged.  While it
 *is* possible to send patches directly to Linus Torvalds and have him merge
@@ -253,10 +265,14 @@ patches in the series, and "subsys" is the name of the affected subsystem.
 Clearly, nn/mm can be omitted for a single, standalone patch.  
 
 If you have a significant series of patches, it is customary to send an
-introductory description as part zero.  In general, the second and
-following parts of a multi-part patch should be sent as a reply to the
-first part so that they all thread together at the receiving end.  Tools
-like git and quilt have commands to mail out a set of patches with the
-proper threading.  If you have a long series, though, and are using git,
-please provide the --no-chain-reply-to option to avoid creating
-exceptionally deep nesting.
+introductory description as part zero.  This convention is not universally
+followed though; if you use it, remember that information in the
+introduction does not make it into the kernel changelogs.  So please ensure
+that the patches, themselves, have complete changelog information.
+
+In general, the second and following parts of a multi-part patch should be
+sent as a reply to the first part so that they all thread together at the
+receiving end.  Tools like git and quilt have commands to mail out a set of
+patches with the proper threading.  If you have a long series, though, and
+are using git, please provide the --no-chain-reply-to option to avoid
+creating exceptionally deep nesting.
diff --git a/Documentation/development-process/6.Followthrough b/Documentation/development-process/6.Followthrough
index 27d1006..2815f88 100644
--- a/Documentation/development-process/6.Followthrough
+++ b/Documentation/development-process/6.Followthrough
@@ -20,7 +20,7 @@ prevent the inclusion of your patches into the mainline.
 
 A patch of any significance will result in a number of comments from other
 developers as they review the code.  Working with reviewers can be, for
-many developers, the most indimidating part of the kernel development
+many developers, the most intimidating part of the kernel development
 process.  Life can be made much easier, though, if you keep a few things in
 mind:
 
@@ -71,6 +71,15 @@ go away.  They will not go away.  If you repost code without having
 responded to the comments you got the time before, you're likely to find
 that your patches go nowhere.
 
+Speaking of reposting code: please bear in mind that reviewers are not
+going to remember all the details of the code you posted the last time
+around.  So it is always a good idea to remind reviewers of previously
+raised issues and how you dealt with them; the patch changelog is a good
+place for this kind of information.  Reviewers should not have to search
+through list archives to familiarize themselves with what was said last
+time; if you help them get a running start, they will be in a better mood
+when they revisit your code.
+
 What if you've tried to do everything right and things still aren't going
 anywhere?  Most technical disagreements can be resolved through discussion,
 but there are times when somebody simply has to make a decision.  If you
@@ -119,8 +128,9 @@ Now they can be resolved at leisure, before the merge window opens.
 
 Some day, if all goes well, you'll log on and see that your patch has been
 merged into the mainline kernel.  Congratulations!  Once the celebration is
-complete, though, it is worth remembering an important little fact: the job
-still is not done.  Merging into the mainline brings its own challenges.
+complete (and you have added yourself to the MAINTAINERS file), though, it
+is worth remembering an important little fact: the job still is not done.
+Merging into the mainline brings its own challenges.
 
 To begin with, the visibility of your patch has increased yet again.  There
 may be a new round of comments from developers who had not been aware of
diff --git a/Documentation/development-process/7.AdvancedTopics b/Documentation/development-process/7.AdvancedTopics
index 840c440..2cd6d49 100644
--- a/Documentation/development-process/7.AdvancedTopics
+++ b/Documentation/development-process/7.AdvancedTopics
@@ -83,9 +83,9 @@ turning a tested (hopefully) kernel tree into an untested one.  But, beyond
 that, developers cannot easily collaborate if they do not have a shared
 view of the project history; if you rewrite history which other developers
 have pulled into their repositories, you will make life much more difficult
-for those developers going forward.  So a simple rule of thumb applies
-here: history which has been exported to others should generally be seen as
-immutable thereafter.
+for those developers.  So a simple rule of thumb applies here: history
+which has been exported to others should generally be seen as immutable
+thereafter.
 
 So, once you push a set of changes to your publicly-available server, those
 changes should not be rewritten.  Git will attempt to enforce this rule if
@@ -123,13 +123,14 @@ can affect your ability to get trees pulled in the future.  Quoting Linus:
 	to trust things *without* then having to go and check every
 	individual change by hand.
 
-(http://lwn.net/Articles/224135/).  To avoid this kind of situation, ensure
-that all patches within a given branch stick closely to the associated
-topic; a "driver fixes" branch should not be making changes to the core
-memory management code.  And, most importantly, do not use a git tree to
-bypass the review process.  Post an occasional summary of the tree to the
-relevant list, and, when the time is right, request that the tree be
-included in linux-next.
+(http://lwn.net/Articles/224135/).  
+
+To avoid this kind of situation, ensure that all patches within a given
+branch stick closely to the associated topic; a "driver fixes" branch
+should not be making changes to the core memory management code.  And, most
+importantly, do not use a git tree to bypass the review process.  Post an
+occasional summary of the tree to the relevant list, and, when the time is
+right, request that the tree be included in linux-next.
 
 If and when others start to send patches for inclusion into your tree,
 don't forget to review them.  Also ensure that you maintain the correct
-- 
1.5.6.4

