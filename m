Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbXKETEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbXKETEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXKETEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:04:12 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42287 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXKETEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:04:10 -0500
Date: Mon, 5 Nov 2007 18:57:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: Erez Zadok <ezk@cs.sunysb.edu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
In-Reply-To: <1194280730.6271.145.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711051839520.25940@blonde.wat.veritas.com>
References: <200710312353.l9VNr67n013016@agora.fsl.cs.sunysb.edu> 
 <Pine.LNX.4.64.0711051358440.7629@blonde.wat.veritas.com>
 <1194280730.6271.145.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Dave Hansen wrote:
> 
> Actually, I think your s/while/if/ change is probably a decent fix.

Any resemblance to a decent fix is purely coincidental.

> Barring any other races, that loop should always have made progress on
> mnt->__mnt_writers the way it is written.  If we get to:
> 
> >                 lock_and_coalesce_cpu_mnt_writer_counts();
> ----------------->HERE
> >                 mnt_unlock_cpus();
> 
> and don't have a positive mnt->__mnt_writers, we know something is going
> badly.  We WARN_ON() there, which should at least give an earlier
> warning that the system is not doing well.  But it doesn't fix the
> inevitable.  Could you try the attached patch and see if it at least
> warns you earlier?

Thanks, Dave, yes, that gives me a nice warning:

leak detected on mount(c25ebd80) writers count: -65537
WARNING: at fs/namespace.c:249 handle_write_count_underflow()
 [<c0103486>] show_trace_log_lvl+0x1b/0x2e
 [<c01034b6>] show_trace+0x16/0x1b
 [<c0103589>] dump_stack+0x19/0x1e
 [<c0171906>] handle_write_count_underflow+0x4c/0x60
 [<c0171983>] mnt_drop_write+0x69/0x8e
 [<c0160211>] __fput+0xff/0x162
 [<c016010d>] fput+0x2e/0x33
 [<c01b8f63>] unionfs_file_release+0xc2/0x1c5
 [<c01601a1>] __fput+0x8f/0x162
 [<c016010d>] fput+0x2e/0x33
 [<c015ec9d>] filp_close+0x50/0x5d
 [<c015ed1e>] sys_close+0x74/0xb4
 [<c01026ce>] sysenter_past_esp+0x5f/0x85

and the test then goes quietly on its way instead of hanging.  Though
I imagine, with your patch or mine, that it's then making an unfortunate
frequency of calls to lock_and_coalesce_longer_name_than_I_care_to_type
thereafter.  But it's hardly your responsibility to optimize for bugs
elsewhere.

The 2.6.23-mm1 tree has MNT_USER at 0x200, so I adjusted your flag to
#define MNT_IMBALANCED_WRITE_COUNT	0x400 /* just for debugging */

> 
> I have a decent guess what the bug is, too.  In the unionfs code:

I'll let Erez take it from there...

Hugh
