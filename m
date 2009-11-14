Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZKNE6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZKNE6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 23:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbZKNE6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 23:58:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbZKNE6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 23:58:20 -0500
Subject: Re: + recordmcount-stfu.patch added to -mm tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, lihong.hi@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
References: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 13 Nov 2009 23:58:25 -0500
Message-Id: <1258174705.22249.236.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 19:56 -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      recordmcount-stfu
> has been added to the -mm tree.  Its filename is
>      recordmcount-stfu.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: recordmcount-stfu
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> oy, people are trying to get work done here.
> 
> Cc: Li Hong <lihong.hi@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  scripts/recordmcount.pl |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN scripts/recordmcount.pl~recordmcount-stfu scripts/recordmcount.pl
> --- a/scripts/recordmcount.pl~recordmcount-stfu
> +++ a/scripts/recordmcount.pl
> @@ -180,9 +180,9 @@ sub check_objcopy
>      close (IN);
>  
>      if (!$can_use_local) {
> -	print STDERR "WARNING: could not find objcopy version or version " .
> -	    "is less than 2.17.\n" .
> -	    "\tLocal function references is disabled.\n";
> +#	print STDERR "WARNING: could not find objcopy version or version " .
> +#	    "is less than 2.17.\n" .
> +#	    "\tLocal function references is disabled.\n";
>      }
>  }
>  

Andrew, would something like this patch be sufficient?

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ffa502..4b8293f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1785,9 +1785,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 static struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     unsigned long length, unsigned long tail,
-	     struct buffer_page *commit_page,
 	     struct buffer_page *tail_page, u64 *ts)
 {
+	struct buffer_page *commit_page = cpu_buffer->commit_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct buffer_page *next_page;
 	int ret;
@@ -1890,13 +1890,10 @@ static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
-	struct buffer_page *tail_page, *commit_page;
+	struct buffer_page *tail_page;
 	struct ring_buffer_event *event;
 	unsigned long tail, write;
 
-	commit_page = cpu_buffer->commit_page;
-	/* we just need to protect against interrupts */
-	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
 
@@ -1907,7 +1904,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	/* See if we shot pass the end of this buffer page */
 	if (write > BUF_PAGE_SIZE)
 		return rb_move_tail(cpu_buffer, length, tail,
-				    commit_page, tail_page, ts);
+				    tail_page, ts);
 
 	/* We reserved something on the buffer */
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a4e2435..ac4fa2d 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -162,6 +162,10 @@ my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
 my $can_use_local = 0; 	# If we can use local function references
 
+# Shut up recordmcount if user has older objcopy
+my $print_warning = 1;
+$print_warning = 0 if ( -f "FTRACE_QUIET");
+
 ##
 # check_objcopy - whether objcopy supports --globalize-symbols
 #
@@ -179,10 +183,12 @@ sub check_objcopy
     }
     close (IN);
 
-    if (!$can_use_local) {
+    if (!$can_use_local && $print_warning) {
 	print STDERR "WARNING: could not find objcopy version or version " .
 	    "is less than 2.17.\n" .
-	    "\tLocal function references is disabled.\n";
+	    "\tLocal function references are disabled.\n" .
+	    "\tTo disable this message, create the file FTRACE_QUIET\n" .
+	    "\tin the top level directory\n";
     }
 }
 


