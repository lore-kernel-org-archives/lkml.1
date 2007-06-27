Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXF0MdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXF0MdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbXF0MdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:33:12 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:2775 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbXF0MdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:33:11 -0400
Date: Wed, 27 Jun 2007 13:32:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGRhdmlkZWxAeG1haWxzZXJ2ZXIub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZHJlcHBlckBnbWFpbC5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Ulrich Drepper wrote:
> On 6/26/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > OTOH glibc could implement __morecore using mmap(MAP_NOZERO), and hence
> > brk2() would not be needed, no?
> 
> No.  mmap calls create individual VMAs which gets expensive.  There
> are also some hardware drivers which get more expensive the more VMAs
> there are.  I want to go away as much as possible from mmap for
> malloc.

Not so: if an mmap can be done by extending either adjacent vma (prot
and flags and file and offset all match up), that's what's done and no
separate vma is created.  (And adjacent vmas get merged when mprotect
removes the difference in protection.)

I don't think there's any such reason to prefer brk to mmap.  But you
may have encountered something which we in the kernel are thinking of
as an insignificant corner case, which is actually breaking things up
badly in practice (I recall the kernel's internal VM_ACCOUNT flag,
relating to non-overcommit accounting, which might get turned on at
any time, sometimes preventing a vma merge you'd otherwise expect).
Please let me know if you've a test case which shows more vmas than
expected.

Hugh
