Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbZKCPY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbZKCPY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZKCPY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:24:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZKCPY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:24:57 -0500
Date: Tue, 3 Nov 2009 10:24:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, hbabu@us.ibm.com,
       kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: kdump fails to load and crashes [was: mmotm 2009-11-01-10-01
	uploaded]
Message-ID: <20091103152448.GC4235@redhat.com>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org> <4AEF673E.5030509@gmail.com> <20091103144450.GB4235@redhat.com> <4AF048D1.4090402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF048D1.4090402@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 04:14:25PM +0100, Jiri Slaby wrote:
> On 11/03/2009 03:44 PM, Vivek Goyal wrote:
> > On Tue, Nov 03, 2009 at 12:11:58AM +0100, Jiri Slaby wrote:
> >> On 11/01/2009 07:07 PM, akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
> >>
> >> Hi, kdump loading crashes:
> >> BUG: unable to handle kernel paging request at ffff8800010a7000
> >> IP: [<ffffffff8101cd8b>] machine_kexec_prepare+0x16b/0x13e0
> >> PGD 1806063 PUD 180a063 PMD 10001e1
> ...
> >> ffff8800010a7000 should be OK, as crashkernel=64M@16M was passed to the
> >> kernel.
> >>
> > 
> > This is strange. As you said, ffff8800010a7000, should be a valid address
> > as you reserved memory from 16M.
> 
> Hmm, PMD has not RW bit set and we do store (see below).
> 
> > I took above -mm and for me kernel loads fine. I reserved memory 64M@32M
> > as by default kernel is loading at address 16M.
> > 
> > How does your /proc/iomem look like in first kernel?
> 
> I'm not any longer on that machine. init_pgtable() overwrites random
> memory, so possibly even host's page tables, hence the oops above, I
> suppose.
> 
> I'm currently chasing it down in the qemu virtual machine, since I
> already got a garbage into my ~/.viminfo (some overwritten page got
> flushed, I guess).
> 
> There /proc/iomem looks like:
> 00100000-12beffff : System RAM
>   01000000-04ffffff : Crash kernel
>     01000000-014680c2 : Kernel code
>     014680c3-016f39f7 : Kernel data
>     0175b000-017d97ab : Kernel bss

Hmm.., this looks fishy. Reserved memory is starting at 16MB at the same
time first kernel is loaded at 16MB. So when we try to load a crash kernel
it can try to overwrite existing kernel.

In the past if crash kernel memory area used to overlap with kernel code,
data or bss, we would not reserve the memory for "Crash Kernel" and this
entry would not appear in /proc/iomem. Not sure what has changed.

Anyway, can you just try reserving memory at some other address, say
64M@32M and see if it works.

Thanks
Vivek
