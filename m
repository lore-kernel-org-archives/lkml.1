Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbYDXHDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbYDXHDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYDXHDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:03:32 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:51867 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYDXHDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:03:30 -0400
Date: Thu, 24 Apr 2008 09:00:52 +0200
Message-Id: <251743781@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: agruen@suse.de, linux-kernel@vger.kernel.org
Subject: Re: make cloneconfig ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+uGRyP27S1uai4YDgs5UdHIAMpWp0BfQtICx6Nqm+dkwtxG
 PtzMxgXsjekoTzZrObUfkFui38WvPsl9vLa/8yjLtzj9wTgS1w=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Isn't "cloneconfig" basically just "zcat /proc/config.gz > .config &&
> make oldconfig" ???  

yes (see below)

> If so, why do we need yet another "make
> <some_target>" Makefile rule? What would actually be gained?

ease of use and less confused users of suse-kernel based distro`s.
i have seen people giving hints for kernel compilation and telling "just do make cloneconfig" to non-suse users, just because they didn`t know, that this is suse specific.

ok, that`s not a real reason because you could argue that suse should drop it for more consistent end-user experience, but i think it`s much easier (and hassle free) to add it to mainline than drop it from suse. 

roland


List:       linux-kernel
Subject:    [kbuild 3/5] Add cloneconfig target
From:       Andreas Gruenbacher <agruen () suse ! de>
Date:       2005-01-18 18:41:23
Message-ID: 20050118192608.500213000.suse.de
[Download message RAW]

Cloneconfig takes the first configuration it finds which appears to
belong to the running kernel, and configures the kernel sources to match
this configuration as closely as possible.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6.11-rc1-bk6/scripts/kconfig/Makefile
===================================================================
--- linux-2.6.11-rc1-bk6.orig/scripts/kconfig/Makefile
+++ linux-2.6.11-rc1-bk6/scripts/kconfig/Makefile
@@ -37,6 +37,22 @@ allnoconfig: $(obj)/conf
 allmodconfig: $(obj)/conf
 	$< -m arch/$(ARCH)/Kconfig
 
+UNAME_RELEASE := $(shell uname -r)
+CLONECONFIG := $(firstword $(wildcard /proc/config.gz \
+				      /lib/modules/$(UNAME_RELEASE)/.config \
+				      /etc/kernel-config \
+				      /boot/config-$(UNAME_RELEASE)))
+cloneconfig: $(obj)/conf
+	$(Q)case "$(CLONECONFIG)" in				\
+	'')	echo -e "The configuration of the running"	\
+			"kernel could not be determined\n";	\
+		false ;;					\
+	*.gz)	gzip -cd $(CLONECONFIG) > .config.running ;;	\
+	*)	cat $(CLONECONFIG) > .config.running ;;		\
+	esac &&							\
+	echo -e "Cloning configuration file $(CLONECONFIG)\n"
+	$(Q)$< -D .config.running arch/$(ARCH)/Kconfig
+
 defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
 	$< -d arch/$(ARCH)/Kconfig

--
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX PRODUCTS GMBH



> -----Ursprüngliche Nachricht-----
> Von: "Jesper Juhl" <jesper.juhl@gmail.com>
> Gesendet: 24.04.08 00:43:56
> An: "devzero@web.de" <devzero@web.de>
> CC: linux-kernel@vger.kernel.org, agruen@suse.de
> Betreff: Re: make cloneconfig ?


> On 24/04/2008, devzero@web.de <devzero@web.de> wrote:
> > any reason why "make cloneconfig" never made it into mainline?
> >
> >  many people are quite used to it and every time i build vanilla kernel i step into that trap  "oh - that`s a suse`ism"
> >
> >  make cloneconfig exists since /proc/config.gz - but while that one went into mainline, cloneconfig never did.
> >
> >  anyone know the reason for that ?
> >
> >  i wished, distros kernels were more similar to vanilla kernels - so what about making them more similar ?
> >
> >
> 
> Isn't "cloneconfig" basically just "zcat /proc/config.gz > .config &&
> make oldconfig" ???   If so, why do we need yet another "make
> <some_target>" Makefile rule? What would actually be gained?
> 
> -- 
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
> 


_______________________________________________________________
Schon gehört? Der neue WEB.DE MultiMessenger kann`s mit allen: 
http://www.produkte.web.de/messenger/?did=3016

