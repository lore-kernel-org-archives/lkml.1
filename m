Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbYGRNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbYGRNmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYGRNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:42:12 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45909 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYGRNmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:42:10 -0400
Date: Fri, 18 Jul 2008 19:11:26 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Current git fails to compile
Message-ID: <20080718134126.GA30416@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080718075340.GC16453@linux.vnet.ibm.com> <20080718091441.GR6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718091441.GR6875@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 11:14:41AM +0200, Ingo Molnar wrote:
> 
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > Hi Ingo, Thomas,
> > 
> > Today's git fails to compile for me with
> > (5b664cb235e97afbf34db9c4d77f08ebd725335e)
> > 
> > arch/x86/mm/pgtable.c: In function `pgd_mop_up_pmds':
> > arch/x86/mm/pgtable.c:194: warning: unused variable `pmd'
> > arch/x86/mm/pgtable.c: In function `pgd_prepopulate_pmd':
> > arch/x86/mm/pgtable.c:222: internal compiler error: in remove_insn, at
> > emit-rtl.c:3829
> > Please submit a full bug report,
> > with preprocessed source if appropriate.
> > See <URL:http://bugzilla.redhat.com/bugzilla> for instructions.
> > Preprocessed source stored into /tmp/ccJG8rDB.out file, please attach
> > this to your bugreport.
> > make[1]: *** [arch/x86/mm/pgtable.o] Error 1
> > make: *** [arch/x86/mm] Error 2
> > [root@llm11 linux-2.6]# 
> > 
> > [root@llm11 linux-2.6]# gcc -v
> > Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.4/specs
> > Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> > --infodir=/usr/share/info --enable-shared --enable-threads=posix
> > --disable-checking --with-system-zlib --enable-__cxa_atexit
> > --disable-libunwind-exceptions --enable-java-awt=gtk
> > --host=i386-redhat-linux
> > Thread model: posix
> > gcc version 3.4.4 20050721 (Red Hat 3.4.4-2)
> > [root@llm11 linux-2.6]# 
> 
> so old-gcc crapped up.
> 
> Any chance you could try something like:
> 
>   git-bisect good v2.6.26
>   git-bisect bad linus/master
>   git-bisect run make arch/x86/mm/pgtable.o
> 
> ... if we know which change caused this maybe we can work this gcc bug 
> around.
> 

d8d5900ef8afc562088f8470feeaf17c4747790f is first bad commit
commit d8d5900ef8afc562088f8470feeaf17c4747790f
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed Jun 25 00:19:13 2008 -0400

    x86: preallocate and prepopulate separately
    
    Jan Beulich points out that vmalloc_sync_all() assumes that the
    kernel's pmd is always expected to be present in the pgd.  The
current
    pgd construction code will add the pgd to the pgd_list before its
pmds
    have been pre-populated, thereby making it visible to
    vmalloc_sync_all().
    
    However, because pgd_prepopulate_pmd also does the allocation, it
may
    block and cannot be done under spinlock.
    
    The solution is to preallocate the pmds out of the spinlock, then
    populate them while holding the pgd_list lock.
    
    This patch also pulls the pmd preallocation and mop-up functions out
    to be common, assuming that the compiler will generate no code for
    them when PREALLOCTED_PMDS is 0.  Also, there's no need for pgd_ctor
    to clear the pgd again, since it's allocated as a zeroed page.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Cc: xen-devel <xen-devel@lists.xensource.com>
    Cc: Stephen Tweedie <sct@redhat.com>
    Cc: Eduardo Habkost <ehabkost@redhat.com>
    Cc: Mark McLoughlin <markmc@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Cc: Jan Beulich <jbeulich@novell.com>
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 fe332e58e5a85d0c577a33dbf410f0a013358974
5fc1451845521927fbc4c894a09b301e871a07c9 M      arch
bisect run success
[root@llm11 linux-2.6]# 

[root@llm11 linux-2.6]# git bisect log
git-bisect start
# good: [bce7f793daec3e65ec5c5705d2457b81fe7b5725] Linux 2.6.26
git-bisect good bce7f793daec3e65ec5c5705d2457b81fe7b5725
# bad: [5b664cb235e97afbf34db9c4d77f08ebd725335e] Merge branch
'upstream-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2
git-bisect bad 5b664cb235e97afbf34db9c4d77f08ebd725335e
# bad: [e18425a0abc8eafa8e98ecffac517bb0c0904f4b] Merge branch
'tracing/for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad e18425a0abc8eafa8e98ecffac517bb0c0904f4b
# bad: [d59fdcf2ac501de99c3dfb452af5e254d4342886] Merge commit 'v2.6.26'
into x86/core
git-bisect bad d59fdcf2ac501de99c3dfb452af5e254d4342886
# good: [3de352bbd86f890dd0c5e1c09a6a1b0b29e0f8ce] Merge branch
'x86/mpparse' into x86/devel
git-bisect good 3de352bbd86f890dd0c5e1c09a6a1b0b29e0f8ce
# bad: [b4df32f4aeef8794d0135fc8dc250acb44cfee60] x86: fix warning in
e820_reserve_resources with 32bit
git-bisect bad b4df32f4aeef8794d0135fc8dc250acb44cfee60
# good: [7f0be02c5ed1deb04c54c6a17f412e04f417df11] x86: move boot_params
declaring to setup.c
git-bisect good 7f0be02c5ed1deb04c54c6a17f412e04f417df11
# good: [eb1379cb296f5aee348c2e04317d911bb84d9184] x86: update
reserve_initrd to support 64bit
git-bisect good eb1379cb296f5aee348c2e04317d911bb84d9184
# bad: [f97013fd8f17120182aa247f360e4d2069a9db9c] x86, 64-bit: split
x86_64_start_kernel
git-bisect bad f97013fd8f17120182aa247f360e4d2069a9db9c
# good: [29f784e369a914b5926e01a0b0caae0b47f6452a] x86: change some
functions in setup.c to static
git-bisect good 29f784e369a914b5926e01a0b0caae0b47f6452a
# good: [67350a5c4514c280665cdb45439d32a008a264ba] x86: simplify
vmalloc_sync_all
git-bisect good 67350a5c4514c280665cdb45439d32a008a264ba
# bad: [97349135fea7f0ba8464534433df3bfd1dc0e9a6] x86/paravirt: add
debugging for missing operations
git-bisect bad 97349135fea7f0ba8464534433df3bfd1dc0e9a6
# bad: [d8d5900ef8afc562088f8470feeaf17c4747790f] x86: preallocate and
prepopulate separately
git-bisect bad d8d5900ef8afc562088f8470feeaf17c4747790f
# good: [eba0045ff87bab465d3c80c289f3bf709c1800f5] x86/paravirt: add a
pgd_alloc/free hooks
git-bisect good eba0045ff87bab465d3c80c289f3bf709c1800f5
[root@llm11 linux-2.6]# 



> 	Ingo

-- 
regards,
Dhaval
