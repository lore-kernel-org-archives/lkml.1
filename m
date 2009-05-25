Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZEYAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZEYAcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZEYAcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:32:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:49234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbZEYAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:32:38 -0400
Message-ID: <4A19E721.9030103@kernel.org>
Date: Mon, 25 May 2009 09:32:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume (output with debug
 patch)
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com> <49D9D4D8.2020608@kernel.org> <49DA489E.1030801@gmail.com> <49DA5A83.2070002@kernel.org> <49DA7392.4020809@gmail.com> <49DE3BE3.80806@kernel.org> <4A17BF44.2030703@gmail.com> <4A17CF66.7070408@gmail.com>
In-Reply-To: <4A17CF66.7070408@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 00:32:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Niel Lambrechts wrote:
> Bug triggered with your patch! I played audio while suspending to try
> and increase activity  (I also removed a CD on boot), and the filesystem
> came up dirty! This was on attempt nr. 3 or 4.

Great.

Here's the problem.

 May 23 12:15:11 linux-7vph kernel: XXX scsi_eh_flush_done_q: online=1(2) noretry=2 retries=0 allowed=5 

scsi_noretry_cmd() is returning non-zero indicating that the request
shouldn't be retried and failed immediagely.  Looks like the return
value 2 is from blk_failfast_dev() which tests REQ_FAILFAST_DEV.  It's
most likely to be set in init_request_from_bio() while translating bio
flags.

cc'ing Theodore Tso.  Hello, Neil is reporting ext4 checking out after
resuming.

  http://thread.gmane.org/gmane.linux.kernel/814466/focus=817937

The origin of the problem is ATA device triggering a PHY event after
resume sequence is complete.  I still don't know why this happens but
it does on certain machines.  This in itself shouldn't be a big
problem as the device works fine after one more pass of ATA EH and the
in-flight requests would be retried.  However, for some reason, the
aborted commands seem to have REQ_FAILFAST_DEV set thus failing
immediately which, in turn, triggers ext4 errors.  Does anything ring
a bell?

Thanks.

-- 
tejun
