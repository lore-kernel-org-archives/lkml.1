Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYJBIDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYJBIDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYJBIDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:03:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbYJBIDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:03:37 -0400
Date: Thu, 2 Oct 2008 01:03:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081002010315.1cda8147.akpm@linux-foundation.org>
In-Reply-To: <20081002074523.GW19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002074523.GW19428@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 09:45:24 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> > So.  Where are these atime updaters getting blocked?
> 
> Behind other IO activity I suppose, since it's marked async. A more
> appropriate fix may be to mark atime updates as sync IO.

No, they might be getting blocked at a higher level.

An async atime update gets recorded into the current transaction. 
kjournald is working on the committing transaction.  We try to keep
those separated, to prevent user processes from getting blocked behind
kjournald activity.

But sometimes that doesn't work (including the place where I knowingly
broke it).  If we can find and fix the offending piece of jbd logic (a
big if) then all is peachy.

If the above theory turns out to be true then diddling IO priorities
is but a workaround.
