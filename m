Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZDYJTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZDYJTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 05:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZDYJTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 05:19:31 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:41497 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZDYJTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 05:19:30 -0400
Date: Sat, 25 Apr 2009 11:19:28 +0200
From: Renzo Davoli <renzo@cs.unibo.it>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090425091928.GB18153@cs.unibo.it>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it> <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it> <20090329163228.GE7671@hack> <20090404101708.GG4203@cs.unibo.it> <20090407173646.GL12226@hack> <20090408121851.GE24173@cs.unibo.it> <20090413163603.GG2391@hack> <20090417081823.GA31897@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090417081823.GA31897@hack>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 04:18:23PM +0800, Am??rico Wang wrote:
> On Tue, Apr 14, 2009 at 12:36:03AM +0800, Américo Wang wrote:
> >Anyway, I will test your patch tomorrow, and will send you more
> >feedbacks soon.
> 
> Sorry for the delay.
Me, too!

UML on UML stopped working long time ago, I wrote a note on it
on March 8. See:
http://article.gmane.org/gmane.linux.uml.devel/12085
Here I am having the same behavior with and without my patches, thus
(in my opinion) the bug is not related with the new tags.

It seems that there are some problems on the virtual memory
when UML runs UML.
With older kernels (<2.6.28.2) the error is:
Eeek! page_mapcount(page) went negative! (-1)
the error is still there now but the message I get is different:

BUG: Bad page map in process linux.umlv2  pte:00164045 pmd:07b5e1e1
page:08905c80 flags:00000400 count:-2 mapcount:-4 mapping:(null) index:0
addr:00100000 vm_flags:00060055 anon_vma:(null) mapping:(null) index:100
vma->vm_ops->fault: special_mapping_fault+0x0/0x47
0fc01d64:  [<081a9c5a>] dump_stack+0x1c/0x20
0fc01d7c:  [<080a233f>] print_bad_pte+0x16d/0x17d
0fc01dac:  [<080a2c20>] unmap_vmas+0x273/0x46f
0fc01e04:  [<080a5c69>] unmap_region+0x82/0xfe
0fc01e3c:  [<080a68b1>] do_munmap+0x1f6/0x245
0fc01e6c:  [<080a7118>] mmap_region+0xc4/0x3fd
0fc01eb8:  [<080a765b>] do_mmap_pgoff+0x20a/0x253
0fc01ef0:  [<08059b2f>] sys_mmap2+0x60/0x8e
0fc01f28:  [<0805b0df>] handle_syscall+0x7f/0x9c
0fc01f78:  [<0806a27a>] userspace+0x2d0/0x377
0fc01fe0:  [<08058e38>] fork_handler+0x53/0x5b
0fc01ffc:  [<00000000>] 0x0
(and then many others)
It seems that the page table of the UML process inside UML gets garbled:
I think that neither "count" should never reach -2 nor "mapcount" -4. 

The numbers of count and mapcount decrease at each faulty UML execution
(the following are outputs of tests without my patch)
$ ./linux ....
0> page:08905d00 flags:00000400 count:1 mapcount:-1 mapping:(null) index:0
$ ./linux ....
1> page:08905d00 flags:00000400 count:0 mapcount:-2 mapping:(null) index:0
2> page:08905d00 flags:00000400 count:-1 mapcount:-3 mapping:(null) index:0
3> page:08905d00 flags:00000400 count:-2 mapcount:-4 mapping:(null) index:0

It seems that a page gets released twice.

I have successfully tested my paches in various configurations:
- patched-kernel running patched-UML
- patched-kernel running unpatched-UML
- patched-kernel running umview
- patched-UML running umview
- UML on UML fails in the same way with and without the patch.
I am currently running the patched kernel on my laptop.

In my spare time (does it exist? ;-) I'll try to track the UML bug
(hoping that Jeff can do it before me, Jeff are you online? ;-)

renzo
