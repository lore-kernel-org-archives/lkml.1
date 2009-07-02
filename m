Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZGBICW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZGBICW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZGBICB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:02:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZGBICB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:02:01 -0400
Date: Thu, 2 Jul 2009 09:58:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Disable CLONE_PARENT for init
Message-ID: <20090702075833.GA14620@redhat.com>
References: <20090701073140.GA14284@us.ibm.com> <20090701074654.A6C6321D57@magilla.sf.frob.com> <20090701082452.GA3297@redhat.com> <20090701214805.GA25734@us.ibm.com> <20090701215833.876DA404FD@magilla.sf.frob.com> <20090702003520.GA26247@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702003520.GA26247@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Sukadev Bhattiprolu wrote:
>
> --- linux-mmotm.orig/kernel/fork.c	2009-06-30 23:01:06.000000000 -0700
> +++ linux-mmotm/kernel/fork.c	2009-07-01 17:29:09.000000000 -0700
> @@ -974,6 +974,16 @@ static struct task_struct *copy_process(
>  	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
>  		return ERR_PTR(-EINVAL);
>
> +	/*
> +	 * Siblings of global init remain as zombies on exit since they are
> +	 * not reaped by their parent (swapper). To solve this and to avoid
> +	 * multi-rooted process trees, prevent global and container-inits
> +	 * from creating siblings.
> +	 */
> +	if ((clone_flags & CLONE_PARENT) &&
> +				current->signal->flags & SIGNAL_UNKILLABLE)
> +		return ERR_PTR(-EINVAL);

Acked-by: Oleg Nesterov <oleg@redhat.com>

