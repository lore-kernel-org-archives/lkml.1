Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZGCPmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZGCPmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbZGCPmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:42:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbZGCPmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:42:15 -0400
Date: Fri, 3 Jul 2009 17:42:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703154209.GA13580@elte.hu>
References: <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk> <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk> <20090703144754.GA13246@elte.hu> <20090703160230.093e422c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703160230.093e422c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > It's an argument you made on false premises.
> > 
> > The thing is, my review wasnt about old code being moved around. It 
> > was about new code being introduced by you:
> 
> Ingo, if you've nothing better to do than quote out of context and 
> be offensive, perhaps you should go fix voyager support or 
> something productive instead.
> 
> The reply section you are quoting was about the code that was 
> moved from place to place. I stand by that comment - you don't 
> move code from place to place and reformat, rework it in one go. 
> It's lousy engineering.

Your claim is simply false on its face. This commit:

 | commit a6614999e800cf3a134ce93ea46ef837e3c0e76e
 | Author: Alan Cox <alan@redhat.com>
 | Date:   Fri Jan 2 13:46:50 2009 +0000
 |
 |     tty: Introduce some close helpers for ports

did not 'move' the piece of code i quoted around:

+       if( tty->count == 1 && port->count != 1) {
+               printk(KERN_WARNING
+                   "tty_port_close_start: tty->count = 1 port count = %d.\n",
+                                                               port->count);
+               port->count = 1;
+	}
+	if (--port->count < 0) {
+               printk(KERN_WARNING "tty_port_close_start: count = %d\n",
+                                                               port->count);
+               port->count = 0;
+	}

it introduces it. This line:

+       if( tty->count == 1 && port->count != 1) {

can be found nowhere else in the commit. You added it.

In fact, if one looks closer, it turns out that:

$ git log -p -1 a6614999e800cf3a134ce93ea46ef837e3c0e76e | grep -iE 'if.*tty->count'
-	if (tty->count == 1 && port->port.count != 1) {
-	if (tty->count == 1 && port->count != 1)
-	if ((tty->count == 1) && (info->port.count != 1)) {
-	if ((tty->count == 1) && (port->port.count != 1))  {
-	if (tty->count == 1 && port->count != 1)
-	if ((tty->count == 1) && (info->port.count != 1)) {
-	if ((tty->count == 1) && (info->port.count != 1)) {
-	if ((tty->count == 1) && (info->port.count != 1)) {
+	if( tty->count == 1 && port->count != 1) {

that you consolidate 8 separate pieces of code, all of which got 
this basic detail right, and you _introduced_ the uncleanliness.

	Ingo
