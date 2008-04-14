Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYDNKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYDNKM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYDNKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:12:16 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:48528 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751296AbYDNKMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:12:14 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Mon, 14 Apr 2008 20:12:00 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 2/2] printk: Remember the message level for multi-line	output
Message-ID: <20080414101200.GH29599@tull.net>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net> <20080413122735.31769.17716.stgit@marcab.local.tull.net> <20080414080351.GL16163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414080351.GL16163@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:03:51AM +0200, Ingo Molnar wrote:
> 
> * Nick Andrew <nick@nick-andrew.net> wrote:
> 
> > printk: Remember the message level for multi-line output
> > 
> > printk(KERN_ALERT "Danger Will Robinson!\nAlien Approaching!\n");
> > 
> > At present this will result in one message at ALERT level and one at 
> > the current default message loglevel (e.g. WARNING). This is 
> > non-intuitive.
> > 
> > Modify vprintk() to remember the message loglevel each time it is 
> > specified and use it for subsequent lines of output which do not 
> > specify one, within the same call to printk.
> 
> i've applied this too for testing.
> 
> but multi-line strings are a bit unclean i think: each message line 
> should have its separate printk.

You'd think. But there are a lot of calls to printk() with multi-line
format strings; developers clearly expect it to "just work" and
that a message level set at the start will be retained across lines.

> will your patch leave the behavior of multiple calls to printk alone? 
> I.e. if i do:
> 
>   printk(KERN_ALERT "Danger Will Robinson!\n");
>   printk("Alien Approaching!\n");
> 
> then we'll still get a KERN_ALERT plus a default printk, right?

Yes, quite. The state of whether we're inside a line is retained
across calls to printk (from anywhere in the system) - this allows
code like this to usually do what you expect:

	printk(KERN_ERR "Error:");
	for (i = 0; i < 16; ++i) {
		printk("  %02x", i);
	}
	printk("\n");

But in your example the first printk call contains a \n at the
end of the line and so upon entry to the second printk call
the function knows a new line is beginning.

The message level is a local variable. It's set to the default
at function entry, and is recalculated at the beginning of each
new line. It's changed only if a new line begins with a token.
So subsequent new lines which don't contain a token reuse the
previous value ... only within a single call to printk().

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
