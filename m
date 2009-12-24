Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZLXAC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZLXAC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZLXACZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:02:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37222 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404AbZLXACY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:02:24 -0500
Date: Thu, 24 Dec 2009 11:02:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20091224110221.cceb841e.sfr@canb.auug.org.au>
In-Reply-To: <20091224093913.4f29f37b.sfr@canb.auug.org.au>
References: <20091224091141.fa1cea64.sfr@canb.auug.org.au>
	<20091224093913.4f29f37b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Thu, 24 Dec 2009 09:39:13 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Thu, 24 Dec 2009 09:11:41 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the acpi tree got a conflict in
> > drivers/platform/x86/sony-laptop.c between commits
> > 45465487897a1c6d508b14b904dc5777f7ec7e04 ("kfifo: move struct kfifo in
> > place"), c1e13f25674ed564948ecb7dfe5f83e578892896 ("kfifo: move out
> > spinlock") and 7acd72eb85f1c7a15e8b5eb554994949241737f1 ("kfifo: rename
> > kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out...") from
> > Linus' tree and commit a287e9f941cf4bb8c167802c0f1cf04a93bc4e4c
> > ("sony-laptop: remove private workqueue, use keventd instead") from the
> > acpi tree.
> > 
> > I fixed it up (see below) and can cay the fix for a while.  This fix
> > needs checking.
> 
> I applied the following further patch (and there may be more fixes
> necessary).

drivers/platform/x86/sony-laptop.c: In function 'sony_laptop_remove_input':
drivers/platform/x86/sony-laptop.c:497: error: implicit declaration of function 'kfifo_get'

I needed this as well ...

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Dec 2009 10:54:06 +1100
Subject: [PATCH] acpi: another fix for kfifo API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/platform/x86/sony-laptop.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 84a1736..28c4a39 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -494,8 +494,9 @@ static void sony_laptop_remove_input(void)
 	cancel_delayed_work_sync(&sony_laptop_release_key_work);
 
 	/* Generate key-up events for remaining keys */
-	while (kfifo_get(sony_laptop_input.fifo,
-			 (unsigned char *)&kp, sizeof(kp)) == sizeof(kp)) {
+	while (kfifo_out_locked(&sony_laptop_input.fifo,
+			 (unsigned char *)&kp, sizeof(kp),
+			 &sony_laptop_input.fifo_lock) == sizeof(kp)) {
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
 	}
-- 
1.6.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
