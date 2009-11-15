Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZKONaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZKONaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 08:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZKONaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 08:30:06 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:61626 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZKONaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 08:30:05 -0500
MIME-Version: 1.0
Date: Sun, 15 Nov 2009 14:30:09 +0100
Message-ID: <40e92d5b0911150530y67878707yed776478a51a34c@mail.gmail.com>
Subject: consolechars switches tty since 8b92e87 vt: add an event interface
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
To: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found (using git bisect) that following commit:

commit 8b92e87d39bfd046e7581e1fe0f40eac40f88608
Author: Alan Cox <alan@linux.intel.com>
Date:   Sat Sep 19 13:13:24 2009 -0700

    vt: add an event interface

    This is needed and requested in various forms for ConsoleKit, screenblank
    handling and the like so do the job with a single interface. Also build the
    interface so that unlike VT_WAITACTIVE and friends it won't miss events.

    FIXME: Should this be a waitactive ioctl or a new device file you can poll
    and read events from. We need the code anyway to fix up the existing broken
    wait for console switch logic but the ConsoleKit people would prefer the
    new device to the ioctl we have here

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

M       drivers/char/vt.c
M       drivers/char/vt_ioctl.c
M       include/linux/vt.h
M       include/linux/vt_kern.h

is the perpetrator of changing consolechars (and probably other
tty-related apps) behavior.

[ In Debian before the end of the S runlevel (boot) console-screen.sh
is executed (it is not the last script though), where consolechars is
used for loading console screen font for each tty. In my case it
evaluates to:

    /usr/bin/consolechars --tty=/dev/ttyX -f lat0-sun16

Similarly consolechars is used in setupcon script invoked by
console-setup (processed after console-screen.sh) to set a font chosen
by user. ]

The problem is that since 8b92e87 running consolechars switches tty to
the one provided with --tty option. Last commit I have tested,
a9366e6, is still affected.

( Back then there was also another problem with "INIT:
open(/dev/console): Input/output error" introduced in b50989d and
fixed in f278a2f. )

Result? Messages starting from "INIT: Switching to runlevel: 2" don't
go to tty1 as they should and tty1 is not the tty I see when login
prompt shows up.

I tried to found out whether this issue was already brought to light,
but without success. Maybe this is an obvious and intentional
consequence of the patch for people familiar with tty/vt --
unfortunately I am not among them.

Thanks.

-- 
Przemysław Pawełczyk
