Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbYDPAhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbYDPAhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYDPAgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:36:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbYDPAgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:36:51 -0400
Date: Tue, 15 Apr 2008 17:35:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: andi-suse@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, markus.t.metzger@intel.com,
       markus.t.metzger@gmail.com, suresh.b.siddha@intel.com,
       roland@redhat.com, mtk.manpages@gmail.com, eranian@googlemail.com,
       juan.villacis@intel.com
Subject: Re: [patch 1/1] x86, ptrace: PEBS support
Message-Id: <20080415173534.b746f8da.akpm@linux-foundation.org>
In-Reply-To: <20080408110158.A9336@sedona.ch.intel.com>
References: <20080408110158.A9336@sedona.ch.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 11:01:58 +0200
Markus Metzger <markus.t.metzger@intel.com> wrote:

> +static inline void *ds_allocate_buffer(size_t size, unsigned int *pages)
>  {
> -	(*(unsigned long *)(base + ds_cfg.bts_interrupt_threshold.offset)) = value;
> +	unsigned long rlim, vm, pgsz;
> +	void *buffer;
> +
> +	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
> +	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
> +	vm   = current->mm->total_vm  + pgsz;
> +	if (rlim < vm)
> +		return 0;
> +
> +	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
> +	vm   = current->mm->locked_vm  + pgsz;
> +	if (rlim < vm)
> +		return 0;

Should we skip the RLIMIT_MEMLOCK check if capable(CAP_IPC_LOCK)?

It's a fairly large patch.
