Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbYDKCzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbYDKCzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 22:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYDKCzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 22:55:09 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:48180 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYDKCzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 22:55:08 -0400
Date: Fri, 11 Apr 2008 04:55:06 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Bill Davidsen <davidsen@tmr.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>, agk@redhat.com,
       mingo@redhat.com, neilb@suse.de
Subject: Re: Data corruption on software RAID
In-Reply-To: <47FE224D.2020309@tmr.com>
Message-ID: <Pine.LNX.4.64.0804110448120.22052@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
 <47FD0BE8.4070105@tmr.com> <Pine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz>
 <47FE224D.2020309@tmr.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently you can go for hours without ever reaching a clean state on active
> files. By not deliberately allowing the buffer to change during a write the
> chances for getting consistent data on the disk should be significantly
> improved.

It can already happen that one device writes the sector and other not if 
the power is interrupted. And all RAID implementations already deal with 
it by resynchronizing the modified areas in case of crash. So they could 
resynchronize modify-while-write cases as well, with the same code.

... or I don't know if MM maintainers want to add locking to the pages 
that are under a write. Personally, I wouldn't do it.

> > From my point of view that trick with thread doing sync() and turning off
> > region bits looks best. I'd like to know if that solution doesn't have any
> > other flaw.
> >
> >   
> > > For reliable operation I would want all copies (and/or CRCs) to be 
> > > written on an fsync, by the time I bother to fsync I really, really, 
> > > want the data on the disk.
> > >     
> >
> > fsync already works this way.
> >   
> 
> The point I was making is that after you change the code I would still want
> that to happen. And your comment above seems to indicate a goal of getting
> consistent data after a crash, with less concern that it be the most recent
> data written. Sorry in advance if that's a misreading of "you just must not
> forget to resync them after a crash."

There would be no problem with fsync. Fsync writes the synced data to both 
devices. So after a crash you can select any of the devices as a resync 
master copy, and you get the data that you wrote before sync() or fsync().

Mikulas
