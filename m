Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168Ab0AHVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0AHVuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027Ab0AHVuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:50:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40252 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0AHVum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eEJtIKjbWj9kVPxaqFzKUQEamBADgYNLZ9Rf9UPZ7b5F8jD/2I+0HAT8v44NcRhvCC
         BMnMdO0FdDQHAk/jLrsaJ1xIrfYrH70lgdZnyVcmb276sqno0IekgIV7cJzQw/boXETZ
         u0JYWc1qAmTeiUR0DnnIwRcKgD52ffsfECdeA=
Date: Sat, 9 Jan 2010 00:50:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, brgerst@gmail.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100108215039.GD4967@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <4B4633D3.2070903@zytor.com> <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 11:30:46AM -0800, Christian Kujau wrote:
> On Thu, 7 Jan 2010 at 11:19, H. Peter Anvin wrote:
> > The big difference between the code before and after this commit is that
> > before, kernel_thread() would initialize the pt_regs structure with
> > whatever state happened to be passed into it by the caller, whereas
> > afterwards it is initialized to zero.
> 
> To be honest, bisection was kinda hazy in the last step (see my previous 
> mails), but from looking at the bisection log, it's definitely one of 
> your/Brians commit (sorry!), so it may be 3bd95dfb in combination with the 
> other 4 changes. However, only with 3bd95dfb applied, the DomU wouldn't 
> start at all. With the only other patches applied, the DomU would start, 
> and then die with a GPF.
> 
> Christian.
> -- 
> BOFH excuse #191:
> 
> Just type 'mv * /dev/null'.
> 

OK, perhaps the patch below is not _that_ stupid so I
would like to get it reviewed and tested if possible.
Just a thought. Wonder if it help but definitely it will
not harm anyway :)

	-- Cyrill
---
x86: kernel_thread -- initialize SS to a known state

Before the kernel_thread was converted into "C" we had
pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).

Though I must admit I didn't find any *explicit* load of
%ss from this structure the better to be on a safe side
and set it to a known value.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/process.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/process.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/process.c
+++ linux-2.6.git/arch/x86/kernel/process.c
@@ -288,6 +288,8 @@ int kernel_thread(int (*fn)(void *), voi
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
+#else
+	regs.ss = __KERNEL_DS;
 #endif
 
 	regs.orig_ax = -1;
