Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbYFDKKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbYFDKKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbYFDKKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:10:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57166 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYFDKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:10:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
References: <20080603131659.GA2970@damson.getinternet.no>
	<20080604014059.06b170b4.akpm@linux-foundation.org>
Date: Wed, 04 Jun 2008 03:02:18 -0700
In-Reply-To: <20080604014059.06b170b4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 4 Jun 2008 01:40:59 -0700")
Message-ID: <m1abi1tt5h.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] proc: calculate the correct /proc/<pid> link count
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 3 Jun 2008 15:16:59 +0200 Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Mon, 2 Jun 2008 08:57:45 +0200
>> Subject: [PATCH] proc: calculate the correct /proc/<pid> link count
>> 
>> commit e9720acd728a46cb40daa52c99a979f7c4ff195c

I sent a message acking the patch but it seems to have gotten lost.
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>> +static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
>> +	unsigned int n)
>> +{
>> +	unsigned int i;
>> +	unsigned int count;
>> +
>> +	count = 0;
>> +	for (i = 0; i < n; ++i) {
>> +		if (S_ISDIR(entries[i].mode))
>> +			++count;
>> +	}
>> +
>> +	return count;
>> +}
>
> I'm unable to correlate the code with the comment.  There is nothing in
> here which handles .  and ..?

Because they don't appear in the table.  It seems the comment was to make
that clear.

>> @@ -2585,10 +2602,9 @@ static struct dentry *proc_pid_instantiate(struct inode
> *dir,
>>  	inode->i_op = &proc_tgid_base_inode_operations;
>>  	inode->i_fop = &proc_tgid_base_operations;
>>  	inode->i_flags|=S_IMMUTABLE;
>> -	inode->i_nlink = 5;
>> -#ifdef CONFIG_SECURITY
>> -	inode->i_nlink += 1;
>> -#endif
>> +
>> +	inode->i_nlink = 2 + pid_entry_count_dirs(tgid_base_stuff,
>> +		ARRAY_SIZE(tgid_base_stuff));
>>  
>
> oh, can we do that?  Is it possible for some code somewhere to come
> along and add a new entry to /proc/pid which doesn't appear in
> these static tables?

Currently we do not dynamically modify the pid_entry tables.
On some days I think it would be a nice addition, to make it easier to
handle modular subsystems.  Given the number of #ifdefs we have
in those tables something more dynamic may ultimately be the way
to go.

However we still have in lookup:
	/*
	 * Yes, it does not scale. And it should not. Don't add
	 * new entries into /proc/<tgid>/ without very good reasons.
	 */
Which doesn't seem to have much impact as these directories are
slowly growing.


> I guess that doesn't happen.  In which case can we not calculate the
> unmber of directories in these two tables just a single time, at
> bootup?
>
> I think I'm missing things here...

Not much.  

Historically /proc used to be very bad with the link counts on
directories.   There was a switch statement that hard coded nlinks for
every directory, and only used the values 2 or 3.  Last time I was in
there I fixed it up so we actually returned the proper hard link
counts for the directories.  In this last conversation I realized we
could be more maintainable without a hard coded number.

Eric

