Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYJGWgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYJGWgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYJGWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:36:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37424 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYJGWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:36:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<m163o47kc5.fsf_-_@frodo.ebiederm.org>
	<m11vys7k92.fsf_-_@frodo.ebiederm.org>
	<1223414381.31401.15.camel@nimitz>
Date: Tue, 07 Oct 2008 15:31:21 -0700
In-Reply-To: <1223414381.31401.15.camel@nimitz> (Dave Hansen's message of
	"Tue, 07 Oct 2008 14:19:41 -0700")
Message-ID: <m1tzboox52.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Hansen <dave@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/3] sysfs:  Remove lock ordering violation in sysfs_chmod_file.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> On Tue, 2008-10-07 at 03:49 -0700, Eric W. Biederman wrote:
>> It is a wee bit subtle but sysfs_get_dentry grabs inode->i_mutex.
>> of potentially all of the parents of sd.  So I can not hold
>> the inode mutex of the directory while it is called.
>
> Hi Eric,
>
> This patch looks good to me.  In my quest to parse exactly what was
> going on, I rewrote a description of the patch.  Could you look over
> this and see if I'm on target?

It sounds like you are on target.

> Before this patch, inode->i_mutex is held in order to keep the inode's
> mode and ctime from changing out underneath us.  If we didn't do this,
> you could potentially get garbage when reading them out of the old
> inode.  We calculated these new permissions once since it is redundant
> to do it several times.

Yes.  updates to mtime and ctime need to be serialized by holding
the inode semaphore.

> We also need to perform a sysfs_get_dentry() operation on the
> sysfs_dirent in order to find all the dentries on each sb.

To find the dentry for a particular sb.

> This needs
> to be performed once for each sb in which the inode appears.  "[B]ut
> sysfs_get_dentry grabs inode->i_mutex. of potentially all of the parents
> of sd.  So I can not hold the inode mutex of the directory while it is
> called."

Yes.

> This patch drops the inode->i_mutex over the entire "for each
> sysfs_dirent" loop.  It, instead, reacquires and drops it each time we
> need to calculate the new mode/ctime for the target dentries.  It does
> this away from the sysfs_get_dentry() call now.

Yes.

Eric
