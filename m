Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZAEMpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZAEMpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbZAEMoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:44:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40942 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZAEMoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:44:54 -0500
Date: Mon, 5 Jan 2009 13:42:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6][v5] Define siginfo_from_ancestor_ns()
Message-ID: <20090105124256.GB3313@redhat.com>
References: <20081227204658.GA27197@us.ibm.com> <20081227205222.GB27337@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227205222.GB27337@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27, Sukadev Bhattiprolu wrote:
>
> +static inline int siginfo_from_ancestor_ns(struct task_struct *t,
> +                       siginfo_t *info)
> +{
> +	struct pid_namespace *ns;
> +
> +	/*
> +	 * Ensure signal is from user-space before checking pid namespace.
> +	 * (We maybe called from interrupt context and dereferencing
> +	 * pid namespace would be safe).
> +	 */
> +	if (siginfo_from_user(info)) {
> +		/*
> +		 * If we do not have a pid in the receiver's namespace,
> +		 * we must be from an ancestor namespace.
> +		 *
> +		 * Note:
> +		 * 	If receiver is exiting, ns == NULL,

Confused. I thought we alread have the patch which ensures
task_active_pid_ns() is never NULL?

If not, we can get ns from task_pid(t). See also below.

>                       signal will be
> +		 * 	queued but eventually ignored anyway (wants_signal()
> +		 * 	is FALSE).

This is only true for thread-specific signals, please remove
this comment,

> +		ns = task_active_pid_ns(t);
> +		if (!ns || task_pid_nr_ns(current, ns) <= 0)
> +			return 1;

See above. In any case, we shouldn't return 1 if ns == NULL.
But afaics we always can know its namespace.

Oleg.

