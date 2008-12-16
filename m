Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLPKJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLPKJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYLPKJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:09:42 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:60228 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYLPKJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:09:41 -0500
Date: Tue, 16 Dec 2008 11:09:38 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1 v2] hvc_console: escape magic sysrq key
Message-ID: <20081216100938.GA22294@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Andreas Schwab <schwab@suse.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Linux PPC devel <linuxppc-dev@ozlabs.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Ryan S. Arnold" <rsa@us.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20081216091544.061115344@linux.vnet.ibm.com> <20081216092408.362722962@linux.vnet.ibm.com> <jeiqpkcvgo.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeiqpkcvgo.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

thanks for your comments.

On Tue, Dec 16, 2008 at 10:36:55AM +0100, Andreas Schwab wrote:
> > +					/* if ^0 is pressed again, reset
> > +					 * sysrq_pressed and flip ^0 char */
> The comment says ^0 twice when ^O is meant.
Correct. I have updated the comment.

> > +					sysrq_pressed = (sysrq_pressed) ? 0 : 1;
>                                         sysrq_pressed = !sysrc_pressed;
Ok, it might look better.


[PATCH v2] hvc_console: escape magic sysrq key

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

The ctrl-o (^O) is a common control key used by several applications like vim.

To allow users to send ^O to the terminal, this patch introduces a check
if ^O is pressed again if the sysrq_pressed variable is already set.
In this case, clear sysrq_pressed state and flip the ^O character to the tty.
(The old behavior has always set "sysrq_pressed" if ^O has been entered, and it
has not flipped the ^O character to the tty.)

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -642,8 +642,11 @@ int hvc_poll(struct hvc_struct *hp)
 				/* Handle the SysRq Hack */
 				/* XXX should support a sequence */
 				if (buf[i] == '\x0f') {	/* ^O */
-					sysrq_pressed = 1;
-					continue;
+					/* if ^O is pressed again, reset
+					 * sysrq_pressed and flip ^O char */
+					sysrq_pressed = !sysrq_pressed;
+					if (sysrq_pressed)
+						continue;
 				} else if (sysrq_pressed) {
 					handle_sysrq(buf[i], tty);
 					sysrq_pressed = 0;
