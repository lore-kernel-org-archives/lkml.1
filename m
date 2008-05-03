Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYECUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYECUJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYECUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:09:28 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:52155 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbYECUJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:09:27 -0400
Date: Sat, 03 May 2008 22:09:25 +0200
Message-Id: <263875520@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: adaplas@gmail.com, alan@lxorguk.ukuu.org.uk, edward@debian.org,
       jsimmons@infradead.org, Soeren Sonnenburg <kernel@nn7.de>,
       matan@svgalib.org
Subject: =?iso-8859-15?Q?[PATCH]_mdacon_messing_up_default_vc's,_set_default_to?=
 =?iso-8859-15?Q?_vc13-16_again?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1945u0nIWDsIqyckb8OMVAeZ7KNiHccs4LRr8DqacXctTDYi
 l1SDaS4ZXXzqNbk+s0cyLczFGSYgHBtlUvEwyEWcSfGw0bebqM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mdacon incorrectly detects MDA hardware on systems without such graphics card.

one may load this module by chance, for example when doing some systematical 
module-testing, and if there is no Monochrome Display Adapter attached , module init 
renders vc1-16 completely unusable. 

me and others have run into this more than once. see [Bug 224522 - modprobe mdacon 
freezes machine -> https://bugzilla.novell.com/show_bug.cgi?id=224522 ] for example

apparently, proper MDA detection seems to be broken for a long time - seems to be 
related to those #ifdef TEST_MDA_B statements added by Edward Betts.

this commit back in 2002 made things even worse :
http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=c72757b49c88914433244757fb4967fc63546685
 
it changed default vc allocation from 13-16 to 1-16  for no apparent reason (!?) , and 
with that (and without X), mdacon grabs the vc you`re currently sitting on and locks you out.

this is from Kconfig :
>config MDA_CONSOLE
>        depends on !M68K && !PARISC && ISA
>        tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
>        ---help---
>          Say Y here if you have an old MDA or monochrome Hercules graphics
>          adapter in your system acting as a second head ( = video card). You
>          will then be able to use two monitors with your Linux system. Do not
>          say Y here if your MDA card is the primary card in your system; the
>          normal VGA driver will handle it.

As we can see mdacon is just meant as an additional driver for dual-head setup, 
and since kernel 2.4.36 still defaults to vc13-16 ,  setting the default back to that value 
again shouldn`t  do any harm. 

hereby i`m reverting that change, setting default back to to vc13-16 again.

Besides the fact that mdacon may be rarely or never be used these days and could 
perhaps put to trash anyway (pre-dinosaur hardware!), indeed this is not a real solution,  
but at least it removes the unfortunate side-effect of messing up the vc you`re working on.


Signed-off-by: Roland Kletzing <devzero@web.de>

--- drivers/video/console/mdacon.c.orig 2008-05-03 15:47:20.000000000 +0200
+++ drivers/video/console/mdacon.c      2008-05-03 15:55:27.000000000 +0200
@@ -71,13 +71,15 @@

 /* console information */

-static int     mda_first_vc = 1;
+static int     mda_first_vc = 13;
 static int     mda_last_vc  = 16;

 static struct vc_data  *mda_display_fg = NULL;

 module_param(mda_first_vc, int, 0);
+MODULE_PARM_DESC(mda_first_vc, "First virtual console. Default: 13");
 module_param(mda_last_vc, int, 0);
+MODULE_PARM_DESC(mda_last_vc, "Last virtual console. Default: 16");

 /* MDA register values
  */

_______________________________________________________________________
EINE FÜR ALLE: die kostenlose WEB.DE-Plattform für Freunde und Deine
Homepage mit eigenem Namen. Jetzt starten! http://unddu.de/?kid=kid@mf2

