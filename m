Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZIJSnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZIJSnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIJSnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:43:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45572 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZIJSnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K4YkCgoDjHccIIJReJp2B9utV/J8/t7f0K6GLB3fVmapFrxiPSgnUOocKF687+zI6S
         gn7CXUxC9xtn13dhlpDHozxq06MFxJPFkqt+EmL+ZIUEZqsz9cIO4BCCB2gaI2V/BQE8
         xrJhSIen1JrVNCLItjUG1yXU7gzEntmY6wuSY=
Date: Thu, 10 Sep 2009 20:43:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/5] perf_counter: Export various perf helpers for
	external users
Message-ID: <20090910184345.GB6421@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-3-git-send-email-fweisbec@gmail.com> <19112.58078.764004.864248@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19112.58078.764004.864248@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 09:28:30PM +1000, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > Export various perf helpers that initialize, destroy, attach and detach
> > a perf counter for future external users like the hardware breakpoint api.
> 
> You are exporting things that are quite deep into the guts of the
> perf_counter code, which makes me think that what you're exporting
> isn't the right abstraction.  At the least, your commit message needs
> to talk about what these external users want to do and why they need
> to reach so deeply into the perf_counter internals.




Yeah those are quite deep in perf internals but I don't have
much the choice. I can't (I shouldn't) call sys_perf_open()
directly so I need to do about the same things that are done
from this syscall, without the file handling.

But I agree this needs more comments and explanations in the
changelog. I'll add these for the v2.


 
> > The allocation and initialization of a perf counter have been split up
> > so that an external user can first allocate and then prefill the
> > counter before initialize it properly.
> 
> Once again, this sounds like the wrong abstraction to me.  Can you
> explain why first allocating and then prefilling it before
> initializing it properly is necessary or desirable?
> 
> Paul.


You're right this is wrong. And this was even meant to be
reverted in further incremental patches.

The reason is that struct perf_counter embeds a struct hw_breakpoint.
And I need it to be inserted right between the counter allocation
and its initialization for it to take effect while calling
bp_perf_counter_init()

Ingo noticed the 1:1 relationship between struct hw_breakpoint
and struct perf_counter and suggested to remove the former and create
core breakpoint field inside perf attributes.

I like the idea, that would shrink the code and also bring a
unified way to set the breakpoints parameters in the counter
(for both syscall and in-kernel uses).

And then we won't need anymore this alloc/init split, which means
this change would have been reverted in further patches.

But I guess I should do that right in the beginning (in this
patchset) instead of later. So I will do that in the v2.

Thanks.

