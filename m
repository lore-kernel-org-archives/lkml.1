Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYE0VbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYE0VbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYE0Va6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:30:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:5189 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765AbYE0Va5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=w2QbDJ2q/7312SwrUxwoqltEuldlxjNefxtGf9iPzUl45Hwop2Qv76owQ6IXEo+3pTeHFose0BVQt6So6vp27PkbSoQmeDoMOFUNCwIN4Y0XzZPHYC4HOkv0TsaVvMoQGHD01KhZ9YgfZp72NkUg7IzCGI7cptQ6oEYtm10Xaco=
Date: Wed, 28 May 2008 01:26:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080527212650.GA3608@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org> <20080527164519.GA826@tv-sign.ru> <20080527173711.GA1458@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527173711.GA1458@tv-sign.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 09:37:11PM +0400, Oleg Nesterov wrote:
> On 05/27, Oleg Nesterov wrote:
> > But I agree, this race is pretty much theoretical.
> 
> Perhaps we have the unbalanced put_pid(), in that case "struct pid" will
> be freed without waiting for a grace period.
> 
> Alexey, could you re-test with the patch below?

OK, and this is first time I saw this oops.

> --- MM/kernel/pid.c~	2008-02-20 18:29:40.000000000 +0300
> +++ MM/kernel/pid.c	2008-02-20 18:35:15.000000000 +0300
> @@ -208,6 +208,10 @@ void put_pid(struct pid *pid)
>  	ns = pid->numbers[pid->level].ns;
>  	if ((atomic_read(&pid->count) == 1) ||
>  	     atomic_dec_and_test(&pid->count)) {
> +		int type = PIDTYPE_MAX;
> +		while (--type >= 0)
> +			if (WARN_ON(!hlist_empty(&pid->tasks[type])))
> +				return;
>  		kmem_cache_free(ns->pid_cachep, pid);
>  		put_pid_ns(ns);
>  	}

