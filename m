Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbYGOU5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbYGOU5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbYGOU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:57:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbYGOU51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:57:27 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <1216154956.26991.30.camel@shinybook.infradead.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <200807152245.44817.rjw@sisk.pl>
	 <1216154956.26991.30.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:57:24 -0700
Message-Id: <1216155444.26991.33.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:49 -0700, David Woodhouse wrote:
> Sam, why do we have FORCE on the rules for $(hostprogs-y)? It forces the
> ihex2fw tool to be rebuilt, which in turn forces all .HEX->.fw
> conversions to happen again, which means that 'make modules_install'
> wants to write to the source tree. That's a problem in some strange
> situations like Rafael's, where he builds on another host and exports
> the tree read-only by NFS.
> 
> Can we do this? ...

Alternatively, Rafael, does this do it for you?

--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -150,11 +150,11 @@ $(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
 # is actually meaningful, because the firmware has to be loaded in a certain
 # order rather than as a single binary blob. Thus, we convert them into our
 # more compact binary representation of ihex records (<linux/ihex.h>)
-$(obj)/%.fw: $(obj)/%.HEX $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.HEX | $(obj)/ihex2fw $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex2fw)
 
 # .H16 is our own modified form of Intel HEX, with 16-bit length for records.
-$(obj)/%.fw: $(obj)/%.H16 $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.H16 | $(obj)/ihex2fw $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,h16tofw)
 
 $(firmware-dirs):

-- 
dwmw2

