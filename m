Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZKKG5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZKKG5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZKKG5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:57:05 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:33079 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZKKG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:57:04 -0500
Message-ID: <4AFA603B.6000102@ladisch.de>
Date: Wed, 11 Nov 2009 07:56:59 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Daniel Mack <daniel@caiaq.de>
CC: Pavel Machek <pavel@ucw.cz>, David Newall <davidn@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de>	<20091109091044.GX29442@buzzloop.caiaq.de>	<4AF7DDC1.4090006@ladisch.de>	<20091109095316.6283fbd6@lxorguk.ukuu.org.uk>	<4AF7FC64.6030904@ladisch.de>	<20091109114600.4d91b90e@lxorguk.ukuu.org.uk>	<20091109145056.GB14091@buzzloop.caiaq.de>	<4AF8582B.2000403@davidnewall.com>	<20091109220944.GH14091@buzzloop.caiaq.de>	<20091110210940.GA1590@ucw.cz> <20091110152605.fc8e760e.akpm@linux-foundation.org>
In-Reply-To: <20091110152605.fc8e760e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
> > On Mon 2009-11-09 23:09:44, Daniel Mack wrote:
> > > On Tue, Nov 10, 2009 at 04:28:03AM +1030, David Newall wrote:
> > > > Daniel Mack wrote:
> > > > > And even if the cursor behaviour is changable at runtime, I don't see
> > > > > why it shouldn't have a selectable compile time default. Which is what
> > > > > the patch adds.
> > > > 
> > > > It seems like adding cruft to the kernel that is just as effectively
> > > > available at run-time. Where does it end? Do we eventually add bash to
> > > > the kernel?
> > > 
> > > One more thing:
> > > 
> > > Clemens' last patch didn't add anything to the kernel's binary size.
> > > It didn't slow down anything either, as there is no run-time condition
> > > evaluation. It just makes something configurable which was hard
> > > coded before. So where's the cruft?
> > 
> > The number of configs to test just got bigger. 100% bigger in
> > fact. Every single developer will have to answer 'do you want blinking
> > cursor?' when your patch is merged.
> > 
> > config options _are_ expensive.
> 
> Plus it's nice not to have to rebuild and reinstall the kernel to flip
> a single bit...
> 
> The module_param() approach seems OK to me.

[PATCH] vt: make the default cursor shape configurable

Make the default console cursor type configurable rather than
hard-coding it.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..750a42f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2704,6 +2704,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vt.cur_default=	[VT] Default cursor shape.
+			Format: 0xCCBBAA, where AA, BB, and CC are the same as
+			the parameters of the <Esc>[?A;B;Cc escape sequence;
+			see VGA-softcursor.txt. Default: 2 = underline.
+
 	vt.default_blu=	[VT]
 			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
 			Change the default blue palette of the console.
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..21dd136 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -162,6 +162,9 @@ static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
+static int cur_default = CUR_DEFAULT;
+module_param(cur_default, int, S_IRUGO | S_IWUSR);
+
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
  * mainly for the privacy of braille terminal users.
@@ -1630,7 +1633,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	/* do not do set_leds here because this causes an endless tasklet loop
 	   when the keyboard hasn't been initialized yet */
 
-	vc->vc_cursor_type = CUR_DEFAULT;
+	vc->vc_cursor_type = cur_default;
 	vc->vc_complement_mask = vc->vc_s_complement_mask;
 
 	default_attr(vc);
@@ -1832,7 +1835,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 				if (vc->vc_par[0])
 					vc->vc_cursor_type = vc->vc_par[0] | (vc->vc_par[1] << 8) | (vc->vc_par[2] << 16);
 				else
-					vc->vc_cursor_type = CUR_DEFAULT;
+					vc->vc_cursor_type = cur_default;
 				return;
 			}
 			break;
