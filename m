Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYJGXtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYJGXtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbYJGXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:49:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYJGXtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:49:05 -0400
Date: Wed, 8 Oct 2008 08:47:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-Id: <20081008084753.f1a4fc2e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48EB8BBB.8000907@kernel.org>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021705460.26309@shark.he.net>
	<20081007163331.711a938c.kamezawa.hiroyu@jp.fujitsu.com>
	<48EB8BBB.8000907@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008 09:18:03 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > I'm sorry if alread fixed.
> > 
> > Folloing function in git-x86.patch touches invalid address.
> > ==
> > +void __init early_cpu_init(void)
> > +{
> > +       struct cpu_dev **cdev;
> > +       int count = 0;
> > +
> > +       printk("KERNEL supported cpus:\n");
> > +       for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
> > +               struct cpu_dev *cpudev = *cdev;
> > +               unsigned int j;
> > +
> > +               if (count >= X86_VENDOR_NUM)
> > +                       break;
> > +               cpu_devs[count] = cpudev;
> > +               count++;
> > +
> > +               for (j = 0; j < 2; j++) {
> > +                       if (!cpudev->c_ident[j])
> > +                               continue;
> > +                       printk("  %s %s\n", cpudev->c_vendor,
> > +                               cpudev->c_ident[j]);
> > +               }
> > +       }
> > +
> > +       early_identify_cpu(&boot_cpu_data);
> >  }
> > ==
> > printk("  %s %s\n", cpudev->c_vendor, cpudev->c_ident[j]);
> > touches invalid address. (following is printk() result by
> > replacing %s with %p.
> > ==
> >   ffffffff8066e38a ffffffff8066e383
> >   ffffffff8066e3ab ffffffff8066e3a2
> >   ffffffff8066e3af ffffffff8066e3b7
> >   807064c0c7c74855 08ec834853e58948
> >   807064c0c7c74855 74c085fffffe9fe8
> > ==
> > and the kernel never boots on my box.
> 
> could be merging problem again.
> 
> please check in arch/x86/kernel/vmliux_64.lds.S
> 
> it should be like 
> 
>   __con_initcall_end = .;
>   __x86_cpu_dev_start = .;
>   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
>         *(.x86_cpu_dev.init)
>   }
>   __x86_cpu_dev_end = .;
> 
>   DYN_ARRAY_INIT(8)
> 
>   SECURITY_INIT
> 
Oh, yes. like this.
==
 __con_initcall_end = .;
  __x86_cpu_dev_start = .;
  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
        *(.x86_cpu_dev.init)
  }
  SECURITY_INIT
  __x86_cpu_dev_end = .;
==

I'll try next version when it comes.

Thanks,
-Kame







