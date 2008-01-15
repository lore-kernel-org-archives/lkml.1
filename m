Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYAOKgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYAOKgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYAOKgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:36:35 -0500
Received: from twin.jikos.cz ([213.151.79.26]:54542 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYAOKge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:36:34 -0500
Date: Tue, 15 Jan 2008 11:36:02 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Adrian Bunk <bunk@kernel.org>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 kernel oopses for the week ending January 12th, 2008
In-Reply-To: <20080112222322.GE17276@does.not.exist>
Message-ID: <Pine.LNX.4.64.0801151126480.15647@twin.jikos.cz>
References: <47890B65.80804@linux.intel.com> <20080112222322.GE17276@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008, Adrian Bunk wrote:

> > Rank 1: implement (hid code)
> > 	WARN_ON at drivers/hid/hid-core.c:784
> > 	Reported 23 times (39 total reports)
> > 	This appears to be the kernel doing a WARN_ON based on unexpected ioctl() arguments
> > 	More info: http://www.kerneloops.org/search.php?search=implement
> >...
> The only complete bug reports seems to be from one user who loaded a 
> module whose distribution might be considered a criminal act in some 
> countries.

The most usual case is hid2hci utility, that tries to switch modes on 
Bluetooth HID peripherials (via hiddev). When these "switching" packets 
are not compliant with HID report descriptor of the device, this WARN_ON() 
happens.

Unfortunately there is no standard specifying how these packets should 
look like, so it is guess-game and some rev-eng, that Marcel has put into 
hid2hci for individual vendors, and sometimes this just happens not to 
work.

I have had the commit below queued in my tree for 2.6.25 for quite some 
time

commit dbacd67dc33f7b0d5fe64323668cf266d18f4b3f
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Fri Nov 30 11:12:58 2007 +0100

    HID: remove redundant WARN_ON()s in order not to scare users

    The WARN_ON() in implement() and extract() spit out stacktraces and
    a lot of other information that might make users think that there is
    something seriously wrong with the system. WARN_ON() should not be
    deliberately triggerable by userspace application, which these can be.
    Usually this WARN_ON() triggers when hid2hci utility is sending the
    data that don't correspond to the device's report descriptor.

    Convert these messages to more friendly printk().

-- 
Jiri Kosina
