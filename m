Return-Path: <linux-kernel-owner+w=401wt.eu-S1765636AbXG0Tvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765636AbXG0Tvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761372AbXG0Tvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:51:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23000 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759893AbXG0Tvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TRe52CzNHdk1krNh4u1CrxCYrA6aOiDU0y+oCTObz1pPQtRWkRllnyW/3Ir4QqA3xl6I8RVaQ3TesE8rqF6oO2ZBe45ZfJjKSRnQAQwjsISxMnZ8BI5ZknGRzIZOF3kdKBZ7otZE2PV1uzY0ZyYJC6WW1A9swep9PzDMce3JAMs=
Message-ID: <46AA4CEA.7070400@gmail.com>
Date: Fri, 27 Jul 2007 21:52:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Char: moxa, fix and optimise empty timer
References: <31400312111566521886@wsc.cz> <20070725220826.3fdb7677.akpm@linux-foundation.org>
In-Reply-To: <20070725220826.3fdb7677.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Wed, 25 Jul 2007 23:43:29 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> moxa, fix and optimise empty timer
>>
>> don't wait and delete empty timer in empty timer function. Also fire next
>> empty timer at rounded jiffies to save power.
>>
> 
> What is actually being "fixed" here?

Lockup (see below).

>> ---
>> commit da52793b6347e8b6b048526ce2422e29b20bb335
>> tree ad0bee78e45beef89dc740f81e0606d782296542
>> parent 3a69b463dcad1ff142f46e8fb74e7dc5a092eb60
>> author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 23:42:49 +0200
>> committer Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 23:42:49 +0200
>>
>>  drivers/char/moxa.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
>> index ed76f0a..5000b3b 100644
>> --- a/drivers/char/moxa.c
>> +++ b/drivers/char/moxa.c
>> @@ -1040,14 +1040,14 @@ static void check_xmit_empty(unsigned long data)
>>  	struct moxa_port *ch;
>>  
>>  	ch = (struct moxa_port *) data;
>> -	del_timer_sync(&moxa_ports[ch->port].emptyTimer);

It's "wait until the code below me is finished". At least the _sync is buggy.

>>  	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
>>  		if (MoxaPortTxQueue(ch->port) == 0) {
>>  			ch->statusflags &= ~EMPTYWAIT;
>>  			tty_wakeup(ch->tty);
>>  			return;
>>  		}
>> -		mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
>> +		mod_timer(&moxa_ports[ch->port].emptyTimer,
>> +				round_jiffies(jiffies + HZ));
>>  	} else
>>  		ch->statusflags &= ~EMPTYWAIT;
>>  }
> 
> A call to check_xmit_empty() used to guarantee that the timer was no longer
> running (if the first `if' succeeds and the second does not), but that is

Correct me if I'm wrong, but it guaranteed nothing. When the timer function is
called (note, that check_xmit_empty is timer.function), timer base lock is held
and there is no window to schedule the timer again when its function is running.

> no longer the case.  You're sure this is correct?

I still think so.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
