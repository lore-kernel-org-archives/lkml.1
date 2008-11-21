Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYKUUUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYKUUUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYKUUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:20:11 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51535 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbYKUUUK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:20:10 -0500
Date: Fri, 21 Nov 2008 15:19:21 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Nikanth Karthikesan <knikanth@suse.de>
cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, davem@davemloft.net,
       mhiramat@redhat.com, contact@ksplice.com, jbarnold@ksplice.com,
       tabbott@ksplice.com, wdaher@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
In-Reply-To: <200811211720.26394.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0811211306000.1505@vinegar-pot.mit.edu>
References: <200811211720.26394.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Nikanth Karthikesan wrote:
> When looking for a shortcut to avoid the rebuild/reboot cycle when 
> hacking the kernel - the ksplice[1] was posted. This patch extends 
> kprobes to do something similar, which would require even lesser time to 
> _experiment_ with the running kernel.

Maybe we haven’t done a good job of explaining just how quickly you can 
use Ksplice for rapid experimentation.  Using the Ksplice utilities 
<http://www.ksplice.com/software>, you can write a 5-line patch today that 
does the same experiment as your 42-line kreplace example, without using 
unsafe hacks:

$ cat example.patch
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -488,6 +488,11 @@

 int attempt_back_merge(struct request_queue *q, struct request *rq)
 {
+	static int count = 0;
+	count++;
+	if (count % 50 == 0)
+		printk("attempt_back_merge called another 50 times\n");
+	return 0;
 	struct request *next = elv_latter_request(q, rq);

 	if (next)
$ ksplice-create -j4 --patch=example.patch linux-2.6/
Ksplice update tarball written to ksplice-sxk9pvow.tar.gz
$ sudo ksplice-apply ksplice-sxk9pvow.tar.gz
Done!
$ sudo ksplice-undo sxk9pvow

Assuming the kernel source tree has been prepared for Ksplice (e.g. if you 
have used Ksplice before), it takes as little as 35 seconds to compile the 
Ksplice update and a fraction of a second to apply it.  The running kernel 
does not need to have been specially prepared or patched.

> This small patch extends jprobes so that the jprobe's handler is 
> executed but skips executing the actual function. But this has its own 
> limitations such as Cannot access symbols not exported for modules 
> (ofcourse hacks like pointers[2] can be used.), problems related to 
> return values[3], etc... This is currently a x86_64 only _hack_.

An even more fundamental limitation of kprobes/jprobes is that it cannot 
hook functions that have been inlined (or partially inlined) by the 
compiler, because the compiler only writes mcount() calls at the beginning 
of function bodies after inlining has been performed.  (Note that at least 
20% of functions in the kernel that don’t have an explicit inline keyword 
get inlined anyway.)

This problem, and others such as the ambiguous symbol name problem (see 
<http://www.ksplice.com/paper>), mean that jprobes doesn’t work well for 
much more than gathering statistics and debugging, which is what it was 
designed for.  Building hot updates with jprobes makes for a cute jprobes 
example, but let’s be clear: it isn’t nearly robust enough for security 
patches or telecom/enterprise use.

Ksplice solves all of these problems, and additionally includes extensive 
safety checks (run-pre matching, kernel stack checking, update dependency 
tracking) to avoid a wide range of dangerous situations, which would 
commonly cause a simplistic hot update system to corrupt the running 
kernel.

Anders
