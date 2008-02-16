Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYBPLYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYBPLYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYBPLYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:24:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55117 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbYBPLYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:24:33 -0500
Date: Sat, 16 Feb 2008 12:24:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, miltonm@bga.com, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove the new perl dependency from build.
Message-ID: <20080216112441.GA11362@uranus.ravnborg.org>
References: <200802152010.05505.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802152010.05505.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob.
> 
> Remove perl dependency introduced in 2.6.25-rc1, by shipping kernel/timeconst.h
> with all the "canned" values so perl is only used to regenerate it if that
> file is deleted.
While I agree that we should keep the dependencies low for building a kernel
trying to avoid the perl dependency is in the long rund a dead-end.

I have for a while considered replacing part of the kbuild gmake magic
with a perl script thus pushing towards a mandatory dependency
on perl.

A few comments on the actual patch.

> --- linux/hg/kernel/Makefile	2008-02-08 19:06:59.000000000 -0600
> +++ linux-new/kernel/Makefile	2008-02-15 19:32:08.000000000 -0600
> @@ -95,7 +95,7 @@
>  $(obj)/time.o: $(obj)/timeconst.h
>  
>  quiet_cmd_timeconst  = TIMEC   $@
> -      cmd_timeconst  = $(PERL) $< $(CONFIG_HZ) > $@
> -targets += timeconst.h
> -$(obj)/timeconst.h: $(src)/timeconst.pl FORCE
> +      cmd_timeconst  = $(PERL) $< \
> +            24 32 48 64 100 122 128 200 250 256 300 512 1000 1024 1200 > $@
> +$(obj)/timeconst.h:
>  	$(call if_changed,timeconst)

We will only build timeconst.h if the file is missing and this
is not the desired behaviour.
What could be done to make the perl dependency optional would be to
introduce a small shell wrapper.
If called with a CONFIG_HZ value that is unknow use the perl script
to generate the .h file.
For known HZ values take a copy of the shipped .h file.

The MAkefile bits would looke like this:
      cmd_timeconst  = $(CONFIG_SHELL) $< $(CONFIG_HZ)

targets += timeconst.h
$(obj)/timeconst.h: $(src)/timeconst.sh FORCE
	$(call if_changed,timeconst)

Using 'if_changed' will make sure we call the shell script
when HZ is changed.

	Sam
