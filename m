Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbXDYXIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbXDYXIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXDYXIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:08:00 -0400
Received: from gw.goop.org ([64.81.55.164]:41443 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbXDYXH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:07:59 -0400
Message-ID: <462FDF6D.8050903@goop.org>
Date: Wed, 25 Apr 2007 16:08:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>	<462FD179.6070802@goop.org> <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> No.  Please just remove the conditionals on the leaf pages.
>   

So, to be specific, you mean make updating the pte_t entries (and pmd_t
entries which refer to hugepages) entries unconditional?

> We know exactly what we require them to be, there is minimal
> cost and no downside to just setting the pte entries to
> what we want them to be for the identity mapping.
>
> It doesn't make sense for paravirtualization or anything else to 
> influence that.
>
> This may be redoing work that has been done before but it is
> doing it all one common place.
>   

The issue is not a matter of avoiding duplicate work, but making sure
all the pagetables are consistent from Xen's perspective.

Specifically, you may not ever, at any time, create a writable mapping
of a page which is currently part of an active pagetable.  This means
that when we're creating mappings of physical memory, the pages which
are part of the current pagetable must be mapped RO.  The easiest way I
found to guarantee that is to copy the Xen-provided pagetable as a
template, and only update pages which are missing.

The other way I could do this is to have special-purpose init-time
version of xen_set_pte which checks to see if it's making a RO mapping
RW, and refuse to do it.  That would minimize the changes to mm/init.c,
but give init-time set_pte rather unexpected hidden semantics.

    J
