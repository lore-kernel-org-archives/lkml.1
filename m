Return-Path: <linux-kernel-owner+w=401wt.eu-S965707AbXCGXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707AbXCGXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbXCGXDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:03:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38591 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965707AbXCGXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:03:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Adam Litke <agl@us.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
References: <20070301234608.29532.66932.stgit@localhost.localdomain>
	<20070302002818.GF10643@holomorphy.com>
Date: Wed, 07 Mar 2007 16:03:17 -0700
In-Reply-To: <20070302002818.GF10643@holomorphy.com> (Bill Irwin's message of
	"Thu, 1 Mar 2007 16:28:18 -0800")
Message-ID: <m1hcswbqru.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin <bill.irwin@oracle.com> writes:

> On Thu, Mar 01, 2007 at 03:46:08PM -0800, Adam Litke wrote:
>>  static inline int is_file_hugepages(struct file *file)
>>  {
>> -	return file->f_op == &hugetlbfs_file_operations;
>> +	if (file->f_op == &hugetlbfs_file_operations)
>> +		return 1;
>> +	if (is_file_shm_hugepages(file))
>> +		return 1;
>> +
>> +	return 0;
>>  }
> ...
>> +int is_file_shm_hugepages(struct file *file)
>> +{
>> +	int ret = 0;
>> +
>> +	if (file->f_op == &shm_file_operations) {
>> +		struct shm_file_data *sfd;
>> +		sfd = shm_file_data(file);
>> +		ret = is_file_hugepages(sfd->file);
>> +	}
>> +	return ret;
>
> A comment to prepare others for the impending doubletake might be nice.
> Or maybe just open-coding the equality check for &huetlbfs_file_operations
> in is_file_shm_hugepages() if others find it as jarring as I. Please
> extend my ack to any follow-up fiddling with that.

You did notice we are testing a different struct file?

> The patch addresses relatively straightforward issues and naturally at
> that.

The whole concept is recursive so I'm not certain being a recursive check
is that bad but I understand the point.

I think the right answer is most likely to add an extra file method or
two so we can remove the need for is_file_hugepages.

There are still 4 calls to is_file_hugepages in ipc/shm.c and
2 calls in mm/mmap.c not counting the one in is_file_shm_hugepages.

The special cases make it difficult to properly wrap hugetlbfs files
with another file, which is why we have the weird special case above.

Eric
