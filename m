Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYJVTf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYJVTf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbYJVTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:35:28 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:48948 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbYJVTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:35:26 -0400
Message-ID: <48FF807B.2020002@skyrush.com>
Date: Wed, 22 Oct 2008 13:35:23 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix n_tty/pty input/output buffer full and other misc
 char handling
References: <48F2E450.1070508@skyrush.com> <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> that ^C, ^Q, etc. can have effect) in non-canonical mode?  This would
>> allow prevention of the gridlocks that still can be invoked when using
>> stty -icanon in, say, an xterm.  For now, I took the conservative route
>> in this patch, but let me know if a more permissive approach is better.
> 
> I suspect having thought about this a bit more that the proper logic is
> in fact
> 
> 	if (special case a)
> 	if (special case b)
> 	if (....)
> 
> 	/* An ordinary character for the queue */
> 	if (queue_full) { ....}
> 
> and we should process everything that may have a special effect (flow
> control, delete line, etc) before worrying about having room to store the
> character whatever the tty ldisc state

Yeah, I had thought about this a little before too.  The tricky part is
knowing that such a character exists and is waiting when we have already
stopped accepting characters.  In the current way things work, a ^C, for
example, will not make it into the line discipline until the stuff that
came before has been processed (which is now wedged waiting for space to
free up), so it's hard to check in the ldisc for it.  I'm guessing that
is why the orignal logic in set_room was designed to lets stuff flow in
in that case when we're looking for an erase char...

Now, in the case of a ^C or ^Q (e.g.), if we knew one was back in the
queue waiting to get to the ldisc, we could put it through out of
sequence, but for an erase (e.g.), it needs to wait for what real chars
come before it (i.e. it cannot jump to the front)...

I'll think more on this, too - let me know if I am not hearing what you
are saying exactly.

				-Joe

