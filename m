Return-Path: <linux-kernel-owner+w=401wt.eu-S940027AbXGTAwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940027AbXGTAwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965479AbXGTAvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:51:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1088 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965434AbXGTAvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:51:32 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 20:51:31 EDT
Subject: RFC - pr_info,warn,dbg,err and PREFIX
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 19 Jul 2007 17:42:38 -0700
Message-Id: <1184892158.26827.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A number of local #defines or functions exist which merely
add a constant prefix to printks.  Perhaps it is better
to have these functions standardized.

Thoughts?

A method to prefix pr_info messages with an arbitrary prefix
(#define PREFIX "foo") could be:

--------------------------------

#define PRINTK_stringify_1(x) #x
#define PRINTK_stringify(x) PRINTK_stringify_1(x)

#define PRINTK_USEPREFIX (strcmp(PRINTK_stringify(PREFIX), "PREFIX"))

#define PRINTK_PREFIX(PREFIX) \
({const char *p = PRINTK_USEPREFIX(PREFIX) ? PRINTK_stringify(PREFIX) + 1 : ""; p;})

#define PRINTK_PREFIXLEN(PREFIX) \
({int len = PRINTK_USEPREFIX(PREFIX) ? strlen(PRINTK_stringify(PREFIX)) - 2 : 0; len;})

#define PRINTK_PREFIXSEPARATOR(PREFIX) \
({const char *p = PRINTK_USEPREFIX(PREFIX) ? ": " : ""; p;})

#define PRINTK_PREFIXFMT "%.*s%s"
#define PRINTK_PREFIXARG PRINTK_PREFIXLEN(PREFIX), PRINTK_PREFIX(PREFIX), PRINTK_PREFIXSEPARATOR(PREFIX)

#define pr_info(fmt, arg...) printk(KERN_INFO PRINTK_PREFIXFMT fmt, PRINTK_PREFIXARG, ##arg)
#define pr_warn(fmt, arg...) printk(KERN_WARNING PRINTK_PREFIXFMT fmt, PRINTK_PREFIXARG, ##arg)
#define pr_err(fmt, arg...) printk(KERN_ERR PRINTK_PREFIXFMT fmt, PRINTK_PREFIXARG, ##arg)

---------------

With a #define of PREFIX:
	#define PREFIX "abc"
	pr_info("msg\n")
output:
	<6>abc: msg

without a #define of PREFIX:
	pr_info("msg\n")
output:
	<6>msg

---------------


