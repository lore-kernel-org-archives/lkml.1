Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbXKDAIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbXKDAIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 20:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXKDAHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 20:07:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:29750 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXKDAHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 20:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=n7ySyJbn+BdZbSOiG6uCYNY0XpFcqAb3eMiG1FuTuXQkV29zd2w67pUjlhG3R7p+J0sfwFipFMQIdFizoCg962B4l25lXBt+nDVKnKHppzAbSQJT0ArDV/+KYiVrHD3/mFaCJP3RTHiiONLukuMDHwrfd62Vu3LeBWw6VrC9hdc=
Message-ID: <472D0D4A.70404@gmail.com>
Date: Sun, 04 Nov 2007 09:07:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org> <4729F8F1.4040103@gmail.com> <472B946F.4030004@gentoo.org> <472BCC18.7070503@gmail.com> <472CD3F3.7050701@gentoo.org>
In-Reply-To: <472CD3F3.7050701@gentoo.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Tejun Heo wrote:
>>> <4>ata2.00: HSM violation: eh_analyze_tf: BUSY|DRQ
>>> <3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> <3>ata2.00: cmd a0/00:00:00:0a:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data
>>> 10 in
>>> <4>         res 58/00:02:00:0a:00/00:00:00:00:00/a0 Emask 0x2 (HSM
>>> violation)
>>> <3>ata2.00: status: { DRDY DRQ }
>>> <6>ata2: soft resetting link
>>> <6>ata2.00: configured for UDMA/33
>>> <6>ata2: EH complete
>>
>> Does this patch fix the problem?
> 
> That fixes it, thanks! There is no more ugly error in dmesg, the test
> prog doesn't print any sense data, and brasero works OK too. However,
> these messages appear in the kernel log every time I run the test app
> (or when brasero does its thing):
> 
> <4>ata2.00: 10 bytes trailing data
> <4>ata2.00: 10 bytes trailing data
> <4>ata2.00: 10 bytes trailing data
> <4>ata2.00: 10 bytes trailing data
> <4>ata2.00: 10 bytes trailing data
> <4>ata2.00: 10 bytes trailing data
> <4>ata2.00: 6 bytes trailing data

Yeah, that's expected.  What's going on here is that your drive sends
full mode sense data (76bytes) regardless of allocation size in CDB but
it does honor transfer chunk set in the PACKET TF, which is set to the
same value as allocation size by Alan's patch.  So, now the drive sends
the 76 bytes in 8 chunks.  The first chunk is transferred into the sg
buffer and the following chunks are thrown away.

Previously, transfer chunk was set to 8k, so the drive claims to
transfer 76 bytes from the buegging, libata transfers leading 10 bytes
got transferred into the user buffer and throws away what's remaining.
The change caused problem because libata HSM always switches to
HSM_ST_LAST (command sequence completion) after filling the command
buffer completely.  So, throwing away is activated iff the extra data to
throw away is transfered together with the last chunk of useful data.

With the chunk size reduced to allocation size, the initial chunk fills
the data buffer completely and all the extra bytes are transfered in
separate chunks.  However, libata HSM expects command sequence to
complete after the initial chunk but the drive asserts DRQ for the next
chunk on the following interrupt, so HSM violation is triggered.

The patch modifies HSM such that it keeps throwing away extra data as
long as the drive asserts DRQ which is how IDE driver does it.

However, there's still remaining issues.  What does happen if you raise
allocation length and buffersize of the test program to 16?  ie. Change
0x0a in cmd[] to 0x10 and increase buffer[10] to buffer[16].

Thanks.

-- 
tejun
