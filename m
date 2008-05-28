Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbYE1PLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbYE1PLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYE1PKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:10:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYE1PKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:10:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Atsushi TSUJI <a-tsuji@bk.jp.nec.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru>
	<m18wy45nej.fsf@frodo.ebiederm.org> <483A60DE.7080306@bk.jp.nec.com>
Date: Wed, 28 May 2008 08:03:08 -0700
In-Reply-To: <483A60DE.7080306@bk.jp.nec.com> (Atsushi TSUJI's message of
	"Mon, 26 May 2008 16:03:58 +0900")
Message-ID: <m18wxua2tv.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Atsushi TSUJI <a-tsuji@bk.jp.nec.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0041]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi TSUJI <a-tsuji@bk.jp.nec.com> writes:

>> Call me paranoid but I don't think there is any guarantee without a lock
>> that we will hit the -ERESTARTNOITR check for new processes.  I think we
>> have a slight race where the fork process may not have received the signal
>> (because it is near the tail of the list) but the new process would be
>> added to the list immediately after we read it's pointer.
>
> I know it might happen some races, but, as Oleg say, it is no problem
> on the user side. Users cannot realize whether the process forked
> during kill or after. We can pretend it was forked after kill
> finished. So I think the change to convert tasklist_lock to
> rcu_read_lock is reasonable way to avoid the local DOS for kill(-1,sig) case.

We can only pretend that if the parent lives.  If the parent is killed
then we can not so pretend.

Which in a lot of ways is the problem.  kill(-1,SIGKIL) should
kill everything except for init and the process that sent the
signal.  If anything else survives we have a broken the shutdown
scripts.

Since the race would rarely hit it will take ages for someone
to trace back to a kernel change.

If I could convince myself that Oleg is correct and that what
Oleg is proposing will always work I don't have a problem.

Eric
