Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZEPXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZEPXqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZEPXqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963AbZEPXqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:46:03 -0400
Date: Sat, 16 May 2009 16:44:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Shirish Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
Message-ID: <alpine.LFD.2.01.0905161632160.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13329
> Subject		: cifs_close: NULL pointer dereference
> Submitter	: Luca Tettamanti <kronos.it@gmail.com>
> Date		: 2009-05-16 16:28 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=124249133701702&w=4

The code in this one decodes to

   0:	89 ef                	mov    %ebp,%edi
   2:	45 31 e4             	xor    %r12d,%r12d
   5:	e8 f3 63 e7 df       	callq  0xffffffffdfe763fd
   a:	41 bd 0a 00 00 00    	mov    $0xa,%r13d
  10:	48 c7 c7 c4 6b 61 a0 	mov    $0xffffffffa0616bc4,%rdi
  17:	e8 b3 7f e7 df       	callq  0xffffffffdfe77fcf
  1c:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  20:	48 8b 43 18          	mov    0x18(%rbx),%rax
  24:	48 c7 c7 c4 6b 61 a0 	mov    $0xffffffffa0616bc4,%rdi
  2b:*	48 89 42 08          	mov    %rax,0x8(%rdx)     <-- trapping instruction
  2f:	48 89 10             	mov    %rdx,(%rax)
  32:	48 c7 43 18 00 02 20 	movq   $0x200200,0x18(%rbx)
  39:	00 
  3a:	48 8b 13             	mov    (%rbx),%rdx

which seems to match (modulo normal compiler issues):

        movq    -56(%rbp), %rdi # %sfp,
        call    mutex_unlock    #
        movq    $GlobalSMBSeslock, %rdi #,
        call    _write_lock     #
        movq    16(%rbx), %rdx  # <variable>.flist.next, D.47095
        movq    24(%rbx), %rax  # <variable>.flist.prev, D.47094
        movq    %rax, 8(%rdx)   # D.47094, <variable>.prev
        movq    %rdx, (%rax)    # D.47095, <variable>.next
        movq    $2097664, 24(%rbx)      #, <variable>.flist.prev
        movq    (%rbx), %rdx    # <variable>.tlist.next, D.47099

which I think ends up being this code:

                mutex_unlock(&pSMBFile->lock_mutex);
        
                write_lock(&GlobalSMBSeslock);
                list_del(&pSMBFile->flist);   

ie 'pSMBFile->flist.next' looks to be zero. Either uninitialized or 
perhaps a use-after-free thing..

We have commit 90e4ee5d31 "[CIFS] Fix double list addition in cifs posix 
open code" that touches exactly that 'flist' thing, and removes the thing 
that adds it to the list because it's _claimed_ to be a "double add". It 
probably wasn't.

The bug reporter says:

> The machine is running kernel from git (1d80cac - almost rc6)

and that 1d80cac is _after_ 90e4ee5d31. So I do think 90e4ee5d31 is buggy.

		Linus
