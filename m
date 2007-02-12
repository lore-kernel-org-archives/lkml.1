Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbXBLP2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbXBLP2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbXBLP2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:28:34 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46999 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbXBLP2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:28:33 -0500
Date: Mon, 12 Feb 2007 20:57:38 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Message-ID: <20070212152738.GD7526@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.485337000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.485337000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:24AM -0800, menage@google.com wrote:
> +/*
> + * Call css_get() to hold a reference on the container; following a
> + * return of 0, this container subsystem state object is guaranteed
> + * not to be destroyed until css_put() is called on it.  A non-zero
> + * return code indicates that a reference could not be taken.
> + *
> + */
> +

Why can't we reuse container->count (or container_group->ref) to
refcount the per-subsystem object attached to a container? I think
that is how it is done for cpusets? That would make css_get/put
unnecessary?

> +static inline int css_get(struct container_subsys_state *css)
> +{
> +	int retval = 0;
> +	unsigned long flags;
> +	/* Synchronize with container_rmdir() */
> +	spin_lock_irqsave(&css->refcnt_lock, flags);
> +	if (atomic_read(&css->refcnt) >= 0) {
> +		/* Container is still alive */
> +		atomic_inc(&css->refcnt);
> +	} else {
> +		/* Container removal is in progress */
> +		retval = -EINVAL;
> +	}
> +	spin_unlock_irqrestore(&css->refcnt_lock, flags);
> +	return retval;
> +}

-- 
Regards,
vatsa
