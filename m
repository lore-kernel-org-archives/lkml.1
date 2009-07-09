Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZGIJHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZGIJHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGIJH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:07:27 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51410 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755259AbZGIJH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:07:26 -0400
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>, Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1247078164.16156.18.camel@laptop>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
	 <1246980836.9777.5.camel@twins>
	 <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
	 <1246981444.9777.11.camel@twins>
	 <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
	 <1246982101.9777.15.camel@twins>  <20090708172248.GB2521@redhat.com>
	 <1247078164.16156.18.camel@laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 09 Jul 2009 10:06:56 +0100
Message-Id: <1247130416.11409.14.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2009 09:06:57.0172 (UTC) FILETIME=[9C490D40:01CA0074]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 20:36 +0200, Peter Zijlstra wrote:
> As a side node, I see that each and every trace ends with a -1 entry:
> 
> ...
> [ 1194.412158]    [<c01f7990>] do_mount+0x3c0/0x7c0
> [ 1194.412158]    [<c01f7e14>] sys_mount+0x84/0xb0
> [ 1194.412158]    [<c01221b1>] syscall_call+0x7/0xb
> [ 1194.412158]    [<ffffffff>] 0xffffffff
> 
> Which seems to come from:
> 
> void save_stack_trace(struct stack_trace *trace)
> {
>         dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
>         if (trace->nr_entries < trace->max_entries)
>                 trace->entries[trace->nr_entries++] = ULONG_MAX;
> }
> EXPORT_SYMBOL_GPL(save_stack_trace);
> 
> commit 006e84ee3a54e393ec6bef2a9bc891dc5bde2843 seems involved,..

The reason for this is that if there are no more traces to show, it
inserts -1. In this case, it cannot trace beyond the system call. If the
stack trace is truncated because of the maximum number of trace entries
it can show, you won't get a -1.

Before the commit above, it was always inserting -1 even if the trace
was longer than the maximum number of entries.

-- 
Catalin

