Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbZDMRwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbZDMRwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZDMRwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:52:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbZDMRwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:52:31 -0400
Date: Mon, 13 Apr 2009 10:45:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Valdis.Kletnieks@vt.edu,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
In-Reply-To: <20090413102749.4ca3a217.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Apr 2009, Andrew Morton wrote:
>
>  static void drv_write(struct drv_cmd *cmd)
>  {
> -	unsigned int i;
> +	unsigned int cpu;
>  
> -	for_each_cpu(i, cmd->mask) {
> -		work_on_cpu(i, do_drv_write, cmd);
> -	}
> +	for_each_cpu(cpu, cmd->mask)
> +		smp_call_function_single(cpu, do_drv_write, cmd, 1);

Ok, that's just -wrong-.

Doesn't anybody else see anything odd in doing

	for_each_cpu(cpu, cmd->mask)
		smp_call_function_single(cpu, ..);

and react to it?

IOW, why not just do

	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);

here?

			Linus
