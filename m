Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbZJLL1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbZJLL1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZJLL1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:27:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:21707 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbZJLL1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:27:31 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091012111545.GB8857@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	 <20091012111545.GB8857@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 14:25:31 +0300
Message-Id: <1255346731.9659.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Oct 2009 11:25:33.0080 (UTC) FILETIME=[B6322980:01CA4B2E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 13:15 +0200, ext Ingo Molnar wrote:
> > We use the mtdoops module which stores oopses on the Flash partition,
> > in order to make it possible to analyze them later. And mtdoops needs
> > to know whether 'panic_on_oops' is on or off. Thus, we need this
> > variable to be exported.
> 
> hm, why does it need it? Could you send the patch please that makes use 
> of it (as an easy way to explain the need for the export) - current 
> upstream drivers/mtd/mtdoops.c doesnt need it so it must be some pending 
> change.

Yes, current drivers/mtd/mtdoops.c does not need it, but we have this
patch:

http://lists.infradead.org/pipermail/linux-mtd/2009-October/027450.html

which makes sure mtdoops writes the oops log immediately, because we
have 'panic_on_oops' set so this is our last chance to save the oops.

Here is the patch inlined as well:

Author: Aaro Koskinen <aaro.koskinen@nokia.com>
Date:   Thu Oct 1 18:16:55 2009 +0300

    mtd: mtdoops: do not schedule work if we are going to die

    If panic_on_oops is set, the log should be written right away
    because this is not going to be a second chance.

    Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 1060337..ac67833 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -335,7 +335,7 @@ static void mtdoops_console_sync(void)
        cxt->ready = 0;
        spin_unlock_irqrestore(&cxt->writecount_lock, flags);

-       if (mtd->panic_write && in_interrupt())
+       if (mtd->panic_write && (in_interrupt() || panic_on_oops))
                /* Interrupt context, we're going to panic so try and log */
                mtdoops_write(cxt, 1);
        else

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

