Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZEMNbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZEMNbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZEMNbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:31:04 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:63321 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZEMNbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:31:02 -0400
Date: Wed, 13 May 2009 15:31:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel:async function call:introduce async_run
Message-ID: <20090513153101.3bceb04c@gondolin>
In-Reply-To: <d82e647a0905130556y50620617i8c5ac597b6207406@mail.gmail.com>
References: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
	<20090513130233.082eeee5@gondolin>
	<d82e647a0905130556y50620617i8c5ac597b6207406@mail.gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 20:56:40 +0800,
Ming Lei <tom.leiming@gmail.com> wrote:

> 2009/5/13 Cornelia Huck <cornelia.huck@de.ibm.com>:
> > On Wed, 13 May 2009 08:33:49 +0800,
> > tom.leiming@gmail.com wrote:

> >>  /**
> >> + * async_run - schedule a function for asynchronous execution
> >> + * @ptr: function to execute asynchronously
> >> + * @data: data pointer to pass to the function
> >> + *
> >> + * Note:we do not allocate a cookie for this kind of aysnchronous
> >> + * function to decrease the wait time of async_synchronize_full().
> >
> > But async_synchronize_full() still waits for list_empty(&async_running)
> > - so what does this buy us?
> 
> I mean it can decrease the wait time for other async function.
> async_schedule() still can be used to do such thing, but may lead to a
> slower boot.  It is the main
> purpose of the patch.

I see how this can affect places calling async_synchronize_cookie(),
but the function will still end up on async_running. If you don't want
async_synchronize_full() waiting for these functions, couldn't you use
your own running list?

(Oh, and I just thought about it a bit further:
- somebody calls async_run() -> function with cookie = MAX_COOKIE will be
  lowest_in_progress at some point in time
- somebody else calls async_schedule() -> cookie = n
- we wait with async_synchronize_cookie(n) - which returns since
  MAX_COOKIE >= n, which is probably not what we want)
