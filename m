Return-Path: <linux-kernel-owner+w=401wt.eu-S965776AbXCHIMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776AbXCHIMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965771AbXCHIMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:12:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56908 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965776AbXCHIMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:12:51 -0500
Date: Thu, 8 Mar 2007 00:12:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: bert.hubert@netherlabs.nl, riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070308001235.d7cb099e.akpm@linux-foundation.org>
In-Reply-To: <45EFC246.4050807@linux.vnet.ibm.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303214108.GA28961@outpost.ds9a.nl>
	<20070303141448.1ed70e6d.akpm@linux-foundation.org>
	<45E9F454.2080600@redhat.com>
	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>
	<20070303230155.GA475@outpost.ds9a.nl>
	<20070303154541.70aed9df.akpm@linux-foundation.org>
	<45EFC246.4050807@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 08 Mar 2007 13:29:02 +0530 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > That all sounds reasonably doable.  It'd be pretty complex to do it
> > in-kernel but we could do it there too.  Problem is if course that the
> > above strategy is explicitly optimised for the backup program and if it's
> > in-kernel it becomes applicable to all other workloads.
> 
> This strategy looks very good.  However we are not considering the
> performance impact on the 'backup' application as such.  By removing
> pagecache pages brought in by the application without the knowledge of
> the applications usage and behavior may severely affect its performance.
> 
> Certainly we are interested in improving system performance at the
> cost certain applications, but not to an extend that the backup
> process will drag on and on to an unreasonable amount of time.
> 
> Also backup processes may consist of a group of applications working
> on the same stream of data.  Like compression program, encryption
> program etc which could be independent applications.

Well yes, if the application is that funky then suitably funky userspace
tricks will be needed to avoid hurting it.

> We should consider having a limit on pagecache usage rather than
> denying any space in the pagecache for these applications.

That's what containerisation is for:

	run-in-container --memory=16M /bin/backup-program

This can be done today with x86_64 fake-numa, controlled by cpusets.  One
day, when we get our containerisation story sorted out, things will be more
convenient...

> Can fadvice() be enhanced to have a limit on pagecache usage and
> reclaim used pages in LRU order?  This way data stays for a little
> while for other applications to pickup from pagecache.
> 
> Pages already in memory or brought in by other applications need not
> be placed in this list and hence we prevent any collateral pageouts.

We could teach the presently-unimplemented POSIX_FADV_NOREUSE to dump this
file's pages at the tail of the inactive list (after cleaning them if
needed).  That way, they're the first to get reclaimed.

The standard says "Specifies that the application expects to access the
specified data once and then not reuse it thereafter." That's a bit
ambiguous: it it before the process accessed the data, or after?  Before, I
suspect.

