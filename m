Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZBWHiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZBWHiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZBWHh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:37:58 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:39475 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZBWHh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:37:58 -0500
From: hooanon05@yahoo.co.jp
Subject: [RFC 7/8] Aufs2: mmap
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7558.1235374266@jrobl>
References: <7558.1235374266@jrobl>
Date: Mon, 23 Feb 2009 16:37:56 +0900
Message-ID: <7828.1235374676@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is my second trial to ask incorporating aufs into mainline.


mmap(2) -- File Memory Mapping
----------------------------------------------------------------------
In aufs, the file-mapped pages are shared between the file on a branch
and the virtual one in aufs by overriding vm_operation, particularly
->fault().

In aufs_mmap(),
- get and store vm_ops of the real file on a branch.
- map the file of aufs by generic_file_mmap() and set aufs's vm
  operations.

In aufs_fault(),
- get the file of aufs from the passed vma, sleep if needed.
- get the real file on a branch from the aufs file.
- a race may happen. for instance a multithreaded library. so some lock
  is implemented.
- call ->fault() in the previously stored vm_ops with setting the
  real file on a branch to vm_file.
- restore vm_file and wake_up if someone else got sleep.

When a branch is added to or deleted from aufs, the same-named file may
unveil and its contents will be replaced by the new one when a process
read(2) through previously opened file.
(Some users may not want to refresh the filedata. For such users, I
have a plan to implement a mount option 'refrof' which decides to
refresh the opened files or not. See plan.txt too.)
In this case, an already mapped file will not be updated since the
contents are a part of a process already and it should not be changed by
aufs branch manipulation. Of course, in case of the deleting branch has a
busy file, it cannot be deleted from the union.

In Unionfs, it took an approach which the memory pages mapped to
filedata are copied from the lower (real) file into the Unionfs's
virtual one and handles it by address_space operations. Recently Unionfs
changed it to this approach which aufs adopted since Jul 2006.
