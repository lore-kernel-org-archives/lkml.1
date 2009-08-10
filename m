Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZHJOLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZHJOLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHJOLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:11:37 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:61384 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbZHJOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W0nWaKBaQzXYgB4EWMEU1rKWsmkDlDcgw26IQxtSF4sjSicJgmLwaLYQDAQNtvHHCU
         tpdAnXECJxHSGxVAQFhmQViEri/+uDoaRCF6YCRmeXmCjwrbj/dS/qelm1KS6R6eAcXb
         fgZF4OK3+ioHcJ62NXQoGPIgYNk2tfi5qR7y4=
Date: Mon, 10 Aug 2009 16:11:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/3] perfcounter: Substract the buffer size field from the
	event record size
Message-ID: <20090810141129.GA5124@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com> <1249698400-5441-2-git-send-email-fweisbec@gmail.com> <1249896447.17467.74.camel@twins> <20090810125731.GA5124@nowhere> <1249909585.17467.135.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249909585.17467.135.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 03:06:25PM +0200, Peter Zijlstra wrote:
> > I'll do the alignment right in the end, just before inserting the entry
> > in the output. That will be more easy. I'll zeroe the rest in the same time.
> 
> OK.


Actually I shouldn't, the alignment should be computed early, taking the
field size into account.

That's not a problem though, I've just substracted the u32 field once
I found the final aligned size.

See below:

---
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 10 Aug 2009 15:56:46 +0200
Subject: [PATCH 6/3] perfcounter: Substract the buffer size field from the event record size

We compute the perf raw sample size by aligning the raw ftrace event
size plus the buffer size field itself. We do that instead of aligning
only the perf raw sample size, so that we might economize some in some
cases.

But this buffer size field is not stored in the perf raw sample, we
must then substract its size from the buffer once we computed the
alignment unless we may get a useless u32 field in the buffer.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/ftrace.h      |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 4dc1a60..f98ff56 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -639,7 +639,12 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	pc = preempt_count();
  *
  *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
- *	__entry_size = __data_size + sizeof(*entry);
+ *
+ *	// Below we want to get the aligned size by taking into account
+ *	// the u32 field that will later store the buffer size
+ *	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
+ *			     sizeof(u64));
+ *	__entry_size -= sizeof(u32);
  *
  *	do {
  *		char raw_data[__entry_size]; <- allocate our sample in the stack
@@ -689,6 +694,7 @@ static void ftrace_profile_##call(proto)				\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
+	__entry_size -= sizeof(u32);					\
 									\
 	do {								\
 		char raw_data[__entry_size];				\
-- 
1.6.2.3


