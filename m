Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXLKPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXLKPxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXLKPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:53:39 -0500
Received: from verein.lst.de ([213.95.11.210]:48628 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXLKPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:53:38 -0500
Date: Tue, 11 Dec 2007 16:53:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][POWERPC] Provide a way to protect 4k subpages when using 64k pages
Message-ID: <20071211155305.GA28055@lst.de>
References: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 05:09:27PM +1100, Paul Mackerras wrote:
> Implicit in this is that the regions of the address space that are
> protected are switched to use 4k hardware pages rather than 64k
> hardware pages (on machines with hardware 64k page support).  In fact
> the whole process is switched to use 4k hardware pages when the
> subpage_prot system call is used, but this could be improved in future
> to switch only the affected segments.

> I have re-purposed the ioperm system call for this.  The old ioperm
> system call never did anything (except return an ENOSYS error) and in
> fact never could have actually been useful for anything on the PowerPC
> architecture, so nothing ever used it.

As Arnd said reusing an old system call slot seems rather dangerous,
I'd rather avoid it.   But I wonder whether we really need a new
syscall.  Using 4k pages should basically be a pre-process flag
(which it already is as an implementation detail in your patch), and
thus the proper way to mark it should be a personality flag.  This
also means it could be implied by certain personalities, e.g. powerpc
32bit for full compatiblity.   All these process would use plain mmap/
mprotect to deal with the subpage protections.

In fact the x86 emulation on ia64 already has some hacks for that in
arch/ia64/ia32/sys_ia32.c, and it would be really useful if we could
make both the interface and eventually the code implementing it generic.
At least ia64 and mips have multiple pages sizes already and I suspect
more architectures will grow support for it.
