Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYEHEq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYEHEq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYEHEqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:46:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42328
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYEHEqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:46:44 -0400
Date: Wed, 07 May 2008 21:46:37 -0700 (PDT)
Message-Id: <20080507.214637.193700986.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: jengelh@computergmbh.de, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: 2.6.26-rcX VC console scrolling regression
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change:

commit c9e587abfdec2c2aaa55fab83bcb4972e2f84f9b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Apr 29 00:59:46 2008 -0700

    vt: fix background color on line feed
    
    A command that causes a line feed while a background color is active,
    such as
    
    	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
    and
    	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
    
    causes the line that was started as a result of the line feed to be completely
    filled with the currently active background color instead of the default
    color.
    
    When scrolling, part of the current screen is memcpy'd/memmove'd to the new
    region, and the new line(s) that will appear as a result are cleared using
    memset.  However, the lines are cleared with vc->vc_video_erase_char, causing
    them to be colored with the currently active background color.  This is
    different from X11 terminal emulators which always paint the new lines with
    the default background color (e.g.  `xterm -bg black`).
    
    The clear operation (\e[1J and \e[2J) also use vc_video_erase_char, so a new
    vc->vc_scrl_erase_char is introduced with contains the erase character used
    for scrolling, which is built from vc->vc_def_color instead of vc->vc_color.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
    Cc: "Antonino A. Daplas" <adaplas@pol.net>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Causes garbage characters to appear at the end of lines on my VCs when
scrolling.

They look like lowercase 'c' characters with a '.' above them, and they
are colored light blue.  The rest of the console text is fine.

I think it might be because my VC gets put into a UTF8 mode or something
like that via the init scripts?  It seems to start happening right when
the init scripts print "Setting up console font and keymap", which seems
to come from /etc/init.d/console-setup which runs /bin/setupcon

This is with a stock Ubuntu 7.10 installation.
