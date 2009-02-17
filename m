Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZBRCaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZBRCaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZBRCaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:30:01 -0500
Received: from thunk.org ([69.25.196.29]:60323 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZBRC37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:29:59 -0500
Date: Tue, 17 Feb 2009 17:00:29 -0500
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andres Freund <andres@anarazel.de>, Alex Buell <alex.buell@munted.org.uk>,
       adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jonathan Bastien-Filiatrault <joe@x2a.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20090217220029.GS23758@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Andres Freund <andres@anarazel.de>,
	Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AFE32.7070003@redhat.com> <499B1935.10906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499B1935.10906@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 02:08:21PM -0600, Eric Sandeen wrote:
> FWIW my problem seems to be different than others have encountered; mine
> persists past reboot, while other reporters have said that a reboot
> (remount) makes the problem go away.

It might or might not be the same problem, since the reporters were
doing this on a mounted root partition, and on a filesystem quite a
bit larger than your test filesystem; so it could be that the act of
shutting down and rebooting created/deleted various pid files, and
purturbed the filesystem to make the problem go away.

The other possibility is that it is the flex_bg specific counters
which were introduced specifically for find_group_flex.  I'm not wild
about them since they mean we have to take an extra flex_bg specific
spin lock for every block and inode allocation.  The Orlov algorithm
only needs the information when allocating directories, and since
those are rarer than file allocations, I think it should be OK to
simply sum up the necessary fields at directory allocation time
instead of trying to maintain separate counters (which could possibly
get corrupted, although I couldn't see a way that they could be
getting out of sync with reality).

					- Ted
