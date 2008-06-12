Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYFLDHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYFLDHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 23:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYFLDG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 23:06:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:56330 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbYFLDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 23:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=skLAUclWT3ccfF4kCZSFRCMCrZgOddCtF3ufDjj/g8XSU2KGBE8/h/TDS7R66P6UBu
         wEKJtYdgfWaMD90BalwRj7r2kLcpDB4x84gW3179Cwd5agFueWniTB3WKd7l0VmQZTzk
         pSoOmW6lTdeZiz+cV35l/7WhtYFksTWzDIJQU=
Message-ID: <485092C9.3050309@gmail.com>
Date: Thu, 12 Jun 2008 12:06:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Prevent busy looping
References: <20080416151305.8788.63912.stgit@denkblock.local>	<20080416163152.GK12774@kernel.dk>	<87r6d5l9pb.fsf@denkblock.local>	<20080417071335.GR12774@kernel.dk>	<87ve2gc1bn.fsf@denkblock.local>	<484F7A8D.1040809@gmail.com> <20080611080502.4aa43980@core> <484F86D4.8050907@gmail.com>
In-Reply-To: <484F86D4.8050907@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Alan Cox wrote:
>>> Elias's synthetic test case triggered infinite loop because it wasn't
>>> a proper ->qc_defer().  ->qc_defer() should never defer commands when
>>> the target is idle.
>> Target or host ? We *do* defer commands in the case of an idle channel
>> when dealing with certain simplex controllers that can only issue one
>> command per host not one per cable (and in fact in the general case we
>> can defer commands due to activity on the other drive on the cable).
> 
> The term was confusing.  I used target to mean both device
> (ATA_DEFER_LINK) and host (ATA_DEFER_PORT).  Hmmm... in simplex case,
> yeah, blocked counters need to be > 1.  We'll need to increase blocked
> counts after all.  I'll test blocked counts of 2 w/ PMP and make sure it
> doesn't incur unnecessary delays and post the patch.

Setting blocked counts to 2 makes simplex scheduling starve one of the
drives.  When a drive loses competition, it retries only after plug
delay and of course it loses most of the time.  For now, it seems we'll
have to live with busy loops (which doesn't lock up the machine) for
simplex controllers.  Ewww... :-(

-- 
tejun
