Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXIDU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXIDU0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXIDU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:26:41 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4337 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbXIDU0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:26:40 -0400
Date: Tue, 4 Sep 2007 16:24:33 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: rusty@rustcorp.com.au, adam@yggdrasil.com, jcm@jonmasters.org,
       kaber@trash.net, netfilter-devel@lists.netfilter.org,
       linux-kernel@vger.kernel.org
Cc: nhorman@tuxdriver.com
Subject: [PATCH 0/2] Fix (improve) deadlock condition on module removal netfilter socket option removal
Message-ID: <20070904202433.GA19083@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	So I've had a deadlock reported to me.  I've found that the sequence of
events goes like this:

1) process A (modprobe) runs to remove ip_tables.ko

2) process B (iptables-restore) runs and calls setsockopt on a netfilter socket,
increasing the ip_tables socket_ops use count

3) process A acquires a file lock on the file ip_tables.ko, calls remove_module
in the kernel, which in turn executes the ip_tables module cleanup routine,
which calls nf_unregister_sockopt

4) nf_unregister_sockopt, seeing that the use count is non-zero, puts the
calling process into uninterruptible sleep, expecting the process using the
socket option code to wake it up when it exits the kernel

4) the user of the socket option code (process B) in do_ipt_get_ctl, calls
ipt_find_table_lock, which in this case calls request_module to load
ip_tables_nat.ko

5) request_module forks a copy of modprobe (process C) to load the module and
blocks until modprobe exits.

6) Process C. forked by request_module process the dependencies of
ip_tables_nat.ko, of which ip_tables.ko is one.

7) Process C attempts to lock the request module and all its dependencies, it
blocks when it attempts to lock ip_tables.ko (which was previously locked in
step 3)

Theres not really any great permanent solution to this that I can see, but I've
developed a two part solution that corrects the problem

Part 1) Modifies the nf_sockopt registration code so that, instead of using a
use counter internal to the nf_sockopt_ops structure, we instead use a pointer
to the registering modules owner to do module reference counting when nf_sockopt
calls a modules set/get routine.  This prevents the deadlock by preventing set 4
from happening.

Part 2) Enhances the modprobe utilty so that by default it preforms non-blocking
remove operations (the same way rmmod does), and add an option to explicity
request blocking operation.  So if you select blocking operation in modprobe you
can still cause the above deadlock, but only if you explicity try (and since
root can do any old stupid thing it would like.... :) ).

The following 2 patches have been tested out by me.

Thanks & Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
