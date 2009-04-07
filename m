Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbZDGRgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbZDGRgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZDGRfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:35:52 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:16308 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbZDGRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fu0DalFHCA4fplzPTCoWv056jflf6WXlxJ4H/CLTagxuf0wynTKsKAGU0xBXcE5Vbc
         YI31+m1eksc/85lGS7JqfEazYnEjRX1Q9pn2Yn+tF+z/7QYV42WhmkgN1NPcXlvg/fkv
         r6ea0udb1tgFHx+pqbUhKNSBEdBKfD7j29efQ=
Date: Wed, 8 Apr 2009 01:36:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090407173646.GL12226@hack>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it> <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it> <20090329163228.GE7671@hack> <20090404101708.GG4203@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090404101708.GG4203@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 12:17:09PM +0200, Renzo Davoli wrote:
>Dear Cong,
>
>On Mon, Mar 30, 2009 at 12:32:28AM +0800, Américo Wang wrote:
>> On Wed, Mar 25, 2009 at 12:47:53AM +0100, Renzo Davoli wrote:
>> >1- the code is now extremely simple 
>> Why adding a new request for ptrace is harder? I don't think so. :)
>> >2- if we define a different tag for syscall (e.g. PTRACE_VM), we need also
>> >different tags for PTRACE_VM_SINGLESTEP, PTRACE_VM_SINGLEBLOCK and maybe
>> >others in the future.
>> >Using the addr field we don't need this multiplication of tags
>> >(and we could soon delete PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP).
>> Yes? We could also remove PTRACE_SYSEMU* if we had PTRACE_VM to replace
>> it. I would like to hear more from you on this point.
>
>I am sorry for the delay of this reply.
>I am having a quite busy time and I like to analyze problems before
>giving answers.

No problem. :)

>
>Let me point out that the primary issue is the following one:
>PTRACE_SYSEMU is a limited feature. It is twofold limited:
>- it is supported only for x86
>- it provides support for "total" virtual machines like User-Mode Linux
>and it is useless for "partial" virtual machine like fakeroot-ng, umview
>or others.
>I have published a proposal for a new support that is able to overpass
>these limits. PTRACE_SYSEMU/SYSEMU_SINGLESTEP could be deprecated.
>There will be some cleaning up of the kernel code when the deprecated
>tags are eliminated.
>
>Whether it is nicer to use the existing tags or defining new tags is a
>secondary issue. I support the hypothesis of reusing the existing tags and use
>values in the addr field but if the community says that it is nicer/better to
>have separate tags it is quite easy to update my patches (and umview).
>
>Let us discuss this latter point.
>
>PTRACE has a number of "resume" tags:
>PTRACE_SYSCALL, PTRACE_SINGLESTEP, PTRACE_SINGLEBLOCK and currently
>PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP.
>all these call are managed in the code by the ptrace_resume function.
>
>My patch #1 (kernel/ptrace.c function ptrace_request) forwards the addr 
>parameter to ptrace_resume which saves the VM bits in some bits inside 
>task_struct's ptrace field.
>
>If we want to use different tags like:
>PTRACE_VM PTRACE_VM_SINGLESTEP PTRACE_VM_SINGLEBLOCK:
>the better implementation I can envision, adds another group of switch cases
>as follows (kernel/ptrace.c function ptrace_request):
> ....
> #ifdef PTRACE_SINGLESTEP
>   case PTRACE_SINGLESTEP:
> #endif
> #ifdef PTRACE_SINGLEBLOCK
>   case PTRACE_SINGLEBLOCK:
> #endif
> #ifdef PTRACE_SYSEMU
>   case PTRACE_SYSEMU:
>   case PTRACE_SYSEMU_SINGLESTEP:
> #endif
>   case PTRACE_SYSCALL:
>   case PTRACE_CONT:
>     return ptrace_resume(child, request, 0, data);
>+/* statements added for PTRACE_VM management */
>+#ifdef PTRACE_VM
>+  case PTRACE_VM:
>+#ifdef PTRACE_VM_SINGLESTEP
>+  case PTRACE_VM_SINGLESTEP:
>+#endif
>+#ifdef PTRACE_VM_SINGLEBLOCK
>+  case PTRACE_VM_SINGLEBLOCK:
>+#endif
>+    return ptrace_resume(child, PTRACE_VM_TAGS_MAPPING(request), addr, data);
>+#endif
>....
>  

Hmmm, I see your points. Thanks for your analysis.

I didn't mean to introduce three new requests for ptrace().
My point is, actually, the same with your first proposal in this thread,
i.e. introducing a new request PTRACE_SYSVM, and two tags in 'addr' for it,
i.e. PTRACE_VM_SKIPCALL, PTRACE_VM_SKIPEXIT.

This will not break any code, and is also easy to implement as you
stated above. Isn't this what you want? Why do you drop this idea now?

Thanks.


-- 
Do what you love, f**k the rest! F**k the regulations!
 
