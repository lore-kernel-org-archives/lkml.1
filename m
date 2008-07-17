Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYGQRwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYGQRwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbYGQRwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:52:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51591 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbYGQRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:52:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Daniel Hokka Zakrisson" <daniel@hozac.com>
Cc: "Pavel Emelyanov" <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, oleg@tv-sign.ru,
       akpm@linux-foundation.org
References: <487F5D6B.1090007@hozac.com> <487F5EDB.1000008@openvz.org>
	<43011.192.168.102.6.1216308280.squirrel@intranet>
Date: Thu, 17 Jul 2008 10:45:13 -0700
In-Reply-To: <43011.192.168.102.6.1216308280.squirrel@intranet> (Daniel Hokka
	Zakrisson's message of "Thu, 17 Jul 2008 17:24:40 +0200 (CEST)")
Message-ID: <m13am8wgk6.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Daniel Hokka Zakrisson" <daniel@hozac.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3839]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/2] signals: kill(-1) should only signal processes in  the same namespace
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Hokka Zakrisson" <daniel@hozac.com> writes:

> Pavel Emelyanov wrote:
>> Daniel Hokka Zakrisson wrote:
>>> While moving Linux-VServer to using pid namespaces, I noticed that
>>> kill(-1) from inside a pid namespace is currently signalling every
>>> process in the entire system, including processes that are otherwise
>>> unreachable from the current process.
>>
>> This is not a "news" actually, buy anyway - thanks :)
>
> And yet nobody's fixed it... Kind of a critical thing, if you actually
> want to use them, since most distribution's rc-scripts do a kill(-1,
> SIGTERM), followed by kill(-1, SIGKILL) when halting (which, needless to
> say, would be very bad).
>
>>> This patch fixes it by making sure that only processes which are in
>>> the same pid namespace as current get signalled.
>>
>> This is to be done, indeed, but I do not like the proposed implementation,
>> since you have to walk all the tasks in the system (under tasklist_lock,
>> by the way) to search for a couple of interesting ones. Better look at how
>> zap_pid_ns_processes works (by the way - I saw some patch doing so some
>> time ago).
>
> The way zap_pid_ns_processes does it is worse, since it signals every
> thread in the namespace rather than every thread group. So either we walk
> the global tasklist, or we create a per-namespace one. Is that what we
> want?

Can you please introduce kill_pidns_info and have both
kill_something_info and zap_pid_ns_processes call this common
function?

We want to walk the set of all pids in a pid namespace.  /proc does
this and it is the recommended idiom.  If walking all of the pids in a
pid namespace is not fast enough we can accelerate that.

You are correct signalling every thread in a namespace is worse, in
fact it is semantically incorrect.  zap_pid_ns_processes gets away
with it because it is sending SIGKILL.   Therefore kill_pidns_info 
should skip sending a signal to every task that is not the
thread_group_leader.

We need to hold the tasklist_lock to prevent new processes from
joining the list of all processes.  Otherwise we could run the code
under the rcu_read_lock.

Eric
