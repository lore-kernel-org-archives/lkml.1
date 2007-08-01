Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXHAQGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXHAQGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXHAQGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:06:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36864 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbXHAQGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:06:34 -0400
Subject: Re: /proc/$pid/pagemap troubles
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070801001404.GY11115@waste.org>
References: <1185914174.18414.184.camel@localhost>
	 <20070731213718.GW11115@waste.org> <1185921790.18414.223.camel@localhost>
	 <20070801001404.GY11115@waste.org>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 09:06:30 -0700
Message-Id: <1185984390.18414.241.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 19:14 -0500, Matt Mackall wrote:
> On Tue, Jul 31, 2007 at 03:43:10PM -0700, Dave Hansen wrote:
> > +       evpfn = min((src + count) / sizeof(unsigned long),
> > +                   ((~0UL) >> PAGE_SHIFT) + 1);
> > 
> > Should that hunk of code be any different for 32-bit processes on a
> > 64-bit kernel?  Do we want to use TASK_SIZE_OF() or restrict these to
> > actual virtual address space (which is only 48 bits on x86_64).
> 
> No. A page for a 32-bit task can line anywhere in the >32-bit physical
> address space.

An evpfn is an ending _virtual_ pfn right?  A virtual pfn is a vaddr >>
PAGE_SHIFT, right?  We're not calculating anything having to do with
physical addresses.  Having 64-bit physical addresses would be a reason
to use 64-bits as the entry size, but not to round down this "evpfn".

"src" in this case is "*ppos", which is the offset into the file.
Divide that by the entry size (sizeof(unsigned long)) and you get the
number of pages offset into the vaddr space that the user is attempting
to read.  There might be a bug here with it forgetting to offset the
header size, but oh well.

In any case, what _is_ the ((~0UL) >> PAGE_SHIFT)  operation there for?
Is it to make sure that a user reading at the end of the virtual address
space doesn't ask to read 10 pages starting at 0xfffffff0?

> Most of those go away with the get_user_pages approach.

Are you working on this actively?  If not, I'd be happy to take whatever
you have and fix it up.  Care to post it, even in a slightly unpolished
state?

-- Dave

