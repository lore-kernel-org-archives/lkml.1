Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZKYMc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZKYMc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbZKYMc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:32:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:59370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725AbZKYMcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:32:25 -0500
Message-ID: <4B0D23A6.8040902@kernel.org>
Date: Wed, 25 Nov 2009 21:31:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: percpu tree build warning
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <20091125105004.GA18163@elte.hu>
In-Reply-To: <20091125105004.GA18163@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/25/2009 07:50 PM, Ingo Molnar wrote:
> Tejun, is it perhaps a problem of the percpu code getting confused 
> between the local and file scope 'dr7' variable shadowing each other?

Yes.

> If yes then that needs to be fixed in the percpu tree. per-cpu variables 
> used to have a __per_cpu prefix and that should be maintained - the two 
> namespaces are obviously separate on the logical space, so they should 
> never overlap in the implementational space either.

If all we ever have are static variables, the prefix may be fine but
with dynamic percpu variables now basically being the same first class
citizen but prefix just doesn't cut it.  It just ends up adding more
confusion.  The transition will be a bit painful (but not too much,
how many of these reports have we had?  Only several) but after that
it's just plain local/global symbol collision the compiler would have
no problem warning about.  It behaves exactly like other global
symbols.

Percpu symbols and variables belong to a different address space than
normal symbols.  Unfortunately, C doesn't have support for such thing.
Prefixing kind of works but simply breaks when the addresses are
allowed to be handled as values.  We have had the exactly same problem
and solution for years now - iomem.  Percpu memory isn't different
from iomem at all.  Once the conversion is complete and annotations
and code are upstream, it won't be painful at all.

Thanks.

-- 
tejun
