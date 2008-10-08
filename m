Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYJHAGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYJHAGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJHAGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:06:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55398 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYJHAGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:06:09 -0400
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
	<48EB27FE.2090009@kernel.org> <m1zllgzki0.fsf@frodo.ebiederm.org>
	<48EB53B8.5020309@kernel.org> <48EBEE0B.6080009@kernel.org>
Date: Tue, 07 Oct 2008 17:04:15 -0700
In-Reply-To: <48EBEE0B.6080009@kernel.org> (Tejun Heo's message of "Wed, 08
	Oct 2008 08:17:31 +0900")
Message-ID: <m1k5cklzpc.fsf@frodo.ebiederm.org>
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
	*      [score: 0.2063]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, a bit of additions after some sleep.


> Heh... it did sound like a plan but I don't think the plan would solve
> the problem.  filldir can't be put in rcu read critical section.  :-p

There is srcu and there is the trick of grabbing the reference count
on the current sysfs_dirent over the filldir and dropping the rcu
lock (which works for proc).

To cut down on lock overhead from user space accesses that works.

>>> The revalidate on access model doesn't appear to have a way to track
>>> remote renames.  Something sysfs supports.
>> 
>> Yeap, IIRC, one of the reasons why sysfs wasn't converted over to
>> sysfs was because sysfs guarantees inode doesn't change over rename or
>> move so that notifications keep working over renames.
>
> s/over to sysfs/over to revalidation/ and s/inode/dentry/.  Maybe we can
> just ignore dnotify?  :-(

Well there are more cases than dnotify, there is the renaming of directories
in sysfs, although rare that I think get awkward if we use revalidation.

I'm still not certain how we can get the lock ordering so it doesn't
cause us problems.  I will look at revalidation and what the other
distributed filesystems are doing and see if that might work.  If it
doesn't we need refactor the VFS locking.

Eric
