Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYLWASY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYLWASY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYLWASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:18:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46698 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYLWASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:18:13 -0500
Date: Tue, 23 Dec 2008 01:30:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Brad Campbell <brad@wasp.net.au>,
       Manfred Spraul <manfred@colorfullife.com>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: BUG() in 2.6.28-rc8-git2 under heavy load
Message-ID: <20081223003051.GA26813@one.firstfloor.org>
References: <494F4C50.1070906@wasp.net.au> <19f34abd0812220406i36d5df21ka321e3eb4993c54c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0812220406i36d5df21ka321e3eb4993c54c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. The CPU reported the wrong faulting instruction (seems highly

I remember spending quite some time on a report a few years ago
and in the end decided the CPU in that case was reporting incorrect
fault addresses too. iirc we blamed it on overheating or some
unspecified hardware damage.

> unlikely, since that means it wouldn't be able to resume properly in
> other situations),
> 2. We really were executing at a slightly strange (offset) EIP
> 
> I'm going for #2. But how could it happen? Did the caller supply a
> wrong address in its CALL? It seems unlikely. Why would it happen only
> for this function, four times in a row, at the exact same location?
> Was the caller's code corrupted?

There are a couple of situations: someone corrupted a pointer 
on the stack or in a structure containing function pointers.

On x86-64 there's another trap that if you call a function
that is declared stdargs ... through a prototype that doesn't
contain ... it can also jump to random addresses due to the
way gcc handles stdargs. Normally we have very few stdargs
functions in the kernel so it's unlikely, but I've seen
the problem in userland.

If it's reproducible one way to trace it down would be to enable
LBR (I got some old patches for that that could be adapted), but then 
that would only tell you the caller.

-Andi
-- 
ak@linux.intel.com
