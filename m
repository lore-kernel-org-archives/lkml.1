Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYG2AeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYG2AeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYG2Ady
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:33:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43120 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYG2Adw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:33:52 -0400
Date: Tue, 29 Jul 2008 10:33:50 +1000
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Terry Loftin <terry.loftin@hp.com>, Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-ia64@vger.kernel.org
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-ID: <20080729003348.GG10434@verge.net.au>
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au> <20080728133110.GC25963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728133110.GC25963@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 09:31:10AM -0400, Vivek Goyal wrote:
> On Mon, Jul 28, 2008 at 11:51:19AM +1000, Simon Horman wrote:
> > [ Updated Vivek's email address to his vgoyal@redhat.com in CC list 
> >   Added Terry Loftin, Tony Luck, Erik Biedermann and linux-ia64 to CC list ]

[snip]

> > 1) Always parse the elfcorehdr kernel command line option
> >    and set elfcorehdr_addr accordingly - currently this is only
> >    done if CONFIG_PROC_VMCORE is set.
> > 
> >    This is nice as it won't need any modifications to kexec-tools
> >    nor any command line bloat.
> > 
> >    A minor difficulty is working out where to initialise elfcorehdr_addr.
> >    Sometimes in include/linux/crash_dump.h and sometimes in
> >    fs/proc/vmcore.c seems horrible to me.
> > 
> >    Another problem is that would be alive and well in
> >    code that really only uses it to check if kdump was activated or not
> >    - a minor naming issue.
> > 
> 
> Hi Simon,
> 
> There are some kernel bits (like iommu initialization patch), which need to
> take special action if they are booting after a kexec on panic (Generally we
> are referring it to booting into kdump kernel) and that's why the notion
> is_kdump_kernel().
> 
> To me, is_kdump_kernel() symbolizes whether I  am booting after kexec on
> panic and not just the fact if CONFIG_CRASH_DUMP is enabled or not in this
> kernel.
> 
> So I would think that lets not rename it to kernel_has_vmcore(), instead
> lets write few lines of comments before function is_kdump_kernel() to
> clarify its meaning.
> 
> Secondly, we are using elfcorehdr_addr to determine whether this kernel
> is booting after a panic so elfcorehdr_addr is not just limited to
> CONFIG_PROC_VMCORE now and we should probably pull it out of
> fs/proc/vmcore.c. How about declaring and initializing this variable in
> kernel/kexec.c under CONFIG_CRASH_DUMP and always parse elfcorehdr_addr
> irrespective of the setting of CONFIG_PROC_VMCORE?

Agreed. Like Eric I think that this is a reasonable solution given
the current state of things. I'll reply to your patches after looking
at them a bit more closely.

> > 2) Add a new kernel command line option, perhaps in_kdump
> > 
> >    This is bloat to get around elfcorehdr_addr initialisation and
> >    naming awkwardness above.
> > 
> > 3) Make select CONFIG_PROC_VMCORE when CONFIG_CRASH_DUMP is selected,
> >    or perhaps even just remove CONFIG_PROC_VMCORE and only use
> >    CONFIG_CRASH_DUMP instead. The effect would be the same either way.
> > 
> >    Pro: One less thing to be confused about
> > 
> >    Con: Bloat for people who want kdump without vmcore.
> >         I wonder what usage case that is.
> 
> Argument was people can use /dev/oldmem and not use /proc/vmcore. So far
> I don't know anybody who uses /dev/oldmem to capture dump and not
> /proc/vmcore.

What I was getting at is that frangly the three variables
CONFIG_KEXEC, CONFIG_CRASH_DUMP and CONFIG_PROC_VMCORE seem to
confuse people. I've seen them used incorrectly several times now.
So if there is a way to simplyfy things, even slightly, I think
that would be a good idea. But if there isn't, so be it.

-- 
Horms

