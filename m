Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbXGEGxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbXGEGxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbXGEGxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:53:44 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:53488 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926AbXGEGxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:53:43 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 08:53:41 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031920.59940.oliver@neukum.org> <20070704233909.GB2719@elf.ucw.cz>
In-Reply-To: <20070704233909.GB2719@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707050853.42224.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Pavel Machek:
> On Tue 2007-07-03 19:20:59, Oliver Neukum wrote:
> > Am Dienstag, 3. Juli 2007 schrieb Rafael J. Wysocki:
> > > On Tuesday, 3 July 2007 15:08, Rafael J. Wysocki wrote:
> > > > On Tuesday, 3 July 2007 07:51, Benjamin Herrenschmidt wrote:
> > > > > On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> > > > > > Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> > > > > > a screaming nightmare - either the suspend fails because syslog (for 
> > > > > > instance) can't be frozen, or the machine deadlocks for some other 
> > > > > > reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> > > > > > could do what we do for suspend to RAM on other platforms (PPC and APM) 
> > > > > > and just not use the freezer.
> > > > > 
> > > > > The main reason for deadlocks is because we do a sys_sync() after the
> > > > > freeze, which we shouldn't do.
> > > > 
> > > > So why don't we remove the sys_sync() from freeze_processes() instead?
> > > 
> > > The patch follows (untested).
> > > 
> > > Greetings,
> > > Rafael
> > > 
> > > 
> > > ---
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > We shouldn't sync filesystems from within the freezer, because it's not needed
> > > for suspend to RAM and leads to problems with FUSE.
> > 
> > This seems fishy. Swsusp needs enough clean memory to make enough
> > room for the image. If you sync before you freeze, the running tasks can
> > redirty memory.
> > What makes you sure that you don't die as shrink_all_memory() writes out
> > pages?
> 
> Shrink_all_memory should just free enough memory, what's the problem?
> Yes, we can have dirty memory, shrink_all_memory() can write that out
> just fine.

If there's any dirty memory to be written out through fuse, this will not
work as user space is already frozen. Now I am told that with fuse writes
are synchronous. Therefore I don't understand why having a call to sys_sync()
can make a difference. IMHO removing it to make fuse work covers over
a symptom but hides the bug.

	Regards
		Oliver

