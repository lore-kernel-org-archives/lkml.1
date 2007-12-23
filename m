Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXLWDLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXLWDLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 22:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXLWDL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 22:11:27 -0500
Received: from outlb3.dejazzd.com ([66.109.229.70]:22142 "EHLO
	smtp.dejazzd.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbXLWDL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 22:11:26 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Message-id: <476DD1D6.50500@videon-central.com>
Date: Sat, 22 Dec 2007 22:11:18 -0500
From: "Cory T. Tusar" <ctusar@videon-central.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071219)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH] tty: Fix logic change introduced by
 wait_event_interruptible_timeout()
References: <476AE109.5070005@videon-central.com>
 <20071221224547.34066a6a.akpm@linux-foundation.org>
In-reply-to: <20071221224547.34066a6a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 20 Dec 2007 16:39:21 -0500 "Cory T. Tusar" <ctusar@videon-central.com> wrote:
> 
>> tty: Fix logic change introduced by wait_event_interruptible_timeout()
>>
>> Commit 5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8 introduced a subtle logic
>> change in tty_wait_until_sent().  The original version would only error
>> out of the 'do { ... } while (timeout)' loop if signal_pending() evaluated
>> to true; a timeout or break due to an empty buffer would fall out of the
>> loop and into the tty->driver->wait_until_sent handling.  The current
>> implementation will error out on either a pending signal or an empty
>> buffer, falling through to the tty->driver->wait_until_sent handling
>> only on a timeout.
>>
>> This change reverts the logic flow in tty_wait_until_sent() to match that
>> prior to the aforementioned commit.
>>
>> Signed-off-by: Cory T. Tusar <ctusar@videon-central.com>
>>
>> ---
>> Please CC me on any replies; I'm not subscribed to lkml.  Thanks.
>>
>>  drivers/char/tty_ioctl.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
>> index 1bdd2bf..e02d592 100644
>> --- a/drivers/char/tty_ioctl.c
>> +++ b/drivers/char/tty_ioctl.c
>> @@ -62,7 +62,7 @@ void tty_wait_until_sent(struct tty_struct * tty, long timeout)
>>  	if (!timeout)
>>  		timeout = MAX_SCHEDULE_TIMEOUT;
>>  	if (wait_event_interruptible_timeout(tty->write_wait,
>> -			!tty->driver->chars_in_buffer(tty), timeout))
>> +			!tty->driver->chars_in_buffer(tty), timeout) < 0)
>>  		return;
>>  	if (tty->driver->wait_until_sent)
>>  		tty->driver->wait_until_sent(tty, timeout);
> 
> OK...  So what are the user-visible effects of this regression?  The caller
> will run ->wait_until_sent() even after being signalled?  So the signal is
> not promptly responded to?

No, the ->wait_until_sent() will not be reached if the buffer empties
before timeout jiffies have elapsed.  This behavior differs from that
prior to commit 5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8.

I turned this up while using a little serial download utility to
bootstrap an ARM-based eval board.  The util worked fine on 2.6.22.x,
but consistently failed on 2.6.23.x.  Once I'd determined that, I
narrowed things down with git bisect, and found the above difference
in logic in tty_wait_until_sent() by inspection.

If you'd like a more in-depth analysis of what's breaking on the
user-space side, I can certainly investigate further and (hopefully) come
up with a simple test case that tickles this issue.


-- 
Cory T. Tusar
Embedded Systems Engineer
Videon Central, Inc.
2171 Sandy Drive
State College, PA 16803
(814) 235-1111 x316
(814) 235-1118 fax


"There are two ways of constructing a software design.  One way is to
 make it so simple that there are obviously no deficiencies, and the
 other way is to make it so complicated that there are no obvious
 deficiencies."  --Sir Charles Anthony Richard Hoare

