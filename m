Return-Path: <linux-kernel-owner+w=401wt.eu-S934937AbXFFSNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937AbXFFSNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXFFSN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:13:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbXFFSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:13:25 -0400
Date: Wed, 6 Jun 2007 11:13:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606111315.884cf712.akpm@linux-foundation.org>
In-Reply-To: <20070606163053.GM6909@holomorphy.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<20070606163053.GM6909@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 09:30:53 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Wed, Jun 06, 2007 at 02:07:37AM -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> > - Somebody broke it on my powerpc G5, but I didn't have time to do yet
> >   another bisection yet.
> > - There's a lengthy patch series here from Nick which attempts to address
> >   the longstanding pagefault-vs-buffered-write deadlock.
> >   A great shower of filesystems were broken and have been disabled with
> >   CONFIG_BROKEN.  This includes reiser4.
> > - Complex patches which eliminate the kernel's fixed size limit on the
> >   command-line length.  These break nommu builds.
> 
> Someone remind me what the pagefault vs. buffered write deadlock is.

generic_file_write() does lock_page(), then copies the user's data into
pagecache.  If that copy_from_user() encounters a major fault and the page
is not uptodate, the pagefault handler does lock_page() and deadlocks.

It requires that the user be writ()ing from a mmap of the page back into
the same page, which is weird.

The kernel tries to prefault the page to avoid the copy_from_user() fault,
but there are ways in whcih that can be defeated (super memory pressure,
malicious fadvise() from a second thread, etc).

> Something brings down i386/qemu before even earlyprintk can handle.
> 
> Bisection has narrowed it down to patch 1140 after everything got
> renumbered by peterz' fix for mm-variable-length-argument-support.patch,
> namely containersv10-make-cpusets-a-client-of-containers.patch

erk.  A step-by-step how-to-make-this-happen might help if poss, please.
