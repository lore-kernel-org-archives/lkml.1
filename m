Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZCQUTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZCQUTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZCQUTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:19:22 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:47034 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZCQUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=WDoXfozm4QHTS6JA6+WdghhzODmX7bg+bi0L49kab0Gwp3ANy565fK3TBvgyx5boxj
         H5d2pP7ddrd44kiPS57bS5eOcBAEvE7InksNMI9cfaZDBq7a1MP0JcroWjztnO4NxelK
         UXrOKZhkaiaERLdhUhn23g85H5YcHu0ybByDg=
MIME-Version: 1.0
Date: Tue, 17 Mar 2009 13:19:18 -0700
Message-ID: <72dbd3150903171319u567fc267m36857506c024315d@mail.gmail.com>
Subject: Large write = large latency for small writes
From: David Rees <drees76@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a fairly active bug 12309 "Large I/O operations result in
slow performance and high iowait times" [1] which has gotten rather
large an unwieldy due to the number of participants and confusion due
to what appears to be multiple bugs in either the schedule or IO
request merging layers.

I encountered this bug when seeing some horrible latency on a NFS
client while the server was performing heavy IO [2] and initially
thought it was a NFS bug, but later found that NFS only makes it worse
because writes over NFS are synchronous by default.

I have a simple test case which demonstrates the huge increase in
write latency that occurs for small writes when a large disk
saturating write is also in progress [3]:

dd if=/dev/zero of=/tmp/bigfile bs=1M count=10000 conv=fdatasync &
sleep 10
time dd if=/dev/zero of=/tmp/smallfile bs=4k count=1 conv=fdatasync

On a handful of systems I have access to, it took anywhere from 6-45
seconds for the small write to complete.  Others in the bug have
reproduced this across a number of filesystems (ext3, reiserfs, ext4).
xfs in particular seems to handle this test case better than the
others.  As do systems which can sustain high write speeds.

The only way I've been able to reduce the latency to acceptable levels
is to drop vm.dirty_background_ratio and vm.dirty_ratio to 1 and 2
respectively - but even then on some systems the small write still
takes 5-7 seconds.

The systems I've been testing on are all Fedora 9 or 10 systems with
the latest kernels (basically 2.6.27.19), ext3 filesystems and various
amounts of CPU, memory and disk subsystems (but nothing too new or
fast).

Any ideas?  How much latency is acceptable with the test case?

-Dave

[1] http://bugzilla.kernel.org/show_bug.cgi?id=12309
[2] http://marc.info/?l=linux-nfs&m=123697692631683&w=2
[3] http://bugzilla.kernel.org/show_bug.cgi?id=12309#c249
