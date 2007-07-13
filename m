Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbXGMCH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbXGMCH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXGMCHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:07:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50184 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXGMCHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:07:20 -0400
Date: Fri, 13 Jul 2007 03:07:10 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, "Hallyn, Serge" <serue@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Simplify /proc/<pid|self>/exe symlink code
Message-ID: <20070713020710.GA21668@ftp.linux.org.uk>
References: <1184292012.13479.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184292012.13479.14.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 07:00:12PM -0700, Matt Helsley wrote:
> This patch avoids holding the mmap semaphore while walking VMAs in response to
> programs which read or follow the /proc/<pid|self>/exe symlink. This also allows
> us to merge mmu and nommu proc_exe_link() functions. The costs are holding the
> task lock, a separate reference to the executable file stored in the task
> struct, and increased code in fork, exec, and exit paths.

I don't think it's a food idea.  Consider a program that deliberately
creates an executable anon memory, copies the binary there, jumps there
and unmaps the original.   In the current tree you'll get nothing
pinning the binary; with your patch it will remained busy.

It's not a common situation, of course, but there are legitimate uses
for such technics...
