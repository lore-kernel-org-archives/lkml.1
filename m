Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYHYOaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYHYOaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbYHYO3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:29:49 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:58472 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbYHYO3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:29:49 -0400
Message-ID: <48B2C1DA.6070700@skyrush.com>
Date: Mon, 25 Aug 2008 08:29:46 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Chris Frey <cdfrey@foursquare.net>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Visible Ctrl-C in latest kernels
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu> <48B2BAE7.4010702@skyrush.com> <20080825141354.GB19337@1wt.eu>
In-Reply-To: <20080825141354.GB19337@1wt.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> not mine, I was speaking about your patch of 2008/02/06 which was
> talked about earlier in this thread. I was thinking that it was
> possible that the signal got delayed when it was hard to print
> ^C because the output was already busy spewing a stream of data.
> Maybe I'm wrong, but I mean it does not cost much to try to revert
> this patch when the problem is encountered. And I keep in mind
> that it is possible, as you say, that your patch only makes the
> problem more visible.

Actually, funny you mention the case when output is busy.  This actually
will not cause any delay of the signal, but it instead causes the echo
(not the signal) to be thrown away in the current code.  If the tty
driver's buffer is full, the attempted write simply returns - nothing is
held.  The signal is still sent right away.

Now, this loss of the echo is a problem in itself, not because it delays
the signals, but because the echo will not be displayed.  Echo is also
lost when the tty is stopped (but the signal chars restart the tty, so
you will only see this for regular chars typed after, say, a ctrl-s)).

I have another patch out that will fix the lost echo issue:

	http://marc.info/?l=linux-kernel&m=121924672730143&w=2

Note that this patch also will never cause any delay of the signals.  In
fact, it places the echo character in a buffer so that a full or stopped
tty buffer will not cause the echoed char to be immediately discarded.
The signal, same as now, is always immediately issued - no delay.

					-Joe
