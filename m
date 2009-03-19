Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZCSDkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZCSDkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 23:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZCSDk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 23:40:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58937 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZCSDk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 23:40:28 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       Zhang Le <r0bertz@gentoo.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org>
	<m17i2okogv.fsf@fess.ebiederm.org>
	<20090318072720.GA20593@adriano.hkcable.com.hk>
	<m1mybjf77w.fsf@fess.ebiederm.org>
	<m1wsandk64.fsf_-_@fess.ebiederm.org>
	<20090318135718.GA32106@hawkmoon.kerlabs.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Mar 2009 20:40:20 -0700
In-Reply-To: <20090318135718.GA32106@hawkmoon.kerlabs.com> (Louis Rilling's message of "Wed\, 18 Mar 2009 14\:57\:18 +0100")
Message-ID: <m13adaxjrv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, oleg@tv-sign.ru, viro@ZenIV.linux.org.uk, r0bertz@gentoo.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] proc:  Fix proc_tid_readdir so it handles the weird cases.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling <Louis.Rilling@kerlabs.com> writes:

> On 18/03/09  6:39 -0700, Eric W. Biederman wrote:
>> 
>> Fix the logic in proc_task_readdir so that we provide the
>> guarantee that in the sequence:
>> opendir
>> readdir
>> readdir
>> ....
>> readdir
>> closedir
>> If a thread exists from the beginning until the end we are
>> guaranteed to see it, even if some threads are created or
>> worse are destroyed during the readdir.
>> 
>> This guarantee is provided by reusing the same logic used
>> by proc_pid_readdir for the root directory of /proc.  The
>> pid is encoded into the offset, and we walk the pid bitmap
>> of all pids in the system, and test each of them to see if
>> it belongs to the specified thread group.
>> 
>> If we seek to a bad location or if the task we say last
>> exits it is ok because we can numerically find the next
>> task we would have returned.
>> 
>> This is slower that the previous version, but it should
>> not be too slow as this techinique is already use for
>> the root directory of /proc without problems.
>
> This makes 'ps -T x' an O(n^2) thing, compared to O(n) before the patch, right?
> It would be good to, at least, check for thread_group_empty().

Sort of.  It is more like it adds a constant to the traversing each thread
directory.  With everything in cache I don't expect it to be a big constant,
as I have reports that when I changed the pid directory it sped things up.

We definitely don't hold any locks so only the process doing the traversal will pay
the price.

Since this is actually a correctness issue I'm willing to pay a little more to get
the right result.

Eric

