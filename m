Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYIHTPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYIHTPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYIHTPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:15:25 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43345 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYIHTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:15:24 -0400
Date: Mon, 8 Sep 2008 20:14:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Rafa=3F_Mi=3Fecki?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
In-Reply-To: <48C55E07.5000406@goop.org>
Message-ID: <Pine.LNX.4.64.0809081956390.23187@blonde.site>
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site>
 <48B80C26.2080002@goop.org> <Pine.LNX.4.64.0809081157020.14401@blonde.site>
 <48C55E07.5000406@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Jeremy Fitzhardinge wrote:
> 
> Well, if we never want the direct map to be non-executable (which I

One too many negatives?

> think would be OK, since all the code is either core kernel or modules
> which are mapped elsewhere),

I had thought so until just before replying.

> then we can set NX on the level4 for the
> linear mapping which will make everything below non-executable.

That would be much the neatest answer: I hadn't realized
that inheritance (perhaps I'm still living in early-i386 days,
when IIRC there was a bug in inheriting WP from higher levels).

But then I stumbled across static_protections() in pageattr.c
(takes both addr and pfn, latter seems weird), whose BIOS_BEGIN
and BIOS_END seem to echo the ISA_START_ADDR and ISA_END_ADDR
used by is_ISA_range() in ioremap.c.

And peering at the pagetables I've got here for that area of the
direct map in 2.6.26 x86_64, yes, I'm missing NX from 0xc0000 to
0xfffff (presumably nothing tried to ioremap 0xa0000 to 0xbffff).

A simple answer might be to go the way you suggest, but remove
the special casing from pageattr.c and ioremap.c; but I fear
that will slow something down, or introduce further bugs.

Hugh
