Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZBWHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZBWHg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZBWHgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:36:49 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:39456 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZBWHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:36:49 -0500
From: hooanon05@yahoo.co.jp
Subject: [RFC 5/8] Aufs2: wbr_policy
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7558.1235374266@jrobl>
References: <7558.1235374266@jrobl>
Date: Mon, 23 Feb 2009 16:36:47 +0900
Message-ID: <7805.1235374607@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is my second trial to ask incorporating aufs into mainline.


Policies to Select One among Multiple Writable Branches
----------------------------------------------------------------------
When the number of writable branch is more than one, aufs has to decide
the target branch for file creation or copy-up. By default, the highest
writable branch which has the parent (or ancestor) dir of the target
file is chosen (top-down-parent policy).
By user's request, aufs implements some other policies to select the
writable branch, for file creation two policies, round-robin and
most-free-space policies. For copy-up three policies, top-down-parent,
bottom-up-parent and bottom-up policies.

As expected, the round-robin policy selects the branch in circular. When
you have two writable branches and creates 10 new files, 5 files will be
created for each branch. mkdir(2) systemcall is an exception. When you
create 10 new directories, all will be created on the same branch.
And the most-free-space policy selects the one which has most free
space among the writable branches. The amount of free space will be
checked by aufs internally, and users can specify its time interval.

The policies for copy-up is more simple,
top-down-parent is equivalent to the same named on in create policy,
bottom-up-parent selects the writable branch where the parent dir
exists and the nearest upper one from the copyup-source,
bottom-up selects the nearest upper writable branch from the
copyup-source, regardless the existence of the parent dir.

There are some rules or exceptions to apply these policies.
- If there is a readonly branch above the policy-selected branch and
  the parent dir is marked as opaque (a variation of whiteout), or the
  target (creating) file is whiteout-ed on the upper readonly branch,
  then the result of the policy is ignored and the target file will be
  created on the nearest upper writable branch than the readonly branch.
- If there is a writable branch above the policy-selected branch and
  the parent dir is marked as opaque or the target file is whiteouted
  on the branch, then the result of the policy is ignored and the target
  file will be created on the highest one among the upper writable
  branches who has diropq or whiteout. In case of whiteout, aufs removes
  it as usual.
- link(2) and rename(2) systemcalls are exceptions in every policy.
  They try selecting the branch where the source exists as possible
  since copyup a large file will take long time. If it can't be,
  ie. the branch where the source exists is readonly, then they will
  follow the copyup policy.
- There is an exception for rename(2) when the target exists.
  If the rename target exists, aufs compares the index of the branches
  where the source and the target exists and selects the higher
  one. If the selected branch is readonly, then aufs follows the
  copyup policy.
