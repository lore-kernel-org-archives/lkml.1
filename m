Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbYFDVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbYFDVw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYFDVwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:52:18 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:28108 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbYFDVwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:52:18 -0400
Message-Id: <4846D647.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 04 Jun 2008 15:52:07 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       <tglx@linutronix.de>, "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: fix cpupri priocount
References: <20080604185838.5108.54912.stgit@novell1.haskins.net>
 <20080604190410.5108.78092.stgit@novell1.haskins.net>
 <1212613754.19205.25.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212613754.19205.25.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jun 4, 2008 at  5:09 PM, in message
<1212613754.19205.25.camel@lappy.programming.kicks-ass.net>, Peter Zijlstra
<peterz@infradead.org> wrote: 
> On Wed, 2008-06-04 at 15:04 -0400, Gregory Haskins wrote:
>> A rounding error was pointed out by Peter Zijlstra which would result
>> in the structure holding priorities to be off by one.
>> 
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> ---
>> 
>>  kernel/sched_cpupri.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
>> index 16d29b9..817c55c 100644
>> --- a/kernel/sched_cpupri.h
>> +++ b/kernel/sched_cpupri.h
>> @@ -4,7 +4,7 @@
>>  #include <linux/sched.h>
>>  
>>  #define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
>> -#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
>> +#define CPUPRI_NR_PRI_WORDS (CPUPRI_NR_PRIORITIES + 
> BITS_PER_LONG/2)/BITS_PER_LONG
> 
> (33 + 16) / 32 = 49 / 32 = 1
> 
> So its still wrong ;-)
> 
> Please use DECLARE_BITMAP and or BITS_TO_LONGS to avoid these issues.

Indeed.  Here is a new version:

(Thanks, Peter!)

------

    sched: fix cpupri priocount

    A rounding error was pointed out by Peter Zijlstra which would result
    in the structure holding priorities to be off by one.

    Signed-off-by: Gregory Haskins <ghaskins@novell.com>
    CC: Peter Zijlstra <peterz@infradead.org>

diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 16d29b9..51e6553 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -4,7 +4,7 @@
 #include <linux/sched.h>

 #define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
-#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
+#define CPUPRI_NR_PRI_WORDS BITS_TO_LONGS(CPUPRI_NR_PRIORITIES)

 #define CPUPRI_INVALID -1
 #define CPUPRI_IDLE     0

