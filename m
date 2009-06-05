Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZFEDRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZFEDRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFEDRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:17:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZFEDRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:17:38 -0400
Date: Thu, 4 Jun 2009 20:17:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-Id: <20090604201733.746928c6.akpm@linux-foundation.org>
In-Reply-To: <20090605023835.GA7933@cr0.nay.redhat.com>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
	<20090605023835.GA7933@cr0.nay.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 10:38:35 +0800 Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Fri, Jun 05, 2009 at 09:38:04AM +0900, Tetsuo Handa wrote:
> >[2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
> >
> >"make allmodconfig" + "CONFIG_KVM=n" on 2.6.30-rc8 triggers build failure
> >when built with gcc 3.3.5 .
> >
> ># make -s
> >/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/Makefile:82: stack protector enabled but no compiler support
> >WARNING: modpost: Found 2 section mismatch(es).
> >To see full details build your kernel with:
> >'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >arch/x86/mm/built-in.o(.init.text+0x43f7): In function `__change_page_attr':
> >arch/x86/mm/pageattr.c:114: undefined reference to `__udivdi3'
> >make: *** [.tmp_vmlinux1] Error 1
> >
> 
> Probably you are compiling on i386?
> 
> Weird... 
> 
> All the types in __change_page_attr() are either 'long' or 'int', how
> can gcc generate software divide for these integer operations?

It could be in some function which was manually or automatically
inlined into __change_page_attr().  Or it could be that ld simply
screwed up in identifying the function - it tends to do that.

Do

	make arch/x86/mm/pageattr.s

then have a look in pageattr.s to find the __udivdi3 callsite.

It might not even be in arch/x86/mm/pageattr.o at all.  If not, keep
building .s files in that directory until you find it.

Building with CONFIG_DEBUG_INFO=1 will allow you to find the exact C
file-n-line where the __udivdi3() call is being emmitted (look at the
.loc lines).

