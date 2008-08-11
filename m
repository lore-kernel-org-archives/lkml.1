Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYHKRlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYHKRlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYHKRll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:41:41 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:57556 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYHKRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:41:41 -0400
Message-ID: <48A079CC.5020508@skyrush.com>
Date: Mon, 11 Aug 2008 11:41:32 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
References: <48977C96.2090005@skyrush.com>	<20080805001129.72d06e60@lxorguk.ukuu.org.uk>	<489A06D9.1080600@skyrush.com>	<20080807203716.4a9870f6@lxorguk.ukuu.org.uk>	<48A0573B.4010602@skyrush.com> <20080811173911.07a3a9c5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080811173911.07a3a9c5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> First thought would be to simply fire all output through your buffer in
> n_tty. It's not a performance critical bit of code and it would still be
> fast as the usual case would be
> 
> 	if (queue->length == 0)
> 		try_write_directly(...)

Only problem with that is that with a steady stream of output, you would likely
end up quickly filling the new buffer and be right back to the same issue of
losing echos and other ldisc chars off the start of the buf.  Also, the regular
output channel has the mechanism to throttle itself already and try again later
(causing the upstream process to wait as expected - example: ping foo.com; hit
^S; it stops pinging until ^Q...).

What I may try is moving the code that manipulates the column marker (mostly
"eraser") to happen at real output (i.e. when we know space is available), and
have all ldisc echos/chars go into the buffer initially.  That way, the regular
output stream and ldisc stream (out of the buffer) will be able to control the
column stuff properly and in sync.  By knowing how many chars need to go out
(eraser is the only non-trivial case, and we can have it tell us the char string
before sending it), we can be sure there is space before trying and subsequently
changing the column.

BTW, I'll also need to call the new buffer push function periodically after the
output happens in case there are characters left to process.  I suspect the
right place is in the write wakeup func or the poll func.  If you know off hand,
let me know.

						Thanks, Joe
