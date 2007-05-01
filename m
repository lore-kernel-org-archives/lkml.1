Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXEAPUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXEAPUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbXEAPUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:20:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:31423 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbXEAPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=J14ZqeXmG+ieMI4jUPigI4PkmIJQGyaTxSJz+aBaA7sfBk0fIXvzpFsPJ/kgwOw2nvrFLq7BY0buhpcV0b0vIWbgQmKCr7DAA4yNeRxVrX56ePaXcOcHBlhc1zSVU1eWYQCJD08i0OtaFYczCQJ0cABrih2LzpbxsltDj/ZKFPs=
Subject: Re: X display shift with disabled console blanking
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: James Pearson <james-p@moving-picture.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46372FC3.6090807@moving-picture.com>
References: <46322E08.3040303@moving-picture.com>
	 <1177727097.7568.6.camel@daplas>  <4635E810.80809@moving-picture.com>
	 <1177969865.4372.23.camel@daplas>  <46372FC3.6090807@moving-picture.com>
Content-Type: multipart/mixed; boundary="=-OlrXoJMmsmDP2sEf1/Mr"
Date: Tue, 01 May 2007 23:20:40 +0800
Message-Id: <1178032840.5331.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OlrXoJMmsmDP2sEf1/Mr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-05-01 at 13:17 +0100, James Pearson wrote:
> Antonino A. Daplas wrote:
> > On Mon, 2007-04-30 at 13:58 +0100, James Pearson wrote:
> > 
> >>Antonino A. Daplas wrote:
> >>
> >>>On Fri, 2007-04-27 at 18:08 +0100, James Pearson wrote:

> It does indeed seem that the switching back and forth between text and 
> graphics does appear to be part of the issue - in my previous testing I 
> probably did do this (but didn't include this in my recipe above) - so 
> here is a new 'recipe' that shows the problem (for me)
> 
> boot to run level 3
> 
> if not root, then make sure /dev/console is writeable
> 
> login and type:
> 
> setterm -blank 0
> 
> start X
> 
> type into an xterm:
> 
> while true; do echo "" > /dev/console; usleep 100000; done
> 
> while the above loop is running switch to the text console and back 
> again (Ctrl-Alt-F1 then Ctrl-Alt-F7)
> 
> ... and the screen will be shifting (and wrapping) to the left.
> 

Okay, this makes me see the problem more clearly.  It looks like that
vt/console layer is unreliable in terms of checking for the
text/graphics mode of the current console.  Instead of auditing the
console code, I'll just have vgacon check for the mode.  Try the
attached patch and let me know if it helps. 

Tony

--=-OlrXoJMmsmDP2sEf1/Mr
Content-Disposition: attachment; filename=vgacon.diff
Content-Type: text/x-patch; name=vgacon.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index d0d2733..2460b82 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -660,6 +660,9 @@ #endif
 
 static void vgacon_cursor(struct vc_data *c, int mode)
 {
+	if (c->vc_mode != KD_TEXT)
+		return;
+
 	vgacon_restore_screen(c);
 
 	switch (mode) {
@@ -1318,7 +1321,7 @@ static int vgacon_scroll(struct vc_data 
 	unsigned long oldo;
 	unsigned int delta;
 
-	if (t || b != c->vc_rows || vga_is_gfx)
+	if (t || b != c->vc_rows || vga_is_gfx || c->vc_mode != KD_TEXT)
 		return 0;
 
 	if (!vga_hardscroll_enabled || lines >= c->vc_rows / 2)

--=-OlrXoJMmsmDP2sEf1/Mr--

