Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYC0EU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYC0EU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 00:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYC0EUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 00:20:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYC0EUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 00:20:15 -0400
Message-ID: <47EB2052.8090100@cn.fujitsu.com>
Date: Thu, 27 Mar 2008 12:19:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: set relay file can not be read by pread(2)
References: <200803261859.m2QIx6rZ025917@hera.kernel.org> <20080326201428.95b4a3f6.akpm@linux-foundation.org>
In-Reply-To: <20080326201428.95b4a3f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 26 Mar 2008 18:59:06 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=37529fe9f62835e1c11895a1895064748b032dc1
>> Commit:     37529fe9f62835e1c11895a1895064748b032dc1
>> Parent:     05dda977f2574c3341abef9b74c27d2b362e1e3a
>> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
>> AuthorDate: Wed Mar 26 12:01:28 2008 +0100
>> Committer:  Jens Axboe <jens.axboe@oracle.com>
>> CommitDate: Wed Mar 26 12:01:28 2008 +0100
>>
>>     set relay file can not be read by pread(2)
>>     
>>     I found that relay files can be read by pread(2). I fix it,
>>     for relay files are not capable of seeking.
>>     
>>     Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>> ---
>>  kernel/relay.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/relay.c b/kernel/relay.c
>> index 4c035a8..ed3f6cf 100644
>> --- a/kernel/relay.c
>> +++ b/kernel/relay.c
>> @@ -736,7 +736,7 @@ static int relay_file_open(struct inode *inode, struct file *filp)
>>  	kref_get(&buf->kref);
>>  	filp->private_data = buf;
>>  
>> -	return 0;
>> +	return nonseekable_open(inode, filp);
>>  }
> 
> Does pread(..., ..., ..., offset=0) work correctly now?
> 
> Because if it does, then applications might be using that, and we just
> broke them.
> 
> 
> 
> 

pread(..., ..., ..., offset=0) works as read (argument offset is ignored).
and pread(..., ..., ..., offset=1)(twice or more times) works incorrectly.

Because pread gets old consumed data, and unread data is consumed too.
See following:(Other bug is shown here,  I'm making a patch for it.)

bug here:
relay file context: 0123456789

two_reader.c            gets                     correct
read(fd1, buf, 2)       01                       01
read(fd2, buf, 2)       23                       23
read(fd1, buf, 2)       23                       45
read(fd2, buf, 2)       45                       67
read(fd1, buf, 2)       45                       89
read(fd2, buf, 2)       EOF                      EOF
read(fd1, buf, 2)       EOF                      EOF
                   all unread data is consumed   all data is read

pread.c                   gets
pread(fd, buf, 2, 0)       01
pread(fd, buf, 2, 0)       23
pread(fd, buf, 2, 0)       45
pread(fd, buf, 2, 0)       67
pread(fd, buf, 2, 0)       89
pread(fd, buf, 2, 0)       EOF -- all unread data is consumed

pread.c                   gets
pread(fd, buf, 2, 1)       12
pread(fd, buf, 2, 1)       12
pread(fd, buf, 2, 1)       12
pread(fd, buf, 2, 1)       12
pread(fd, buf, 2, 1)       12
pread(fd, buf, 2, 1)       EOF -- all unread data is consumed



the simplest patch: delete one line in function relay_file_read_start_pos()

	if (!read_pos)
		read_pos = consumed * subbuf_size + buf->bytes_consumed;
----> read_pos = consumed * subbuf_size + buf->bytes_consumed;

but var read_pos should be deleted in several functions.
So I'm making a more complex patch(but the code of reading relay file is simpler).

