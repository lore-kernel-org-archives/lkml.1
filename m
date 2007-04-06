Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbXDFUzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbXDFUzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXDFUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:55:39 -0400
Received: from elvis.mu.org ([192.203.228.196]:50843 "EHLO elvis.mu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbXDFUzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:55:38 -0400
Message-ID: <50660.65.57.245.11.1175892938.squirrel@ssl.mu.org>
In-Reply-To: <46169DDA.6020008@ru.mvista.com>
References: <20070406173603.GA82722@freefall.freebsd.org>
    <46169DDA.6020008@ru.mvista.com>
Date: Fri, 6 Apr 2007 13:55:38 -0700 (PDT)
Subject: Re: [PATCH] Correctly prevent IDE timer expiry function to run if 
     request was already handled
From: "Suleiman Souhlal" <ssouhlal@FreeBSD.org>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Cc: "Suleiman Souhlal" <ssouhlal@FreeBSD.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, April 6, 2007 12:22 pm, Sergei Shtylyov wrote:
> Hello.
>
>
> Suleiman Souhlal wrote:
>
>
>> It is possible for the timer expiry function to run even though the
>> request has already been handled: ide_timer_expiry() only checks that the
>> handler is not NULL, but it is possible that we have handled a request
>> (thus clearing the handler) and then started a new request
>> (thus starting the timer again, and setting a handler).
>>
>
>> A simple way to exhibit this is to set the DMA timeout to 1 jiffy and
>> run dd: The kernel will panic after a few minutes because
>> ide_timer_expiry() tries to add a timer when it's already active.
>
>> To fix this, we simply add a request generation count that gets
>> incremented at every interrupt, and check in ide_timer_expiry() that we
>> have not already handled a new interrupt before running the expiry
>> function.
>
> Couldn't this be addressed by simply changing add_timer() to mod_timer()?

No, we don't want to run the expiry function at all, in this case, since
the   request might have correctly been handled already by the time we
would try to run the expiry function/restart the timer.

Also, if we just change the add_timer() to mod_timer(), we will just be
hiding the problem because you might end up changing the timeout of a
timer whose purpose is different (for a new request, for example).
The timer should not be active when ide_timer_expiry() tries to restart
it, since that function is called when the timer has expired (meaning it
is not active anymore).
The reason the timer could have been active at that point, before applying
this patch, is that we try to dispatch a new request after handling one.
The new request will then have its own expiry timer, along with a handler.
Since  before this patch ide_timer_expiry() only looked at whether or not
a handler was present, it would incorrectly think the request had not been
handled already, and incorrectly tried to restart the timer.

-- Suleiman

