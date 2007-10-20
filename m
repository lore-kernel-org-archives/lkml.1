Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXJTSuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXJTSuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbXJTSuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:50:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422AbXJTSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:50:22 -0400
Date: Sat, 20 Oct 2007 11:49:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <alpine.LFD.0.999.0710201058300.3794@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710201140550.3794@woody.linux-foundation.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
 <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
 <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com>
 <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
 <20071020164752.GB6855@uranus.ravnborg.org>
 <alpine.LFD.0.999.0710201058300.3794@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Linus Torvalds wrote:
> 
> I could perhaps look at making "git log --follow" also break up files that 
> got totally rewritten (git already has a notion of "-B" to do that), but 
> no, we don't do it right now. 

Ok, if you guys have a current git source, and want to try something out, 
this fairly small patch does this.

As mentioned, git already supports the notion of "try to break files with 
the same name if the contents are too dissimilar". In other words, even if 
a file exists under the same name in both the old revision and in the 
newer one, we'll look at just how big the changes are, and if git decides 
that it looks like the whole file was rewritten, then git will split up 
the diff into a "delete old contents" and "create new contents". That then 
allows it to consider the file for rename detection.

(The rename detection may, of course, decide that the original file was 
the best source after all.. ;)

However, "git log --follow" didn't ever actually enable that for the logic 
that tries to figure out where a file came from, so you would only see 
this when generating the diffs, never in the file history logic. That's 
an easy one-liner to tree-diff.c: try_to_follow_renames().

However, when I actually tried it, it turns out that the break logic was 
broken - nobody has ever really depended on it. So while it was a 
one-liner to make "git log --follow" understand to break files that seem 
to be totally rewritten, it still didn't actually work, because the 
changes that totally rewrote vmlinux.lds.S wouldn't trigger the break 
logic.

So most of this (still fairly small patch) is just fixing the break logic 
in diffcore-break.c:should_break().

It hasn't gotten a lot of testing, but it does actually improve other 
cases too, so I think this is the right thign to do. I'll bring it up on 
the git lists.

Oh, and with this patch, the "break same filename" is still off by 
default. You need to do

	git log --follow -B arch/x86/kernel/vmlinux_64.lds.S

to enable the file-rewritten-so-break-associations detection. I suspect 
it makes sense to enable -B by default when using --follow (--follow 
already obviously implies rename detection), but that's a separate and 
independent issue.

		Linus

----
 diffcore-break.c |   11 +++++++----
 tree-diff.c      |    1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/diffcore-break.c b/diffcore-break.c
index ae8a7d0..c71a226 100644
--- a/diffcore-break.c
+++ b/diffcore-break.c
@@ -45,8 +45,8 @@ static int should_break(struct diff_filespec *src,
 	 * The value we return is 1 if we want the pair to be broken,
 	 * or 0 if we do not.
 	 */
-	unsigned long delta_size, base_size, src_copied, literal_added,
-		src_removed;
+	unsigned long delta_size, base_size, max_size;
+	unsigned long src_copied, literal_added, src_removed;
 
 	*merge_score_p = 0; /* assume no deletion --- "do not break"
 			     * is the default.
@@ -63,7 +63,8 @@ static int should_break(struct diff_filespec *src,
 		return 0; /* error but caught downstream */
 
 	base_size = ((src->size < dst->size) ? src->size : dst->size);
-	if (base_size < MINIMUM_BREAK_SIZE)
+	max_size = ((src->size > dst->size) ? src->size : dst->size);
+	if (max_size < MINIMUM_BREAK_SIZE)
 		return 0; /* we do not break too small filepair */
 
 	if (diffcore_count_changes(src, dst,
@@ -89,12 +90,14 @@ static int should_break(struct diff_filespec *src,
 	 * less than the minimum, after rename/copy runs.
 	 */
 	*merge_score_p = (int)(src_removed * MAX_SCORE / src->size);
+	if (*merge_score_p > break_score)
+		return 1;
 
 	/* Extent of damage, which counts both inserts and
 	 * deletes.
 	 */
 	delta_size = src_removed + literal_added;
-	if (delta_size * MAX_SCORE / base_size < break_score)
+	if (delta_size * MAX_SCORE / max_size < break_score)
 		return 0;
 
 	/* If you removed a lot without adding new material, that is
diff --git a/tree-diff.c b/tree-diff.c
index 26bdbdd..7c261fd 100644
--- a/tree-diff.c
+++ b/tree-diff.c
@@ -319,6 +319,7 @@ static void try_to_follow_renames(struct tree_desc *t1, struct tree_desc *t2, co
 	diff_opts.detect_rename = DIFF_DETECT_RENAME;
 	diff_opts.output_format = DIFF_FORMAT_NO_OUTPUT;
 	diff_opts.single_follow = opt->paths[0];
+	diff_opts.break_opt = opt->break_opt;
 	paths[0] = NULL;
 	diff_tree_setup_paths(paths, &diff_opts);
 	if (diff_setup_done(&diff_opts) < 0)
