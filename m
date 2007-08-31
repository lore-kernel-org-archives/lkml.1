Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbXHaXgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbXHaXgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 19:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXHaXgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 19:36:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48584 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbXHaXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 19:36:21 -0400
Date: Sat, 1 Sep 2007 05:19:27 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@kernel-bugs.osdl.org
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
In-Reply-To: <116718.45429.qm@web52005.mail.re2.yahoo.com>
Message-ID: <alpine.LFD.0.999.0709010400440.13094@enigma.security.iitk.ac.in>
References: <116718.45429.qm@web52005.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Matti Linnanvuori wrote:
> 
> It seems to me that kernel/module.c allows the whole kernel to use
> exported symbols during the execution of the init function if they are
> weak:
>                         /* Ok if weak.  */
>                           if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
>                                   break;
> That seems a possible way to produce the scenario of this so-called bug.

No, even that won't reproduce the bug you're talking about, and you
clearly don't know how weak symbols are supposed to work / be used :-)
simplify_symbols() -> resolve_symbol() is called to resolve /external/
symbols that the module-being-loaded references, and error out in case
no such (global, exported) symbol was currently found.

So the "sym[i]" there refers to the (as yet unresolved) symbol referenced
in the _dependent module B_, that it sees exported as a weak symbol
(probably because marked as such in some header prototype). That check is
to support usage where we still allow B to load without A being loaded,
because it's somehow ensured that B will never call that function at
runtime unless it is available ... something like:

extern void mod_a_func(void) __attribute__((weak));
static int __init mod_b_init(void)
{
        if (mod_a_func)
                mod_a_func();
        else {
                /* some remedial action */
                printk(KERN_INFO "own little mod_a_func fallback\n");
        }
        return 0;
}

Try running the same test I described in previous post with this change.

Moreover, failure to check (mod_a_func) will cause an _oops_, and *not*
the "module A's exported function being called even when module_init()
has not finished" issue that you've complained about. So things look
alright to me on this front, the bug has been rightly rejected as invalid.
And as Arjan pointed out, if you really saw such an issue, please post
some code instead, so that we can have a look.

Thanks,

Satyam
