Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbXDBLok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbXDBLok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbXDBLok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:44:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:48852 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933963AbXDBLoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=hXg+HbPl2CWdQNjjA4QtwSpIQm0Mt1xosCYxhPG6CBcbogt7s6h+2HSJSPoVYZkgCadW2yjLoDzpzV84bIB8N7J6VaEwS09LZzJoaPNVLfiT2sPWJoGIAUwE3iVJPb6cLVDGUXW5f30HntOmMbeGeAt+9dMIQe5GpMmZ3mI8/ig=
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Daniel Jacobowitz <dan@debian.org>
In-Reply-To: <20070402112607.GK26707@cel.leo>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>
	 <1175496595.4614.11.camel@daplas>
	 <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
	 <20070402112607.GK26707@cel.leo>
Content-Type: multipart/mixed; boundary="=-QUVbUkpUqQKkZN0swhgD"
Date: Mon, 02 Apr 2007 19:44:13 +0800
Message-Id: <1175514253.4431.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QUVbUkpUqQKkZN0swhgD
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-04-02 at 12:26 +0100, Paul LeoNerd Evans wrote:
> On Mon, Apr 02, 2007 at 09:31:37AM +0200, Jan Engelhardt wrote:
> > Also see:
> > 	http://lkml.org/lkml/2005/5/17/289
> > 	http://lkml.org/lkml/2005/5/17/297
> > 
> > These posts argue about terminfo being the culprit. But how can terminfo 
> > be at fault, when `echo -en "\ec"` triggers it too?
> > 
> > Since I am in a patch mood, here's my stance/patch, which is compile and 
> > run tested and behaves as expected (both with `echo` and `reset`).
> 
> ...
> 
> > Index: linux-2.6.21-rc5/drivers/char/vt.c
> > ===================================================================
> > --- linux-2.6.21-rc5.orig/drivers/char/vt.c
> > +++ linux-2.6.21-rc5/drivers/char/vt.c
> > @@ -1518,7 +1518,6 @@ static void reset_terminal(struct vc_dat
> >  	vc->vc_charset		= 0;
> >  	vc->vc_need_wrap	= 0;
> >  	vc->vc_report_mouse	= 0;
> > -	vc->vc_utf		= 0;
> >  	vc->vc_utf_count	= 0;
> >  
> >  	vc->vc_disp_ctrl	= 0;
> > #<EOF>
> 
> Is it OK to do that? I recall when I was originally looking at the code
> I didn't want to just remove that line, because it looked like that was
> being used to first initialise the vc* structure when it is created, as
> well as reset it every time. Doesn't this leave vc->vc_utf uninitialised
> when a new VC is allocated?

That's true.  We can move the line vc->vc_utf = 0; in vc_init()
instead. 

Tony


--=-QUVbUkpUqQKkZN0swhgD
Content-Disposition: attachment; filename=vc_reset.diff
Content-Type: text/x-patch; name=vc_reset.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1bbb45b..23e4432 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1497,7 +1497,6 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
@@ -2590,6 +2589,7 @@ static void vc_init(struct vc_data *vc, 
 	vc->vc_rows = rows;
 	vc->vc_size_row = cols << 1;
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
+	vc->vc_utf = 0;
 
 	set_origin(vc);
 	vc->vc_pos = vc->vc_origin;

--=-QUVbUkpUqQKkZN0swhgD--

