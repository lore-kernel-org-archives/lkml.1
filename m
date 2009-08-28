Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZH1TwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZH1TwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZH1TwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:52:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60714 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752386AbZH1TwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:52:22 -0400
Date: Fri, 28 Aug 2009 20:53:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe Shmoe <jsmoe3@yahoo.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without
 PAE
Message-ID: <20090828205337.3677cf04@lxorguk.ukuu.org.uk>
In-Reply-To: <8980.20135.qm@web45211.mail.sp1.yahoo.com>
References: <24089.1251486780@turing-police.cc.vt.edu>
	<8980.20135.qm@web45211.mail.sp1.yahoo.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 12:44:25 -0700 (PDT)
joe Shmoe <jsmoe3@yahoo.com> wrote:

> No I am not talking about embedded systems. It is just an example.
> My question is what is preventing the kernel from setting up the page tables so that entire RAM can be mapped upto 4 GB.

The design of the x86 processor

You only have 4GB of virtual address space at any one time so you have to
fit the following within your 4GB virtual space

- Virtual addresses of the user space
- Mappings for physical memory
- Kernel virtual spaces (vmalloc etc)
- Various miscellaneous kernel mappings
- I/O MMIO space

Now you could in theory switch the page tables on kernel entry to get a
very big user space mapping and then instead of relying on the user space
being mapped you could map specific user pages or access them via their
physical address lookup.

That however means reloading %cr3 (page table base) which is very
expensive, and some very hard to implement locking on user space access.

Some other processor families have the notion of "spaces" or MMU
bypassing. The Sparc64 for example can access MMIO space without an MMU
mapping or virtual address being needed for it. x86 does not - it has
segments but the segments map into the 4GB space so they don't help here
hence the current implementation and 3G/1G split.
