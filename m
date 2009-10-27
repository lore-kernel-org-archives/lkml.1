Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZJ0BHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZJ0BHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZJ0BHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:07:16 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:43277 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbZJ0BHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CoR8E8RRwA0laoOR13dKe6IV/O7miSRNU0xDyr4z3sPCxBsX+6WIMmmmi9nbYV7rvQ
         hFBfM9llCzY2Ti8DFew8yLS0mKpeZVznINzOkgaE9ioWxYCSKz3RAdRbPAiACVMuuHAu
         kta3XWul3cxRi/8HfofDlQXz/hS+03nLbf4vY=
MIME-Version: 1.0
In-Reply-To: <20091026.174525.154760254.davem@davemloft.net>
References: <20091026162011.GA3289@frolo.macqel> <4AE64031.5060105@gmail.com>
	 <20091026.174525.154760254.davem@davemloft.net>
Date: Mon, 26 Oct 2009 19:07:18 -0600
Message-ID: <51f3faa70910261807h54f05f73j48b67067ee3dde70@mail.gmail.com>
Subject: Re: [PATCH ide] : Increase WAIT_DRQ to support slow CF cards
From: Robert Hancock <hancockrwd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: phdm@macqel.be, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 6:45 PM, David Miller <davem@davemloft.net> wrote:
> From: Robert Hancock <hancockrwd@gmail.com>
> Date: Mon, 26 Oct 2009 18:34:57 -0600
>
>> This has come up before:
>>
>> http://marc.info/?l=linux-ide&m=123064513313466&w=2
>>
>> I think this timeout should not even exist. libata has no such timeout
>> (only the overall command completion timeout), and I can't find any
>> reference in current ATA specs to the device being required to raise
>> DRQ in any particular amount of time.
>
> So is the issue that, whilst we should wait for BUSY to clear,
> waiting around for DRQ is unreasonable?
>
> It seems that WAIT_DRQ is passed to ide_wait_stat() but that
> only controls how long we wait for BUSY to clear, the ATA_DRQ
> 'bad' bit we pass there only gets probed in a fixed limit loop:
>
>        for (i = 0; i < 10; i++) {
>                udelay(1);
>                stat = tp_ops->read_status(hwif);
>
>                if (OK_STAT(stat, good, bad)) {
>                        *rstat = stat;
>                        return 0;
>                }
>        }
>        *rstat = stat;
>        return -EFAULT;
>
> Therefore, if increasing WAIT_DRQ helps things for people, it's
> because the BUSY bit needs that much time to clear in these
> cases.
>
> The talking in that thread seems to state that the ATA layer
> waits only for BUSY to clear, it does not wait for DRQ.  But
> from the data we're seeing here, it is in fact BUSY which needs
> so much more time to clear so removing the DRQ bit probe to
> be more like ATA won't fix anything.

Hmm, I think you're right.. seems it expects BSY to be de-asserted
within 100ms when issuing a write, which is fairly ridiculous. Maybe
not a problem for a hard drive in typical cases, but if a CF or SSD is
in an erase cycle or something it's quite possible for this not to
work.

Of course, just jacking up the timeout may make the problem alluded to
in the comment in __ide_wait_stat more evident ("This routine should
get fixed to not hog the cpu during extra long waits"), as it just
does a tight loop polling the status with no sleeps.

libata only busy-waits for 50 microseconds, if not set then it sleeps
for 2ms and polls for another 10 microseconds, if still not set it
tries the whole thing again at 16ms intervals. Only after (typically)
30 seconds does it give up.
