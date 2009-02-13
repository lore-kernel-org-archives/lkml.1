Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZBMBre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZBMBre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbZBMBrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:47:20 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41033 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605AbZBMBrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:47:19 -0500
Date: Thu, 12 Feb 2009 20:46:40 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 6/7] Ksplice: Export symbols needed for Ksplice
In-Reply-To: <200902042205.09651.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0902080129020.11936@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-6-git-send-email-jbarnold@mit.edu> <1228521840-3886-7-git-send-email-jbarnold@mit.edu> <200902042205.09651.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rusty Russell wrote:

> On Saturday 06 December 2008 10:33:59 Jeff Arnold wrote:
> > From: Tim Abbott <tabbott@mit.edu>
> > 
> > Ksplice uses several functions from module.c in order to resolve
> > symbols and implement dependency handling.  Calling these functions
> > requires holding module_mutex, so it is exported.
> 
> I have fought every attempt to export that.  It was long a cause of misery
> and pain; people saw the lock and so started grabbing it.
> 
> Any chance we can find another way?

It is definitely possible, but it wouldn't be pretty.  There are a few 
things that we use module_mutex for:

(1) Preventing races involving modules being unloaded during run-pre 
matching.  Functions such as kallsyms_on_each_symbol, find_symbol, 
__module_text_address, __module_address, and find_module that are used to 
obtain a module or a symbol can only be used within preempt_disable or 
while holding module_mutex.  Further, the values that they return can only 
be used in the same such context, unless one module_gets the relevant 
module in that context.

So, we'd change/add wrappers to a bunch of these functions to do their own 
preempt_disable or grabbing of module_mutex, and to module_get the 
relevant module before they return.  We'd also need to change the Ksplice 
code to module_put whenever we stop referencing a symbol.  Since a lot of 
the Ksplice kernel code is related to resolving symbols, I suspect this 
latter part would be somewhat messy.

(2) Calling use_module.  use_module needs to be called while holding 
module_mutex because it changes the modules_which_use_me lists.

We could change this by creating a modified version of use_module that 
grabs module_mutex itself; perhaps renaming the current use_module to 
__use_module.

(3) Preventing races involving two different Ksplice updates being applied 
at the same time.

This one is easy; we could just create a new ksplice_mutex.

	-Tim Abbott
