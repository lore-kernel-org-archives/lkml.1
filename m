Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbZK3UTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbZK3UTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZK3UTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:19:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50864 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751797AbZK3UTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:19:40 -0500
Date: Mon, 30 Nov 2009 15:19:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200911301631.00484.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0911301502470.4478-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Ondrej Zary wrote:

> It does not make much sense to me but I think that it crashes iside this list 
> manipulation:
> 
>         prev = ehci->async;
>         while (prev->qh_next.qh != qh)
>                 prev = prev->qh_next.qh;

Yes, it's crashing in the "while" test because prev is NULL.  This
means the code is looking for qh in the async list but not finding it.  
That's supposed to be impossible.

The assembly code is peculiar because it includes stuff that isn't in
the source code!  For example, right at this point (after the end of
the loop) there's a test to see whether prev is NULL.  Where could that
have come from?  Do you have any idea?

>         prev->hw_next = qh->hw_next;
>         prev->qh_next = qh->qh_next;
>         wmb ();

These lines aren't reached.

Does this happen every time you disconnect the Nexio?

You can try patching that loop.  If prev is NULL then print an error
message in the log, including the value of qh and the value of
ehci->async, and jump past the following three statements.

With that change the system shouldn't crash, although khubd might hang.  
But we still need to find out how this could have happened.  Try
collecting a usbmon trace while running the test; then let's compare
the usbmon output with the error messages in the log.

Alan Stern

