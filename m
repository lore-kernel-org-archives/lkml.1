Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZFRPrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZFRPrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZFRPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:46:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbZFRPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:46:58 -0400
Date: Thu, 18 Jun 2009 17:42:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] Prevent container-inits from using
	CLONE_PARENT
Message-ID: <20090618154216.GB6404@redhat.com>
References: <20090618024743.GA31515@us.ibm.com> <20090618025103.GB31672@us.ibm.com> <20090618153501.GA6404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618153501.GA6404@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Oleg Nesterov wrote:
>
> On 06/17, Sukadev Bhattiprolu wrote:
> >
> > @@ -974,6 +974,14 @@ static struct task_struct *copy_process(
> >  	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
> >  		return ERR_PTR(-EINVAL);
> >
> > +	/*
> > +	 * To keep pid namespace semantics simple, prevent container-inits
> > +	 * from creating siblings.
> > +	 */
> > +	if ((clone_flags & CLONE_PARENT) &&
> > +			is_container_init(current) && !is_global_init(current))
>
> Both is_ checks are not right afaics. There are per-thread. This means
> that container-init can do clone(CLONE_THREAD), and then this thread
> does CLONE_PARENT and fools copy_process().
>
> As for !is_global_init(). I never understood what should we do if the
> global init does CLONE_PARENT, this attaches another process to swapper,
> not good.

Hmm. And idle threads run with ->action[SIGHLD] == SIG_DFL, so this is
really wrong. Fortunately, we can trust the global init.

Oleg.

