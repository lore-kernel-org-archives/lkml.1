Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbXKTBNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbXKTBNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXKTBNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:34 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49811 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751898AbXKTBNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:32 -0500
Message-Id: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:32 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data handling on x86_64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pretty early draft stage of the patch. It works on
x86_64 only. Its a bit massive so I'd like to have some feedback
before proceeding (and maybe some help)?.

The support for other arches was not tested yet.

The patch establishes a new set of cpu operations that allow to
exploit single instruction atomicity to allow per cpu variable
modifications without disabling/enabling preempt or interrupts and
without the need to do an offset calculation in order to determine
the location of the variable on the current processor.

It then implements these operations on x86_64 after consolidating
per cpu access for allocpercpu, percpu and pda. All per
cpu data is then accessible via gs segment override.

This results in a reduction in code size of the kernel and in more efficient
operation of per cpu access.

Before:
   text    data     bss     dec     hex filename
   4041907  512371 1302360 5856638  595d7e vmlinux

After (this includes the code added for the cpu allocator!):

  text    data     bss     dec     hex filename
  3861532  527715 1298072 5687319  56c817 vmlinux


On x86_64 the segment override results in the following change for a simple
vm counter increment:

Before:

mov    %gs:0x8,%rdx		Get smp_processor_id
mov    tableoffset,%rax		Get table base
incq   varoffset(%rax,%rdx,1)	Perform the operation with a complex lookup
				adding the var offset

An interrupt or a reschedule action can move the execution thread to another
processor if interrupt or preempt is not disabled. Then the variable of
the wrong processor may be updated in a racy way.

After:

incq   %gs:varoffset(%rip)

Single instruction that is safe from interrupts or moving of the execution
thread. It will reliably operate on the current processors data area.

Other platforms can also perform address relocation plus atomic ops on
a memory location. Exploiting of the atomicity of instructions vs interrupts
is therefore possible and will reduce the cpu op processing overhead.

F.e on IA64 we have per cpu virtual mapping of the per cpu area. If
we add an offset to the per cpu area variable address then we can guarantee
that we always hit the per cpu areas local to a processor.

Other platforms (SPARC?) have registers that can be used to form addresses.
If the cpu area address is in one of those then atomic per cpu modifications
can be generated for those platforms in the same way.

Slub best performance in the fast fastpath goes from 47 cycles to 41 cycles
through the use of the segment override.


-- 
