Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYEOSFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYEOSFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYEOSFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:05:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:50031 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYEOSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=w54xcNGtYMSR0aCaFRFfhGlNMSoSsif8CtqD6HS0MN4S4uN38GDCG6NM6qxawZfB3hi3uR4mfhW9XvZVcCb6TVXhFISDOjukXLAqYnQk2e2Iq9FjDhu1ug5zNQ7kqtAcpc5Y6pxKTmN0Xmt9udrZCHM2V8t+RW+KDSSNbvaABiA=
Date: Thu, 15 May 2008 22:05:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Andreas Schwab <schwab@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
Message-ID: <20080515180528.GC7481@cvg>
References: <20080514154402.GF6902@cvg> <20080515105803.7c9ab8c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515105803.7c9ab8c7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Thu, May 15, 2008 at 10:58:03AM -0700]
| On Wed, 14 May 2008 19:44:02 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > This patch does fix build bug on m68k wich does not have strncat in straight way.
| > 
| > What is more important - my previous patch
| > 
| > commit e662e1cfd434aa234b72fbc781f1d70211cb785b
| > Author: Cyrill Gorcunov <gorcunov@gmail.com>
| > Date:   Mon May 12 14:02:22 2008 -0700
| > 
| >     init: don't lose initcall return values
| > 
| > has introduced potential buffer overflow by wrong calculation
| > of string accumulator size.
| > 
| > Many thanks Andreas Schwab and Geert Uytterhoeven for helping
| > to catch and fix the bug.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > Index: linux-2.6.git/init/main.c
| > ===================================================================
| > --- linux-2.6.git.orig/init/main.c	2008-05-14 17:55:10.000000000 +0400
| > +++ linux-2.6.git/init/main.c	2008-05-14 19:11:18.000000000 +0400
| > @@ -702,7 +702,7 @@ static void __init do_initcalls(void)
| >  
| >  	for (call = __initcall_start; call < __initcall_end; call++) {
| >  		ktime_t t0, t1, delta;
| > -		char msgbuf[40];
| > +		char msgbuf[64];
| >  		int result;
| >  
| >  		if (initcall_debug) {
| > @@ -729,11 +729,11 @@ static void __init do_initcalls(void)
| >  			sprintf(msgbuf, "error code %d ", result);
| >  
| >  		if (preempt_count() != count) {
| > -			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
| > +			strcat(msgbuf, "preemption imbalance ");
| >  			preempt_count() = count;
| >  		}
| >  		if (irqs_disabled()) {
| > -			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
| > +			strcat(msgbuf, "disabled interrupts ");
| >  			local_irq_enable();
| >  		}
| >  		if (msgbuf[0]) {
| 
| umm, why can't m68k call strncat() from init/main.c??
| 

there some problem with headers iirc, we have to declare it first or
use some gcc option (as Adrian suggested). Actually I would prefer to use
strlcat there but it seems it would fail to build too. Originally I've messed
strlcat with strncat :(

		- Cyrill -
