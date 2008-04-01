Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYDAShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYDAShH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYDASgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:36:50 -0400
Received: from eazy.amigager.de ([213.239.192.238]:39838 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141AbYDASgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:36:49 -0400
Date: Tue, 1 Apr 2008 20:37:32 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Pavel Machek <pavel@ucw.cz>, linux-usb@vger.kernel.org
Cc: Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080401183732.GA5043@dose.home.local>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, linux-usb@vger.kernel.org,
	Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20080320060550.GA13200@dose.home.local> <20080320105432.GA13404@dose.home.local> <20080325231300.GA10641@thinkpad.home.local> <200803290003.16199.rjw@sisk.pl> <20080331212812.GB5313@dose.home.local> <1207030991.11035.35.camel@localhost> <20080401062734.GA8824@dose.home.local> <20080401105213.GB10554@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401105213.GB10554@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 12:52:13 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > [...]
> > > > 
> > > > > Can you please try to boot with acpi_new_pts_ordering and retest?
> > > > 
> > > > I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> > > > without success. I still got the same hand at resume.
> > > 
> > > I am having the hang on resume problem too (macbook pro), cf.
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10319, 2.6.24 was fine.
> > 
> > What about 2.6.25-rc5? Up to this, resume works for me. -rc6 is broken.
> 
> Any chance to bisect?

git-bisect revealed this:

$ git bisect good
e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 is first bad commit
commit e82cc1288fa57857c6af8c57f3d07096d4bcd9d9
Author: David Brownell <david-b@pacbell.net>
Date:   Fri Mar 7 13:49:42 2008 -0800

    USB: fix ehci unlink regressions
    
    The recent EHCI driver update to split the IAA watchdog timer out from
    the other timers made several things work better, but not everything;
    and it created a couple new issues in bugzilla.  Ergo this patch:
    
      - Handle a should-be-rare SMP race between the watchdog firing
        and (very late) IAA interrupts;
    
      - Remove a shouldn't-have-been-added WARN_ON() test;
    
      - Guard against one observed OOPS;
    
      - If this watchdog fires during clean HC shutdown, it should act
        as a NOP instead of interfering with the shutdown sequence;
    
      - Guard against silicon errata hypothesized by some vendors:
          * IAA status latch broken, but IAAD cleared OK;
          * IAAD wasn't cleared when IAA status got reported;
    
    The WARN_ON is in bugzilla as 10168; the OOPS as 10078; these are
    both regressions.
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Tested-by: Gordon Farquharson <gordonfarquharson@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 ff621bb62396fdf71c7b97877ddbb8542f57b871
251bc90076ea0b3a14d0b88dd250581fa815b5de M	drivers

For the linux-usb people: this commit breaks resume from suspend to RAM
on my Mac mini Core Duo. It worked with 2.6.24, 2.6.25-rc5, and was
broken since 2.6.25-rc6 (also with -rc7 and later). See
http://lkml.org/lkml/2008/3/20/23 for more information.

Regards,
Tino
