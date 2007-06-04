Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXFDA1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXFDA1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 20:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbXFDA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 20:27:10 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1275 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXFDA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 20:27:09 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: slow open() calls and o_nonblock
Date: Sun, 3 Jun 2007 17:27:06 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEMFEEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 03 Jun 2007 17:27:28 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 03 Jun 2007 17:27:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Now, Netapp speed aside, O_NONBLOCK and O_DIRECT seem to make zero
> difference to my open times.  Example:
>
> open("/somefile", O_WRONLY|O_NONBLOCK|O_CREAT, 0644) = 1621 <0.415147>

How could they make any difference? I can't think of any conceivable way
they could.

> Now, I'm a userspace guy so I can be pretty dense, but shouldn't a
> call with a nonblocking flag return EAGAIN if its going to take
> anywhere near 415ms?  Is there a way I can force opens to EAGAIN if
> they take more than 10ms?

There is no way you can re-try the request. The open must either succeed or
not return a handle. It is not like a 'read' operation that has an "I didn't
do anything, and you can retry this request" option.

If 'open' returns a file handle, you can't retry it (since it must succeed
in order to do that, failure must not return a handle). If you 'open'
doesn't return a file handle, you can't retry it (because, without a handle,
there is no way to associate a future request with this one, if it creates a
file, the file must not be created if you don't call 'open' again).

The 'open' function must, at minimum, confirm that the file exists (or
doesn't exist and can be created, or whatever). This takes however long it
takes on NFS.

You need either threads or a working asynchronous system call interface.
Short of that, you need your own NFS client code.

DS


