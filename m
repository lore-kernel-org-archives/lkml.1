Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbXJWGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbXJWGMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXJWGMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:12:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXJWGL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:11:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oNjLktvRZMefBb2wHN9CrCIHncI9NUeigI9eF3QPTki7u1BGX8uwE0jzfU093TSl6
	kKEz9n5Ohmapn2xm8hL1g==
Message-ID: <6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
Date: Mon, 22 Oct 2007 23:11:54 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH -v2 4/7] RT overloaded runqueues accounting
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, dmitry.adamushko@gmail.com,
       ghaskins@novell.com, a.p.zijlstra@chello.nl
In-Reply-To: <20071022211709.7be79fea.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071023025900.927578809@goodmis.org>
	 <20071023032916.651749224@goodmis.org>
	 <20071022211709.7be79fea.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Paul Jackson <pj@sgi.com> wrote:
> Steven wrote:
> > +void cpuset_rt_set_overload(struct task_struct *tsk, int cpu)
> > +{
> > +     cpu_set(cpu, task_cs(tsk)->rt_overload);
> > +}
>
> Question for Steven:
>
>   What locks are held when cpuset_rt_set_overload() is called?
>
> Questions for Paul Menage:
>
>   Does 'tsk' need to be locked for the above task_cs() call?

Cgroups doesn't change the locking rules for accessing a cpuset from a
task - you have to have one of:

- task_lock(task)

- callback_mutex

- be in an RCU section from the point when you call task_cs to the
point when you stop using its result. (Additionally, in this case
there's no guarantee that the task stays in this cpuset for the
duration of the RCU section).

Paul
