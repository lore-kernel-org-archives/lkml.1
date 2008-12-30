Return-Path: <linux-kernel-owner+w=401wt.eu-S1751128AbYL3MGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbYL3MGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYL3MFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:05:54 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49636 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYL3MFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:05:53 -0500
Date: Tue, 30 Dec 2008 13:07:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Many warnings from our userspace headers
Message-ID: <20081230120725.GA4622@uranus.ravnborg.org>
References: <20081230103348.GA363@uranus.ravnborg.org> <jeiqp2j645.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeiqp2j645.fsf@sykes.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 11:43:22AM +0100, Andreas Schwab wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> 
> > /home/sam/kernel/knext.git/usr/include/linux/acct.h:62: leaks CONFIG_M68K to userspace where it is not valid
> 
> IMHO this is a false positive, since it is protected by __KERNEL__ in
> the same expression.

Correct - but we can rewrite it like this:

diff --git a/include/linux/acct.h b/include/linux/acct.h
index 882dc72..bcc6d2f 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
@@ -59,8 +59,12 @@ struct acct
 	comp_t		ac_majflt;		/* Major Pagefaults */
 	comp_t		ac_swaps;		/* Number of Swaps */
 /* m68k had no padding here. */
-#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
+#ifndef __KERNEL__
 	__u16		ac_ahz;			/* AHZ */
+#else
+  #ifndef CONFIG_M68K
+	__u16		ac_ahz;			/* AHZ */
+  #endif
 #endif
 	__u32		ac_exitcode;		/* Exitcode */
 	char		ac_comm[ACCT_COMM + 1];	/* Command Name */

This is at least for me also easier to parse.
So we remove a (bogus) warning and make the code easier to read.

	Sam
