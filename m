Return-Path: <linux-kernel-owner+w=401wt.eu-S932910AbZJ3VS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbZJ3VS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbZJ3VS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:18:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932899AbZJ3VS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:18:26 -0400
Date: Fri, 30 Oct 2009 14:18:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org, zach.brown@oracle.com
Subject: Re: [patch] aio: Don't zero out the pages array inside struct dio
Message-Id: <20091030141811.1c77571b.akpm@linux-foundation.org>
In-Reply-To: <x49tyxhroes.fsf@segfault.boston.devel.redhat.com>
References: <x49tyxhroes.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 09:39:55 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> Intel reported a performance regression caused by the following commit:
> 
> commit 848c4dd5153c7a0de55470ce99a8e13a63b4703f
> Author: Zach Brown <zach.brown@oracle.com>
> Date:   Mon Aug 20 17:12:01 2007 -0700
> 
>     dio: zero struct dio with kzalloc instead of manually
> 
>     This patch uses kzalloc to zero all of struct dio rather than
>     manually trying to track which fields we rely on being zero.  It
>     passed aio+dio stress testing and some bug regression testing on
>     ext3.
> 
>     This patch was introduced by Linus in the conversation that lead up
>     to Badari's minimal fix to manually zero .map_bh.b_state in commit:
> 
>       6a648fa72161d1f6468dabd96c5d3c0db04f598a
> 
>     It makes the code a bit smaller.  Maybe a couple fewer cachelines to
>     load, if we're lucky:
> 
>        text    data     bss     dec     hex filename
>     3285925  568506 1304616 5159047  4eb887 vmlinux
>     3285797  568506 1304616 5158919  4eb807 vmlinux.patched
> 
>     I was unable to measure a stable difference in the number of cpu
>     cycles spent in blockdev_direct_IO() when pushing aio+dio 256K reads
>     at ~340MB/s.
> 
>     So the resulting intent of the patch isn't a performance gain but to
>     avoid exposing ourselves to the risk of finding another field like
>     .map_bh.b_state where we rely on zeroing but don't enforce it in the
>     code.
> 
> Zach surmised that zeroing out the page array was what caused most of
> the problem, and suggested the approach taken in the attached patch for
> resolving the issue.  Intel re-tested with this patch and saw a 0.6%
> performance gain (the original regression was 0.5%).
> 
> Comments, as always, are appreciated.
> 

You forgot something:

--- a/fs/direct-io.c~aio-dont-zero-out-the-pages-array-inside-struct-dio-fix
+++ a/fs/direct-io.c
@@ -130,6 +130,12 @@ struct dio {
 	unsigned head;			/* next page to process */
 	unsigned tail;			/* last valid page + 1 */
 	int page_errors;		/* errno from get_user_pages() */
+
+	/*
+	 * pages[] (and any fields placed after it) are not zeroed out at
+	 * allocation time.  Don't add new fields after pages[] unless you
+	 * wish that they not be zeroed.
+	 */
 	struct page *pages[DIO_PAGES];	/* page buffer */
 };
 
_

