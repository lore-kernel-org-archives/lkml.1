Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbZFCPIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbZFCPIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZFCPIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:08:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036AbZFCPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:08:36 -0400
Date: Wed, 3 Jun 2009 08:07:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
Message-ID: <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com>
 <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Christoph Lameter wrote:
> 
> Ok. So what we need to do is stop this toying around with remapping of
> page 0. The following patch contains a fix and a test program that
> demonstrates the issue.

No, we _need_ to be able to map to address zero.

It may not be very common, but things like vm86 require it - vm86 mode 
always starts at virtual address zero. 

For similar reasons, some other emulation environments will want it too, 
simply because they want to emulate another environment that has an 
address space starting at 0, and don't want to add a base to all address 
calculations.

There are historically even some crazy optimizing compilers that decided 
that they need to be able to optimize accesses of a pointer across a NULL 
pointer check, so that they can turn code like

	if (!ptr)
		return;
	val = ptr->member;

into doing the load early. In order to support that optimization, they 
have a runtime that always maps some garbage at virtual address zero.

(I don't remember who did this, but my dim memory wants to say it was some 
HP-UX compiler. Scheduling loads early can be a big deal on especially 
in-order machines with nonblocking cache accesses).

The point being that we do need to support mmap at zero. Not necessarily 
universally, but it can't be some fixed "we don't allow that".

		Linus
