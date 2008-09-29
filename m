Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYI2DFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYI2DFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 23:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYI2DFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 23:05:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42424 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbYI2DFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 23:05:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20080926152031.GA30831@x200.localdomain>
	<alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
	<20080928141856.GG28946@ZenIV.linux.org.uk>
	<Pine.LNX.4.64.0809282011020.1967@blonde.site>
	<alpine.LFD.1.10.0809281350410.3265@nehalem.linux-foundation.org>
Date: Sun, 28 Sep 2008 20:05:22 -0700
In-Reply-To: <alpine.LFD.1.10.0809281350410.3265@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Sun, 28 Sep 2008 13:55:29 -0700 (PDT)")
Message-ID: <m1hc7zabyl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0542]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I actually like my second patch better - it looks simpler, and it means 
> that the rules for filesystems using d_compare() are a bit clearer: at 
> least we'll only pass them dentries to look at that haven't gone through 
> d_drop (and we do hold dentry->d_lock that serializes all of that).
>
> So here it is again (I sent it out just minutes ago, but you weren't on 
> that cc, you must have picked this up off the kernel list)
>
> NOTE! Totally untested patch! It looks sane and really obvious, but maybe 
> it has some insane and non-obvious bug.

We definitely have a race between d_kill setting dentry->d_inode = NULL
and proc_sys_compare reading d_inode. 

We don't generate negative dentries for /proc/sys.

In dput atomic_dec_and_lock takes the lock before setting the count to 0.
So there is no race there.

Testing for d_unhashed and getting us out of rcu limbo before calling
into the filesystem methods makes the reasoning a lot clearer.


Looks good to me.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

