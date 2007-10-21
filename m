Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbXJUK73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbXJUK73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 06:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXJUK7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 06:59:23 -0400
Received: from smtp103.plus.mail.mud.yahoo.com ([68.142.206.236]:28797 "HELO
	smtp103.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750987AbXJUK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 06:59:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=aNDUnmGx6nQUxy7s8xNO4HIve8w+x2BVSCFlqSDMRIDY3AAN0phL7J/brrgXvLetMP+aodwBYf0Bf7auZYw4FQ8lDKQpyeayKncFBi0M5xBgM776FP/iXLbZnxO8C+zXdK3Oo+5p3ixgNlocY4FtDnzQqD0fJ05LI0y7Qm3+nTY=  ;
X-YMail-OSG: eXoRssMVM1mbZu_N2zg_T3Glu3K7duqzzJlxn1KlpOos8XYstwBRfPftKrXXZNXGlBbV4uLOcleI.rvuVyolUUS1ngp5US4FWBrk7i_QsjIGvFJLaLs-
Date: Sun, 21 Oct 2007 12:56:00 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@perex.cz
Subject: [PATCH] sound/core/control.c: hard-irq-safe -> hard-irq-unsafe
	lock warning
Message-ID: <20071021105600.GA4650@zmei.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this on current git: v2.6.23-6597-gcfa76f0:


Oct 21 08:50:12 zmei kernel: [  215.376967] ======================================================
Oct 21 08:50:12 zmei kernel: [  215.376978] [ INFO: hard-safe -> hard-unsafe lock order detected ]
Oct 21 08:50:12 zmei kernel: [  215.376984] 2.6.23 #11
Oct 21 08:50:12 zmei kernel: [  215.376989] ------------------------------------------------------
Oct 21 08:50:12 zmei kernel: [  215.376996] artsd/4129 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
Oct 21 08:50:12 zmei kernel: [  215.377002]  (&ctl->read_lock){--..}, at: [<c027519b>] snd_ctl_notify+0x50/0x116
Oct 21 08:50:12 zmei kernel: [  215.377024] 
Oct 21 08:50:12 zmei kernel: [  215.377026] and this task is already holding:
Oct 21 08:50:12 zmei kernel: [  215.377031]  (&substream->self_group.lock){++..}, at: [<c027bd9a>] snd_pcm_drop+0x78/0xbb
Oct 21 08:50:12 zmei kernel: [  215.377048] which would create a new lock dependency:
Oct 21 08:50:12 zmei kernel: [  215.377053]  (&substream->self_group.lock){++..} -> (&ctl->read_lock){--..}
Oct 21 08:50:12 zmei kernel: [  215.377071] 
Oct 21 08:50:12 zmei kernel: [  215.377072] but this new dependency connects a hard-irq-safe lock:
Oct 21 08:50:12 zmei kernel: [  215.377079]  (&substream->self_group.lock){++..}
Oct 21 08:50:12 zmei kernel: [  215.377086] ... which became hard-irq-safe at:
Oct 21 08:50:12 zmei kernel: [  215.377092]   [<c01445fc>] __lock_acquire+0x423/0xc0a
Oct 21 08:50:12 zmei kernel: [  215.377108]   [<c0145217>] lock_acquire+0x72/0x95
Oct 21 08:50:12 zmei kernel: [  215.377121]   [<c02fd933>] _spin_lock+0x35/0x42
Oct 21 08:50:12 zmei kernel: [  215.377136]   [<c0280646>] snd_pcm_period_elapsed+0x3a/0x1fd
Oct 21 08:50:12 zmei kernel: [  215.377150]   [<c02a65ef>] snd_ymfpci_pcm_interrupt+0x85/0xfc
Oct 21 08:50:12 zmei kernel: [  215.377165]   [<c02a70f5>] snd_ymfpci_interrupt+0x50/0x1d3
Oct 21 08:50:12 zmei kernel: [  215.377179]   [<c0150991>] handle_IRQ_event+0x1a/0x4f
Oct 21 08:50:12 zmei kernel: [  215.377192]   [<c0151a6c>] handle_fasteoi_irq+0xab/0xb8
Oct 21 08:50:12 zmei kernel: [  215.377205]   [<c0106c65>] do_IRQ+0x7c/0x97
Oct 21 08:50:12 zmei kernel: [  215.377218]   [<c0104c52>] common_interrupt+0x2e/0x34
Oct 21 08:50:12 zmei kernel: [  215.377232]   [<ffffffff>] 0xffffffff
Oct 21 08:50:12 zmei kernel: [  215.377249] 
Oct 21 08:50:12 zmei kernel: [  215.377250] to a hard-irq-unsafe lock:
Oct 21 08:50:12 zmei kernel: [  215.377255]  (&ctl->read_lock){--..}
Oct 21 08:50:12 zmei kernel: [  215.377262] ... which became hard-irq-unsafe at:
Oct 21 08:50:12 zmei kernel: [  215.377268] ...  [<c0144669>] __lock_acquire+0x490/0xc0a
Oct 21 08:50:12 zmei kernel: [  215.377283]   [<c0145217>] lock_acquire+0x72/0x95
Oct 21 08:50:12 zmei kernel: [  215.377296]   [<c02fd933>] _spin_lock+0x35/0x42
Oct 21 08:50:12 zmei kernel: [  215.377309]   [<c0274cb6>] snd_ctl_empty_read_queue+0x12/0x48
Oct 21 08:50:12 zmei kernel: [  215.377324]   [<c027643f>] snd_ctl_release+0xb3/0xd9
Oct 21 08:50:12 zmei kernel: [  215.377338]   [<c01721ae>] __fput+0xb9/0x160
Oct 21 08:50:12 zmei kernel: [  215.377352]   [<c017246f>] fput+0x17/0x19
Oct 21 08:50:12 zmei kernel: [  215.377366]   [<c016fa18>] filp_close+0x54/0x5c
Oct 21 08:50:12 zmei kernel: [  215.377381]   [<c0170cbd>] sys_close+0x76/0xb2
Oct 21 08:50:12 zmei kernel: [  215.377394]   [<c0104202>] syscall_call+0x7/0xb
Oct 21 08:50:12 zmei kernel: [  215.377407]   [<ffffffff>] 0xffffffff
Oct 21 08:50:12 zmei kernel: [  215.377419] 
Oct 21 08:50:12 zmei kernel: [  215.377421] other info that might help us debug this:
Oct 21 08:50:12 zmei kernel: [  215.377423] 
Oct 21 08:50:12 zmei kernel: [  215.377429] 4 locks held by artsd/4129:
Oct 21 08:50:12 zmei kernel: [  215.377433]  #0:  (&card->power_lock){--..}, at: [<c027bd61>] snd_pcm_drop+0x3f/0xbb
Oct 21 08:50:12 zmei kernel: [  215.377454]  #1:  (snd_pcm_link_rwlock){..++}, at: [<c027bd8d>] snd_pcm_drop+0x6b/0xbb
Oct 21 08:50:12 zmei kernel: [  215.377474]  #2:  (&substream->self_group.lock){++..}, at: [<c027bd9a>] snd_pcm_drop+0x78/0xbb
Oct 21 08:50:12 zmei kernel: [  215.377494]  #3:  (&card->ctl_files_rwlock){..?-}, at: [<c027516a>] snd_ctl_notify+0x1f/0x116
Oct 21 08:50:12 zmei kernel: [  215.377514] 
<snip for vger mail constraints>

The following patch fixes it for me.

---
From: Borislav Petkov <bbpetkov@yahoo.de>

The lock grabbed in snd_ctl_empty_read_queue() is hardirq-unsafe but we hold
an hardirq-safe one already, so make the &ctl->read_lock also hard-irq-safe.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
diff --git a/sound/core/control.c b/sound/core/control.c
index 4c3aa8e..df0774c 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -93,15 +93,16 @@ static int snd_ctl_open(struct inode *inode, struct file *file)
 
 static void snd_ctl_empty_read_queue(struct snd_ctl_file * ctl)
 {
+	unsigned long flags;
 	struct snd_kctl_event *cread;
 	
-	spin_lock(&ctl->read_lock);
+	spin_lock_irqsave(&ctl->read_lock, flags);
 	while (!list_empty(&ctl->events)) {
 		cread = snd_kctl_event(ctl->events.next);
 		list_del(&cread->list);
 		kfree(cread);
 	}
-	spin_unlock(&ctl->read_lock);
+	spin_unlock_irqrestore(&ctl->read_lock, flags);
 }
 
 static int snd_ctl_release(struct inode *inode, struct file *file)
