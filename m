Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbYDKJRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbYDKJRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYDKJRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:17:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:6746 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291AbYDKJRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iNndYic08YylMAU8CNgN00jDja4mihM/4Z289fsqAE2a5MBkK/ittA7yF7G9OuX/Li7bORvnLuMJrF6ubGxQCZeXKK3ZAwNdiSLh9a6W30ME4avrGlneY6dVfcwl/gRiKDyOdTmglMR+SqNg2waYg3HK6puUm/S127XIJlSi2ug=
Message-ID: <91b13c310804110217g1d2c3ee4p69fee6fd43f4abd2@mail.gmail.com>
Date: Fri, 11 Apr 2008 17:17:31 +0800
From: "rae l" <crquan@gmail.com>
To: linux-fsdevel@vger.kernel.org
Subject: iowait stability regressed from kernel 2.6.22 under heavy load of multi-thread aio writing/reading
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a problem with the vanilla kernel from 2.6.22 (include 23, 24):

the situation is to test a customized linux distribution under heavy IO load:
1. the client process initiates tens of POSIX threads (using
libpthread), each thread uses aio_write or aio_read(using librt)
operating
   on one small file, then close it and write another small file;
   the whole objective is to get a maxium throughput of small files,
by generating heavy aio stress on the system;

I have tested the vanilla kernel 2.6.22/23/24.y, all these kernels
have the common problem:
1. I use top, vmstat, and iostat to monitor the system performance, I
found that the iowait time of CPU is high at most time,
   above 60%, and not stable while the client process running,
although the throughput is stable, the CPU iowait time not stable;
   As a result of instability processes felt too long and unacceptable delay.
2. in seldom testing cases, the system even stopped: with bi/bo are 0
and iowait 100%, all writing processes are blocking with
   uninterruptible state (D state in ps output), these cases are all
system running after several days writing, but cannot guarantee
   to reproduce;

First I suspect the filesystem or the storage medium have problems, I
tried ext2/ext3/reiserfs/xfs, for different filesytems and
SATA/SAS, IDE disks, and several commercial hard RAID card for
different storage medium, but the bad result remained;

Then I tested 2.6.21.7 kernel, this results a stable iowait CPU time
(below 10%) but not so good throughput of small files;

Now I think the improvements of IO effciency in the development of
2.6.22 also caused the instability of iowait time, right? but how
to find out? Simple bisecting seems not work.

by the way, a question is how to guarantee a kernel not regress under
heavy multi-thread aio writing load? ltp project seems not give the
answer:
http://ltp.sourceforge.net/tooltable.php

--
Denis
