Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbXIJXya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbXIJXya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXIJXyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:54:23 -0400
Received: from ozlabs.org ([203.10.76.45]:40909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXIJXyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:54:22 -0400
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module
	Mutex
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20070908072811.GB1819@martell.zuzino.mipt.ru>
References: <20070906200228.086651361@polymtl.ca>
	 <20070906200314.079453533@polymtl.ca>
	 <20070908072811.GB1819@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 09:53:34 +1000
Message-Id: <1189468414.8023.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 11:28 +0400, Alexey Dobriyan wrote:
> On Thu, Sep 06, 2007 at 04:02:29PM -0400, Mathieu Desnoyers wrote:
> > Remove "static" from module_mutex and the modules list so it can be used by
> > other builtin objects in the kernel. Otherwise, every code depending on the
> > module list would have to be put in kernel/module.c. Since the immediate values
> > depends on the module list but can be considered as logically different, it
> > makes sense to implement them in their own file.

If I understand this code correctly, then changing immediate values
needs some exclusion to avoid patching live code.  You leave this to the
user with some very unclear rules.

The result is a real mess that has nothing to do with the module mutex
and list.  These patches need a lot more work 8(

1) The immediate types are just kind of silly.  See per-cpu for how it
handles this already.  DECLARE_IMMEDIATE(type, var) is probably enough.

2) immediate_if() needs an implementation before you introduce it.  Your
assumption that it's always unlikely seems non-orthogonal.

3) immediate_set(), _immediate_set() and immediate_set_early()?  No
thanks!  AFAICT you really want an "init_immediate(var, val)".  This
means "you can patch all the references now, they're not executing".
Later on we could possibly have a super-stop-machine version which
ensures noone's preempted and handles the concurrent case.  Maybe.

4) With an "init" interface not a "set" interface, you don't need
locking.  Simpler.

Hope that helps,
Rusty.


