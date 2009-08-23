Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbZHWQYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbZHWQYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 12:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933923AbZHWQYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 12:24:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34905 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933921AbZHWQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 12:24:45 -0400
Date: Sun, 23 Aug 2009 12:24:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
In-Reply-To: <31690E3D-43A0-484D-9D65-C0003E033D1E@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0908231216300.26309-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009, Rogério Brito wrote:

> > The trace shows that something (presumably smartctl) sends a command
> > the drive doesn't understand.  The drive then violates the USB
> > mass-storage protocol, sending an invalid response.
> 
> Right.
> 
> > The kernel waits
> > for a proper response but nothing more happens, so after 30 seconds  
> > the
> > command times out and is aborted and the drive is reset.
> 
> I'm not with the kernel sources here (so, I can't check the code),  
> but is there any option to be able to log such invalid responses when  
> the kernel gets one? Perhaps the verbose USB logging does that?

There's no way to log the invalid responses because the kernel doesn't
realize they are invalid.  However the resets _do_ get logged; you can
see them in the logs you sent.

> > The command
> > then gets retried, and the same thing happens again.  The retries take
> > so long that the kernel complains about smartctl being blocked for  
> > more
> > than 120 seconds -- that's the reason for the stack dump.
> 
> Right.
> 
> Geeez, Alan, is there any vendor out there that gets the USB  
> implementation according to the specs?

There are some... but a lot of them mess it up.  :-(

> This is the 3rd USB device that I sent you some message about where  
> the kernel moans about something that it doesn't understand (I can  
> get you the vendor and device ids when I get home).
> 
> I will test with some other devices that I have, just to see what  
> their response is. :-(

Be sure to get usbmon traces.

> > So the problem has several causes.  One is that the drive is buggy (it
> > doesn't respond with an error code in the proper way when it  
> > receives a
> > command it doesn't understand).  Another is that smartctl is trying to
> > send commands in a form the drive can't handle.
> 
> That's probably not smartctl, but the user (me) that is telling it to  
> use a given command set to check if the USB adapter understands/ 
> allows pass-thru of the SMART protocol to the drive.

Yes, it's entirely possible that this adapter does not understand the 
pass-thru protocol you tried.  Isn't there more than one such protocol?

> > Finally, there's the
> > problem about all the retries taking too long.
> 
> Is there anything that could be done about this?

The length of each timeout is adjustable in sysfs, but I don't remember 
what attribute file you need to change.

Also, you could follow the instructions in those stack dumps.  They are
only warnings, not errors, and you can prevent the kernel from issuing
them.

> > Perhaps you can blame the kernel for spending too much time on  
> > retries,
> > but the other two are the fault of the drive and smartctl.
> 
> I understand the p-o-v of the kernel: some devices need a little bit  
> more time on a retry, while others don't. There's no way to hardcode  
> a once and for all behavior. It seems that an expensive solution to  
> this would be to create (yet) another list of blacklisted devices  
> (how many lists of quirks do we have in the kernel already---this is  
> really causing some bloat, especially for some embedded devices). :-(
> 
> OTOH, creating blacklists seem to not be the adequate (let alone  
> "right") solution (see the ASUS/it87 monitoring cause) in many  
> situations. :-/
> 
> 
> Thanks for your always kind messages, Rogério Brito.

You're welcome.

Alan Stern

