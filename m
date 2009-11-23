Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbZKWMdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbZKWMdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbZKWMdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:33:11 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64359 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbZKWMdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wITw6icaxIQZwqmK4sUoSGYHvL8eC8mNrcNZuoLxvwDPfDrbH9G26QWQDEgDi8Pr5C
         VZWCXkfxoOanl77E/gn7cTcruaBHNvsxTacQoRP95/aPxI/bd34LZkjfifdvrIL7Xt2y
         uWPvyJNgOwXAXvMjSiX9k3m0UIy0YeRhU8w5s=
MIME-Version: 1.0
In-Reply-To: <E1NBZJ5-0003hL-Qc@longford.logfs.org>
References: <20091120181113.GA2159@logfs.org>
	 <E1NBZJ5-0003hL-Qc@longford.logfs.org>
Date: Mon, 23 Nov 2009 14:33:15 +0200
X-Google-Sender-Auth: 8ab5a33535eddcb8
Message-ID: <84144f020911230433q5fd90321m9b463cb425fafe7d@mail.gmail.com>
Subject: Re: [PATCH 12/17] [LogFS] readwrite.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joern,

(Dunno who to CC, really, so lets see if I can trick Andrew or Hugh
into looking at the issue.)

On Fri, Nov 20, 2009 at 9:38 PM, Joern Engel <joern@logfs.org> wrote:
> +static void logfs_lock_write_page(struct page *page)
> +{
> +       int loop = 0;
> +
> +       while (unlikely(!trylock_page(page))) {
> +               if (loop++ > 0x1000) {
> +                       /* Has been observed once so far... */
> +                       printk(KERN_ERR "stack at %p\n", &loop);
> +                       BUG();
> +               }
> +               if (PagePreLocked(page)) {
> +                       /* Holder of page lock is waiting for us, it
> +                        * is safe to use this page. */
> +                       break;
> +               }
> +               /* Some other process has this page locked and has
> +                * nothing to do with us.  Wait for it to finish.
> +                */
> +               schedule();
> +       }
> +       BUG_ON(!PageLocked(page));
> +}

What's the purpose of PagePreLocked()? The above function looks pretty
fragile for a filesystem to me.

                        Pekka
