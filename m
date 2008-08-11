Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYHKPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYHKPOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYHKPOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:14:08 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:36491 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYHKPOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:14:07 -0400
Message-ID: <48A0573B.4010602@skyrush.com>
Date: Mon, 11 Aug 2008 09:14:03 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
References: <48977C96.2090005@skyrush.com>	<20080805001129.72d06e60@lxorguk.ukuu.org.uk>	<489A06D9.1080600@skyrush.com> <20080807203716.4a9870f6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080807203716.4a9870f6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> It should certainly occur if the output buffer is full but that shouldn't
> be the case for a few bytes. Agreed the current behaviour is unexpected
> and less than desirable so hack away.

I see the problem clearly now.  The driver does indeed reject writes when the
tty is stopped or full, and the ldisc throws them away in that case (only for
echos or other ldisc-generated output, of course).  This problem goes deeper
in that the column logic (for eraser, tabs, etc.) relies on the characters
making it to the tty, and here are many places this is never checked/guaranteed.

I am working up an echo buffer (fifo) that would hold these characters until
they can be sent (if the write is not possible), but since that means they
will arrive at the tty later, their interleaving within the application output
stream is not guaranteed, which again is a problem for the column logic.

I'm still looking into it - not trivial for sure...

							-Joe
