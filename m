Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYGWCin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYGWCin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 22:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYGWCie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 22:38:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3349 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752108AbYGWCid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 22:38:33 -0400
Date: Tue, 22 Jul 2008 22:38:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tomas Styblo <tripie@cpan.org>
cc: Robert Hancock <hancockr@shaw.ca>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <20080722090331.GC8303@notebook.homenet.local>
Message-ID: <Pine.LNX.4.44L0.0807222238060.12003-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008, Tomas Styblo wrote:

> * Alan Stern <stern@rowland.harvard.edu> [Tue, 22 Jul 2008]:
> > On Mon, 21 Jul 2008, Robert Hancock wrote:
> > > > this message includes a patch that provides a workaround for
> > > > a silent data corruption bug caused by incorrect error handling in
> > > > the JMicron JM20337 Hi-Speed USB to SATA & PATA Combo Bridge chipset,
> > > > USB device id 152d:2338.
> > 
> > The two of you should read through
> > 
> > 	http://bugzilla.kernel.org/show_bug.cgi?id=9638
> > 
> > which concerns this very problem.
> 
> I had found this bugreport and read through it before I posted my
> patch. I don't think this is the same problem. The error messages
> and the description of the problem are different from what I've
> been trying to fix.

Maybe the initial descriptions are.  If you read through the entire
report, though, you'll see that the underlying problems are exactly
the same:

	A READ fails to transfer all the data requested.  The device
	sends back Check Condition status, but the sense data is all
	0, indicating that nothing was wrong.  The system does not
	retry the READ, leading to data corruption.

	A WRITE fails and times out after 30 seconds.  The system
	tries to reset the device, but the reset fails.

The system doesn't detect the first problem for two reasons: The
scsi_eh_prep_cmnd routine fails to preserve scmd->underflow, and
usb-storage fails to check for underflow when the device returns Check
Condition status.  The Bugzilla report contains fixes for both of
these, and they solve the problem.

The second problem is harder.  The device is supposed to send a STALL
to cut the WRITE short -- and a USB trace under Windows seems to
indicate that it does -- but under Linux no STALL is received.  I
don't know why not.  But since Linux does not respond in the way the
device expects, the device crashes.

> Anyway, I'll send the patch to this person so he can try it. 
> I guess it won't fix his problem. This patch is much simpler and doesn't 
> need any delays - I really think this is a different situation.

It isn't.  And your patch is an ad-hoc correction that doesn't address
the true underlying reasons for the errors.

You should also try adding the delay mentioned in the bug report.
There's an excellent chance it will also prevent your problems.

> I sometimes experience the problems described by this person, as I
> noted in the first message with the patch. When these "reset high
> speed USB device" messages appear, it is usually necessary to
> disconnect and power off the device.

Because the device's firmware has crashed.  That's why the reset fails.

Alan Stern

