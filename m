Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZEKMEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZEKMEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZEKMEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:04:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZEKMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:04:35 -0400
Date: Mon, 11 May 2009 08:04:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090511120418.GA3859@infradead.org>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com> <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 12:12:40PM +0200, Vitaly Mayatskikh wrote:
> +static int wait_copyout(struct wait_opts *wo, struct task_struct *p,
> +			pid_t pid, uid_t uid, int why, int status, int signal)
>  {
> -	struct siginfo __user *infop;
> +	struct siginfo __user *infop = wo->wo_info;
>  	int retval = wo->wo_rusage
>  		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
>  
> +	if (!retval && infop) {
> +		retval = put_user(signal, &infop->si_signo);
> +		if (!retval)
> +			retval = put_user(0, &infop->si_errno);
> +		if (!retval)
> +			retval = put_user((short)why, &infop->si_code);
> +		if (!retval)
> +			retval = put_user(pid, &infop->si_pid);
> +		if (!retval)
> +			retval = put_user(uid, &infop->si_uid);
> +		if (!retval)
> +			retval = put_user(status, &infop->si_status);
> +	}
> +	return retval;

wouldn't this better be written as:

static int wait_copyout(struct wait_opts *wo, struct task_struct *p,
			pid_t pid, uid_t uid, int why, int status, int signal)
{
	struct siginfo __user *infop = wo->wo_info;

	if (wo->wo_rusage) {
		int retval = getrusage(p, RUSAGE_BOTH, wo->wo_rusage);
		if (retval)
			return retval;
	}

	if (!infop)
		return 0;

	if (put_user(signal, &infop->si_signo) ||
	    put_user(0, &infop->si_errno) ||
	    put_user((short)why, &infop->si_code) ||
	    put_user(pid, &infop->si_pid) ||
	    put_user(uid, &infop->si_uid) ||
	    put_user(status, &infop->si_status))
		return -EFAULT;
	return 0;
}

