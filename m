Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYJGMGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYJGMGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 08:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYJGMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 08:06:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59120 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYJGMGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 08:06:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<48EB27FE.2090009@kernel.org>
Date: Tue, 07 Oct 2008 04:56:39 -0700
In-Reply-To: <48EB27FE.2090009@kernel.org> (Tejun Heo's message of "Tue, 07
	Oct 2008 18:12:30 +0900")
Message-ID: <m1zllgzki0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2758]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If the filler is a real concern, I think it's better to just decouple
> it rather than making sysfs locking fine-grained.  sysfs metadata
> might as well be protected by a single spinlock if it can be decoupled
> from vfs locking and stuff.  It's just an in-memory tree which isn't
> used too often.

I think with a little care we can make the sysfs read side rcu
protected which would remove any real locking from lookup
and readdir.


> Generally, the VFS layer isn't too easy for sysfs which is a bit like
> distributed filesystem but has more strict here-and-now rule (all
> changes should be visible instantaneously).  At the beginning, sysfs
> didn't have much metadata itself, it just used the VFS data structures
> but that was too large so sysfs_dirent got introduced and it tried to
> update VFS data structures as necessary and (this is when I started
> working on it) the current code and Eric's patcheset evolved from
> there.


> Maybe it can be done better by taking more traditional distributed
> filesystem approach - re/invalidation on access.  I don't know whether
> it will fit sysfs's needs but if it can be done, sysfs would be able
> to ride along with other distributed filesystems and become much more
> conventional in its interfacing with VFS.

The revalidate on access model doesn't appear to have a way to track
remote renames.  Something sysfs supports.

I have just spent a little bit of time thinking it through.  I had previously
thought that we could take advantage of the fact that sysfs only allows
VFS reads we could fix our backwards lock ordering by optimizing the read
side with rcu.  Unfortunately the VFS still takes locks on rename and similar
paths despite the fact sysfs does not implement those paths functions.  Therefore
whatever we do has to be handle all VFS operations even if we don't support
them.  Weird,  but true.

We may need to delay dentry unhashing until revalidate.  I think I see
some issues if we don't do that.

Eric
