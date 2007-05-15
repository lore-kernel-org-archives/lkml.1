Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXEOHTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXEOHTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbXEOHTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:19:39 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:23489 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbXEOHTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MaSz3MM8iiC8txBC9uKrKsEcF4OHeOxmrDIRzGAZxtdA5Y95s/hDHP5EhIwsSgJoY/XSl9rXseiSQrFIH27PGd6TcufiTjO5GfNhJfREp6HTNn3qzBI1cReSQ8Ehqeak/PGZf5yo6KZutaIGsU+eoCZNx7ApHLGN692XrQd9KOY=
Message-ID: <4de7f8a60705150019q768b292al12c08a3a53c820e9@mail.gmail.com>
Date: Tue, 15 May 2007 09:19:37 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, pbadari@us.ibm.com
Subject: Re: [RFC][PATCH 5/14] Introduce union stack
Cc: "Bharata B Rao" <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <Pine.LNX.4.61.0705142241070.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094047.GG4139@in.ibm.com>
	 <Pine.LNX.4.61.0705142241070.9570@yvahk01.tjqt.qr>
X-Google-Sender-Auth: dd188a07c5c470cb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> >+static inline void union_lock(struct dentry *dentry)
> >+{
> >+      if (unlikely(dentry && dentry->d_union)) {
> >+              struct union_info *ui = dentry->d_union;
> >+
> >+              UM_DEBUG_LOCK("\"%s\" locking %p (count=%d)\n",
> >+                            dentry->d_name.name, ui,
> >+                            atomic_read(&ui->u_count));
> >+              __union_lock(dentry->d_union);
> >+      }
> >+}
> >+
> >+static inline void union_unlock(struct dentry *dentry)
> >+{
> >+      if (unlikely(dentry && dentry->d_union)) {
> >+              struct union_info *ui = dentry->d_union;
> >+
> >+              UM_DEBUG_LOCK("\"%s\" unlocking %p (count=%d)\n",
> >+                            dentry->d_name.name, ui,
> >+                            atomic_read(&ui->u_count));
> >+              __union_unlock(dentry->d_union);
> >+      }
> >+}
>
> Do we really need the unlikely()? d_union may be a new feature,
> but it may very well be possible that someone puts the bigger
> part of his/her files under a union. And when d_unions get
> stable, people will probably begin making their root filesystem
> unioned for livecds, and then unlikely() will rather be a
> likely penalty. My stance: just
>         if (dentry != NULL && dentry->d_union != NULL)
> This also goes for union_trylock.

Good question. My intention was that since most of the union code
costs performance (stack traversal, readdir) I optimize for the normal
(not unified) case.

> >+static inline int union_trylock(struct dentry *dentry)
> >+{
> >+      int locked = 1;
> >+
> >+      if (unlikely(dentry && dentry->d_union)) {
> >+              UM_DEBUG_LOCK("\"%s\" try locking %p (count=%d)\n",
> >+                            dentry->d_name.name, dentry->d_union,
> >+                            atomic_read(&dentry->d_union->u_count));
> >+              BUG_ON(!atomic_read(&dentry->d_union->u_count));
> >+              locked = mutex_trylock(&dentry->d_union->u_mutex);
> >+              UM_DEBUG_LOCK("\"%s\" trylock %p %s\n", dentry->d_name.name,
> >+                            dentry->d_union,
> >+                            locked ? "succeeded" : "failed");
> >+      }
> >+      return (locked ? 1 : 0);
> >+}
>
>         return locked ? 1 : 0
> or even
>         return !!locked;
> or since we're just passing up from mutex_trylock:
>         return locked;
> ?

Ahh, this seems to be a left-over of the semaphore -> mutex conversion.

> >+/*
> >+ * This is a *I can't get no sleep* helper
>
> More commonly known as "insomnia". :)
>

:)


Before I forget this: thank you (and Badari) for reviewing the patches!

Cheers,
Jan
