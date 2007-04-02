Return-Path: <linux-kernel-owner+w=401wt.eu-S934025AbXDBMsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbXDBMsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbXDBMsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:48:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:39912 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025AbXDBMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=gWERGNtCpxy79L7CUnA+43lXlyWAR9k2Fj67Wr6l/N8L19CfRM2YqPO/98Pl7HO/G4tZtuN3+HTi5KwnXHPfZt2x36s+pmVwKZdgsjZ1sEqkVw6ivpN7KPOsXjr8vr5x+qLT90yiyYvlxddmCnTjwQDCka+MxsJmtPop5HEV6Lg=
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Daniel Jacobowitz <dan@debian.org>
In-Reply-To: <20070402115411.GL26707@cel.leo>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>
	 <1175496595.4614.11.camel@daplas>
	 <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
	 <20070402112607.GK26707@cel.leo> <1175514253.4431.7.camel@daplas>
	 <20070402115411.GL26707@cel.leo>
Content-Type: multipart/mixed; boundary="=-U4E+e8OHIMbBiXv34j33"
Date: Mon, 02 Apr 2007 20:47:59 +0800
Message-Id: <1175518079.4545.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U4E+e8OHIMbBiXv34j33
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-04-02 at 12:54 +0100, Paul LeoNerd Evans wrote:
> On Mon, Apr 02, 2007 at 07:44:13PM +0800, Antonino A. Daplas wrote:
> > > Is it OK to do that? I recall when I was originally looking at the code
> > > I didn't want to just remove that line, because it looked like that was
> > > being used to first initialise the vc* structure when it is created, as
> > > well as reset it every time. Doesn't this leave vc->vc_utf uninitialised
> > > when a new VC is allocated?
> > 
> > That's true.  We can move the line vc->vc_utf = 0; in vc_init()
> > instead. 
> 
> ...
> 
> > @@ -2590,6 +2589,7 @@ static void vc_init(struct vc_data *vc, 
> >  	vc->vc_rows = rows;
> >  	vc->vc_size_row = cols << 1;
> >  	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
> > +	vc->vc_utf = 0;
> >  
> >  	set_origin(vc);
> >  	vc->vc_pos = vc->vc_origin;
> 
> While we're on that subject, did you take a look at my original mail?

I did not actually.

> The intent with that patch was to allow system policy to state all new
> VCs are UTF-8-enabled by default. I feel that in 2007 this should be the
> default setting.
> 
> Would it therefore be possible to have
> 
>    vc->vc_utf = some_default;
> 
> where some_default comes maybe from a sysctl or some other configurable
> source? Or maybe even have a compiletime option?
> 
> This would get around many bugs. For example, on boot, "unicode_start"
> can only set utf8 mode on the existing VCs 1 to 6. If X11 fails to
> start, debian nicely runs me the XKeepsCrashing program, which offers to
> show me logs and the like. It reads the locale, en_GB.UTF-8 and
> determines we're in UTF-8 mode, so outputs Unicode linedrawing
> characters for dialogs. Unfortunately, we're on VC7 which doesn't have
> UTF-8 mode turned on, so much mess results.
> 
> It would be nice if the kernel's default UTF-8 mode for new VCs could be
> synched to whatever local policy was regarding locale.

How about this? This should allow us to reset the terminal without
affecting utf, and also allows setting of a global utf default that can
be set via boot option or sysfs:

echo 1 > /sys/module/vt/parameters/default_utf

Tony




> 

--=-U4E+e8OHIMbBiXv34j33
Content-Disposition: attachment; filename=utf.diff
Content-Type: text/x-patch; name=utf.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1bbb45b..b9b3247 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -157,6 +157,8 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
+static int default_utf;
+module_param(default_utf, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -1497,7 +1499,6 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
@@ -2590,6 +2591,7 @@ static void vc_init(struct vc_data *vc, 
 	vc->vc_rows = rows;
 	vc->vc_size_row = cols << 1;
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
+	vc->vc_utf = default_utf;
 
 	set_origin(vc);
 	vc->vc_pos = vc->vc_origin;

--=-U4E+e8OHIMbBiXv34j33--

