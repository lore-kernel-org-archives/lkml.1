Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbYDAUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbYDAUFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYDAUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:05:46 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46299 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756964AbYDAUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:05:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=jHLtKnzIX8t+xIraZO8+ElPQOGePjoqPv6SYIxkRl0FCMPMTTPay5L0yv/OmBhu6TxJtcBQ3GRykFjvLPNE/3y/OsHDa6NZwstzTK2nUpqiY2MkVvJtRNTO84B9qW3fCFU3aJidHuVxFE0dM6tk26s/teoUrM6RWo5725PipEvY=  ;
X-YMail-OSG: ncN9eJsVM1mRpIrYcDEZPucVfPpAx2E_yr2xyjWlizTMk7dhs.kwsUROjSeClUpUaHBOzfp7fQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 01 Apr 2008 13:06:18 -0700
From: David Brownell <david-b@pacbell.net>
To: tino.keitel@gmx.de, pavel@ucw.cz, linux-usb@vger.kernel.org
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core 
 Duo
Cc: sonne@nn7.de, rjw@sisk.pl, linux-kernel@vger.kernel.org, lenb@kernel.org,
       akpm@linux-foundation.org
References: <20080320060550.GA13200@dose.home.local>
 <20080320105432.GA13404@dose.home.local>
 <20080325231300.GA10641@thinkpad.home.local>
 <200803290003.16199.rjw@sisk.pl>
 <20080331212812.GB5313@dose.home.local>
 <1207030991.11035.35.camel@localhost>
 <20080401062734.GA8824@dose.home.local>
 <20080401105213.GB10554@elf.ucw.cz>
 <20080401183732.GA5043@dose.home.local>
In-Reply-To: <20080401183732.GA5043@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080401200618.7284DCC224@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> git-bisect revealed this:
>
> $ git bisect good
> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 is first bad commit
> commit e82cc1288fa57857c6af8c57f3d07096d4bcd9d9
> Author: David Brownell <david-b@pacbell.net>
> Date:   Fri Mar 7 13:49:42 2008 -0800
>
>     USB: fix ehci unlink regressions

Most curious.  Based on what I read earlier, I was wondering about
the handling of the unlink watchdog during a known-dodgey path.

Specifically:

>     The recent EHCI driver update to split the IAA watchdog timer out from
>     the other timers made several things work better, but not everything;
>     and it created a couple new issues in bugzilla.  Ergo this patch:
>     
>       - Handle a should-be-rare SMP race between the watchdog firing
>         and (very late) IAA interrupts;
>     
>       - Remove a shouldn't-have-been-added WARN_ON() test;
>     
>       - Guard against one observed OOPS;
>     
>       - If this watchdog fires during clean HC shutdown, it should act
>         as a NOP instead of interfering with the shutdown sequence;

This "fires during a clean shutdown" path.  If there's any way this
patch would affect resume handling, that's where I'd expect it to
kick in.  Virtually nothing else *could* cause problems there.

If you'd like to experiment, modify the "if (...)" at the top of the
ehci_iaa_watchdog() function and make it just check to see if there's
an entry being reclaimed ... comment out the HC_IS_RUNNING() check.


>       - Guard against silicon errata hypothesized by some vendors:
>           * IAA status latch broken, but IAAD cleared OK;
>           * IAAD wasn't cleared when IAA status got reported;

FWIW the former has been confirmed as existing on some current AMD/ATI
chipsets (SB600 and SB700 are the numbers that come to mind).


>     The WARN_ON is in bugzilla as 10168; the OOPS as 10078; these are
>     both regressions.
>     
>     Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
>     Tested-by: Gordon Farquharson <gordonfarquharson@gmail.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

