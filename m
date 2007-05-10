Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXEJGsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXEJGsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbXEJGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:48:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2579 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbXEJGsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:48:04 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 9 May 2007 23:47:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       charle97@yahoo.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
In-Reply-To: <20070509200842.d2d93184.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705092329260.16104@alien.or.mcafeemobile.com>
References: <200705100237.l4A2b5h8025394@fire-2.osdl.org>
 <20070509200842.d2d93184.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Andrew Morton wrote:

> On Wed, 9 May 2007 19:37:05 -0700 bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8462

Is it possible to have more information? Like CPU, kernel 32/64, userspace 
32/64 ...?
I've spotted something here:

+                       smp_mb();
+                       INIT_LIST_HEAD(&epi->rdllink);

The epoll callback uses list_empty() as test if to queue the item as ready, 
and list_empty() checks ->next. INIT_LIST_HEAD() sets ->next before, then 
->prev. Whoops :)
This should be:

	epi->rdllink.prev = &epi->rdllink;
	smp_mb();
	epi->rdllink.next = &epi->rdllink;

Does the problem happens with some other publicly available software that 
runs under wine, so that I can test it?


- Davide


