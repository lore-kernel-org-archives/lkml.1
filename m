Return-Path: <linux-kernel-owner+w=401wt.eu-S1030668AbXDUL3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668AbXDUL3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXDUL3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:29:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:58664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030668AbXDUL3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:29:44 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18ija9RPb4iBfoTZO1Wr3rt+7cZtf+KsA9TLdKJxa
	knHetcMMzSleSu
Date: Sat, 21 Apr 2007 13:29:41 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070421112941.GA22432@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu> <20070419184534.GA29096@1wt.eu> <20070421103129.GA12621@elte.hu> <20070421104522.GA17856@elte.hu> <20070421110748.GA6383@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070421110748.GA6383@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2007.04.21 13:07:48 +0200, Willy Tarreau wrote:
> > another thing i noticed: when using a -y larger then 1, then the window 
> > title (at least on Metacity) overlaps and thus the ocbench tasks have 
> > different X overhead and get scheduled a bit assymetrically as well. Is 
> > there any way to start them up title-less perhaps?
> 
> It has annoyed me a bit too, but I'm no X developer at all, so I don't
> know at all if it's possible nor how to do this. I know that my window
> manager even adds title bars to xeyes, so I'm not sure we can do this.
> 
> Right now, I've added a "-B <border size>" argument so that you can
> skip the size of your title bar. It's dirty but it's not my main job :-)

Here's a small patch that makes the windows unmanaged, which also causes
ocbench to start up quite a bit faster on my box with larger number of
windows, so it probably avoids some window manager overhead, which is a
nice side-effect.

Björn

--

diff -u ocbench-0.4/ocbench.c ocbench-0.4.1/ocbench.c
--- ocbench-0.4/ocbench.c	2007-04-21 13:05:55.000000000 +0200
+++ ocbench-0.4.1/ocbench.c	2007-04-21 13:24:01.000000000 +0200
@@ -213,6 +213,7 @@
 int main(int argc, char *argv[]) {
   Window root;
   XGCValues gc_setup;
+  XSetWindowAttributes swa;
   int c, index, proc_x, proc_y, pid;
   int *pcount[] = {&HOUR, &MIN, &SEC};
   char *p, *q;
@@ -342,8 +343,11 @@
   alloc_color(fg, &orange);
   alloc_color(fg2, &blue);
 
-  win = XCreateSimpleWindow(dpy, root, X, Y, width, height, 0, 
-  			    black.pixel, black.pixel);
+  swa.override_redirect = 1;
+
+  win = XCreateWindow(dpy, root, X, Y, width, height, 0,
+  			    CopyFromParent, InputOutput, CopyFromParent,
+  			    CWOverrideRedirect, &swa);
   XStoreName(dpy, win, "ocbench");
 
   XSelectInput(dpy, win, ExposureMask | StructureNotifyMask);
Only in ocbench-0.4.1/: .README.swp
