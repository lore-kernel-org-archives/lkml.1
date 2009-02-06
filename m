Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZBFWHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZBFWHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZBFWHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:07:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbZBFWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:07:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       torvalds@linux-foundation.org
Subject: Re: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
 set_fs(KERNEL_DS)
In-Reply-To: Andrew Morton's message of  Friday, 6 February 2009 13:44:10 -0800 <20090206134410.d548b72c.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <1233940235.22140.9.camel@localhost.localdomain>
	<20090206134410.d548b72c.akpm@linux-foundation.org>
Emacs: Lovecraft was an optimist.
Message-Id: <20090206220717.AE750FC3AD@magilla.sf.frob.com>
Date: Fri,  6 Feb 2009 14:07:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address in question comes from a user vma's vm_start, so by definition
it has to be in the user part of the address space.  This code path is
excluded for VM_IO and the like by checks earlier in vma_dump_size.
So, is this problem purely theoretical?  I guess not on machines where
set_fs actually changes the meaning of the lower address space.

I think get_user_pages would certainly be overkill for this.  It's a check
to decide whether you need to pay the cost of get_user_pages, after all.

set_fs is quite cheap at least on most machines.  So a pair of set_fs calls
around that get_user call doesn't seem so bad.  OTOH, on the machines where
this actually matters at all (maybe just sparc, arm, s390?) it is
presumably (much?) more costly.  But it seems like the best solution, and
certainly is straightforward.


Thanks,
Roland
