Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbYDNP7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbYDNP7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbYDNP7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:59:01 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17268 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbYDNP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:59:00 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
References: <20080411210022.GJ11962@parisc-linux.org>
	<1208003081.7427.7.camel@twins>
	<20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com>
	<20080412204748.GN11962@parisc-linux.org>
	<20080413070833.GC19773@elte.hu>
	<20080413125758.GQ11962@parisc-linux.org>
	<20080414153928.GA22259@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 14 Apr 2008 08:58:54 -0700
In-Reply-To: <20080414153928.GA22259@elte.hu> (Ingo Molnar's message of "Mon,
	14 Apr 2008 17:39:28 +0200")
Message-ID: <adafxtoqvgh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Apr 2008 15:58:55.0358 (UTC) FILETIME=[712BA9E0:01C89E48]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > which ones exactly are these places that demand the use of a counting 
 > semaphore? I cannot think of a single place where it's the best choice, 
 > let alone one where it's the only choice.

Two of the places that use semaphores are drivers/infiniband/hw/mthca
and drivers/net/mlx4 -- in both cases, the device firmware allows up to
"N" outstanding firmware commands to be in flight, and the driver uses a
semaphore to handle issuing firmware commands.  That is, down() when we
want to issue a command, and up() when the firmware responds that the
command is complete.

What would you suggest as a better way to code this?  This is an honest
question -- there probably is a more elegant way to handle this
situation and I really would like to learn about it.

Also, the argument that removing semaphores makes the kernel as a whole
better does make sense to me; I wouldn't be opposed to basically
open-coding semaphores in terms of wait_event() in the driver or
something like that, but I wouldn't say that such an implementation is
locally more readable or maintainable if we look only at the driver
code.

 - R.
