Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZEWRwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZEWRwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 13:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZEWRwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 13:52:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36655 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725AbZEWRwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 13:52:34 -0400
Date: Sat, 23 May 2009 18:53:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Schmitt <rschmitt@bluepeach.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TTY/Serial Driver Hangs in tty_wait_until_sent, analysis, and
 recommendations
Message-ID: <20090523185338.5754e0f5@lxorguk.ukuu.org.uk>
In-Reply-To: <60483.14588.qm@web1112.biz.mail.sk1.yahoo.com>
References: <60483.14588.qm@web1112.biz.mail.sk1.yahoo.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, the console is hung.  Control C characters and Control Q characters are not processed and there is nothing you can do short of logging on through a different port and killing the shell on the console.

(or reading it from another process if you diagnosis is correct - and it
sounds so)

> I think there are two long term solutions to this: 1) have the low level serial port drivers (i.e. 8250) treat XON/XOFF out of band and have some back door into the line discipline driver to restart the serial line without needing input buffer space and 2) to change the tty_ioctl handling of a WAIT call to flush the output buffer if the port is stopped.  I figure either of these approaches alters the serial behavior enough that it is more then just a bug fix.

#2 is out of spec for the standards and pushing the flow control down
into the drivers is a major project (and very hard to do as flow control
is discipline dependant sometimes). Like a lot of the tty layer its all
quite ugly 8(

The obvious quick hack would I think be to add an optional ldisc method
that is called when new data arrives which cannot be queued due to
throttling and get to snoop on the buffer and perhaps optionally trim
bytes out of it.

If flush_to_ldisc called such a routine for those bytes that didn't fit
then something like

		if (c == START_CHAR(tty) && I_IXON(tty) && tty->stopped) {
			start_tty(tty);
			process_echoes(tty);
		}

in the ldisc handler for n_tty would uncork the bottle.


