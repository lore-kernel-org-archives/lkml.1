Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXIURqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXIURqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXIURqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:46:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3849 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbXIURqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:46:14 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Rob Landley <rob@landley.net>, Indan Zupancic <indan@nul.nu>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <10228.1190394985@turing-police.cc.vt.edu>
References: <46F1645D.9050406@am.sony.com>
	 <200709201538.43093.rob@landley.net>
	 <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
	 <200709201818.42125.rob@landley.net>
	 <10228.1190394985@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 10:45:27 -0700
Message-Id: <1190396728.32660.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 13:16 -0400, Valdis.Kletnieks@vt.edu wrote:
> What about something *really* hardcore ugly like:
> #ifdef __FILE__
> #undef __FILE__
> #define __FILE__ ""
> #endif
> (or similar preprocessor blecherousness) if you want to *really* shrink
> that binary down?

I prefer removing all __FILE__, __FUNCTION__, __LINE__ uses
from printks and defining something that modifies pr_<level>.

Something like:

#define PR_FILE
#define PR_FUNCTION
#define PR_LINE

#if    defined PR_FILE &&  defined PR_FUNCTION &&  defined PR_LINE
#define PR_FMT "(%s:%s:%u) "
#define PR_ARG , __FILE__ , __FUNCTION__ , __LINE__ 
#elif  defined PR_FILE &&  defined PR_FUNCTION && !defined PR_LINE
#define PR_FMT "(%s:%s) "
#define PR_ARG , __FILE__ , __FUNCTION__ 
#elif  defined PR_FILE && !defined PR_FUNCTION &&  defined PR_LINE
#define PR_FMT "(%s:%u) "
#define PR_ARG , __FILE__ , __LINE__ 
#elif  defined PR_FILE && !defined PR_FUNCTION && !defined PR_LINE
#define PR_FMT "(%s) "
#define PR_ARG , __FILE__ 
#elif !defined PR_FILE &&  defined PR_FUNCTION &&  defined PR_LINE
#define PR_FMT "(%s:%u) "
#define PR_ARG , __FUNCTION__ , __LINE__ 
#elif !defined PR_FILE &&  defined PR_FUNCTION && !defined PR_LINE
#define PR_FMT "(%s) "
#define PR_ARG , __FUNCTION__ 
#elif !defined PR_FILE && !defined PR_FUNCTION && defined PR_LINE
#define PR_FMT "(%u) "
#define PR_ARG , __LINE__ 
#else
#define PR_FMT
#define PR_ARG
#endif

#define pr_info(fmt, arg) printk(KERN_INFO PR_FMT fmt PR_ARG, ##arg)


