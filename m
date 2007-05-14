Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbXENUuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbXENUuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXENUuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:50:10 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57398 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbXENUuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:50:08 -0400
Date: Mon, 14 May 2007 22:48:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
In-Reply-To: <20070514094047.GG4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705142241070.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094047.GG4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:10, Bharata B Rao wrote:
>+struct union_info * union_alloc(void)

Ultimate nitpick: try s/\* /*/; (also elsewhere)

>+static inline void union_lock(struct dentry *dentry)
>+{
>+	if (unlikely(dentry && dentry->d_union)) {
>+		struct union_info *ui = dentry->d_union;
>+
>+		UM_DEBUG_LOCK("\"%s\" locking %p (count=%d)\n",
>+			      dentry->d_name.name, ui,
>+			      atomic_read(&ui->u_count));
>+		__union_lock(dentry->d_union);
>+	}
>+}
>+
>+static inline void union_unlock(struct dentry *dentry)
>+{
>+	if (unlikely(dentry && dentry->d_union)) {
>+		struct union_info *ui = dentry->d_union;
>+
>+		UM_DEBUG_LOCK("\"%s\" unlocking %p (count=%d)\n",
>+			      dentry->d_name.name, ui,
>+			      atomic_read(&ui->u_count));
>+		__union_unlock(dentry->d_union);
>+	}
>+}

Do we really need the unlikely()? d_union may be a new feature,
but it may very well be possible that someone puts the bigger
part of his/her files under a union. And when d_unions get
stable, people will probably begin making their root filesystem
unioned for livecds, and then unlikely() will rather be a
likely penalty. My stance: just
	if (dentry != NULL && dentry->d_union != NULL)
This also goes for union_trylock.

>+static inline int union_trylock(struct dentry *dentry)
>+{
>+	int locked = 1;
>+
>+	if (unlikely(dentry && dentry->d_union)) {
>+		UM_DEBUG_LOCK("\"%s\" try locking %p (count=%d)\n",
>+			      dentry->d_name.name, dentry->d_union,
>+			      atomic_read(&dentry->d_union->u_count));
>+		BUG_ON(!atomic_read(&dentry->d_union->u_count));
>+		locked = mutex_trylock(&dentry->d_union->u_mutex);
>+		UM_DEBUG_LOCK("\"%s\" trylock %p %s\n", dentry->d_name.name,
>+			      dentry->d_union,
>+			      locked ? "succeeded" : "failed");
>+	}
>+	return (locked ? 1 : 0);
>+}

	return locked ? 1 : 0
or even
	return !!locked;
or since we're just passing up from mutex_trylock:
	return locked;
?

>+/*
>+ * This is a *I can't get no sleep* helper

More commonly known as "insomnia". :)


	Jan
-- 
