Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbXFBLjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbXFBLjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 07:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbXFBLjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 07:39:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:35892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXFBLjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 07:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sErNIIbJ9N0nsnP0FvuwV+d6gEhyR6OoIyfdrhxSmooXYmJpPyZPp588dV4FIKbOhlZCR5A9cb2cNEWZejlbsIizONtb9ZHSPwtNmF9YKiHzPOGg4C9wO+/Ce8fUcxl81WJSIdKMlXv/kMoHsQco0lAPAniZJLv5MWpZoTmpUI4=
Message-ID: <46612152.8040203@gmail.com>
Date: Sat, 02 Jun 2007 16:50:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>  <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com> <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>  <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>  <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com> <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org> <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org> <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com> <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org> <466058F8.4050107@pobox.com> <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org> <46606851.3060905@pobox.com>
In-Reply-To: <46606851.3060905@pobox.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff, Linus.

Jeff Garzik wrote:
> Linus Torvalds wrote:
>>
>> On Fri, 1 Jun 2007, Jeff Garzik wrote:
>>> With these old PATA devices, device reset is "six of one, half-dozen
>>> of the
>>> other."  Using SRST is the only way to kick some ATAPI devices into
>>> working:
>>> http://suif.stanford.edu/~csapuntz/blackmagic.html#reset
>>
>> Well, wouldn't it be a good thing to
>>  1) if BUSY/DRQ is set even before you try the problem, obviously skip
>> the     two polite cases, and go to #4
>>  2) try to just do an IDENTIFY  3) if that doesn't work, do a HOST
>> RESET and then try again
>>  4) if that doesn't work, do the full SRST
>>
>> (or some variation of the above).
> 
> Skipping reset means it doesn't get the device away from a state that
> the previous boot may have configured itself to... standard "I didn't do
> reset" problems you see with any hardware.  Transfer modes and
> removeable media status notification are the most notable that are left
> in a semi-random state, but there are many other minor feature bits that
> fall into this category as well.

libata configures most of the stuff, so I don't think we'll see big
surprises even if we skip SRST during probing but I agree that it's nice
to give good kicks in the devices' asses during probing.

We can try IDENTIFY/IDENTIFY_PACKET with short timeout first and then
issue reset if the device isn't in reset blacklist, but it would make
probe sequence....

 IDENTIFY -> reset -> IDENTIFY -> configure -> IDENTIFY for reval

Which doesn't seem too attractive.  We can use the result from the first
IDENTIFY for configuration but it's probably a good idea to re-read
IDENTIFY page after reset.

It would be best if we can handle these braindead SRST-impaired devices
in the common code, if that's not feasible, we should at least provide
some option to allow correct (without timeout) detection of these devices.

Thanks.

-- 
tejun

