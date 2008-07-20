Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYGTP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYGTP5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbYGTP5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:57:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:43686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYGTP5L (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:57:11 -0400
Date: Sun, 20 Jul 2008 08:56:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "V.Radhakrishnan" <rk@atr-labs.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
 problems in mmap() of /dev/mem character file
Message-ID: <20080720085650.3b6c2f6f@infradead.org>
In-Reply-To: <1216569046.2268.14.camel@atlas>
References: <1216315516.2324.10.camel@atlas>
	<alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
	<20080717223940.GA8206@elte.hu>
	<1216346657.2170.11.camel@atlas>
	<20080719150546.15a0e773@infradead.org>
	<1216569046.2268.14.camel@atlas>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 21:20:46 +0530
"V.Radhakrishnan" <rk@atr-labs.com> wrote:
> 
> It so happened that all my 17 students had working code with 2.6.25
> and I, the instructor, had the kernel 2.6.26 crash in front of them !
> 
> So I started tracing the call and found the 'bug' and 'fixed it'.

to get the old behavior, just disable PAT..

> 
> I agree with you 100% that my patch does not solve the problem, but
> is a quick fix approach to the next release. The PAT related access
> issue is valid. However, I humbly submit that memory access is a
> policy issue and perhaps should not be tinkered with thru code. 

it's not policy, it's correctness. We don't allow root to open a file
on a cdrom for write and then write to it.. even though denying root
would equally be policy, right? (it's not)

> 
> If you provide the root, access to /dev/mem, I don't think it should
> be a problem, since in any case, all others are denied access.

this assertion is not correct; the device driver, the pagecache etc etc
will still use the page for whatever they were using it for.
> Also,
> theoretically, if you access RAM for Read Only, why should there be a
> triple fault ? 

yes.
If you access it as cachable from /dev/mem, but the actual owner of the
memory was using it uncached, that can tripple fault the cpu (again
depending on model etc). If you access it uncachable from /dev/mem, but
the owner was using it cached... likewise. (and on some systems, the CPU
is fine but the chipset/memory controller are not)

On x86 you're not supposed to mix cached and uncached. And PAT enforces
this for all cases where there's an owner.. but for /dev/mem there's no
such thing.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
