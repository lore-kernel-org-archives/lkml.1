Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYKGCaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYKGCaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYKGC35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:29:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37024 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYKGC35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:29:57 -0500
Message-ID: <4913A7B2.9000609@redhat.com>
Date: Fri, 07 Nov 2008 11:28:02 +0900
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: h-shimamoto@ct.jp.nec.com, ananth@in.ibm.com, laijs@cn.fujitsu.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: bugfix: try_module_get even if calling_mod is
 NULL
References: <490FE405.1000105@cn.fujitsu.com>	<4910F697.2050203@redhat.com>	<4910FB3D.4020805@cn.fujitsu.com>	<491212C0.4030900@redhat.com>	<4912222F.9040605@ct.jp.nec.com>	<49122745.4090004@redhat.com>	<49123521.6020608@redhat.com> <20081106170023.d5349c42.akpm@linux-foundation.org>
In-Reply-To: <20081106170023.d5349c42.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I do not understand this description "Get probed module even if the
> caller is in the kernel core code".
> 
> What bug is being fixed here?  What is the kernel behaviour before and
> after the patch?

When someone called register_*probe() from kernel-core code(not from
module) and that probes a kernel module, users can remove the probed
module because kprobe doesn't increment reference counter of the module.
(on the other hand, if the kernel-module calls register_*probe,
kprobe increments refcount of the probed module.)

Currently, we have no register_*probe() calling from kernel-core(except
smoke-test, but the smoke-test doesn't probe module), so there is no
real bugs. But the logic is wrong(or not fair) and it can causes a
problem when someone might want to probe module from kernel.

After this patch is applied, even if someone put register_*probe() call
in the kernel-core code, it increments the reference counter of the
probed module, and it prevents user to remove the module until stopping
probing it.

> Was the bug present in 2.6.27, 2.6.26 etc?  Or was it a post-2.6.28
> regression?

Hmm, it might be an enhancement, because currently the kernel doesn't
have real bugs.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

