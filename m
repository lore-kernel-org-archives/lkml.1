Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZGXODA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZGXODA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZGXODA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:03:00 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:51696 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZGXOC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HCPRkIxgTU5tE+eltQIcd2LDpXmg70mJrkwH9/LCtTlI9nZJlHm81c1P110dzDsnq6
         ieSERPGugP+vYUpQv3x9VIsyR8XNeW9u1XW468+SOPrR4VrK3nipmo896Z5JyFL4S+t9
         vHUgpztixjbmKwD3rMHkcntw9h32ofGsw0UCY=
MIME-Version: 1.0
In-Reply-To: <1248354493.26273.2.camel@twins>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
Date: Fri, 24 Jul 2009 16:02:56 +0200
Message-ID: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware 
	breakpoints
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/23 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
>> This adds the support for kernel hardware breakpoints in perfcounter.
>> It is added as a new type of software counter and can be defined by
>> using the counter number 5 and by passsing the address of the
>> breakpoint to set through the config attribute.
>
> Is there a limit to these hardware breakpoints? If so, the software
> counter model is not sufficient, since we assume we can always schedule
> all software counters. However if you were to add more counters than you
> have hardware breakpoints you're hosed.
>
>

Hmm, indeed. But this patch handles this case:

+static const struct pmu *bp_perf_counter_init(struct perf_counter *counter)
+{
+       if (hw_breakpoint_perf_init((unsigned long)counter->attr.config))
+               return NULL;
+

IIRC, hw_breakpoint_perf_init() calls register_kernel_breakpoint() which in turn
returns -ENOSPC if we haven't any breakpoint room left.

It seems we can only set 4 breakpoints simultaneously in x86, or
something close to that.
