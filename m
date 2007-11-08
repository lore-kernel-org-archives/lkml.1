Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbXKHQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbXKHQoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbXKHQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:44:08 -0500
Received: from mailgw.infracomspa.it ([217.12.183.244]:3300 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760331AbXKHQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:44:07 -0500
Message-ID: <47333CCF.1050403@infracomspa.it>
Date: Thu, 08 Nov 2007 17:43:59 +0100
From: Roberto Oppedisano <roppedisano@infracomspa.it>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
References: <4731C86B.1040704@infracomspa.it> <20071107121355.5eaf4496.akpm@linux-foundation.org>
In-Reply-To: <20071107121355.5eaf4496.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 11/08/2007 05:43:59 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 08/11/2007 17.44.06,
	Serialize complete at 08/11/2007 17.44.06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote, On 11/07/2007 09:13 PM:
>> On Wed, 07 Nov 2007 15:15:07 +0100 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
>> Hello.
>> I noticed that after suspending to ram the DVD-ROM/CDRW
>> drive in no more recognized on my laptop. Looking at dmesg
>> after suspend i found:
>>
>> [    5.313446] ata2.00: _GTF unexpected object type 0x1
>> [    5.313453] ata2.00: ACPI on devcfg failed the second time, disabling 
>> (errno=-22)
>> [    5.313457] ata2.00: revalidation failed (errno=1)
>> [    5.313459] ata2.00: disabled
>>
>>
>> Not sure when the bug was introduced or if it has been always been there
>> (but I can investigate if needed).
>>
>> More details on request.
>>
>> Following dmesg pre and after suspend.
> Yes, it would be useful if you could work ot whether this worked OK in an
> earlier kernel, thanks.
Hello Andrew.
The bug has been recently added.

I did a git-bisect, but the result is probably not completely useful,
because many kernel did non build with my config, and I marked them as bad.
Anyway here's the output of git-bisect:

rao@infra-bb:/usr/src/linux-2.6$ git bisect bad
99874d50481c093adfe74e796436024d88b6a48c is first bad commit
commit 99874d50481c093adfe74e796436024d88b6a48c
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Oct 12 12:50:41 2007 +0200

    [BLOCK] Only include the compat ioctl code if CONFIG_BLOCK is set

    Add an extra CONFIG_BLOCK_COMPAT that we can use in the Makefile

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

:040000 040000 f88b7b0e496edb8fbdd4bc74abd1a742a6a1d6d9
32ead3bd57b52a664cc8ccb662195041868d7632 M      block


Following the output of git-bisect log, hand edited by me to tag the one
that did non build.

git-bisect start
# good: [fa285a3d7924a0e3782926e51f16865c5129a2f7] Linux 2.6.20
git-bisect good fa285a3d7924a0e3782926e51f16865c5129a2f7
# bad: [9aae299f7fd1888ea3a195cfe0edef17bb647415] Linux 2.6.24-rc2
git-bisect bad 9aae299f7fd1888ea3a195cfe0edef17bb647415
# good: [16cefa8c3863721fd40445a1b34dea18cd16ccfe] Merge
git://git.linux-nfs.org/pub/linux/nfs-2.6
git-bisect good 16cefa8c3863721fd40445a1b34dea18cd16ccfe
# good: [dd6d1844af33acb4edd0a40b1770d091a22c94be] Merge branch
'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git-bisect good dd6d1844af33acb4edd0a40b1770d091a22c94be
# bad: [af767cbdd78f293485c294113885d95e7f1da123] hugetlb: fix dynamic
pool resize failure case
git-bisect bad af767cbdd78f293485c294113885d95e7f1da123
# bad: [efefc6eb38d43b8e5daef482f575d767b002004e] Merge
master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6 - ONLY A
GUESS DID NOT COMPILE
git-bisect bad efefc6eb38d43b8e5daef482f575d767b002004e
# good: [038a5008b2f395c85e6e71d6ddf3c684e7c405b0] Merge branch 'master'
of git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect good 038a5008b2f395c85e6e71d6ddf3c684e7c405b0
# good: [e86908614f2c7fec401827e5cefd7a6ea9407f85] Merge branch 'master'
of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc
git-bisect good e86908614f2c7fec401827e5cefd7a6ea9407f85
# bad: [4d5709a7b7d54fc5882d2943a14988a92d48c00a] Merge
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq - ONLY A GUESS
DID NOT COMPILE
git-bisect bad 4d5709a7b7d54fc5882d2943a14988a92d48c00a
# good: [f26e51f67ae6a75ffc57b96cf5fe096f75e778cb] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw
git-bisect good f26e51f67ae6a75ffc57b96cf5fe096f75e778cb
# bad: [a6e3d7dba92e19acffaa36aad962741a762aa8c5] Merge branch
'upstream-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2 - ONLY A
GUESS DID NOT COMPILE
git-bisect bad a6e3d7dba92e19acffaa36aad962741a762aa8c5
# good: [5b6a3a2b4a5f071d170f8122038dd647a84810a8] ocfs2: Write support
for directories with inline data
git-bisect good 5b6a3a2b4a5f071d170f8122038dd647a84810a8
# bad: [408af0dab78ef4145203b849d6bfd3195f6e3ec9] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc
- ONLY A GUESS DID NOT COMPILE
git-bisect bad 408af0dab78ef4145203b849d6bfd3195f6e3ec9
# good: [000233e4d1321e54033d097e98f6868b11614217] Merge branch 'master'
of git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect good 000233e4d1321e54033d097e98f6868b11614217
# bad: [b018fc09498f73da0014b44acbd59ea4a94300b4] [BLOCK] s390 xpram typo
git-bisect bad b018fc09498f73da0014b44acbd59ea4a94300b4
# good: [43d28d98bed372649060ef783719b426a91972ed] [BLOCK] Better fix
for do_blk_trace_setup() for !CONFIG_BLOCK
git-bisect good 43d28d98bed372649060ef783719b426a91972ed
# bad: [99874d50481c093adfe74e796436024d88b6a48c] [BLOCK] Only include
the compat ioctl code if CONFIG_BLOCK is set - ONLY A GUESS DID NOT COMPILE
git-bisect bad 99874d50481c093adfe74e796436024d88b6a48c


If needed I can do further investigation, changing the assumption of
efefc6eb38d43b8e5daef482f575d767b002004e to good and see if the bisect
points to a different commit.

R.
