Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZEUIEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZEUIEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 04:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZEUIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 04:04:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57052 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZEUIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 04:04:07 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>
	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org>
	<4A15046A.10106@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 01:04:04 -0700
In-Reply-To: <4A15046A.10106@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 16\:36\:10 +0900")
Message-ID: <m1octm287f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4664]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of directories with subdirectories
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>>> I agree we should be heading this way but what happens to attributes
>>> or directories living below the subdirectories?  If it's gonna handle
>>> recursive case, I think it better do it properly.  I had patches of
>>> similar effect.
>> 
>> I do handle it properly.  sysfs_get_one finds the deepest child of the
>> first directory entry.  Then I remove it.  And I repeat until done.
>> 
>> The locking is correct, something that is much more difficult to
>> tell with your version.
>
> Why? :-)

Because mine is all in a single place and there is no optimization
to get locks I don't need.

Unless I have misread your patch you are failing to get the
i_mutex for child directories, if it possible to get it.

Something that it is trivial to see that I always do correctly.
Simply because the distance between the lock and where I depend on
it is so small.

>> By grabbing and dropping the sysfs_mutex things are simpler, and they
>> get even simpler in future patches.
>> 
>> Now looking at that code in detail there is a question of what happens if
>> we add a directory entry while we are recursively deleting a directory.
>> Neither your patch, my patch, nor the existing code handle that case
>> (assuming the sysfs_dirent) was looked up before it is removed from it's
>> parent directory.  I expect another patch is called for to plug that
>> theoretical gap.  
>> 
>> I expect the way to close that hole is to have an extra flag that says
>> we are removing a directory entry and refuse to add if that flag is
>> set.
>> 
>> I would prefer to only remove empty directories.  But when I
>> instrumented things up I found cases where that does indeed happen.
>
> IIRC, my version did the whole thing while holding sysfs_mutex, so
> it's safe against such races.  I can't really see why ops like this
> can't be atomic in sysfs.  I don't really care how things are done but
> please make it atomic.

Nope.  Holding the sysfs_mutex does not make you safe from such races.
It actually makes you more prone to someone adding a directory entry to
a deleted directory and not having it deleted.  I have a chance of
deleting the added directory entry.

The problem is that sysfs_add_one takes to sysfs_dirents.  The look up
of the directory is done before we take the sysfs_mutex.  So the
sysfs_dirent could be grabbed at any time.

Eric
