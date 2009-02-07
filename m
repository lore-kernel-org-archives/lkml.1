Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZBGB4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZBGB4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZBGB4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:56:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbZBGB4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:56:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
 set_fs(KERNEL_DS)
In-Reply-To: Linus Torvalds's message of  Friday, 6 February 2009 14:19:31 -0800 <alpine.LFD.2.00.0902061416070.3048@localhost.localdomain>
X-Fcc: ~/Mail/linus
References: <1233940235.22140.9.camel@localhost.localdomain>
	<20090206134410.d548b72c.akpm@linux-foundation.org>
	<20090206220717.AE750FC3AD@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902061416070.3048@localhost.localdomain>
Emacs: no job too big... no job.
Message-Id: <20090207015553.3EE46FC3AD@magilla.sf.frob.com>
Date: Fri,  6 Feb 2009 17:55:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I suspect just surrounding the load with set_fs(USER_DS) and then 
> set_fs(KERNEL_DS) to put it back is likely the right thing to do.

Agreed.

> The address is "safe" in that it does come from the vma, but we obviously 
> do play games with things like the call gate mappings etc. 

gate_vma has VM_ALWAYSDUMP so it never sees this whole path anyway.
I doubt there is any actual case.  But, point taken.

> Should we also perhaps do this only if the vma is marked readable and
> executable? That way we could avoid taking unnecessary faults there.
> 
> Probably doesn't really matter. 

I'm sure it doesn't really matter.  But, just to say it all: Requiring
VM_EXEC would actually exclude some valid cases.  Even requiring VM_READ is
less than perfect as far as pedantic semantics go--but there is no reason
not to check it since its lack rules out get_user() actually working
anyway.  I already chose that trade-off since get_user() here is so much
cheaper than get_user_pages().  The core dump from a stray
"mprotect(0,1UL<<32,PROT_NONE)" (i.e. presumably actually one with some
arithmetic error) would be useful if we made the check work without
VM_READ, but oh well.


Thanks,
Roland
