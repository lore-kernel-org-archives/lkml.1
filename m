Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZBKOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZBKOmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZBKOlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:41:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:35054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbZBKOly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:41:54 -0500
Message-ID: <4992E396.6000205@kernel.org>
Date: Wed, 11 Feb 2009 23:41:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 	it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>	 <4992812B.1050800@kernel.org> <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com>
In-Reply-To: <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 14:41:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
>> Here and at other places where the function takes more than one
>> arguments, wouldn't it be better to just take *regs and use other
>> parameters from regs?  That way we won't have to worry about gcc
>> corrupting register frame at all and I think it's cleaner that way.
> 
> Expanding the parameters is good documentation.

Copying from ptregs to appropriately named local variable would
provide at least similar level of documentation but I don't think this
is a big deal one way or the other.

> If there is a risk of tail-call optimization causing the register
> corruption, then asmlinkage_protect() should be used.  The problem
> isn't limited to just the syscalls that take pt_regs.  It's just
> getting the args out of the pt_regs struct was an easy hack to get
> around it.

If pt_regs is being passed with regparm(1) and no other parameter is
specified, it's a proper solution as we can guarantee that callee
can't corrupt (or discard changes to) the register frame no matter
what gcc does.

> I checked the disassembly of these functions and didn't see this
> happen on gcc 4.3.0.

Well, tracking down why run_init_process() is returning 0 with
-fstack-protector wasn't much of fun.  These breakages are very subtle
and if we're gonna pass in pointer to pt_regs anyway and thus can
guarantee such breakage can't happen at no additional cost, I think we
should do that even if it means slightly more argument fetching in a
few places.

Thanks.

-- 
tejun
