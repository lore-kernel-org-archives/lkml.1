Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXFMTT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXFMTT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXFMTTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:19:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1539 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXFMTTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:19:52 -0400
X-Greylist: delayed 865 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 15:19:50 EDT
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Joe Perches <joe@perches.com>
To: holzheu@linux.vnet.ibm.com
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
In-Reply-To: <1181758680.26375.25.camel@localhost.localdomain>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613175147.GB14355@suse.de>
	 <1181758680.26375.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 12:04:56 -0700
Message-Id: <1181761496.6020.158.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 20:18 +0200, holzheu wrote:
> But they unfortunately do not solve our problem. We need an identifier
> for a documented message in order to find the right description for a
> message.

I believe it better to simply add __FILE__ & __LINE__ to the
macro rather than some other externally specified unique
identifier that adds developer overhead and easily gets stale.

If you go overboard, you could do something like:

#define dev_dbg(dev, format, arg...)		\
	dev_printk(KERN_DEBUG, dev, DBG_FMT format DBG_ARG, ## arg)

#define dev_err(dev, format, arg...)		\
	dev_printk(KERN_ERR, dev, PR_FMT format PR_ARG, ## arg)

etc...

and use config variables to control what additional info is printk'ed.

Go overboard without a life preserver and add __TIMESTAMP__ too.

/*
 */
#if defined DBG_FMT
#undef DBG_FMT
#endif
#if defined DBG_ARG
#undef DBG_ARG
#endif

#if    defined DBG_FILE &&  defined DBG_FUNCTION &&  defined DBG_LINE
#define DBG_FMT "(%s:%s:%u) "
#define DBG_ARG , __FILE__ , __FUNCTION__ , __LINE__ 
#elif  defined DBG_FILE &&  defined DBG_FUNCTION && !defined DBG_LINE
#define DBG_FMT "(%s:%s) "
#define DBG_ARG , __FILE__ , __FUNCTION__ 
#elif  defined DBG_FILE && !defined DBG_FUNCTION &&  defined DBG_LINE
#define DBG_FMT "(%s:%u) "
#define DBG_ARG , __FILE__ , __LINE__ 
#elif  defined DBG_FILE && !defined DBG_FUNCTION && !defined DBG_LINE
#define DBG_FMT "(%s) "
#define DBG_ARG , __FILE__ 
#elif !defined DBG_FILE &&  defined DBG_FUNCTION &&  defined DBG_LINE
#define DBG_FMT "(%s:%u) "
#define DBG_ARG , __FUNCTION__ , __LINE__ 
#elif !defined DBG_FILE &&  defined DBG_FUNCTION && !defined DBG_LINE
#define DBG_FMT "(%s) "
#define DBG_ARG , __FUNCTION__ 
#elif !defined DBG_FILE && !defined DBG_FUNCTION && defined DBG_LINE
#define DBG_FMT "(%u) "
#define DBG_ARG , __LINE__ 
#else
#define DBG_FMT
#define DBG_ARG
#endif

/*
 */

#if defined PR_FMT
#undef PR_FMT
#endif
#if defined PR_ARG
#undef PR_ARG
#endif

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


