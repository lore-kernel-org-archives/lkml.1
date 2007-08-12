Return-Path: <linux-kernel-owner+w=401wt.eu-S936081AbXHLQpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936081AbXHLQpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbXHLQpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:45:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52063 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbXHLQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:45:40 -0400
Date: Sun, 12 Aug 2007 18:45:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Finding out socket/pipe connectivity status
In-Reply-To: <20070812170018.6f56a0dd@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0708121808470.28963@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708121059160.28963@fbirervta.pbzchgretzou.qr>
 <20070812170018.6f56a0dd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 17:00, Alan Cox wrote:
>> when a pipe/socket is broken, the process trying to read/write to it 
>> gets SIGPIPE. Is there a way to detect whether the next read/write will 
>> trigger a SIGPIPE? select() does not seem helpful here.

>Processes that are network aware normally set SIGPIPE to SIG_IGN.
>The default behaviour comes from a desire that non aware programs
>shouldn't get stuck spinning on a network error but go away.
>
>If you ignore the signal you'll get a event from select, and then an
>error code.
>
Yes, SIGPIPE is ignored, because it just occurs at the same time I
can check read() for -1 [=too late].

>
>select considers the broken pipe an error that needs reporting
>so it goes ready.

I am in a quite awkward situation. It is about a fuse mount program
operating in xinetd mode (reading/writing to stdin/stdout). When any
of my code is called, I am already involved in a filesystem operation
(e.g. the user called `df`), so there is no point in trying to
handle a broken pipe here. For reference, my_getattr() is,
simplified:

	write(stdout, request);
	/* reference point [A] */
	read(stdin, response);

So my idea had been to launch another thread that monitors stdin for
'breakage' and unmount the fs before a user can start an operation on
myfs. So I've been trying to complete the idea to code. You say a
broken socket raises the read flag, so:

	while(1) {
		select(STDIN_FILENO+1, &read_set, NULL, NULL, NULL);
		/* check if broken */
	}

but the read flag may also raised during [A] above. So I'd have to
use locking ...

	pthread_mutex_lock(&lk);
	write(stdout, request);
	read(stdin, response);
	pthread_mutex_unlock(&lk);

and

	while(1) {
		pthread_mutex_lock(&lk);
		select(STDIN_FILENO+1, &read_set, NULL, NULL,
			&(struct timeval){0, 0});
		/* check if broken */
		pthread_mutex_unlock(&lk);
	}

this has the disadvantage that I have to use {0,0} so as to unlock
&lk ASAP, otherwise I'd be blocking the write(). Additionally, this
makes it busy-loop, which is not so good. Adding a sleep(60) is a
workaround, but I'd prefer some infinite timeout that cancels on
condition, like e.g. select with a NULL timeout.

Maybe there is a thought bug somewhere and it can be done better.
Your advice is highly appreciated,
thanks,
	Jan
-- 
