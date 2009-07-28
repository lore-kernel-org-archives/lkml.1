Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbZG1TLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbZG1TLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZG1TLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:11:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7135 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZG1TLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:11:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding:x-system-of-record;
	b=F69SKA8pD1sec35Eqp/LMA6vm/+hUZzILtyozYpKdKDCIo5APKtpGUnYkmzMBahwb
	pQFw6QBcYivjOhE6keGbA==
MIME-Version: 1.0
Date: Tue, 28 Jul 2009 12:11:31 -0700
Message-ID: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
Subject: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Chad Talbott <ctalbott@google.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, wfg@mail.ustc.edu.cn, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run a simple workload on a 4GB machine which dirties a few largish
inodes like so:

# seq 10 | xargs -P0 -n1 -i\{} dd if=/dev/zero of=/tmp/dump\{}
bs=1024k count=100

While the dds are running data is written out at disk speed.  However,
once the dds have run to completion and exited there is ~500MB of
dirty memory left.  Background writeout then takes about 3 more
minutes to clean memory at only ~3.3MB/s.  When I explicitly sync, I
can see that the disk is capable of 40MB/s, which finishes off the
files in ~10s. [1]

An interesting recent-ish change is "writeback: speed up writeback of
big dirty files."  When I revert the change to __sync_single_inode the
problem appears to go away and background writeout proceeds at disk
speed.  Interestingly, that code is in the git commit [2], but not in
the post to LKML. [3]  This is may not be the fix, but it makes this
test behave better.

Thanks,
Chad

[1] I've plotted the dirty memory from /proc/meminfo and disk write
speed from iostat at
http://sites.google.com/site/cwtlinux/2-6-31-writeback-bug
[2] git commit:
http://mirror.celinuxforum.org/gitstat/commit-detail.php?commit=8bc3be2751b4f74ab90a446da1912fd8204d53f7
[3] LKML post: http://marc.info/?l=linux-kernel&m=119131601130372&w=2
