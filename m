Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbYLXQhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbYLXQhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 11:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYLXQg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 11:36:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYLXQgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 11:36:55 -0500
Date: Wed, 24 Dec 2008 17:35:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7][v4] Protect init from unwanted signals more
Message-ID: <20081224163503.GF11593@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115047.GB8020@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224115047.GB8020@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Sukadev Bhattiprolu wrote:
>
> -static int sig_ignored(struct task_struct *t, int sig)
> +static int sig_task_ignored(struct task_struct *t, int sig)
>  {
>  	void __user *handler;
>
> +	handler = sig_handler(t, sig);
> +
> +	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
> +			(handler == SIG_IGN || handler == SIG_DFL))
> +		return 1;
> +	
> +	return sig_handler_ignored(handler, sig);

Well, really minor nit, but can't resist ;)

if we check both SIG_IGN and SIG_DFL, then why do we call
sig_handler_ignored() ? We can do

	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE))
		return handler == SIG_IGN || handler == SIG_DFL;
	return sig_handler_ignored(handler, sig);

Or, we can do

	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
			 handler == SIG_DFL)
		return 1;
	return sig_handler_ignored(handler, sig);

because sig_handler_ignored() checks SIG_IGN too.

Of course, this is a matter of taste only...

Oleg.

