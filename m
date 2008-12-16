Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbYLPUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbYLPUgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYLPUg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:36:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbYLPUg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:36:29 -0500
Date: Tue, 16 Dec 2008 12:35:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Brice Goglin <Brice.Goglin@inria.fr>,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>
Subject: Re: mm: Don't touch uninitialized variable in
 do_pages_stat_array()
In-Reply-To: <1229456821.20606.19.camel@localhost>
Message-ID: <alpine.LFD.2.00.0812161231500.14014@localhost.localdomain>
References: <200812161859.mBGIx1kR018513@hera.kernel.org> <1229456821.20606.19.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Dec 2008, Joe Perches wrote:
> 
> Perhaps this is more legible and avoids
> the unnecessary assignments to err.

Not only is it less legible to me, but the "unnecessary" assignments are 
the ones that make the flow control much simpler.

I think it's a _lot_ easier to read

	retval = BADNESS;
	if (something bad)
		goto out;

than it is to make the insides of the conditional more complex. It also 
tends to generate better code, although gcc's code movement often makes it 
not matter (and equally often makes a mess of it). That's because a 

	if (something)
		goto somewhere;

is actually how the CPU itself ends up executing things, while a

	if (something) {
		retval = something;
		goto somewhere;
	}

actually ends up becoming 

	if (!someting)
		goto over;
	retval = something;
	goto somewhere;
   over:

by the time the CPU actually has to execute it.

			Linus
