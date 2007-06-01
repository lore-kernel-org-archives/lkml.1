Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbXFABCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbXFABCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXFABB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:01:59 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4928 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbXFABB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:01:58 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: SELECT() returns 1 But FIONREAD says (Input/output error)
Date: Thu, 31 May 2007 18:01:31 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCENHEDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <465F112C.6090409@gatworks.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 31 May 2007 19:02:05 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 31 May 2007 19:02:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> i am using the GARMIN_GPS/usb driver to read a gps receiver.
> In testing the ability of my software to recover from various errors, I
> try this: unplug the gps/USB cable from the usb hub.
>
> Interestingly enough the thread spins.
> the SELECT() waits for something to happen, and I get one channel that
> something interesting happened.
> Then i try to find out how many chars are in the read buff via FIONREAD.
> That call errors out with an i/o error.
>
> Needless to day, the code resets the SELECT parameters, and SELECT is
> called again. It again says that something interesting has happened on
> that ( i/o errored ) channel. And we now repeat the  FIONREAD.
>
> In this case what, will reset the "something interesting has happened"
> report from the SELECT call? Will it ever be reset in this case?

Nope. An errored connection is always ready for read/write -- there is
nothing to wait for as far as the kernel is concerned. Your code keeps
asking the kernel if something interesting has happened, the kernel keeps
telling it yes, and it refuses to do anything about it.

At minimum, a detection of an error condition that could be persistent
should be followed by a delay. A detection of an error condition that has in
fact persisted and was previously detected should *never* be followed by an
immediate return to 'select'.

You need to *handle* the I/O error. Backoff might be one way, sleeping for
an increasing amount of time after each fatal error, subject to some limit.

And why are you calling FIONREAD? Just 'read' the data -- you're going to
have to eventually anyway.

DS


