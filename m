Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbXBDH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbXBDH5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 02:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXBDH5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 02:57:34 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1276 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbXBDH5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 02:57:32 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: O_NONBLOCK setting "leak" outside of a process??
Date: Sat, 3 Feb 2007 23:56:44 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEELOBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <200702040222.13337.vda.linux@googlemail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 23:56:58 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 23:57:00 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Easy. O_NONBLOCK should only affect whether read/write blocks or
> returns EAGAIN. It's logical for this setting to be per-process.

Sadly, that's not what POSIX says. POSIX says that 'dup' and 'fork' create
two references to the same file description and that O_NONBLOCK is a
per-file-description flag. So such an implementation would not be
POSIX-conforming.

> Currently changing O_NONBLOCK on stdin/out/err affects other,
> possibly unrelated processes - they don't expect that *their*
> reads/writes will start returning EAGAIN!

Then they're broken. Sorry, that's just the way it is. Code should always
correctly handle defined error codes. I agree that it's unexpected and
unfortunate, but you have to code defensively.

*Every* blocking fd operation should be followed by a check to see if the
operation failed, succeeded, or partially succeeded. If it partially
succeeded, it needs to be continued. If it failed, you need to check if the
error is fatal or transient. If transient, you need to back off and retry.
It has, sadly, always been this way. (Programs can get signals, debuggers
can interrupt a system call, the unexpected happens.)

> Worse, it cannot be worked around by dup() because duped fds
> are still sharing O_NONBLOCK. How can I work around this?

If this causes your code a problem, your code is broken. What does your code
currently do if it gets a non-fatal error from a blocking operation? If it
does anything other than back off and retry, it's mishandling the condition.

It is also an error to change the modes on an inherited file descriptor
unless you know for a fact that this is what the program that gave you the
file descriptor expects you to do (or that it has relinquished that
descriptor). So it takes two bugs to cause this problem.

I agree that the world might have been a better place had this been thought
about from the beginning.

DS


