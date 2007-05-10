Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXEJNJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXEJNJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXEJNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:09:13 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:26428 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbXEJNJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cAy6W9ATAgDx2M4wJw0ZXw6lN9mi3zhWvz+WZskchfG4YaUjKoeu12heA135E4+xYF5p0BlYWcf4iUWHNRjHOvBq/hli4baeXmKqebse0oypR8RILoOx+4EN+HbFj+bMwrC5biB3T8wa5m7Kajhbi6vf8n21yCrz8GWZRBohZ7o=
Message-ID: <4643196B.7070806@gmail.com>
Date: Thu, 10 May 2007 15:08:59 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: libata reset-seq merge broke sata_sil on sh
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org>
In-Reply-To: <20070510124645.GA18534@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> Yes, it's spun down at boot. I'll get the logs with the timestamps and
> the results of the mdelay() incrementing in the morning when I've got the
> board handy again.

I see.  That's where the expected initial prereset failure comes from.

> On Thu, May 10, 2007 at 01:53:48PM +0200, Tejun Heo wrote:
>> * According to the report, things still work till 27c78b37 - commit for
>> the actual merge and there's no related change till the current master
>> from there.  So, which commit actually breaks detection?  Or is
>> detection just flaky after b8cffc6a?
>>
> The detection is simply flaky after that point, however before the
> current master it never hit the 35 second point (and thus never implied
> that the link was down). I'll double check the bisect log to see if there
> was anything beyond that that may have caused it.
> 
> The -ENODEV at least implies that the SRST fails, so at least that's a
> starting point.

If prereset() fails to get the initial DRDY before 10secs, it assumes
something went wrong and escalates to hardreset.  sil family of
controllers report 0xff status while the link is broken and it seems
that your particular drive needs more than the current 150ms to recover
phy link.  It probably went unnoticed till now because the device was
never hardreset before.  If the diagnosis is correct, increasing the
delay in hardreset should fix the problem.  Well, let's see.  :-)

> One other curious thing is that it seems to misreport the IRQ. In this
> case the log indicates 0, whereas it's actually on IRQ 66. When the
> system is booted, /proc/interrupts reflects that sata_sil is on the
> proper IRQ (even when it's reported as 0 in the boot printk()).

That's somthing I've missed during init model conversion.  It's just
printk problem.  I'll fix it.

Thanks.

-- 
tejun
