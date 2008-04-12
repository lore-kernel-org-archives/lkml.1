Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbYDLQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbYDLQmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYDLQm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:42:26 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:32913 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752383AbYDLQmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:42:25 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 13 Apr 2008 02:42:16 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Remember the message level for multi-line	output
Message-ID: <20080412164215.GC29599@tull.net>
References: <20080412161733.24882.30930.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412161733.24882.30930.stgit@marcab.local.tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 02:18:54AM +1000, Nick Andrew wrote:
> -	static int log_level_unknown = 1;
> +	static int new_text_line = 1;

Further to the previous patch, maintaining the state of being in the
middle of an output line across calls to printk() opens up the
possibility of log corruption when calling code uses printk() to
output fragments of a line. This seems to happen a lot in the
codebase, for example (from arch/blackfin/kernel/traps.c):

        printk(KERN_NOTICE "Stack from %08lx:", (unsigned long)stack);
        for (i = 0; i < kstack_depth_to_print; i++) {
                if (stack + 1 > endstack)
                        break;
                if (i % 8 == 0)
                        printk("\n" KERN_NOTICE "       ");
                printk(" %08lx", *stack++);
        }
        printk("\n");

The caller should be building complete output lines, at a minimum.
Or, to maintain the convenient coding, there would need to be an
intermediate function which buffers the partial lines until the
caller issues a flush call.

Nick.
