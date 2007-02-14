Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXBNIOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXBNIOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbXBNIOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:14:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42818 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbXBNIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:14:17 -0500
Message-ID: <45D2C4D1.4030809@np.css.fujitsu.com>
Date: Wed, 14 Feb 2007 17:14:09 +0900
From: shic <shic@np.css.fujitsu.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: A problem with the load_elf_interp() in fs/binfmt_elf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,All

When I did some NFS mount operations, I found a problem with the load_elf_interp() in the fs/binfmt_elf. 

I mounted a number of NFS, after lots of continuous mount operations, the fatal error "Segmentation fault" happened with the mount.nfs4, as the count of the mount operations reached about 1000~3000.

Using the strace, I found the mount.nfs4 fails just at the execve().The strace log is as follows.
execve("/sbin/mount.nfs4", ["mount.nfs4", "192.168.236.8:/", "/mnt/nfspt/num_mount_014847/nfs-"...], [/* 24 vars */]) = -1 EINVAL (Invalid argument)
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++

I have investigate it, and found the problem exists in the load_elf_interp() when the "Segmentation fault" happened.

When the mount.nfs4 is executed, the execve() in the kernel is invoked as follows.  
 sys_execve
  | - 
  do_execve
       |
       | - search_binary_handler   
            |-  linux_binfmt= elf_format
            |-  
            |- elf_format-> load_elf_binary
                 | -  elf_entry = load_elf_interp()
                     |-    
                     |  if  (BAD_ADDR(elf_entry)) 
                     |  force_sig(SIGSEGV, 
                     |     retval =-EINVAL;

In the do_execve(), after setting up some data structure, the do_execve() will invoke the search_binary_handler() to get the corresponding ELF binary loader for the mount.nfs4, and read the ELF executable image into memory.
In my test, when the "segment fault" of mount.nfs4 happened, in the procedure of load_elf_binary(),the address elf_entry of the interp segment read from the load_elf_interp() was judged a BAD_ADDR and afterwards the kernel send a forcible signal "SIGSEGV" to the process of mount.nfs4, and exit with the retval "EINVAL".
After I debug the kernel, I have found the cause is the address map_addr in the load_elf_interp(). 
When the problem happens, the map_addr returned from the elf_map() is judged a valid address by BAD_ADDR() in load_elf_interp() , but unluckily the address elf_entry returned by  "map_addr - ELF_PAGESTART(eppnt->p_vaddr)" is judged an invalid address by BAD_ADDR(), then the problem happens in the load_elf_binary().

By now, I've still not got a good method to resolve this problem in the load_elf_interp().
Any good ideas?

Thanks.

Best Regards.
Shi Chao









