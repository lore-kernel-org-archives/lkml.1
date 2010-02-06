Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0BFAnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:43:17 -0500
Received: from ozlabs.org ([203.10.76.45]:38677 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab0BFAnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:43:16 -0500
From: Michael Neuling <mikey@neuling.org>
To: anton@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Serge Hallyn <serue@us.ibm.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org
cc: miltonm@bga.com
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: Stack size protection broken on ppc64
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sat, 06 Feb 2010 11:43:13 +1100
Message-ID: <3984.1265416993@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent ppc64 kernels, limiting the stack (using 'ulimit -s blah') is
now more restrictive than it was before.  On 2.6.31 with 4k pages I
could run 'ulimit -s 16; /usr/bin/test' without a problem.  Now with
mainline, even 'ulimit -s 64; /usr/bin/test' gets killed.

Using 64k pages is even worse.  I can't even run '/bin/ls' with a 1MB
stack (ulimit -s 1024; /bin/ls).  Hence, it seems new kernels are too
restrictive, rather than the old kernels being too liberal.

I've not tested with any other architectures.  

Bisecting, I found that this is the culprit (which is in 2.6.32)

  commit fc63cf237078c86214abcb2ee9926d8ad289da9b
  Author: Anton Blanchard <anton@samba.org>
  exec:   setup_arg_pages() fails to return errors

Looking at the patch, it's probably just unmasking a preexisting issue.
The error path for expand_stack() (and others) was modified to:
---
	ret = expand_stack(vma, stack_base);
	if (ret)
		ret = -EFAULT;

out_unlock:
	up_write(&mm->mmap_sem);
-       return 0;
+       return ret;
 }
 EXPORT_SYMBOL(setup_arg_pages);
---

So previously expand_stack errors were not returned correctly by
setup_arg_pages, but now they are.

Any clues how to fix this?

Mikey
