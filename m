Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254Ab0AULS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0AULS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035Ab0AULS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:18:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:41565 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0AULS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ek5HnMwvgFGeGJIhnC4/+3N00sn3GXvVnwvpxLXOscOGP3+Pflwf3G68eBqtnTNFxo
         RYSNSETMxb3k+GwCmHLswdz7W3/afe45LAWRHJZme0A7BCc2sNVmFCJCQvdquQ1UX8nQ
         iVtmoYu/6cgomRBT63ok7VFH671smak9i+EOw=
Date: Thu, 21 Jan 2010 12:18:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: perf record -g hangs the system
Message-ID: <20100121111850.GD5017@nowhere>
References: <ff13bc9a1001210310x5ebc9993kbf6b302285d2d9a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff13bc9a1001210310x5ebc9993kbf6b302285d2d9a4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 12:10:12PM +0100, Luca Barbieri wrote:
> I'm experiencing a system lockup running the following command:
> perf record -g true
> 
> The system hangs and does not respond to any sysrq.
> No messages are printed to netconsole.
> 
> This is with 2.6.33-rc4 on an x86-32 Core 2 dual core machine.
> 
> Any tips on how to debug/fix this?



It should be fixed in latest linus's git tree with the
following patch:


commit c2c5d45d46c8c0fd34291dec958670ad4816796f
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Dec 31 03:52:25 2009 +0100

    perf: Stop stack frame walking off kernel addresses boundaries
    
    While processing kernel perf callchains, an bad entry can be
    considered as a valid stack pointer but not as a kernel address.
    
    In this case, we hang in an endless loop. This can happen in an
    x86-32 kernel after processing the last entry in a kernel
    stacktrace.
    
    Just stop the stack frame walking after we encounter an invalid
    kernel address.
    
    This fixes a hard lockup in x86-32.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    LKML-Reference: <1262227945-27014-1-git-send-regression-fweisbec@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c56bc28..6d81755 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -123,13 +123,15 @@ print_context_stack_bp(struct thread_info *tinfo,
 	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
 		unsigned long addr = *ret_addr;
 
-		if (__kernel_text_address(addr)) {
-			ops->address(data, addr, 1);
-			frame = frame->next_frame;
-			ret_addr = &frame->return_address;
-			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
-		}
+		if (!__kernel_text_address(addr))
+			break;
+
+		ops->address(data, addr, 1);
+		frame = frame->next_frame;
+		ret_addr = &frame->return_address;
+		print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 	}
+
 	return (unsigned long)frame;
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);

