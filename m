Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYKHBEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYKHBEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 20:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYKHBEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 20:04:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbYKHBEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 20:04:12 -0500
Date: Fri, 7 Nov 2008 17:03:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] kprobe: increase kprobe_hash_table size
Message-Id: <20081107170307.1a4f815e.akpm@linux-foundation.org>
In-Reply-To: <4914DAEE.2050301@redhat.com>
References: <4914D2DE.9030603@redhat.com>
	<20081107155646.b375413e.akpm@linux-foundation.org>
	<4914DAEE.2050301@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 19:18:54 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Andrew,
> 
> Andrew Morton wrote:
> > On Fri, 07 Nov 2008 18:44:30 -0500 Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > 
> >> Increase the size of kprobe hash table to 512. It's useful when hundreds
> >> of kprobes were used in the kernel because current size is just 64.
> >>
> > 
> > "useful" is a bit vague.  How big is the problem which this solves, and
> > how well did it solve it?
> 
> For example, when probing enters and exits of syscall-related functions,
> we need more than 500 probes. In that case, each hlist would have 8
> elements in average. With this patch, the hlist would have 1 element in
> average.
> 
> I agree that there may be many opinions about what is the best suited size.
> Why I chose 512 was that I thought the table (byte) size was less than or
> equal 4096 even on 64-bit arch.

Well...

   text    data     bss     dec     hex filename
   7036     744    9380   17160    4308 kernel/kprobes.o
   7048     744   73892   81684   13f14 kernel/kprobes.o

That's 64 kbytes more memory.  It will be kretprobe_table_locks[] which
is hurting here, due to the ____cacheline_aligned.

I expected CONFIG_X86_VSMP=y to make this far worse, but fortunately
that only affects ____cacheline_internodealigned_in_smp.

btw, that array wastes a ton of memory on uniprocessor builds.  Using
____cacheline_aligned_in_smp should fix that.

Please always check these thigns with /usr/bin/size.

btw2, could/should kprobe_table[] and kretprobe_inst_table[] be
aggregated into kretprobe_table_locks[]?  That would save some memory
and might save some cache misses as well?


Anyway, enough pos-facto code review.  Is this change which you're
proposing worth increasing kernel memory usage by 64k?
