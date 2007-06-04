Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXFDVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXFDVGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbXFDVGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:06:00 -0400
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:7433 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761055AbXFDVF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:05:59 -0400
Date: Mon, 4 Jun 2007 23:05:55 +0200
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel@killerfox.forkbomb.ch
Subject: Re: [linux-usb-devel] [PATCH] Fix NEC OHCI chip silicon bug
Message-ID: <20070604210555.GB12676@hansmi.ch>
References: <20070602124009.GA6991@hansmi.ch> <Pine.LNX.4.44L0.0706021042360.11640-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0706021042360.11640-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 10:49:44AM -0400, Alan Stern wrote:
> Then later on, when the hub driver is resumed it will see the flag and
> disconnect all the devices below the root hub.

> For instance, you could force ohci-hcd to report connect-change events
> on all the ports. Perhaps it does something like that anyway, in which
> case you wouldn't have to worry about it.

After studying the code for two evenings, I'm quite sure it does that
already.

A comment in ohci-hcd.c:ohci_restart reads:
  /* mark any devices gone, so they do nothing till khubd disconnects.
   * recycle any "live" eds/tds (and urbs) right away.
   * later, khubd disconnect processing will recycle the other state,
   * (either as disconnect/reconnect, or maybe someday as a reset).
   */

usb_root_hub_lost_power marks the ports as gone, khubd will disconnect them.
After restarting the chip, khubd will cause them to be detected again.

This is also what I can watch in the logs:
  ohci_hcd 0001:10:15.1: OHCI Unrecoverable Error, scheduling NEC chip restart
  usb usb2: root hub lost power or was reset
  usb 2-2: USB disconnect, address 2
  input: appletouch disconnected
  usb 2-2: new full speed USB device using ohci_hcd and address 3
  usb 2-2: configuration #1 chosen from 1 choice
  input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input16 on usb-0001:10:15.1-2
  input: appletouch as /class/input/input17
  input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input18 on usb-0001:10:15.1-2

(Actually, I added some code to trigger the error handling code, reliably
reproducing it otherwise is impossible.)

Thanks,
Michael
