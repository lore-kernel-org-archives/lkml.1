Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZGVB7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZGVB7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZGVB7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:59:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54893 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZGVB7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:59:31 -0400
Message-ID: <4A667218.7040105@redhat.com>
Date: Wed, 22 Jul 2009 09:57:44 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <6599ad830907210903q7206cac2l83a9139d19c5e1a@mail.gmail.com>
In-Reply-To: <6599ad830907210903q7206cac2l83a9139d19c5e1a@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050805030304000303050602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050805030304000303050602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/22/2009 12:03 AM, Paul Menage wrote:
> On Tue, Jul 21, 2009 at 3:25 AM, Xiaotian Feng<dfeng@redhat.com>  wrote:
>> In cgroup_get_sb, the lock sequence is:
>>         mutex_lock(&inode->i_mutex);
>>         mutex_lock(&cgroup->mutex);
>> so the last unlock sequence should be:
>
> Make this "so for consistency the last ..." ?
>
> Maybe make the patch title "Make unlock sequence in cgroup_get_sb
> consistent" so someone looking through the change logs for fixes to
> backport doesn't wrongly thing that this fixes any bug"?
>

Yep, this is a trivial patch.  Modified following your suggestion, thank 
you.

>>         mutex_unlock(&cgroup->mutex);
>>         mutex_unlock(&inode->i_mutex);
>>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>
> Acked-by: Paul Menage<menage@google.com>
>
> Paul


--------------050805030304000303050602
Content-Type: text/x-patch;
 name="0001-cgroup-make-unlock-sequence-in-cgroup_get_sb-consistent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-cgroup-make-unlock-sequence-in-cgroup_get_sb-consistent";
 filename*1=".patch"

>From ff96b0dc4a5f06a0e5b7f8dfa5df2b93e993302c Mon Sep 17 00:00:00 2001
From: Xiaotian Feng <dfeng@redhat.com>
Date: Tue, 21 Jul 2009 18:06:43 +0800
Subject: [PATCH] cgroup: make unlock sequence in cgroup_get_sb consistent

Make the last unlock sequence consistent with previous unlock sequeue.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3737a68..11ef162 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1140,8 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		BUG_ON(root->number_of_cgroups != 1);
 
 		cgroup_populate_dir(root_cgrp);
-		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
+		mutex_unlock(&inode->i_mutex);
 	}
 
 	simple_set_mnt(mnt, sb);
-- 
1.6.2.5


--------------050805030304000303050602--
