Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZBDWEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZBDWEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZBDWEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:04:33 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:45096 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbZBDWEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:04:32 -0500
Date: Wed, 4 Feb 2009 14:04:28 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Cannot use SHM_HUGETLB as a regular user
Message-ID: <20090204220428.GA6794@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a regular user cannot shmget more than 64k of memory using hugetlb!!
Atleast if we go by Documentation/vm/hugetlbpage.txt

Quote Documentation/vm/hugetlbpage.txt:

"Users who wish to use hugetlb page via shared memory segment should be a
member of a supplementary group and system admin needs to configure that
gid into /proc/sys/vm/hugetlb_shm_group."

However, setting up hugetlb_shm_group with the right gid does not work!
Looks like hugetlb uses mlock based rlimits which cause shmget
with SHM_HUGETLB to fail with -ENOMEM.  Setting up right rlimits for mlock
through /etc/security/limits.conf works though (regardless of
hugetlb_shm_group).

I understand most oracle users use this rlimit to use largepages.
But why does this need to be based on mlock!? We do have shmmax and shmall
to restrict this resource.

As I see it we have the following options to fix this inconsistency:

1. Do not depend on RLIMIT_MEMLOCK for hugetlb shm mappings.  If a user
   has CAP_IPC_LOCK or if user belongs to /proc/sys/vm/hugetlb_shm_group,
   he should be able to use shm memory according to shmmax and shmall OR
2. Update the hugetlbpage documentation to mention the resource limit based
   limitation, and remove the useless /proc/sys/vm/hugetlb_shm_group sysctl

Which one is better?  I am leaning towards 1. and have a patch ready for 1.
but I might be missing some historical reason for using RLIMIT_MEMLOCK with
SHM_HUGETLB.

Thanks,
Kiran
