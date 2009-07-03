Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZGCRQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZGCRQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZGCRQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:16:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZGCRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:16:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on generic header files for the ABI
Date: Fri, 3 Jul 2009 19:16:26 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-10-generic; KDE/4.2.95; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au,
       John Williams <john.williams@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       John Linn <John.Linn@xilinx.com>
References: <cover.1245345894.git.arnd@arndb.de> <200907021136.07426.arnd@arndb.de> <4A4D9D41.5090006@monstr.eu>
In-Reply-To: <4A4D9D41.5090006@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907031916.26214.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19zvKHAZL8j7VDfipms/gPcTOHZC05G9j1k3tr
 dWfqLBzAewcJeizZhUAeUiS+I1A1Hb8JA2JHgNETlZYXsiWYyt
 7dYj5owVMvpHm7WgwCFbLYED9ZFbHeP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Michal Simek wrote:
> 
> > Initially I had hoped that we could do the change before 2.6.30 and
> > I worked hard on getting the ABI patches to you early enough for
> > that. After that failed, I made sure that you had everything in
> > place for 2.6.31 and I believed that Michal said he would integrate
> > that in the microblaze-mmu merge, before you actually start seeing
> > users on the mainline kernel.
> 
> we are talking about minor change - I know it break ABI a little bit
> but don't be scared with it.

The data structures are all compatible by now, with this one exception.
__kernel_mode_t is easy enough to fix in the generic headers if it
really helps.

My frustration is only about the system call list, which has
not been fixed, and which will cause a significant ABI break
once you change it. If you are lucky, most applications will still
work after you install a matching libc, but you still get a
cross-dependency between libc and the kernel.

This means you may not want to really use the generic syscall numbers,
but at least you should make sure that your table is consistent.
FWIW, below you find a list of inconsistencies.

	Arnd <><

System calls that have a number but are missing an entry in your sys_call_table:

sys_preadv
sys_pwritev
sys_pselect6
sys_ppoll
sys_sigaltstack
sys_migrate_pages /* not needed */
sys_futimesat /* not needed */

System call numbers you might need for binary compatiblily and
should have removed earlier:
__NR_waitpid                                                                                                                                            
__NR_stime                                                                                                                                              
__NR_nice                                                                                                                                               
__NR_oldstat                                                                                                                                            
__NR_oldfstat                                                                                                                                           
__NR_oldlstat                                                                                                                                           
__NR_sigaction                                                                                                                                          
__NR_sgetmask                                                                                                                                           
__NR_ssetmask                                                                                                                                           
__NR_sigsuspend                                                                                                                                         
__NR_sigpending                                                                                                                                         
__NR_socketcall                                                                                                                                         
__NR_readdir                                                                                                                                            
__NR_sigreturn                                                                                                                                          
__NR_sigprocmask                                                                                                                                        
__NR_ipc                                                                                                                                                
__NR_sysfs                                                                                                                                              

Numbers that you really really should simply not #define, with no
chance of breaking anything:
__NR_break                                                                                                                                              
__NR_stty                                                                                                                                               
__NR_gtty                                                                                                                                               
__NR_ftime                                                                                                                                              
__NR_prof                                                                                                                                               
__NR_lock                                                                                                                                               
__NR_mpx                                                                                                                                                
__NR_ulimit                                                                                                                                             
__NR_oldolduname                                                                                                                                        
__NR_profil                                                                                                                                             
__NR_ioperm                                                                                                                                             
__NR_olduname                                                                                                                                           
__NR_iopl                                                                                                                                               
__NR_idle                                                                                                                                               
__NR_vm86old                                                                                                                                            
__NR_modify_ldt                                                                                                                                         
__NR_create_module                                                                                                                                      
__NR_get_kernel_syms                                                                                                                                    
__NR_afs_syscall
__NR__newselect
__NR_vm86
__NR_query_module
__NR_getpmsg
__NR_putpmsg
__NR_ugetrlimit
__NR_set_thread_area
__NR_get_thread_area
__NR_vserver
__NR_accept04 /* typo? */

Duplicate system call numbers:
__NR_lchown32
__NR_getuid32
__NR_getgid32
__NR_geteuid32
__NR_getegid32
__NR_setreuid32
__NR_setregid32
__NR_getgroups32
__NR_setgroups32
__NR_fchown32
__NR_setresuid32
__NR_getresuid32
__NR_setresgid32
__NR_getresgid32
__NR_chown32
__NR_setuid32
__NR_setgid32
__NR_setfsuid32
__NR_setfsgid32

	Arnd <><
