Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbZHWARc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbZHWARc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 20:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZHWARb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 20:17:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33951 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752760AbZHWARb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 20:17:31 -0400
Date: Sat, 22 Aug 2009 20:17:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
In-Reply-To: <20090822211430.GA2547@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0908222002110.9952-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009, [utf-8] Rogério Brito wrote:

> Hi, Alan.
> 
> On Aug 21 2009, Alan Stern wrote:
> > A usbmon trace showing what happens when you plug in the drive and
> > when you run smartctl would help.
> 
> The requested trace is attached to this message. Please let me know if
> you need more information.

The trace shows that something (presumably smartctl) sends a command
the drive doesn't understand.  The drive then violates the USB
mass-storage protocol, sending an invalid response.  The kernel waits
for a proper response but nothing more happens, so after 30 seconds the
command times out and is aborted and the drive is reset.  The command
then gets retried, and the same thing happens again.  The retries take
so long that the kernel complains about smartctl being blocked for more
than 120 seconds -- that's the reason for the stack dump.

So the problem has several causes.  One is that the drive is buggy (it
doesn't respond with an error code in the proper way when it receives a
command it doesn't understand).  Another is that smartctl is trying to
send commands in a form the drive can't handle.  Finally, there's the
problem about all the retries taking too long.

Perhaps you can blame the kernel for spending too much time on retries, 
but the other two are the fault of the drive and smartctl.

Alan Stern

