Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbXHNWPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbXHNWPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936161AbXHNWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:00:13 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3258 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935222AbXHNWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:00:10 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: O_NONBLOCK is broken
Date: Tue, 14 Aug 2007 14:59:21 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEKAGCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200708141241.44021.vda.linux@googlemail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 14 Aug 2007 14:59:58 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 14 Aug 2007 14:59:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem is, O_NONBLOCK flag is not attached to file *descriptor*,
> but to a "file description" mentioned in fcntl manpage:
[snip]
> We don't know whether our stdout descriptor #1 is shared with
> anyone or not,
> and if we were started from shell, it typically is. That's why we try to
> restore flags ASAP.

> But "ASAP" isn't soon enough. Between setting and clearing O_NONBLOCK,
> other process which share fd #1 with us may well be affected
> by file suddenly becoming O_NONBLOCK under its feet.
>
> Worse, other process can do the same
>     fcntl(1, F_SETFL, fl | O_NONBLOCK);
>     ...
>     fcntl(1, F_SETFL, fl);
> sequence, and first fcntl can return flags with O_NONBLOCK set
> (because of
> us), and then second fcntl will set O_NONBLOCK permanently, which is not
> what was intended!
[snip]
> P.S. Hmm, it seems fcntl GETFL/SETFL interface seems to be racy:
>
>     int fl = fcntl(fd, F_GETFL, 0);
>     /* other process can muck with file flags here */
>     fcntl(fd, F_SETFL, fl | SOME_BITS);
>
> How can I *atomically* add or remove bits from file flags?

Simply put, you cannot change file flags on a shared descriptor. It is a bug
to do so, a bug that is sadly present in many common programs.

I like the idea of being able to specify blocking or non-blocking behavior
in the operation. It is not too uncommon to want to perform blocking
operations sometimes and non-blocking operations other times for the same
object and having to keep changing modes, even if it wasn't racy, is a pain.

However, there's a much more fundamental problem here. Processes need a good
way to get exclusive use of their stdin, stdout, and stderr streams and
there is no good way. Perhaps an "exclusive lock" that blocked all other
process' attempts to use the terminal until it was released would be a good
thing.

DS


