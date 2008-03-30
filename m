Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYC3Mzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYC3Mzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 08:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYC3Mz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 08:55:29 -0400
Received: from mail2.hosting.nl ([62.129.139.44]:36270 "HELO mail2.hosting.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751546AbYC3Mz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 08:55:29 -0400
Message-ID: <20080330144804.wdrpaiuhz4swksw4@62.129.139.44>
Date: Sun, 30 Mar 2008 14:48:04 +0200
From: sander van ginkel <sander@van-ginkel.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptmx: adding handshake support
References: <20080311212830.5f4apfr4uqs884cc@62.129.139.44>
	<20080330140948.0cqmtqb9us880cw8@62.129.139.44>
	<20080330131652.7073589c@core>
In-Reply-To: <20080330131652.7073589c@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will test this kernel if its stable enough for my needs, and  
later this week I will move on to the latest kernel.
Further I shall look at your comments and make some corrections to my code.

One thing thats comming up to me:

>> +    case 0x5426: /* Set all of the handshake line, even the  
>> normally  read only */
>>

> Use a proper value as I said before.


I may pick the last value + 1 defined in the lib?

thanks for your input


Quoting Alan Cox <alan@lxorguk.ukuu.org.uk>:

> On Sun, 30 Mar 2008 14:09:48 +0200
> postmaster@van-ginkel.eu wrote:
>
>> This weekend I upgraded my kernel to 2.6.22.5 and tried my patch.
>> Unfortunately pty.c seems to be a slightly different, so generated a new
>> patch:
>
> Really you want to be working against 2.6.25-rc5-mm1 or later as there
> are big changes in the tty layer pending, some of which affect the
> locking on stuff like this.
>
>> +struct pty_mcrmsr {
>> +
>> +	struct semaphore        sem;            /* locks this structure */
>
> You create a lock but don't use it. Also btw the -mm tty layer has a
> ctrl_lock you could use instead.
>
>> +	/* for tiocmget and tiocmset functions */
>> +
>> +	int                     msr;            /* MSR shadow */
>> +	int                     mcr;            /* MCR shadow */
>
> Could be one value using the existing bit masks.
>
>> +	mcrmsr = kmalloc(sizeof(*mcrmsr), GFP_KERNEL);
>> +
>> +	init_MUTEX(&mcrmsr->sem);
>
> Crashes on allocation failure
>
>> +	if (tty->driver_data != NULL) {
>> +		msr = mcrmsr->msr;
>> +		mcr = mcrmsr->mcr;
>> +	}
>
> Always true
>
>> +
>> +	result = ((mcr & 0x01)  ? TIOCM_DTR  : 0) |  /* DTR is set */
>> +		((mcr & 0x02)  ? TIOCM_RTS  : 0) |  /* RTS is set */
>> +		((mcr & 0x04)  ? TIOCM_LOOP : 0) |  /* LOOP is set */
>> +		((msr & 0x08)  ? TIOCM_CTS  : 0) |  /* CTS is set */
>> +		((msr & 0x10)  ? TIOCM_CAR  : 0) |  /* Carrier detect is set*/
>> +		((msr & 0x20)  ? TIOCM_RI   : 0) |  /* Ring Indicator is set */
>> +		((msr & 0x40)  ? TIOCM_DSR  : 0);   /* DSR is set */
>
> Use the mcr/msr bits as is and you don't need this mess
>
>> +	if (set & TIOCM_DTR)
>> +		mcr |= 0x01;
>> +	if (set & TIOCM_RTS)
>> +		mcr |= 0x02;
>> +	if (set & TIOCM_LOOP)
>
> Ditto
>
>> +	/* set the new MCR value in the device */
>> +
>> +	if (tty->driver_data != NULL)
>> +		mcrmsr->mcr=mcr;
>
> That may cause wakeups, open, hangup etc to occur - does that need to be
> considered here.
>
>> +	case 0x5426: /* Set all of the handshake line, even the normally
>> read only */
>
> Use a proper value as I said before.
>
>
>
>



