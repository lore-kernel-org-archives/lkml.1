Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYEHGDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYEHGDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYEHGDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:03:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYEHGD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:03:29 -0400
Date: Wed, 7 May 2008 23:02:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, jengelh@computergmbh.de, adaplas@pol.net,
       hpa@zytor.com, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
Message-Id: <20080507230247.96b37830.akpm@linux-foundation.org>
In-Reply-To: <20080507.214637.193700986.davem@davemloft.net>
References: <20080507.214637.193700986.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 21:46:37 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> 
> This change:
> 
> commit c9e587abfdec2c2aaa55fab83bcb4972e2f84f9b
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Tue Apr 29 00:59:46 2008 -0700
> 
>     vt: fix background color on line feed
>     
>     A command that causes a line feed while a background color is active,
>     such as
>     
>     	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
>     and
>     	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
>     
>     causes the line that was started as a result of the line feed to be completely
>     filled with the currently active background color instead of the default
>     color.
>     
>     When scrolling, part of the current screen is memcpy'd/memmove'd to the new
>     region, and the new line(s) that will appear as a result are cleared using
>     memset.  However, the lines are cleared with vc->vc_video_erase_char, causing
>     them to be colored with the currently active background color.  This is
>     different from X11 terminal emulators which always paint the new lines with
>     the default background color (e.g.  `xterm -bg black`).
>     
>     The clear operation (\e[1J and \e[2J) also use vc_video_erase_char, so a new
>     vc->vc_scrl_erase_char is introduced with contains the erase character used
>     for scrolling, which is built from vc->vc_def_color instead of vc->vc_color.
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>     Cc: "Antonino A. Daplas" <adaplas@pol.net>
>     Cc: "H. Peter Anvin" <hpa@zytor.com>
>     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Causes garbage characters to appear at the end of lines on my VCs when
> scrolling.
> 
> They look like lowercase 'c' characters with a '.' above them, and they
> are colored light blue.  The rest of the console text is fine.
> 
> I think it might be because my VC gets put into a UTF8 mode or something
> like that via the init scripts?  It seems to start happening right when
> the init scripts print "Setting up console font and keymap", which seems
> to come from /etc/init.d/console-setup which runs /bin/setupcon
> 
> This is with a stock Ubuntu 7.10 installation.

Thanks, Dave.  I queued the revert but I'll hold off for 48-odd hours if
that's OK - it might just be something silly.


If we continue in this way, patch-2.6.26 will consist solely of:

--- a/Makefile
+++ a/Makefile
@@ -1,6 +1,6 @@
 VERSION = 2
 PATCHLEVEL = 6
-SUBLEVEL = 25
+SUBLEVEL = 26
 EXTRAVERSION =
 NAME = Funky Weasel is Jiggy wit it
 
:(
