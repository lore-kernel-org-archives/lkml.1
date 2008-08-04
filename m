Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYHDQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYHDQ6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYHDQ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:57:58 -0400
Received: from nebensachen.de ([195.34.83.29]:44495 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYHDQ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:57:57 -0400
X-Hashcash: 1:20:080804:htejun@gmail.com::TNFbDlBTUN7UJY0K:04QaB
X-Hashcash: 1:20:080804:alan@lxorguk.ukuu.org.uk::zSqthHLU7twEkFer:00000000000000000000000000000000000003u4T
X-Hashcash: 1:20:080804:jeff@garzik.org::za8ng2NL/6r49c5b:007fYF
X-Hashcash: 1:20:080804:bzolnier@gmail.com::cW/3DKu8gXgaH25v:000000000000000000000000000000000000000000032V9
X-Hashcash: 1:20:080804:james.bottomley@hansenpartnership.com::rBPwiZLy4diXORMn:0000000000000000000000000+a+
X-Hashcash: 1:20:080804:pavel@ucw.cz::3IWSzAUvIj7y/UyR:000002AfH
X-Hashcash: 1:20:080804:linux-ide@vger.kernel.org::9mPr7ekPK+/TF+6G:0000000000000000000000000000000000004QI+
X-Hashcash: 1:20:080804:linux-kernel@vger.kernel.org::WPz6D5vjHwxK+fGY:0000000000000000000000000000000006ZJz
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.10413.stgit@denkblock.local>
	<4892B8FE.1070400@gmail.com> <87proooqry.fsf@denkblock.local>
	<48970E34.9000706@gmail.com>
Date: Mon, 04 Aug 2008 18:54:35 +0200
In-Reply-To: <48970E34.9000706@gmail.com> (Tejun Heo's message of "Mon, 04 Aug
	2008 23:12:04 +0900")
Message-ID: <87d4kooh4k.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Elias Oltmanns wrote:
>>> For libata, the easiest way to achieve the above would be adding a
>
>>> per-dev EH action, say, ATA_EH_UNLOAD and schedule EH w/ the action OR'd
>>> to eh_info->action.  The EH_UNLOAD handler can then issue the command
>>> wait for the specified number of seconds and continue.  This will be
>>> pretty simple to implement as command exclusion and stuff are all
>>> automatically handled by EH framework.
>> 
>> I'm rather afraid this approach is impractical or unfavourable at the
>> very least. Depending on the configured thresholds, a head unload
>> request might well be issued unintentionally, e.g. by accidentally
>> knocking against the table. It is quite alright for the HD to stop I/O
>> for a moment but if the secondary device on the interface happens to be
>> a CD writer, it will be very annoying to have CD writing operations fail
>> due to minor percussions.
>
> Why would it fail?

To be quite honest, I don't know very much about the way CD writing
works. I just assumed that delaying queue processing for a CD writer for
several seconds would have very much the same effect as the input buffer
of cdrecord getting empty prematurely. Do you mean to say that CD
writing (or any other time expensive operation I haven't thought of)
won't be affected irrecoverably by interrupted command processing?

>
>> Also, if there are two devices on the same
>> port that support the UNLOAD FEATURE and you issue a head unload request
>> to both of them in close succession, the IDLE IMMEDIATE to the second
>> device will be blocked until the timeout for the first has expired.
>
> Unload can be implemented as port-wide operation so that it issues IDLE
> IMMEDIATE to all drives on the port but given that this is mostly for
> laptop, this discussion is a bit peripheral.

We can't rule out that the HD is connected as master and CDRW as slave
to the same controller in a PATA setup. I'm not familiar with the SATA
configurations in modern laptops though.

Regards,

Elias
