Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZIBJsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZIBJsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZIBJsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:48:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZIBJsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:48:35 -0400
Date: Wed, 2 Sep 2009 11:48:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Paul McKenney <paulmck@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: tree rcu: call_rcu scalability problem?
Message-ID: <20090902094835.GB12251@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I'm testing out scalability of some vfs code paths, and I'm seeing
a problem with call_rcu. This is a 2s8c opteron system, so nothing
crazy.

I'll show you the profile results for 1-8 threads:

1:
 29768 total                                      0.0076
 15550 default_idle                              48.5938
  1340 __d_lookup                                 3.6413
   954 __link_path_walk                           0.2559
   816 system_call_after_swapgs                   8.0792
   680 kmem_cache_alloc                           1.4167
   669 dput                                       1.1946
   591 __call_rcu                                 2.0521

2:
 56733 total                                      0.0145
 20074 default_idle                              62.7313
  3075 __call_rcu                                10.6771
  2650 __d_lookup                                 7.2011
  2019 dput                                       3.6054

4:
 98889 total                                      0.0253
 21759 default_idle                              67.9969
 10994 __call_rcu                                38.1736
  5185 __d_lookup                                14.0897
  4475 dput                                       7.9911

8:
170391 total                                      0.0437
 31815 __call_rcu                               110.4688
 12958 dput                                      23.1393
 10417 __d_lookup                                28.3071

Of course there are other scalability factors involved too, but
__call_rcu is taking 54 times more CPU to do 8 times the amount
of work from 1-8 threads, or a factor of 6.7 slowdown.

This is with tree RCU.

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set

Testing classic RCU showed its call_rcu seemed to scale better, only
getting up to about 10 000 at 8 threads.

You'd need my vfs scalability patches to reproduce this exactly, but
the workload is just close(open(fd)), which rcu frees a lot of file
structs. I can certainly get more detailed profiles or test patches
for you though if you have any ideas.

Thanks,
Nick

