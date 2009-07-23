Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbZGWIOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbZGWIOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGWIOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:14:18 -0400
Received: from ns.firmix.at ([62.141.48.66]:4892 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZGWIOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:14:15 -0400
Subject: Re: question for C preprocessor wizards
From: Bernd Petrovitsch <bernd@firmix.at>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <20090723010715.GA5712@cr0.nay.redhat.com>
References: <4A675F89.50506@nortel.com>
	 <20090723010715.GA5712@cr0.nay.redhat.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 23 Jul 2009 10:14:05 +0200
Message-Id: <1248336845.7489.8.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.276 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.276 required=5
X-Spam-Score: -2.276 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 09:07 +0800, Amerigo Wang wrote:
> On Wed, Jul 22, 2009 at 12:50:49PM -0600, Chris Friesen wrote:
> >
> >I'm hoping someone can help me out.
> 
> 
> This is _not_ a question about kernel. :)
> 
> >
> >I've got a bunch of code that call a bunch of different wrapper
> >routines, with varying numbers of arguments.  Depending on whether a
> >compile flag is set, I want to do some stuff before and after calling
> >the "real" routine.  I can do this easily enough with a macro.
> >
> >#if FLAG
> >#define func_wrapper(args...) \
> >	do { \
> >		dostuff(); \
> >		func(args); \
> >		do_more_stuff(); \
> >	} while (0)
> >#else
> >#define func_wrapper(args...) func(args)
> >#endif
> >
> >
> >However, given that there are hundreds of functions, I'd like to
> >generate these macros with another macro, sort of like:
> >
> >#if FLAG
> >#define WRAPPER(func) \
> >	#define func # _wrapper(args...) \
> >	do { \
> >		dostuff(); \
> >		func(args); \
> >		do_more_stuff(); \
> >	} while (0)
> >#else
> >#define WRAPPER(func) \
> >	#define func ## _wrapper(args...) func(args)
> >#endif
> >
> >Where I could then do
> >
> >WRAPPER(func1)
> >WRAPPER(func2)
> >...
> >WRAPPER(func100)
> >
> >
> >However, the preprocessor complains about having that "#" in the macro
> >body where it isn't used for stringification.
One can't generate preprocessor directive via #define.

> >Anyone have any ideas how to accomplish this?  I had considered writing
> >an app to programmatically generate an include file as a precursor to
> >actually compiling the real app, but I was hoping there was a more
> >elegant solution.
Personally, I don't find it in elegant to generate simple/trivial .c
or .h files with some small-ish perl/shell-script via sane Makefile
rules. Perhaps unless the contents is (almost) never going to change
(and even then there might be good reasons).
Within the kernel, it's probably better to avoid perl-scripts for easier
acceptance.

> Well, you can define func() as a real function instead of a macro,
> i.e:
> 
> #define WRAPPER(func) \
>  void func ## _wrapper(args, ...) \
>  {  \
>     dostuff(); \
>     func(args); \
>     do_more_stuff(); \
>  }
ACK.

Or the other way around:
Have dostuff() at the begin and do_more_stuff() at the end of the real
function in the source and #if-them-away per
----  snip  ----
#if FLAG
void dostuff();
void do_more_stuff();
#else
#define dostuff() ((void)0)
#define do_more_stuff() ((void)0)
#endif
----  snip  ----

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


