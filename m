Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbXE3Ssk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbXE3Ssk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbXE3Ssd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:48:33 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38693
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXE3Ssc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:48:32 -0400
From: Rob Landley <rob@landley.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch] tweak make htmldocs (nochunks and better index).
Date: Wed, 30 May 2007 14:47:41 -0400
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <200705291528.34092.rob@landley.net> <20070529211809.d995a5f7.randy.dunlap@oracle.com>
In-Reply-To: <20070529211809.d995a5f7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705301447.41421.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 12:18 am, Randy Dunlap wrote:
> What is <\p> supposed to do?

Sorry, typo.  Should be </p> instead.  My bad.

As to what it does in a larger sense, "make the xml people happy".  Closing
parentheses tags make the various xhtml validators shut up.  The main
difference between xhtml and html is that you close all the tags you open.  I
can yank it if people prefer it that way.

> Here's what I see in index.html (beginning lines of it):
> 
> Linux Kernel HTML Documentation
> Kernel Version: 2.6.22-rc3
> 
> deviceiobookBus-Independent Device Accesses <\p>

Yeah, that's screwed up.  (It looked fine in Konqueror. :)  *rummage*...

Here's an updated patch.  This time I checked that it looked ok in Firefox
too:

--- git/Documentation/DocBook/Makefile	2007-05-23 16:36:56.000000000 -0400
+++ work/Documentation/DocBook/Makefile	2007-05-30 14:36:49.000000000 -0400
@@ -141,9 +141,12 @@
 		   cat $(HTML) >> $(main_idx)
 
 quiet_cmd_db2html = HTML   $@
-      cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
-		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
-        $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
+      cmd_db2html = xmlto xhtml-nochunks $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
+		NAME='$(patsubst %.html,%,$(notdir $@))'; \
+		echo -n "<p><a HREF=\"$$NAME/$$NAME.html\">$$NAME</a> - " >$@; \
+		sed -nre 's@.*<title>(.*)</title>.*@\1@p' \
+			"Documentation/DocBook/$$NAME/$$NAME.html" >> $@ ; \
+		echo '</p>' >> $@
 
 %.html:	%.xml
 	@(which xmlto > /dev/null 2>&1) || \

Rob
