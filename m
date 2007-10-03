Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXJCPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXJCPOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJCPOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:14:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44298 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXJCPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:14:10 -0400
Date: Wed, 3 Oct 2007 08:12:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
 2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003081213.4676ae60@laptopd505.fenrus.org>
In-Reply-To: <20071003142600.GJ8181@ftp.linux.org.uk>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	<20071003084607.GC32218@elte.hu>
	<20071003133422.GI8181@ftp.linux.org.uk>
	<20071003140842.GA8837@elte.hu>
	<20071003142600.GJ8181@ftp.linux.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 15:26:01 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> On Wed, Oct 03, 2007 at 04:08:42PM +0200, Ingo Molnar wrote:
> > > Charming...  So we get d_path() either returning junk or we get 
> > > something that isn't NUL-terminated.  Which one it is?  I.e. what
> > > does p look like and what's in s?
> > 
> > could be use-after-free as well, as CONFIG_PAGEALLOC was enabled.
> 
> Umm...  d_path() had just written there, so use-after-free is not too
> likely to trigger page fault on read immediately afterwards - you'd
> need a pretty tight race to hit it.

I suspect we want the following patch out of general principles; Ingo,
can you see if this one helps?
(if not, it's still worth considering; it looks like we're first
destroying the device object (which holds the name of the directory)
before we unregister the directory... if that fails then we have a mess.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


--- linux-2.6.23-rc2/net/wireless/core.c~	2007-10-03 08:04:45.000000000 -0700
+++ linux-2.6.23-rc2/net/wireless/core.c	2007-10-03 08:04:45.000000000 -0700
@@ -133,8 +133,8 @@ void wiphy_unregister(struct wiphy *wiph
 	mutex_unlock(&drv->mtx);
 
 	list_del(&drv->list);
-	device_del(&drv->wiphy.dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
+	device_del(&drv->wiphy.dev);
 
 	mutex_unlock(&cfg80211_drv_mutex);
 }
