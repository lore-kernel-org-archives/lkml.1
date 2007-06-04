Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXFDUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXFDUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXFDUd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:33:57 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4519 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXFDUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:33:56 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: slow open() calls and o_nonblock
Date: Mon, 4 Jun 2007 13:32:53 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGECFEFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 04 Jun 2007 13:33:25 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 04 Jun 2007 13:33:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Aaron Wiebe wrote:


> David Schwartz wrote:

> > There is no way you can re-try the request. The open must
> > either succeed or
> > not return a handle. It is not like a 'read' operation that has
> > an "I didn't
> > do anything, and you can retry this request" option.

> > If 'open' returns a file handle, you can't retry it (since it
> > must succeed
> > in order to do that, failure must not return a handle). If you 'open'
> > doesn't return a file handle, you can't retry it (because,
> > without a handle,
> > there is no way to associate a future request with this one, if
> > it creates a
> > file, the file must not be created if you don't call 'open' again).

> I understand, but this is exactly the situation that I'm complaining
> about.  There is no functionality to provide a nonblocking open - no
> ability to come back around and retry a given open call.

I agree. I'm addressing why things can't "just work", not arguing that they
aren't broken or should stay broken. ;)

I think a good solution would be to re-use the 'connect' and 'shutdown'
calls. You would need a new asynchronous flag to 'open' that would mean,
*really* don't block. You would have to follow up with 'connect' to complete
the actual opening -- the 'open' would just assign a file descriptor (unless
it could complete or error immediately, of course).

To asynchronously close such a socket, you simply call 'shutdown'. Once the
'shutdown' completes, 'close' would be guaranteed not to block.

Obviously, being able to 'poll' or 'select' would be a huge plus (while an
'open' or 'close' is in progress, of course, otherwise it would always
return immediate availability).

I think this covers all the bases and the only ugly API change is an extra
'open' flag. (Which I think is unavoidable.)

> I'm speaking to my ideal world view - but any application I write
> should not have to wait for the kernel if I don't want it to.   I
> should be able to submit my request, and come back to it later as I so
> decide.

A working generic asynchronous system call interface would be the best
solution, I think. But that may be further off than just an asynchronous
file open/close interface.

> (And I did actually consider writing my own NFS client for about
> 5 minutes.)

Yeah, what a pain that would be. The obvious counter-argument to what I
propose above is that it doesn't handle reads and writes, so why bother with
a complex partial solution?

DS


