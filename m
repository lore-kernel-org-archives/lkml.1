Return-Path: <linux-kernel-owner+w=401wt.eu-S2992885AbXBQXsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992885AbXBQXsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992891AbXBQXsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:48:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965396AbXBQXsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:48:04 -0500
Date: Sat, 17 Feb 2007 15:47:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, michael chang <thenewme91@gmail.com>,
       ck mailing list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: 2.6.20-ck1
Message-Id: <20070217154746.7ff10870.akpm@linux-foundation.org>
In-Reply-To: <200702180800.07393.kernel@kolivas.org>
References: <200702162110.03355.kernel@kolivas.org>
	<200702171417.28376.kernel@kolivas.org>
	<45D74D34.5020201@redhat.com>
	<200702180800.07393.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 08:00:06 +1100 Con Kolivas <kernel@kolivas.org> wrote:

> On Sunday 18 February 2007 05:45, Chuck Ebbert wrote:
> ...
> > But the one I like, mm-filesize_dependant_lru_cache_add.patch,
> > has an on-off switch.
> >
>
> ...
>
> Do you still want this patch for mainline?... 

Don't think so.  The problems I see are:

- It's a system-wide knob.  In many situations this will do the wrong
  thing.  Controlling pagecache should be per-process.

- Its heuristics for working out when to invalidate the pagecache will be
  too much for some situations and too little for others.

- Whatever we do, there will be some applications in some situations
  which are hurt badly by changes like this: they'll do heaps of extra IO.


Generally, the penalties for getting this stuff wrong are very very high:
orders of magnitude slowdowns in the right situations.  Which I suspect
will make any system-wide knob ultimately unsuccessful.

The ideal way of getting this *right* is to change every application in the
world to get smart about using sync_page_range() and/or posix_fadvise(),
then to add a set of command-line options to each application in the world
so the user can control its pagecache handling.

Obviously that isn't practical.  But what _could_ be done is to put these
pagecache smarts into glibc's read() and write() code.  So the user can do:

	MAX_PAGECACHE=4M MAX_DIRTY_PAGECACHE=2M rsync foo bar

This will provide pagecache control for pretty much every application.  It
has limitations (fork+exec behaviour??) but will be useful.


A kernel-based solution might use new rlimits, but would not be as flexible
or successful as a libc-based one, I suspect.

