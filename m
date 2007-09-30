Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbXI3WOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbXI3WOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXI3WNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:13:55 -0400
Received: from lazybastard.de ([212.112.238.170]:45393 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbXI3WNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:13:54 -0400
Date: Sun, 30 Sep 2007 22:37:46 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Arnd Bergmann <arnd@arndb.de>, Indan Zupancic <indan@nul.nu>,
       Rob Landley <rob@landley.net>,
       Michael Opdenacker <michael@free-electrons.com>, linux-tiny@selenic.com,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] Linux-tiny project revival
Message-ID: <20070930203745.GB30514@lazybastard.org>
References: <46F1645D.9050406@am.sony.com> <200709270900.36602.arnd@arndb.de> <39129.81.207.0.53.1190910941.squirrel@secure.samage.net> <200709280021.34783.arnd@arndb.de> <1190968746.15499.4.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1190968746.15499.4.camel@tara.firmix.at>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 September 2007 10:39:06 +0200, Bernd Petrovitsch wrote:
> 
> If think you misunderstood:
> Say, you compile out everything of DEBUG level.
> Say, you have a continued printk() after each and every pr_debug().
> 
> Then how is the macro supposed to know (at compile-time) that the
> continued printk()  actually belongs to a DEBUG printk (and not another
> one)?

#if CONFIG_PRINTK_DOICARE >= 3
#define PRINTK_DEBUG_CONTINUED "",
#else
#define PRINTK_DEBUG_CONTINUED PRINTK_DEBUG
#endif
...

#define printk(level, str, ...) \
   do { \
     if (sizeof(level) == 1) /* continued printk */\
        actual_printk(str, __VA_ARGS__); \
     else if ((level[1] - '0') < CONFIG_PRINTK_DOICARE) \
       actual_printk(level str, __VA_ARGS__); \
   } while(0);

Now you can mark a continued KERN_ERR call as such.  And depending on
CONFIG_PRINTK_DOICARE it will either be printed as always or turned into
a stand-alone printk() that gets optimized away.  Do the same for all
the other levels.

Open question remains: do we want to go down that road?  I have no idea.

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
