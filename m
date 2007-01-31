Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXAaBcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXAaBcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbXAaBcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:32:06 -0500
Received: from mail.suse.de ([195.135.220.2]:52946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbXAaBcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:32:03 -0500
Date: Wed, 31 Jan 2007 02:31:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 0/9] buffered write deadlock fix
Message-ID: <20070131013157.GA21285@wotan.suse.de>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070130125558.ae9119b0.akpm@osdl.org> <20070130152119.e0a18e58.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130152119.e0a18e58.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 03:21:19PM -0800, Andrew Morton wrote:
> On Tue, 30 Jan 2007 12:55:58 -0800
> Andrew Morton <akpm@osdl.org> wrote:
> 
> > y'know, four or five years back I fixed this bug by doing
> > 
> > 	current->locked_page = page;
> > 
> > in the write() code, and then teaching the pagefault code to avoid locking
> > the same page.  Patch below.
> > 
> > But then evil mean Hugh pointed out that the patch is still vulnerable to
> > ab/ba deadlocking so I dropped it.
> 
> And he was right, of course.  Task A holds file a's i_mutex and takes a
> fault against file b's page.  Task B holds file b's i_mutex and takes a
> fault against file a's page.  Drat.
> 
> I wonder if there's a sane way of preventing that.

If you want to go down the path of carrying state around in task_struct,
you can take the mmap_sem and set a flag, then get_user_pages the source
page and lock both source and destination in ascending order, then your
page fault handler checks the flag and skips mmap_sem, and the rest of
your fault path checks both the page locks you're holding.

At which point you arrive at a horrible mess :)

