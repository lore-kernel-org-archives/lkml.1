Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYH0QcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYH0QcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYH0QcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:32:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36382 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbYH0Qb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:31:59 -0400
Date: Wed, 27 Aug 2008 20:36:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing
Message-ID: <20080827163619.GB97@tv-sign.ru>
References: <20080824154911.GA3777@tv-sign.ru> <20080826212526.GA12230@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826212526.GA12230@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@tv-sign.ru):
> > zap_pid_ns_processes() sets pid_ns->child_reaper = NULL, this is wrong.
> > ...
> > Even if there are no childs, it is not good that forget_original_parent()
> > uses reaper == NULL.
> > ...
> 
> Well while it looked correct to me all along, I couldn't get the
> testcase to cause an oops.

Perhaps you can start several instances or increase the delay, I
forgot that usleep() uses usecs, not msecs. In any case I agree,
the test-case is oversimplified, but since it worked for me I didn't
try to make it more "stubborn".

> Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks!

> > +	/*
> > +	 * We can not clear ->child_reaper or leave it alone.
> > +	 * There may by stealth EXIT_DEAD tasks on ->children,
> > +	 * forget_original_parent() must move them somewhere.
>
> Actually this comment is a little bit misleading - the null
> deref will happen regardless of whether there are children,
> right?

Yes, the comment could be better ;)

But no, we won't oops without children. Please note that
forget_original_parent() uses reaper inside the
list_for_each_entry_safe(father->children) loop. ->children is
empty, reaper is not used at all.

But please also note the "not good" part of the changelog above.


Thanks to all for review!

Oleg.

