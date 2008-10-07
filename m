Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYJGQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYJGQTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYJGQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:19:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:59958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbYJGQTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:19:44 -0400
Message-ID: <48EB8BBB.8000907@kernel.org>
Date: Tue, 07 Oct 2008 09:18:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>	<Pine.LNX.4.64.0810021705460.26309@shark.he.net> <20081007163331.711a938c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081007163331.711a938c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> I'm sorry if alread fixed.
> 
> Folloing function in git-x86.patch touches invalid address.
> ==
> +void __init early_cpu_init(void)
> +{
> +       struct cpu_dev **cdev;
> +       int count = 0;
> +
> +       printk("KERNEL supported cpus:\n");
> +       for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
> +               struct cpu_dev *cpudev = *cdev;
> +               unsigned int j;
> +
> +               if (count >= X86_VENDOR_NUM)
> +                       break;
> +               cpu_devs[count] = cpudev;
> +               count++;
> +
> +               for (j = 0; j < 2; j++) {
> +                       if (!cpudev->c_ident[j])
> +                               continue;
> +                       printk("  %s %s\n", cpudev->c_vendor,
> +                               cpudev->c_ident[j]);
> +               }
> +       }
> +
> +       early_identify_cpu(&boot_cpu_data);
>  }
> ==
> printk("  %s %s\n", cpudev->c_vendor, cpudev->c_ident[j]);
> touches invalid address. (following is printk() result by
> replacing %s with %p.
> ==
>   ffffffff8066e38a ffffffff8066e383
>   ffffffff8066e3ab ffffffff8066e3a2
>   ffffffff8066e3af ffffffff8066e3b7
>   807064c0c7c74855 08ec834853e58948
>   807064c0c7c74855 74c085fffffe9fe8
> ==
> and the kernel never boots on my box.

could be merging problem again.

please check in arch/x86/kernel/vmliux_64.lds.S

it should be like 

  __con_initcall_end = .;
  __x86_cpu_dev_start = .;
  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
        *(.x86_cpu_dev.init)
  }
  __x86_cpu_dev_end = .;

  DYN_ARRAY_INIT(8)

  SECURITY_INIT


YH


