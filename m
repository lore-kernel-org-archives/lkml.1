Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZBFWU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZBFWU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZBFWUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:20:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbZBFWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:20:48 -0500
Date: Fri, 6 Feb 2009 14:19:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
 set_fs(KERNEL_DS)
In-Reply-To: <20090206220717.AE750FC3AD@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0902061416070.3048@localhost.localdomain>
References: <1233940235.22140.9.camel@localhost.localdomain> <20090206134410.d548b72c.akpm@linux-foundation.org> <20090206220717.AE750FC3AD@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Feb 2009, Roland McGrath wrote:
> 
> set_fs is quite cheap at least on most machines.  So a pair of set_fs calls
> around that get_user call doesn't seem so bad.  OTOH, on the machines where
> this actually matters at all (maybe just sparc, arm, s390?) it is
> presumably (much?) more costly.  But it seems like the best solution, and
> certainly is straightforward.

Yes, I suspect just surrounding the load with set_fs(USER_DS) and then 
set_fs(KERNEL_DS) to put it back is likely the right thing to do.

The address is "safe" in that it does come from the vma, but we obviously 
do play games with things like the call gate mappings etc. Should we also 
perhaps do this only if the vma is marked readable and executable? That 
way we could avoid taking unnecessary faults there.

Probably doesn't really matter. 

			Linus
