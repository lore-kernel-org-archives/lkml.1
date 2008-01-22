Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbYAVBHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbYAVBHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYAVBHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:07:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:11196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498AbYAVBHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:07:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,230,1199692800"; 
   d="scan'208";a="254624552"
Subject: Re: [PATCH]Fix the order of atomic operations in
	restore_previous_kprobes on ia64
From: Shaohua Li <shaohua.li@intel.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <4790D1DE.8030700@redhat.com>
References: <4790D1DE.8030700@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 09:07:46 +0800
Message-Id: <1200964066.1353.0.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 00:20 +0800, Masami Hiramatsu wrote:
> From: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Fix the order of atomic operations to prevent overwriting
> prev_kprobe[0].
> To pop values from stack, we must decrement stack index right AFTER
> reading values.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> Details of this issue was reported to
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=2071
> 
>    arch/ia64/kernel/kprobes.c |    7 ++++---
>    1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: 2.6.24-rc8/arch/ia64/kernel/kprobes.c
> ===================================================================
> --- 2.6.24-rc8.orig/arch/ia64/kernel/kprobes.c  2008-01-17
> 21:14:01.000000000 -0500
> +++ 2.6.24-rc8/arch/ia64/kernel/kprobes.c       2008-01-17
> 21:14:01.000000000 -0500
> @@ -381,9 +381,10 @@
>    static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk
> *kcb)
>    {
>         unsigned int i;
> -       i = atomic_sub_return(1, &kcb->prev_kprobe_index);
> -       __get_cpu_var(current_kprobe) = kcb->prev_kprobe[i].kp;
> -       kcb->kprobe_status = kcb->prev_kprobe[i].status;
> +       i = atomic_read(&kcb->prev_kprobe_index);
> +       __get_cpu_var(current_kprobe) = kcb->prev_kprobe[i-1].kp;
> +       kcb->kprobe_status = kcb->prev_kprobe[i-1].status;
> +       atomic_sub(1, &kcb->prev_kprobe_index);
>    }
> 
>    static void __kprobes set_current_kprobe(struct kprobe *p,
Acked. Thanks for the patch.

Thanks,
Shaohua

