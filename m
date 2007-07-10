Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXGJToA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXGJToA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXGJTnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:43:43 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:3848 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbXGJTnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:43:42 -0400
Date: Tue, 10 Jul 2007 20:42:59 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dave McCracken <dave.mccracken@oracle.com>
cc: herbert.van.den.bergh@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] include private data mappings in RLIMIT_DATA limit
In-Reply-To: <200707101412.19785.dave.mccracken@oracle.com>
Message-ID: <Pine.LNX.4.64.0707102030150.2063@blonde.wat.veritas.com>
References: <4692D616.4010004@oracle.com> <200707101219.29743.dave.mccracken@oracle.com>
 <Pine.LNX.4.64.0707101857310.20758@blonde.wat.veritas.com>
 <200707101412.19785.dave.mccracken@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZGF2ZS5tY2NyYWNrZW5Ab3JhY2xlLmNvbQBoZXJiZXJ0LnZhbi5kZW4uYmVyZ2hAb3JhY2xlLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Dave McCracken wrote:
> On Tuesday 10 July 2007, Hugh Dickins wrote:
> >
> > Mapped private readonly yes, but vm_stat_account() says
> > 	if (file) {
> > 		mm->shared_vm += pages;
> > 		if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
> > 			mm->exec_vm += pages;
> 
> In that code shared_vm includes everything that's mmap()ed, including private 
> mappings.  But if you look at Herbert's patch he has the following change:
> 
>         if (file) {
> -               mm->shared_vm += pages;
> +               if (flags & VM_SHARED)
> +                       mm->shared_vm += pages;
>                 if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
>                         mm->exec_vm += pages;
> 
> This means that shared_vm now is truly only memory that's mapped VM_SHARED and 
> does not include VM_EXEC memory.  That necessitates the separate subtraction 
> of exec_vm in the data calculations.

Ah, I just noticed at the beginning of the patch, and didn't look for
a balancing change - thanks.  I'd strongly recommend that he not mess
around with these numbers, unless there's _very_ good reason: they're
not ideal, nothing ever will be, changing them around just causes pain.
shared_vm may not be a full description of what it counts, but it'll
do until you've a better name (readonly mappings share with the file
even when they're private).

Hugh
