Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbYGOUtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbYGOUtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYGOUt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:49:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYGOUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:49:24 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <200807152245.44817.rjw@sisk.pl>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <200807152245.44817.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:49:16 -0700
Message-Id: <1216154956.26991.30.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 22:45 +0200, Rafael J. Wysocki wrote:
> Have you fixed the issue with FORCE in line 117 of
> scripts/Makefile.host?

I need to hassle Sam about that.

Sam, why do we have FORCE on the rules for $(hostprogs-y)? It forces the
ihex2fw tool to be rebuilt, which in turn forces all .HEX->.fw
conversions to happen again, which means that 'make modules_install'
wants to write to the source tree. That's a problem in some strange
situations like Rafael's, where he builds on another host and exports
the tree read-only by NFS.

Can we do this? ...

diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 1ac414f..c0b6a86 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -114,7 +114,7 @@ hostcxx_flags  = -Wp,-MD,$(depfile) $(__hostcxx_flags)
 quiet_cmd_host-csingle 	= HOSTCC  $@
       cmd_host-csingle	= $(HOSTCC) $(hostc_flags) -o $@ $< \
 	  	$(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-csingle): $(obj)/%: $(src)/%.c FORCE
+$(host-csingle): $(obj)/%: $(src)/%.c
 	$(call if_changed_dep,host-csingle)
 
 # Link an executable based on list of .o files, all plain c

-- 
dwmw2

