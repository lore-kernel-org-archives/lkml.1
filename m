Return-Path: <linux-kernel-owner+w=401wt.eu-S934121AbYD3VDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbYD3VDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbYD3VDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:03:10 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1573 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760053AbYD3VDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:03:09 -0400
Subject: Re: [patch 0/3] dynamic_printk: new feature
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <20080430124506.0dd2a473.akpm@linux-foundation.org>
References: <20080429183935.GA8717@redhat.com>
	 <20080430124506.0dd2a473.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 13:54:26 -0700
Message-Id: <1209588866.5041.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 12:45 -0700, Andrew Morton wrote: 
> Have you taken a look across the tree with a view to converting some of
> them?  If so, how sizeable/messy/feasible would that task be?

I've done that.
There have been many attempts at this.

http://lkml.org/lkml/2007/9/22/110
http://lkml.org/lkml/2007/9/27/274

It's not particularly difficult.
It's just a few scripts and some message massaging.
It's also a lot of what some call unnecessary churn.
I think it useful though.

I also have scripts to remove file/function/line numbers
from messages and use a generic method to integrate and
optionally display them via pr_<level>.

akin to:

#define pr_info(fmt, arg...) \
do { \
	char prefix[MAX_PREFIX_LEN]; \
	if (pr_enabled(prefix, sizeof(prefix), PR_INFO)) { \
		printk("%s" fmt, prefix, ##arg); \
	} \
} while (0)

where pr_enabled optionally formats KBUILD_MODNAME/__func__/__LINE__
and of course <level> to prefix with appropriate
CONFIG_PR_USE_MODNAME/FUNCTION/LINE controls for
embedded size minimization when kallsyms is not
available.

pr_enabled can also be #defined to 0 to eliminate
the strings and printk calls.

> - Your design handles a boolean on/off control.  But some code implements
>   a verbosity-level control.  Thoughts on this?

It seems there is still resistance to even ethtool style
msglevel.

Extending Jason's approach to test a module message level
seems simple enough and could/should be universal.

I think that message rate limiting should also be done here.
Also I think this facility would help in localization.

> But we will need to design it carefully first.

Agreed.  The "useless churn!" cries need also to be ignored
or at least damped down.

I'd also like to consider including mechanisms to
consolidate what are now consecutive calls to printk
to print partial lines into block start/end calls.
Perhaps pr_start, pr_cont, pr_end.

These calls should never fail under memory pressure.

Vegard Nossum had what I think is a good idea to
include a pointer to a printk reassembly buffer
in struct task_struct.

That could remove the need to pass round a pointer
when using block style printk calls.  

> I guess one good testcase would be ALSA.  It has pretty fancy debugging
> control (which I apparently have never been smart enough to understand). 
> Did you take a look at what they're doing, with a view to
> can-we-switch-ALSA-to-use-this?

If you're referring to include/sound/core.h, it seems simple enough.

Would it be accepted though?

