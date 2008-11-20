Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYKTSQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYKTSQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYKTSPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:15:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57677 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYKTSPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:15:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20081118175901.GA17134@redhat.com>
	<20081119185148.DC1D31544EB@magilla.localdomain>
	<m1skpncg2b.fsf@frodo.ebiederm.org> <20081120145234.GA3325@redhat.com>
Date: Thu, 20 Nov 2008 10:10:08 -0800
In-Reply-To: <20081120145234.GA3325@redhat.com> (Oleg Nesterov's message of
	"Thu, 20 Nov 2008 15:52:34 +0100")
Message-ID: <m13ahm9slb.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 11/19, Eric W. Biederman wrote:
>>
>> Roland McGrath <roland@redhat.com> writes:
>>
>> > With that, I wonder if the SIGNAL_UNKILLABLE checks in get_signal_to_deliver
>> > and complete_signal are needed at all.  Hmm, I guess we do because this
>> > doesn't affect blocked signals, so they might be unblocked and delivered.
>> > (Note that since it doesn't affect blocked signals, this doesn't break init
>> > using sigwait if it wanted to.)
>>
>> Ah.  That answers the question I had bouncing in the back of my head.
>
> Even worse. The signal can be dequeued even before unblocked by the target.
> complete_signal() can "redirect" this signal to another thread wich doesn't
> block it.

The signal handlers should still be the same.

>> My original analysis of the situation was that we should not send blocked
> signals.
>> Treating handler != SIG_DFL as a permission check.  Not as an optimization.
>>
>> Mostly because it is more consistent and uniform.
>>
>> inits today don't do anything with blocked signals.
>
> (I guess you mean "with blocked SIG_DFL signals", otherwise this is
>  too strong ;)

Could be.

> If init does exec and do not want to miss (say) SIGCHLD, the only option
> is to block it before exec. And right after exec the handler is SIG_DFL.

Interesting point.

>> They explicitly ignore all signals,
>> they don't want to deal with an enable those they do.
>
> I do remember I had the (unrelated) bugreport which in particular showed
> that user-space sends SIGUSR1 to init. Usually init has a handler and does
> something in responce, but sometimes the handler is SIG_DFL. I don't
> remember the distribution, ubuntu iirc.

Could be.  I have to follow up on what craziness upstart is doing.
So my information is a bit dated.

> Yes, this perhaps means init is not perfect, but still.
>
>> Which reminds me.  I need to retest, but I had a case where I had a trivial
> init
>> that set all signal handlers to SIG_IGN so it could ignore SIGCHLD.  And not
>> all of it's children were getting reaped automagically.  Do we have a bug in
>> the reparenting/reaping logic?
>
> Ah... I thought this was already fixed... shouldn't reparent_thread()
> check task_detached() after do_notify() ? like ptrace_exit() does.

Like I said I need to retest.  I was on a 2.6.26 fedora kernel base.
So if there have been recent bug fixes things may have changed.

Eric
