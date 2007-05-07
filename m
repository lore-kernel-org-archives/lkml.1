Return-Path: <linux-kernel-owner+w=401wt.eu-S966278AbXEGTQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966278AbXEGTQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966249AbXEGTQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:16:20 -0400
Received: from holomorphy.com ([66.93.40.71]:33752 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966192AbXEGTQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:16:19 -0400
Date: Mon, 7 May 2007 12:16:58 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] VM: per-user overcommit policy
Message-ID: <20070507191658.GY31925@holomorphy.com>
References: <463F764E.5050009@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463F764E.5050009@users.sourceforge.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 08:56:39PM +0200, Andrea Righi wrote:
> Allow to define per-UID virtual memory overcommit handling. Configuration is
> stored in a hash list in kernel space reachable through /proc/overcommit_uid
> (surely there're better ways to do it, i.e. via configfs).
> Hash elements are defined using a triple:
> uid:overcommit_memory:overcommit_ratio
> The overcommit_* values have the same semantic of their respective sysctl
> variables.
> If a user is not present in the hash, the default system policy will be used
> (defined by /proc/sys/vm/overcommit_memory and /proc/sys/vm/overcommit_ratio).

While I think it's a step in the right direction, I'm not convinced of
the soundness of the approach. I expect one might be better served by
per-user limits on committed memory, perhaps even proportional limits.

The basic idea is that committed memory is a relatively global resource.
You can apportion it and limit the global pool, but it's difficult to
arrange for overall overcommitment policy on a per-anything basis
without some sort of OOM-isolated domains for users and processes to run
within. Those are particularly interesting as they relate to kernel
memory allocations.

The /proc/ interface is probably going to raise a few eyebrows. I'm
unaware of what sorts of interfaces would be recommended for all this.

The following stanza occurs often:
+       if (!vm_acct_get_config(&v, current->uid)) {
+               overcommit_memory = v.overcommit_memory;
+               overcommit_ratio = v.overcommit_ratio;
+       } else {
+               overcommit_memory = sysctl_overcommit_memory;
+               overcommit_ratio = sysctl_overcommit_ratio;
+       }

suggesting that vm_acct_get_config() isn't the proper abstraction.

Instead of
	int vm_acct_get_config(struct vm_acct_values *, uid_t);
you could just have
	int vm_acct_get_config(struct vm_acct_values *);
which conditionally uses current->uid, and then unconditionally use
v.overcommit_memory and v.overcommit_ratio vs. sysctl_overcommit_memory
and sysctl_overcommit_ratio in the sequel.


-- wli
