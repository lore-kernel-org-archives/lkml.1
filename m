Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXGSOOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXGSOOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965001AbXGSOEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:04:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60219 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938794AbXGSOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:04:13 -0400
Date: Thu, 19 Jul 2007 15:04:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: will_schmidt@vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH for review] [11/48] x86_64: During VM oom condition, kill all threads in process group
Message-ID: <20070719140411.GD16279@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <ak@suse.de>, will_schmidt@vnet.ibm.com,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20070719348.540885000@suse.de> <20070719134840.47B5114E6E@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719134840.47B5114E6E@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 03:48:40PM +0200, Andi Kleen wrote:
> 
> From: Will Schmidt <will_schmidt@vnet.ibm.com>
> 
> During a VM oom condition, kill all threads in the process group.
> 
> We have had complaints where a threaded application is left in a bad state
> after one of it's threads is killed when we hit a VM: out_of_memory condition.
> 
> Killing just one of the process threads can leave the application in a bad
> state, whereas killing the entire process group would allow for the
> application to restart, or otherwise handled, and makes it very obvious that
> something has gone wrong.
> 
> This change allows the entire process group to be taken down, rather than just
> the one thread.

Shouldn't we have one patc hthat does this for every architecture instead
of going through arch maintainers and probably losing half of them?

> Index: linux/arch/x86_64/mm/fault.c
> ===================================================================
> --- linux.orig/arch/x86_64/mm/fault.c
> +++ linux/arch/x86_64/mm/fault.c
> @@ -569,7 +569,7 @@ out_of_memory:
>  	}
>  	printk("VM: killing process %s\n", tsk->comm);
>  	if (error_code & 4)
> -		do_exit(SIGKILL);
> +		do_group_exit(SIGKILL);
>  	goto no_context;
>  
>  do_sigbus:
