Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYAEGwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYAEGwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 01:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAEGwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 01:52:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44637 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYAEGwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 01:52:34 -0500
Date: Sat, 5 Jan 2008 06:52:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Berthold Cogel <cogel@rrz.uni-koeln.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
Message-ID: <20080105065233.GE27894@ZenIV.linux.org.uk>
References: <477A93CD.9030707@rrz.uni-koeln.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477A93CD.9030707@rrz.uni-koeln.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 08:26:05PM +0100, Berthold Cogel wrote:

> Jan  1 17:34:39 wonderland kernel: BUG: unable to handle kernel paging 
> request at virtual address 00100100

LIST_POISON1

> Jan  1 17:34:39 wonderland kernel: EIP is at evdev_disconnect+0x65/0x9e 

and by the look of code, it's a bit before the call of something that gets
0x20006 as one of its arguments.  Which, by the look of evdev.s, gets
passed only to kill_fasync().  So it's POLL_HUP, so this code could be
these days:
	spin_lock(&evdev->client_lock);
	list_for_each_entry(client, &evdev->client_list, node)
		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
	spin_unlock(&evdev->client_lock);
in evdev_hangup()
prior to commit 6addb1d6de1968b84852f54561cc9a999909b5a9:
		list_for_each_entry(client, &evdev->client_list, node)
			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
in evdev_disconnect()


> I'm using Debian stable/testing/unstable with homemade kernel 2.6.23.12 
> (patched with tuxonice-3.0-rc3-for-2.6.23.9).

... and seeing that this changeset postdates 2.6.23 *and* adds locking to
the lists we are traversing in either variant, I'd bet that the kernel you
have does *NOT* have the changeset in question, that you have list corruption
from race and that your oops is list_for_each_entry() trying to walk
forward from entry that just had list_del() poisoning its ->next.

There are only 4 changesets between 2.6.23 and this one affecting drivers/input
and only
8006479c9b75fb6594a7b746af3d7f1fbb68f18f and
6addb1d6de1968b84852f54561cc9a999909b5a9
appear to be relevant.  Apply to your kernel and see if it helps...
