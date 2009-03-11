Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZCKPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZCKPui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZCKPu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:50:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56509 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZCKPu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:50:28 -0400
Date: Wed, 11 Mar 2009 08:50:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Dmitriy V'jukov" <dvyukov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RCU: Number of grace-periods
Message-ID: <20090311155024.GB7086@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <loom.20090311T104939-544@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20090311T104939-544@post.gmane.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:58:41AM +0000, Dmitriy V'jukov wrote:
> In the article "The design of preemptible read-copy-update":
> http://lwn.net/Articles/253651
> 
> Paul McKenney explains why number of grace periods before executing callbacks is
> set to 2:
> #define GP_STAGES 2
> 
> There are following statements in the reasoning:
> "Note that because rcu_read_lock() does not contain any memory barriers, the
> contents of the critical section might be executed early by the CPU"
> and:
> "However, because rcu_read_unlock() contains no memory barriers, the contents of
> the corresponding RCU read-side critical section (possibly including a reference
> to the item deleted by CPU 0) can be executed late by CPU 1"
> 
> But on some architectures (IA-32, Intel 64, SPARC TSO) acquire and release
> fences are implied with every load/store (read - costless), so isn't it possible
> to reduce the number of required grace periods before executing callbacks on
> these architectures?
> I.e. something like:
> #ifdef ACQUIRE_RELEASE_FENCES_ARE_IMPLIED_ON_ARCH // defined for x86 etc
> #define GP_STAGES 1
> #else
> #define GP_STAGES 2
> #endif
> Have someone considered such variant? Is it worth doing?
> Thank you.

Interesting thought -- but please keep in mind that acquire/release fences
still allow subsequent stores to be reordered to precede earlier loads.
This means that the first loads in the RCU critical section could be
reordered to precede the final store of the rcu_read_lock() primitive.
My guess is there would be some resistance to the new #define, but if
there were enough uses, perhaps such resistence could be overcome.

So, have you tried running this through Relacy?  If so, what happened?

							Thanx, Paul
