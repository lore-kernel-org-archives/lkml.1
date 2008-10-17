Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYJQIdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYJQIdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYJQIcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:32:51 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:45905 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYJQIcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:32:50 -0400
Message-ID: <48F84DAB.4060002@nttdata.co.jp>
Date: Fri, 17 Oct 2008 17:32:43 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       akpm@linux-foundation.org
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp> <20081009164836.GA5480@us.ibm.com> <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp> <20081015012916.GF6874@linux.vnet.ibm.com> <48F6BD8E.4050402@nttdata.co.jp> <20081016151003.GA6772@linux.vnet.ibm.com>
In-Reply-To: <20081016151003.GA6772@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2008 08:32:44.0368 (UTC) FILETIME=[ED404500:01C93032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting from http://lkml.org/lkml/2008/2/2/255
> Similarly, the smp_read_barrier_depends() is only for initialization
> of something that is about to enter the list.  As with the smp_wmb()
> primitive, smp_read_barrier_depends() also is not to protect against
> freeing.  Instead, it is rcu_read_lock() and rcu_read_unlock() that
> protect against freeing.
We don't need to use rcu_read_lock() and rcu_read_unlock() because 
we don't free elements in a list. I see.

However, to ensure the reader gets up-to-date value, we need to use 
smp_read_barrier_depends() (which is expanded to "mb()" for SMP on 
Alpha, "read_barrier_depends()" for SMP on H8300, "((void)0)" for SMP 
on M68K-nommu, "((void)0)" for M68K, "do { } while (0)" otherwise) 
whenever the reader fetches an element in a list.

Paul E. McKenney wrote:
> But fair enough.  How about the following?
> 
> 	#define worm_dereference()	rcu_dereference()
> 	#define worm_assign_pointer()	rcu_assign_pointer()
> 
So, I understood that the rcu_dereference() and rcu_assign_pointer() 
are not only for RCU. They are needed to ensure the reader gets 
up-to-date value. Then, their names should be var_dereference() and 
var_assign_pointer() or something, shouldn't they? The "rcu_" prefix 
and comments on rcu_dereference in include/linux/rcupdate.h sound for 
me that they are used for variables protected by RCU locking 
mechanism only...

You are suggesting to explicitly call rcu_assign_pointer() (which 
will call smp_wmb()) and rcu_dereference() (which will call 
smp_read_barrier_depends()). But I think that the various cache 
invalidations driven by the workload will call rcu_assign_pointer() 
and rcu_dereference() sooner or later. So, if the reader can tolerate 
reading non-up-to-date value (in fact, TOMOYO can), isn't there a 
choice to omit rcu_assign_pointer() and rcu_dereference() (which will 
cost "mb()" for SMP on Alpha)?

Regards,


