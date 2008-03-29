Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYC2Ax7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYC2Ax7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYC2Axt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:53:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYC2Axs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:53:48 -0400
Date: Fri, 28 Mar 2008 17:53:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
In-Reply-To: <20080329001341.7F93826FA1D@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
References: <20080329001230.D013726FA1D@magilla.localdomain> <20080329001341.7F93826FA1D@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Roland McGrath wrote:
>
> Set TIF_SIGPENDING in set_restore_sigmask.  This lets arch code take
> TIF_RESTORE_SIGMASK out of the set of bits that will be noticed on
> return to user mode.  On some machines those bits are scarce, and we
> can free this unneeded one up for other uses.

Hmm. That probably means that TIF_RESTORE_SIGMASK shouldn't be a "TIF" 
flag at all, but a "TS" ("thread status") flag.

The TS flags are faster, because they are thread-synchronous and do not 
need atomic accesses (ie they are purely thread-local in setting, testing 
and clearing).

Of course, it may well not be worth it. Unlike the TIF flags, the TS flags 
have been architecture-specific and I don't think all architectures even 
do them (x86 uses them for FP state bits and stuff like that).

I guess TIF_RESTORE_SIGMASK is never *so* performance-critical that we'd 
care about the difference between a single cycle (approx) for a non-atomic 
"or" into memory and an atomic bitop (~50 cycles or so). 

			Linus
