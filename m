Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZDJXlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZDJXlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 19:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZDJXlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 19:41:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbZDJXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 19:41:35 -0400
Date: Fri, 10 Apr 2009 16:38:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, yinghan@google.com
Subject: Re: [PATCH 9/9] readahead: record mmap read-around states in
 file_ra_state
Message-Id: <20090410163853.0e1b8f7c.akpm@linux-foundation.org>
In-Reply-To: <20090410061255.041947147@intel.com>
References: <20090410060957.442203404@intel.com>
	<20090410061255.041947147@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 14:10:06 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Mmap read-around now shares the same code style and data structure
> with readahead code.
> 
> This also removes do_page_cache_readahead().
> Its last user, mmap read-around, has been changed to call ra_submit().
> 
> The no-readahead-if-congested logic is dumped by the way.
> Users will be pretty sensitive about the slow loading of executables.
> So it's unfavorable to disabled mmap read-around on a congested queue.

Did you verify that the read-congested code ever triggers?

It used to be (and probably still is) the case that
bdi_read_congested() is very very rare, because the read queue is long
and the kernel rarely puts many read requests into it.  You can of
course create this condition with a fake workload with may
threads/processes, but it _is_ fake.

Some real-world workloads (databases?) will of course trigger
bdi_read_congested().  But they're usually doing fixed-sized reads, and
if we're doing _any_ readahead/readaround in that case, readahead is
busted.

