Return-Path: <linux-kernel-owner+w=401wt.eu-S2992715AbXCGX0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992715AbXCGX0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965731AbXCGX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:26:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54130 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965726AbXCGX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:26:50 -0500
Subject: Re: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm
	segments
From: Adam Litke <agl@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <m1hcswbqru.fsf@ebiederm.dsl.xmission.com>
References: <20070301234608.29532.66932.stgit@localhost.localdomain>
	 <20070302002818.GF10643@holomorphy.com>
	 <m1hcswbqru.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 17:26:48 -0600
Message-Id: <1173310008.26558.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 16:03 -0700, Eric W. Biederman wrote:
> Bill Irwin <bill.irwin@oracle.com> writes:
> 
> > On Thu, Mar 01, 2007 at 03:46:08PM -0800, Adam Litke wrote:
> >>  static inline int is_file_hugepages(struct file *file)
> >>  {
> >> -	return file->f_op == &hugetlbfs_file_operations;
> >> +	if (file->f_op == &hugetlbfs_file_operations)
> >> +		return 1;
> >> +	if (is_file_shm_hugepages(file))
> >> +		return 1;
> >> +
> >> +	return 0;
> >>  }
> > ...
> >> +int is_file_shm_hugepages(struct file *file)
> >> +{
> >> +	int ret = 0;
> >> +
> >> +	if (file->f_op == &shm_file_operations) {
> >> +		struct shm_file_data *sfd;
> >> +		sfd = shm_file_data(file);
> >> +		ret = is_file_hugepages(sfd->file);
> >> +	}
> >> +	return ret;
> >
> > A comment to prepare others for the impending doubletake might be nice.
> > Or maybe just open-coding the equality check for &huetlbfs_file_operations
> > in is_file_shm_hugepages() if others find it as jarring as I. Please
> > extend my ack to any follow-up fiddling with that.
> 
> You did notice we are testing a different struct file?
> 
> > The patch addresses relatively straightforward issues and naturally at
> > that.
> 
> The whole concept is recursive so I'm not certain being a recursive check
> is that bad but I understand the point.
> 
> I think the right answer is most likely to add an extra file method or
> two so we can remove the need for is_file_hugepages.
> 
> There are still 4 calls to is_file_hugepages in ipc/shm.c and
> 2 calls in mm/mmap.c not counting the one in is_file_shm_hugepages.
> 
> The special cases make it difficult to properly wrap hugetlbfs files
> with another file, which is why we have the weird special case above.

:) Enter my remove-is_file_hugepages() patches (which I posted a few
weeks ago).  I'll rework them and repost soon.  That should help to make
all of this cleaner.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

