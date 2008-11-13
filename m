Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYKMOx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYKMOx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYKMOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:53:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYKMOxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:53:39 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
From: Andi Kleen <andi@firstfloor.org>
References: <491B4F0A.3080901@gmail.com>
Date: Thu, 13 Nov 2008 15:53:35 +0100
In-Reply-To: <491B4F0A.3080901@gmail.com> (Frederic Weisbecker's message of "Wed, 12 Nov 2008 22:47:54 +0100")
Message-ID: <87od0jd6ds.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:
O

> _ The only race could happen between the current thread and an interrupt. If an
>   interrupt is raised, it will increase the index of the return stack storage and
>   then execute until the end of the tracing to finally free the index it used.
>   We don't need to disable irqs.
>
> This is theorical. In practice, I've tested it with a two-core SMP and had no
> problem at all. Perhaps -tip testing could confirm it.

The problem I think is that you assume the ++ is atomic against
interrupts, which is not guaranteed by the C compiler. e.g.
it would be perfectly legal for the compiler to generate code like

local register i
i = index;
write to index'ed array using i
                            <--------- interrupt here would overwrite data
...
index = i + 1;

You would need to convert the index access to a "local_add_return()" and 
possibly also add memory barriers.

-Andi

-- 
ak@linux.intel.com
