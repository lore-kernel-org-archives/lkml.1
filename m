Return-Path: <linux-kernel-owner+w=401wt.eu-S2992531AbXDDCxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992531AbXDDCxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992532AbXDDCxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:53:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47340 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992531AbXDDCxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:53:04 -0400
Date: Tue, 3 Apr 2007 19:52:59 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org, ego@in.ibm.com,
       dipankar@in.ibm.com, cpw@sgi.com
Subject: Re: getting processor numbers
Message-Id: <20070403195259.68d53931.pj@sgi.com>
In-Reply-To: <20070403154831.37bde672.akpm@linux-foundation.org>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<4612BB89.8040102@redhat.com>
	<20070403141348.9bcdb13e.akpm@linux-foundation.org>
	<4612D175.30604@redhat.com>
	<20070403154831.37bde672.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> Paul, could you please describe what cpusets' policy is in the presence of
> CPU additional and removal?

Currently, if we remove the last CPU in a cpuset, we give that cpuset
the CPUs of its parent cpuset, in order to ensure that every cpuset
with tasks attached actually has some CPUs they can run on.  See the
routine kernel/cpuset.c:guarantee_online_cpus_mems_in_subtree(), and
kernel/cpuset.c:guarantee_online_cpus(), and close your eyes to the
recursion ... yeah that has to get fixed someday ;).

But Cliff Wickman <cpw@sgi.com> (added to CC) figured out that this was
broken, as it could easily violate the cpu_exclusive property of
cpusets.  He is working on a patch that will move the tasks in the
CPU-deficient cpuset up to their parent cpuset.

In general, the idea is to ensure that every task has at least one CPU
on which it can run.  If the sysadmin intends to unplug all the CPUs
required by some task, he "should" first move those tasks somewhere
else where they can continue to run.  If he doesn't, then the kernel
"makes do", by either (currently) adding CPUs to the CPU-deficient
cpuset, or (future) moving the CPU-deprived tasks somewhere else.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
