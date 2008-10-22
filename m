Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYJVBys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYJVBys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYJVByj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:54:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:45114 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYJVByj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:54:39 -0400
Message-ID: <48FE87CF.4040007@windriver.com>
Date: Tue, 21 Oct 2008 20:54:23 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] kgdboc, tty: use tty open to start low level drivers
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com><1224616493-23237-2-git-send-email-jason.wessel@windriver.com><1224616493-23237-3-git-send-email-jason.wessel@windriver.com><1224616493-23237-4-git-send-email-jason.wessel@windriver.com><1224616493-23237-5-git-send-email-jason.wessel@windriver.com><1224616493-23237-6-git-send-email-jason.wessel@windriver.com> <20081021234728.6853beee@lxorguk.ukuu.org.uk>
In-Reply-To: <20081021234728.6853beee@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 01:54:23.0789 (UTC) FILETIME=[1B7615D0:01C933E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 21 Oct 2008 14:14:51 -0500
> Jason Wessel <jason.wessel@windriver.com> wrote:
>
>> +        unlock_kernel();
>> +    } else {
>> +        tty = tty_driver_lookup_tty(driver, NULL, tty_line);
>> +        if (!tty) {
>> +            tty = tty_init_dev(driver, tty_line, 0);
>> +            inc_tty = 0;
>> +        }
>> +        (*filp)->private_data = tty;
>> +        ret = tty->ops->open(tty, *filp);
>
> and with the error paths wrong
>
>
> This is to put it bluntly just horrible.
>

Yeah, I'd say it is pretty horrible too, but this the only API that
exists presently and it is not at all obvious how to use it.

I am fine with keeping it out of the tree, IE this patch is dropped
from merge consideration for now.  It is obvious that it is a moving
target because the patch to 2.6.27 looked different than 2.6.28.  Even
with it out of the tree I am interested in fixing the "error paths"
you mentioned.  Perhaps in this case the return of tty_init_dev()
needed further checking and that was what you were stating is incorrect?

> Really kgdb, console and other boot processes need an abstraction for tty
> device ports at the device (not ldisc) level and until that work is done
> there is no acceptable way to sort this out. Merging gunk like this will
> simply make the existing mess worse and provide more crap that will make
> it harder to fix properly.

If there is another API, please point me to it.  I am not aware of how
to get uart startup code to run without going through the
tty->ops->open().  The kgdboc module has only a generic high level
interface and makes use of only the high level tty calls.  The
debugger's needs are the same as the console and the user space.  The
early debug is still a special case, but in the ideal world there
would be a way to hand off from early debug into the struct tty_port
at the point that console_init() is called.

>
> All this stuff needs revisiting when every tty device side object in the
> kernel contains a struct tty_port, until then it's a nasty (perhaps
> neccessary for the moment) hack that belongs out of tree.

Let me know when we get closer to that stage, as I am interested in
figuring out how to have a uniform way to share the hardware between
the polled and interrupt drive contexts.

Thanks,
Jason.

