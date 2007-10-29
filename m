Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbXJ2UBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbXJ2UBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbXJ2UBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:01:11 -0400
Received: from pat.uio.no ([129.240.10.15]:44994 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbXJ2UBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:01:09 -0400
Subject: Re: [BUG] nfs: readv/writev with O_DIRECT fails on  2.6.24-rc1
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: gurudas pai <gurudas.pai@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47258C0A.2040603@oracle.com>
References: <47258C0A.2040603@oracle.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 15:59:37 -0400
Message-Id: <1193687977.7497.45.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=12.0, autolearn=disabled, AWL=-0.400)
X-UiO-Scanned: 6DBBA8942C46189AE374767F6C6CA55FCA79771B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 5 total 4792483 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-29 at 13:00 +0530, gurudas pai wrote:
> Hi,
> 
> While running olt kit on 2.6.24-rc1 over nfs , Oracle reported I/O 
> errors. I debugged little more and found that readv/writev are failing 
> with O_DIRECT on nfs ( netapp's filer).
> 
> I am able to re-produce same error using ltp/diotest5.
> 
> ./diotest5  -f /storage/nas/testfile -v 5
> 
> diotest05 1953719669  FAIL  :  readv failed: Invalid argument
> diotest05 1953719670  FAIL  :  Read with Direct IO, Write without
> diotest05 1953719671  FAIL  :  writev failed: Invalid argument
> diotest05 1953719672  FAIL  :  Write with Direct IO, Read without
> diotest05 1953719673  FAIL  :  writev failed: Invalid argument
> diotest05 1953719674  FAIL  :  Read, Write with Direct IO
> diotest05    0  INFO  :  3/3 testblocks failed
> 
>  >strace -e readv,writev ./diotest5  -f /storage/nas/testfile -v 5
> writev(3, [{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}], 5) = 20480
> readv(4, 0x8051000, 5)                  = -1 EINVAL (Invalid argument)
> diotest05 1953719669  FAIL  :  readv failed: Invalid argument
> diotest05 1953719670  FAIL  :  Read with Direct IO, Write without
> writev(3, [{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}], 5) = -1 EINVAL(Invalid argument)
> diotest05 1953719671  FAIL  :  writev failed: Invalid argument
> diotest05 1953719672  FAIL  :  Write with Direct IO, Read without
> writev(3, [{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}, {"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
> 4096}], 5) = -1 EINVAL(Invalid argument)
> diotest05 1953719673  FAIL  :  writev failed: Invalid argument
> diotest05 1953719674  FAIL  :  Read, Write with Direct IO
> diotest05    0  INFO  :  3/3 testblocks failed
> Process 4749 detached
> 
> 
> mount options:
> rw,bg,nointr,hard,timeo=600,wsize=32768,rsize=32768,nfsvers=3,tcp,actimeo=0
> 
> 
> Please let me know if I have to try test/debug patch.

Nobody has yet added support for nvec>1.

Trond

