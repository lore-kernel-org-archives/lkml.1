Return-Path: <linux-kernel-owner+w=401wt.eu-S1763735AbZE0TKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763735AbZE0TKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761213AbZE0TJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:09:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37707 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbZE0TJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:09:59 -0400
Date: Wed, 27 May 2009 21:05:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527190513.GA32452@redhat.com>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090527183109.GA30574@redhat.com> <20090527185056.GW1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527185056.GW1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Andi Kleen wrote:
>
> > Actually, I think there is a strong reason to handle signals during
> > core dumping. The coredump can take a lot of time/resources, not good
> > it looks like unkillable procees to users.
>
> One problem with that is if you send a process a string of signals that cause
> a core dump and then kill. In the old case you would just get a full core dump
> on the first signal and be done. With your change it would process
> the second signal too and stop the dumping and you get none or a partial
> core dump. That might well break existing setups.

I don't think we should worry about this particular case. Suppose a user
does

	kill(pid, SIGQUIT);
	kill(pid, SIGKILL);

In this case, most likely the core dump will not start. Because SIGKILL
will set SIGNAL_GROUP_EXIT before the process dequeues SIGQUIT and start
do_coredump() which checks signal_group_exit() in zap_threads().

But yes, I agree, this change is user-visible and should be discussed.

Oleg.

