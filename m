Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbXFJTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbXFJTxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXFJTxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:53:38 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1497 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbXFJTxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:53:37 -0400
Date: Sun, 10 Jun 2007 21:53:33 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrea Righi <righiandr@users.sourceforge.net>, Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070610195333.GB15616@vanheusden.com>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <46517817.1080208@users.sourceforge.net> <20070521110406.GA14802@vanheusden.com> <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr> <20070521124734.GB14802@vanheusden.com> <a781481a0705231100q333a589at6c025eb1292019cd@mail.gmail.com> <20070523184535.GE21655@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523184535.GE21655@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Mon Jun 11 01:07:27 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> >+    {
> > >> if (sig_fatal(t, sig)) {
> > >> >+            printk(KERN_WARNING "Sig %d send to %d owned by %d.%d 
> > >(%s)\n",
> > >> s/send/sent/;
> > >> >+            sig, t -> pid, t -> uid, t -> gid, t -> comm);
> > >> t->pid, t->uid, t->gid, t->comm);
> > >
> > 
> > Gargh ... why does this want to be in the *kernel*'s logs? In any case, can
> > you please make this KERN_INFO (or lower) instead of KERN_WARNING.
> Description:
> This patch adds code to the signal-sender making it log a message when
> an unhandled fatal signal will be delivered.

New version. This one also informs the user about the sende pid/uid of
the signal (when applicable).

Signed-of by: Folkert van Heusden <folkert@vanheusden.com

--- linux/kernel/signal.c.org	2007-05-20 22:47:13.000000000 +0200
+++ linux/kernel/signal.c	2007-06-10 00:21:31.000000000 +0200
@@ -739,6 +739,18 @@
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+	/* unhandled fatal signals are logged */
+	if (sig_fatal(t, sig)) {
+		if (is_si_special(info))
+			printk(KERN_INFO "Sig %d sent to %d owned by %d.%d (%s)\n",
+				sig, t->pid, t->uid, t->gid, t->comm);
+		else
+			printk(KERN_INFO "Sig %d sent to %d owned by %d.%d (%s), sent by pid %d, uid %d\n",
+				sig, t->pid, t->uid, t->gid, t->comm,
+				info -> _sifields._kill._pid,
+				info -> _sifields._kill._uid);
+	}
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.


Folkert van Heusden

-- 
Feeling generous? -> http://www.vanheusden.com/wishlist.php
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
