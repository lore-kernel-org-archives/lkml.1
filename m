Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYIKEYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYIKEYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYIKEYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:24:16 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51855 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYIKEYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:24:15 -0400
Message-ID: <48C89D7D.3070105@in.ibm.com>
Date: Thu, 11 Sep 2008 09:54:29 +0530
From: Srinivasa DS <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>
Subject: [RFC] Some Interesting one liner systemtap scripts
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am listing out some interesting one line systemtap scripts which can be
of handy use for kernel developers. These scripts can be reused to probe other
functions by modifying the function name.

If you have ideas/suggestions to improve these or create more such one
liner scripts, please let me know.


1) Script to display the backtrace from a given kernel function.

stap  -e 'probe kernel.function("generic_make_request") { print_backtrace() }'


Output looks like:
   0xffffffff8030a614 : generic_make_request+0x1/0x345 [kernel]
   0xffffffff8030bc0e : submit_bio+0xc8/0xcf [kernel]
   0xffffffff802ace12 : submit_bh+0xdc/0xfc [kernel] )
   0xffffffff802ae7ea : __block_write_full_page+0x1c2/0x2b6 [kernel]
   0xffffffff802b209d : blkdev_get_block+0x0/0x46 [kernel]
   ......................................................

2) Script to display the backtrace from a given kernel function, without the help of debug information.

stap --kmap=/proc/kallsyms  -e 'probe kernel.function("generic_make_request") { print_backtrace() }'

Output looks like:
   0xffffffff8030a614 : generic_make_request+0x1/0x345 [kernel]
   0xffffffff8030bc0e : submit_bio+0xc8/0xcf [kernel]
   0xffffffff802ace12 : submit_bh+0xdc/0xfc [kernel] )
   0xffffffff802ae7ea : __block_write_full_page+0x1c2/0x2b6 [kernel]
   0xffffffff802b209d : blkdev_get_block+0x0/0x46 [kernel]
   ......................................................

3) Script to display parameters and local variables of a given kernel function

stap -e 'probe kernel.function("vfs_read") { printf("%s \n", $$vars)}'

Output looks like:
   file=0xffff81003b570300 buf=0x41afc0e0 count=0x20000 pos=0xffff810068095f50 ret=?
   file=0xffff81003b570300 buf=0x41afc0e0 count=0x20000 pos=0xffff810068095f50 ret=?

4) Script to display return value of a given kernel function

stap -e 'probe kernel.function("vfs_read").return { printf("ret=%x \n",$return ) }'

Output looks like:
   ret=189
   ret=10
   ret=8

5) Script to display local variable of given function at a given line number

stap  -e 'probe kernel.statement("__dentry_open@fs/open.c:772")  { printf("%s \n",$$locals) }'

Output looks like:
   inode=0xffff81007e0ff118 error=0x0
   inode=0xffff81007e0f3d18 error=0x0
   inode=0xffff81007e0f3d18 error=0x0
   inode=0xffff81007dc5ba18 error=0x0
   inode=0xffff81007d575418 error=0x0

6) Script to view how values of local variables varies in a given function

stap  -e 'probe kernel.statement("copy_strings@fs/exec.c:*")  { printf("%s %s \n",$$locals, pp()) }'

Output Looks like:
   kmapped_page=0xffffe200005faec0 kaddr=0xffff81001b568000 kpos=0x7fffffffe000 ret=?  kernel.statement("copy_strings@fs/exec.c:412")
   kmapped_page=0xffffe200005faec0 kaddr=0xffff81001b568000 kpos=0x7fffffffe000 ret=?  kernel.statement("copy_strings@fs/exec.c:418")
   kmapped_page=0xffffe200005faec0 kaddr=0xffff81001b568000 kpos=0x7fffffffe000 ret=?  kernel.statement("copy_strings@fs/exec.c:419")
   kmapped_page=0xffffe200005faec0 kaddr=0xffff81001b568000 kpos=0x7fffffffe000 ret=?  kernel.statement("copy_strings@fs/exec.c:420")
   kmapped_page=0xffffe200005faec0 kaddr=0xffff81001b568000 kpos=0x7fffffffe000 ret=?  kernel.statement("copy_strings@fs/exec.c:422")


Thanks
   Srinivasa DS


