Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYHKUzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYHKUzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYHKUzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:55:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbYHKUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:55:36 -0400
Date: Mon, 11 Aug 2008 13:44:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Marcin Obara" <marcin_obara@users.sourceforge.net>
Cc: Valdis.Kletnieks@vt.edu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tpm@selhorst.net, kjhall@us.ibm.com,
       tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] 2.6.26-mmotm
 tpm-correct-tpm-timeouts-to-jiffies-conversion-d820-fix.patch
Message-Id: <20080811134413.014ddcf2.akpm@linux-foundation.org>
In-Reply-To: <ea8d860a0807261227w66e29978uecd12cf1fcb915d1@mail.gmail.com>
References: <20080725164614.044a526e.akpm@linux-foundation.org>
	<50684.1217035060@turing-police.cc.vt.edu>
	<20080725185115.5d1a107d.akpm@linux-foundation.org>
	<15114.1217045033@turing-police.cc.vt.edu>
	<ea8d860a0807261227w66e29978uecd12cf1fcb915d1@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 20:27:33 +0100
"Marcin Obara" <marcin_obara@users.sourceforge.net> wrote:

> 2008/7/26  <Valdis.Kletnieks@vt.edu>:
> > +       if (chip->vendor.duration[TPM_SHORT] == 1)
> > +               chip->vendor.duration[TPM_SHORT] *= 1000;
> > +
> >        chip->vendor.duration[TPM_MEDIUM] =
> >            usecs_to_jiffies(be32_to_cpu
> >                             (*((__be32 *) (data +
> 
> 
> Value in  chip->vendor.duration[TPM_SHORT]  is in jiffies not in  milliseconds.
>  (As I know it's not the same. Jiffy is in range 1-10 ms.)
> I know the result may be the same, but it is unclear.
> 
> Maybe... value should be compared (to 1000) before conversion?
> or...
> If after conversion, there should be something like this:
>        if (chip->vendor.duration[TPM_SHORT]  < (HZ/100))  /*  less
> than 10ms ? */
>                chip->vendor.duration[TPM_SHORT] = HZ;
> 
> What do you think?
> 

This all seemed to die off without a conclusion.

Here's the current
tpm-correct-tpm-timeouts-to-jiffies-conversion.patch.  Does it need
updating?

Thanks.


From: Marcin Obara <marcin_obara@users.sourceforge.net>

This patch fixes timeouts conversion to jiffies, by replacing
msecs_to_jiffies() calls with usecs_to_jiffies().  According to TCG TPM
Specification Version 1.2 Revision 103 (pages 166, 167) TPM timeouts and
durations are returned in microseconds (usec) not in miliseconds (msec).

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-correct-tpm-timeouts-to-jiffies-conversion drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-correct-tpm-timeouts-to-jiffies-conversion
+++ a/drivers/char/tpm/tpm.c
@@ -525,19 +525,19 @@ void tpm_get_timeouts(struct tpm_chip *c
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX)));
 	if (timeout)
-		chip->vendor.timeout_a = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_2_IDX)));
 	if (timeout)
-		chip->vendor.timeout_b = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_3_IDX)));
 	if (timeout)
-		chip->vendor.timeout_c = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_4_IDX)));
 	if (timeout)
-		chip->vendor.timeout_d = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
 
 duration:
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
@@ -554,15 +554,15 @@ duration:
 		return;
 
 	chip->vendor.duration[TPM_SHORT] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_1_IDX))));
 	chip->vendor.duration[TPM_MEDIUM] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_2_IDX))));
 	chip->vendor.duration[TPM_LONG] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_3_IDX))));
 }
_

