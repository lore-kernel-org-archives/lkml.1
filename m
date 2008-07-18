Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYGROOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYGROOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYGROOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:14:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbYGROOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:14:39 -0400
Subject: Re: The request_firmware() changes causing problems with make-kpkg
From: David Woodhouse <dwmw2@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <20080718115833.GC11221@mit.edu>
References: <20080718115833.GC11221@mit.edu>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 07:14:35 -0700
Message-Id: <1216390475.31897.36.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 07:58 -0400, Theodore Tso wrote:
> Using 2.6.26-git4 and -git6, and with CONFIG_FIRMWARE_IN_KERNEL=y,
> make modules_install is calling firmware_install, which is dropping
> files in /lib/firmware --- which make-kpkg is happily picking up and
> including in the debian kernel package.  Which was fine --- until I
> tried to build and install kernel package for -git6, at which point I
> got an error at install time because the second package was tying to
> overwrite files installed by the first linux-image file.  Doh!

Fedora has already taken the other approach -- it uses 'make
firmware_install' to create a noarch package, and each binary package
depends on that. You can have multiple kernel binaries, but you only
need to have the latest firmware package. (Just like you only need one
kernel-headers package.)

The GPL zealots can now drop that firmware package from their build
(actually, to satisfy the hard dependency they probably need to build
their own replacement with only the one or two firmwares for which we
have source), and then they can sod off and stop bothering us.

I would be quite surprised if Debian didn't want to take this kind of
approach, in the fairly short term -- shipping the firmware in a
separate package.

> Given that Ubuntu's firmware loader already tries to find firmware at
> /lib/firmware/<kpkg> and only if that fails, to load it from
> /lib/firmware, it seems like the obvious thing to do is to add a
> quickie CONFIG option which changes the default setting of
> INSTALL_FW_PATH in the top-level makefile from /lib/firwmare to
> /lib/firmware/<kver>.

I assume those are actually the same -- <kpkg> vs. <kver>?

> Maybe the userspace for other distributions won't support this, but
> they can simply not use this CONFIG option for now; but it will solve
> the problem for all Ubuntu, and possibly Debian, users who want to
> build their own kernel using make-kpkg.  If I cons a patch like this,
> is there likely going to be any objections with it getting merged?

Hm. The way we normally override such paths is with make variables.

If you really can't just fix make-kpkg to set INSTALL_FW_PATH when
installing modules, you could export MAKEFLAGS=INSTALL_FW_PATH=/foo
before invoking make-kpkg.

Your logic is that it's easier for you to update your config than to
override $(INSTALL_FW_PATH) by either method above? 

It seems a little odd to me, but I suppose I don't have any particular
objection if that's _really_ the case. The makefiles are baroque enough
anyway; it would be churlish of me to object to a bit more complexity :)

Given that 'make firmware_install' is intended to work when there is
no .config, I would probably recommend making the new config option
affect only modules_install rather than also affecting firmware_install.

In general, I don't much like putting firmware in a kver-specific
directory. It _doesn't_ change from kernel to kernel, as a general rule
-- and on the rare occasions that it does change incompatibly from
kernel to kernel, we should be changing the filename anyway. But as a
short-term hack I certainly see the utility of it.

-- 
dwmw2

