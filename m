Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbZJIUvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbZJIUvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbZJIUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:50:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43871 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbZJIUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:50:58 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>, andrea@suse.de,
       Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com>
	<4ACAFD6A.3060008@fr.ibm.com> <20091008030828.GA18973@us.ibm.com>
	<4ACD9ECC.90508@fr.ibm.com> <20091009032928.GA2031@us.ibm.com>
	<4ACF381F.9050808@fr.ibm.com> <20091009203809.GA12230@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 09 Oct 2009 13:50:12 -0700
In-Reply-To: <20091009203809.GA12230@us.ibm.com> (Sukadev Bhattiprolu's message of "Fri\, 9 Oct 2009 13\:38\:09 -0700")
Message-ID: <m18wfkl2bf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: pidns memory leak
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Andrea,
>
> We have been running a leak in child pid namespaces and some early debugging
> points to the following commit:
>
>>> 	commit 7766755a2f249e7e0dabc5255a0a3d151ff79821
>>> 	Author: Andrea Arcangeli <andrea@suse.de>
>>> 	Date:   Mon Feb 4 22:29:21 2008 -0800
>>>
>
> Reverting the commit seems to fix the leak but we need to do some more
> analysis (like the lstat() question Daniel has).

Yes.

That entire path is an optimization.  It should not be needed for correct
operation.  Although it may be responsible for some false positives.

> However I have a basic question regarding the commit - the log mentions:
>
> 	> do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
> 	> come back to run journal_stop)
>
> But release_task() calls shrink_dcache_parent() for a _procfs_ dentry. Does
> journal_stop() apply to procfs also ?

The problem when the that PF_EXITING check was introduced is that
shrink_dcache_parent could shrink dcache entries for other
filesystems.  Last I looked that is no longer the case and we can
remove that code.  As I recall proc_flush_task_mnt has a few other minor
bugs as well that could cause problems.

Ultimately what problems are you seeing?

Eric
