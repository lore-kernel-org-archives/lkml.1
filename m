Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYIVTOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYIVTOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYIVTOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:14:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47627 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYIVTON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:14:13 -0400
Date: Mon, 22 Sep 2008 20:13:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 1/3] watchdog: sync linux-omap changes
Message-ID: <20080922191353.GB8314@flint.arm.linux.org.uk>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com> <1221873243-18303-2-git-send-email-me@felipebalbi.com> <20080922182206.GM22550@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922182206.GM22550@infomag.infomag.iguana.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 08:22:06PM +0200, Wim Van Sebroeck wrote:
> Hi All,
> 
> last item that (for me) is still open is:
> > +struct omap_wdt_dev {
> > +	void __iomem    *base;          /* physical */
> > +	struct device   *dev;
> 
> is dev indeed unused or is it used by platform specific code?
> If this is sorted out this will go into the watchdog-mm tree.

It's unused, but it's a minor point, something that shouldn't stand
in the way of it going into the watchdog tree.  It doesn't cause a
build error and doesn't cause malfunction.  It's just a little untidy
and can be addressed separately.

However, if you want Filipe to redo the patch yet again (risking him
getting pissed off with the number of times round the loop it's taking
for what should be a simple driver) there's also this:

@@ -219,12 +240,12 @@ static long omap_wdt_ioctl(struct file *file, unsigned int+cmd,
                omap_wdt_adjust_timeout(new_margin);

                spin_lock(&wdt_lock);
-               omap_wdt_disable();
-               omap_wdt_set_timeout();
-               omap_wdt_enable();
-
-               omap_wdt_ping();
+               omap_wdt_disable(wdev);
+               omap_wdt_set_timeout(wdev);
+               omap_wdt_enable(wdev);
                spin_unlock(&wdt_lock);
+
+               omap_wdt_ping(wdev);

which is moving omap_wdt_ping() outside of the spin lock, which I
doubt actually causes any problem in real life on OMAP platforms.
Granted that theoretically and logically it's wrong.
