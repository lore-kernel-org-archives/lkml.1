Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbYJ0H6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbYJ0H6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYJ0H6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:58:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13699 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYJ0H6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:58:24 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix possible chmod/truncate race condition.
References: <m33aixy7ls.fsf@dmon-lap.sw.ru>
	<20081026203713.c00e69db.akpm@linux-foundation.org>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 27 Oct 2008 10:57:15 +0300
In-Reply-To: <20081026203713.c00e69db.akpm@linux-foundation.org> (Andrew Morton's message of "Sun\, 26 Oct 2008 20\:37\:13 -0700")
Message-ID: <m31vy2bhd0.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 15 Oct 2008 23:35:27 +0400 Dmitri Monakhov <dmonakhov@openvz.org> wrote:
>
>> 
>> Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/open.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/open.c b/fs/open.c
>> index 07da935..3423b94 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -214,10 +214,9 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
>>  		newattrs.ia_valid |= ATTR_FILE;
>>  	}
>>  
>> +	mutex_lock(&dentry->d_inode->i_mutex);
>>  	/* Remove suid/sgid on truncate too */
>>  	newattrs.ia_valid |= should_remove_suid(dentry);
>> -
>> -	mutex_lock(&dentry->d_inode->i_mutex);
>>  	err = notify_change(dentry, &newattrs);
>>  	mutex_unlock(&dentry->d_inode->i_mutex);
>>  	return err;
>
> OK, I give up.  What race?
i_mode read not protected by i_mutex in should_remove_suid() and we
may have race condition with chown(). Sorry, seems I've been too crazy
about this. The truth is:
1: No one will call truncate() and chown() concurrently.
2: This race is still possible regardless to this fix.
