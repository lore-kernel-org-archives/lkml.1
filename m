Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYI3PmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYI3PmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYI3Plw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:41:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752124AbYI3Plv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:41:51 -0400
Message-ID: <48E248CB.5080305@sgi.com>
Date: Tue, 30 Sep 2008 08:42:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] cpumask: Provide new cpumask API
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <20080929180250.825653000@polaris-admin.engr.sgi.com> <20080930091140.GB27452@elte.hu>
In-Reply-To: <20080930091140.GB27452@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>     /* replaces cpumask_t dst = (cpumask_t)src */
>>     void cpus_copy(cpumask_t dst, const cpumask_t src);
> 
> minor namespace nit i noticed while looking at actual usage of 
> cpus_copy(): could you please rename it cpumask_set(dst, src)?
> 
> That streamlines it to have the same naming concept as atomic_set(), 
> node_set(), zero_fd_set(), etc.

Cpus_copy came from it's underlying function: bits_copy().  Cpumask_set
would deviate from the current naming convention of cpu_XXX for single
cpu ops and cpus_XXX for all cpus ops.  Do we want that?

> 
> the patch-set looks quite nice otherwise already, the changes are 
> straightforward and the end result already looks a lot more maintainable 
> and not fragile at all.

I was hoping for a stronger compiler error to indicate incorrect usage,
it currently just says "may be used before it's initialized" if you mistakenly
have cpumask_t as the local variable declaration.  I'm testing it now.

> 
> In what way will Rusty's changes differ? Since you incorporate some of 
> Rusty's changes already, could you please iterate towards a single 
> patchset which we could then start testing?

Our timezones are not very conducive to a lot of email exchanges (and he's moving.)
>From what I've seen I believe he's leaning towards using struct cpumask * and
less trickery than I have.

The other alternative that is very easy to implement with the new code is
using a simple unsigned long list for cpumask_t (as Linus first suggested):

	typedef unsigned long cpumask_var_t[1];	/* small NR_CPUS */
	typedef unsigned long *cpumask_var_t;	/* large NR_CPUS */

This simplifies things quite a bit and I can get rid of some trickery (and
it's a pointer already without having to invent a pointer to a struct.)  The
downside is arrays of cpumask_t's are less clean, but doable.  The best thing
about the changes in this patchset is the context of the cpumask is more well
known, and changes to the underlying type for cpumask are confined to only a
few files (cpumask.h, lib/cpumask.c, etc.)

Thanks,
Mike
