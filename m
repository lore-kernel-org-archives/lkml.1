Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbXJOVNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbXJOVNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXJOVNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:13:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbXJOVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:13:30 -0400
Date: Mon, 15 Oct 2007 14:12:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       mingo@elte.hu
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20071015141236.62b075c6.akpm@linux-foundation.org>
In-Reply-To: <20071015161315.4fe18e07@bree.surriel.com>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
	<20071015114738.6b5a25c7.akpm@linux-foundation.org>
	<20071015161315.4fe18e07@bree.surriel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 16:13:15 -0400
Rik van Riel <riel@redhat.com> wrote:

> Since you have been involved a lot with ext3 development,
> which kinds of workloads do you think will show a performance
> degradation with Arjan's patch?   What should I test?

Gee.  Expect the unexpected ;)

One problem might be when kjournald is doing its ordered-mode data
writeback at the start of commit.  That writeout will now be
higher-priority and might impact other tasks which are doing synchronous
file overwrites (ie: no commits) or O_DIRECT reads or writes or just plain
old reads.

If the aggregate number of seeks over the long term is the same as before
then of course the overall throughput should be the same, in which case the
impact might only be upon latency.  However if for some reason the total
number of seeks is increased then there will be throughput impacts as well.

So as a starting point I guess one could set up a
copy-a-kernel-tree-in-a-loop running in the background and then see what
impact that has upon a large-linear-read, upon a
read-a-different-kernel-tree and upon some database-style multithreaded
O_DIRECT reader/overwriter.
