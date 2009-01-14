Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbZANQbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbZANQbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbZANQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:31:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759492AbZANQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:31:34 -0500
Message-ID: <496E1357.8050507@redhat.com>
Date: Wed, 14 Jan 2009 11:31:19 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH][bugfix] kprobes: fix module compilation error with CONFIG_KPROBES=n
References: <49628849.1000706@redhat.com> <20090114003234.3720e9a1.akpm@linux-foundation.org>
In-Reply-To: <20090114003234.3720e9a1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 05 Jan 2009 17:23:05 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Define kprobes related data structures even if CONFIG_KPROBES is not set.
>> This fixes compilation errors which occur if CONFIG_KPROBES is not set, in
>> kprobe using modules.
>>
>> Reviewed-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> ---
>>  include/linux/kprobes.h |   45 +++++++++++++++++++++++----------------------
>>  1 file changed, 23 insertions(+), 22 deletions(-)
>>
>> Index: 2.6.28/include/linux/kprobes.h
>> ===================================================================
>> --- 2.6.28.orig/include/linux/kprobes.h
>> +++ 2.6.28/include/linux/kprobes.h
>> @@ -37,9 +37,9 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/rcupdate.h>
>>  #include <linux/mutex.h>
>> +#include <asm/kprobes.h>
>>
>>  #ifdef CONFIG_KPROBES
>> -#include <asm/kprobes.h>
>>
> 
> The above change breaks alpha, and any other architecture which has no
> asm/kprobes.h.

Oops, indeed. Thank you for finding it!

> I undid that change, but maybe that rebroke things?

Yes, some structures should be defined in asm/kprobes.h, so
here is an additional fix patch.

------------------------------------------------------
From: Masami Hiramatsu <mhiramat@redhat.com>

Add dummy definitions of kprobe_opcode_t and arch_specific_insn
when CONFIG_KPROBES=n.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/kprobes.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: 2.6-mm/include/linux/kprobes.h
===================================================================
--- 2.6-mm.orig/include/linux/kprobes.h
+++ 2.6-mm/include/linux/kprobes.h
@@ -50,6 +50,10 @@
 /* Attach to insert probes on any functions which should be ignored*/
 #define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
 #else /* CONFIG_KPROBES */
+typedef int kprobe_opcode_t;
+struct arch_specific_insn {
+	int dummy;
+};
 #define __kprobes	notrace
 #endif /* CONFIG_KPROBES */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

