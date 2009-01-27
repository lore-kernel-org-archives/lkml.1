Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbZA0FDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbZA0FDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZA0FDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:03:32 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35792 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbZA0FDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:03:32 -0500
Subject: Re: [PATCH] x86-32: Fix __per_cpu_load relocation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <497E8778.9060503@gmail.com>
References: <20090126103243.GA31307@elte.hu>
	 <1232977445-11815-1-git-send-email-brgerst@gmail.com>
	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>
	 <497E8778.9060503@gmail.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 05:03:29 +0000
Message-Id: <1233032609.3248.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 13:03 +0900, Tejun Heo wrote:
> (cc'ing James Bottomley.)
> 
> Tejun Heo wrote:
> > Ingo Molnar wrote:
> >> * Brian Gerst <brgerst@gmail.com> wrote:
> >>
> >>> This patch fixes this error:
> >>> WARNING: Absolute relocations present
> >>> Offset     Info     Type     Sym.Value Sym.Name
> >>> c0a4e07d 00e78001   R_386_32 c0ab0000  __per_cpu_load
> >>>
> >>> Now, __per_cpu_load is a section-relative symbol:
> >>> c0aa4000 D __per_cpu_load
> >>> c0aa4000 A __per_cpu_load_abs
> >>>
> >>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> >> Applied to tip/core/percpu, thanks Brian!
> > 
> > Heh.. Thanks.  Sorry about lack of response.  It's lunar new year's
> > day here and I'm off till tomorrow.  I'll start reviewing and
> > integrating posted patches from tomorrow.
> 
> Well, I just had time to do it.  All the patches look fine to me.
> Very nice cleanup.  The git tree is at the following URL.
> 
>   http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=tj-percpu
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> The head commit is 2697fbd5faf19c84c17441b1752bdcbdcfd1248c.  James,
> this patchset converts voyager to share generic x86 percpu code.  Can
> you please review whether the change looks good for voyager?

Erm ... it's a bit difficult to tell from the tree what is specific to
voyager and what isn't.

I ran across a simple build failure:

  LD      .tmp_vmlinux1
arch/x86/kernel/built-in.o: In function `setup_per_cpu_areas':
/home/jejb/git/BUILD-voyager/arch/x86/kernel/setup_percpu.c:128: undefined reference to `x86_cpu_to_apicid_early_ptr'
/home/jejb/git/BUILD-voyager/arch/x86/kernel/setup_percpu.c:129: undefined reference to `x86_bios_cpu_apicid_early_ptr'
make: *** [.tmp_vmlinux1] Error 1

which is easily fixed below.

Not sure about the GDT changes, but will boot test them tomorrow.

James

---

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 4caa78d..42b3b35 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -125,8 +125,10 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	/* indicate the early static arrays will soon be gone */
+#ifdef X86_LOCAL_APIC
 	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
 	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
+#endif
 #if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif


