Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZLITGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZLITGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZLITGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:06:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40647 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756987AbZLITGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:06:44 -0500
Date: Wed, 9 Dec 2009 14:06:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081339040.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912091356200.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> > Wait a second.  Are you saying that with code like this:
> > 
> > 	if (x == 1)
> > 		y = 5;
> > 
> > the CPU may write to y before it has finished reading the value of x?  

> > And this write is visible to other CPUs, so that if x was initially 0
> > and a second CPU sets x to 1, the second CPU may see y == 5 before it
> > executes the write to x (whatever that may mean)?
> 
> Well, yes and no. CPU1 above won't release the '5' until it has confirmed 
> the '1' (even if it does so by reading it late). but assuming the other 
> CPU also does speculation, then yes, the situation you describe could 
> happen. If the other CPU does
> 
> 		z = y;
> 		x = 1;
> 
> then it's certainly possible that 'z' contains 5 at the end (even if both 
> x and y started out zero). Because now the read of 'y' on that other CPU 
> might be delayed, and the write of 'x' goes ahead, CPU1 sees the 1, and 
> commits its write of 5, sp when CPU2 gets the cacheline, z will now 
> contain 5.

That could be attributed to reordering on CPU2, so let's take CPU2's
peculiarities out of the picture (initially everything is set to 0):

	CPU1			CPU2
	----			----
	if (x == 1)		z = y;
		y = 5;		mb();
				x = 1;

This gets at the heart of the question: Can a write move up past a
control dependency?  Similar questions apply to the two types of data 
dependency:

	CPU1			CPU2
	----			----
	y = x + 4;		z = y;
				mb();
				x = 1;

(Initially p points to x, not y):

	CPU1			CPU2
	----			----
	*p = 5;			z = y;
				mb();
				p = &y;

Can z end up equal to 5 in any of these examples?

Alan Stern

