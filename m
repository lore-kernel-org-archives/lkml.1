Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXGYSnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXGYSnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXGYSnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:43:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:28328 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXGYSnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xj1x90eMNm2HYuPStEIfOSdO6Pf7mKl0BwJk3LJ5qBR94YqEDNk7k6kmQE7OEhWHkfv067bWhjdTwv41DoW46HE1TfqCD6Vv86NQjKW2nVbWcEvYQSImTGA2Fd7Gtyd9+/+YL3RYZu+Lvbo7FVfy3cUWyTANj6lqu3Fn79xyUKk=
Message-ID: <a4e6962a0707251143ie0b0ce8s7d4a9078fed7eb26@mail.gmail.com>
Date: Wed, 25 Jul 2007 13:43:16 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: net/9p/mux.c: use-after-free
Cc: "Latchesar Ionkov" <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070723012014.GV26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723012014.GV26212@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Adrian Bunk <bunk@stusta.de> wrote:
> The Coverity checker spotted the following use-after-free
> in net/9p/mux.c:
>
> <--  snip  -->
>
> ...
> struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
>                                     unsigned char *extended)
> {
> ...
>         if (!m->tagpool) {
>                 kfree(m);
>                 return ERR_PTR(PTR_ERR(m->tagpool));
>         }
> ...
>
> <--  snip  -->
>

I've got a fix for this one:
        if (!m->tagpool) {
                mtmp = ERR_PTR(PTR_ERR(m->tagpool));
                kfree(m);
                return mtmp;
        }

but I was wondering about one of the other returns further down the function:

...
        memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
        m->poll_task = NULL;
        n = p9_mux_poll_start(m);
        if (n)
                return ERR_PTR(n);

        n = trans->poll(trans, &m->pt);
...

lucho: doesn't that constitute a leak?  Shouldn't we be doing:

        if (n) {
                kfree(m);
                return ERR_PTR(n);
        }

         -eric
