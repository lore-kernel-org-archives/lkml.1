Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXAZH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXAZH7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 02:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030806AbXAZH7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 02:59:31 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:10327 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030802AbXAZH7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 02:59:30 -0500
To: Andrew Morton <akpm@osdl.org>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH][RFC] incorrect direct io error handling (v3)
References: <87fya0nt3x.fsf@sw.ru> <20070125133405.3a4ffeda.akpm@osdl.org>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Fri, 26 Jan 2007 10:59:40 +0300
In-Reply-To: <20070125133405.3a4ffeda.akpm@osdl.org> (Andrew Morton's message of "Thu, 25 Jan 2007 13:34:05 -0800")
Message-ID: <87odomw74j.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@osdl.org> writes:

> On Wed, 24 Jan 2007 22:05:06 +0300
> Dmitriy Monakhov <dmonakhov@sw.ru> wrote:
>
>> incorrect direct io error handling (v3)
>> Changes from v2:
>>  - Remove BUG_ON(!mutex_is_locked(..)) for non blkdev.
>>  - vmtruncate() called from generic_file_aio_write().
>>  - depends on patch titled:
>>    [PATH][RFC] mm: Move common segments checks to separate function
>
> drat, I skipped that patch due to rejects, and because Nick is working on
> things in the same area.
>
[skip]
>>  	if ((written >= 0 || written == -EIOCBQUEUED) &&
>>  	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
>> @@ -2365,6 +2366,17 @@ ssize_t generic_file_aio_write(struct ki
>>  			&iocb->ki_pos);
>>  	mutex_unlock(&inode->i_mutex);
>>  
>> +	if (unlikely(ret < 0 && (file->f_flags & O_DIRECT))) {
>> +		ssize_t cnt = generic_segment_checks(nr_segs, iov, VERIFY_READ);
>> +		loff_t isize = i_size_read(inode);
>> +		/*
>> +		 * generic_file_direct_write() may have instantiated a few 
>> +		 * blocks outside i_size.  Trim these off again.
>> +		 */
>> +		if (cnt > 0 && (pos + cnt > isize))
>> +			vmtruncate(inode, isize);
>> +	}
>> +
>
> vmtruncate() really wants i_mutex to be held.  Can't we do that here?
Yepp 110% true, baaahh ..... it looks like my brain was't clear at the time i
wrote this. We have to do vmtruncate() brfore droping i_mutex , right after
__generic_file_aio_write_nolock() call , i'm sorry to waste your time. 
    

