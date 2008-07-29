Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbYG2MzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbYG2MzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYG2MzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:55:06 -0400
Received: from mail.ocs.com.au ([202.134.241.204]:13639 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYG2MzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:55:05 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 08:55:04 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: Simon Horman <horms@verge.net.au>
cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [patch] IA64: only call up() in salinfo_work_to_do() if down_trylock() was successful 
In-reply-to: Your message of "Tue, 29 Jul 2008 19:47:20 +1000."
             <20080729094718.GA5247@verge.net.au> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 29 Jul 2008 22:47:09 +1000
Message-ID: <1163.1217335629@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman (on Tue, 29 Jul 2008 19:47:20 +1000) wrote:
>Aesthetic issues aside is it safe to call up() if down_trylock() failed?
>
>arch/ia64/kernel/salinfo.c: In function `salinfo_work_to_do':
>arch/ia64/kernel/salinfo.c:195: warning: ignoring return value of `down_trylock'
>
>Signed-off-by: Simon Horman <horms@verge.net.au>
>
>Index: linux-2.6/arch/ia64/kernel/salinfo.c
>===================================================================
>--- linux-2.6.orig/arch/ia64/kernel/salinfo.c	2008-07-29 19:06:33.000000000 +1000
>+++ linux-2.6/arch/ia64/kernel/salinfo.c	2008-07-29 19:40:02.000000000 +1000
>@@ -192,8 +192,8 @@ struct salinfo_platform_oemdata_parms {
> static void
> salinfo_work_to_do(struct salinfo_data *data)
> {
>-	down_trylock(&data->mutex);
>-	up(&data->mutex);
>+	if (down_trylock(&data->mutex) == 0)
>+		up(&data->mutex);
> }
> 
> static void

NAK.  The whole point of this function is to set the mutex to the up
state, irrespective of whether it was already down or not.  Tracking
the state of data->mutex in all the possible contexts is just too
fragile, especially since it can be modified from NMI context.
salinfo_work_to_do() ensures that the mtuex ends in the up state.

To remove the warning, just stick '(void)' in front of down_trylock().

