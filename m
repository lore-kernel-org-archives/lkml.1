Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbYKQMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbYKQMnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYKQMnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:43:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55136 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYKQMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:43:41 -0500
Date: Mon, 17 Nov 2008 13:53:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [RFC] x86: save_args out of line
Message-ID: <20081117125317.GK6703@one.firstfloor.org>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm> <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 03:29:01PM +0100, Alexander van Heukelum wrote:
> From: Alexander van Heukelum <heukelum@sleipnir.lusi.uni-sb.de>
> 
> The macro "interrupt" in entry_64.S generates a lot of code. This
> patch moves most of its contents into an external function. It
> saves anywhere between 500 and 2500 bytes of text depending on the
> configuration.

The only duplication is in the apicinterrupt entry points which
have expanded recently (when I wrote all that there weren't as many)

I think it would be cleaner to just have a common apic_interrupt
entry point similar to how the exceptions work that try to factor
out "interrupt" like this. As more and more of them get added
(I have another new one in recent) patches that will likely
save more space.

The only ugly part is that passing the handler to the common
stub requires the manual pt_regs setup that the exception
handler currently does. Because that could be factored
out in a new macro. Or just copied (I have heard complaints
in the past that the file has too many macros already)

> There is a comment in the original code about saving rbp twice, but
> I don't understand what the code tries to do. First of all, the

To be honest I didn't understand this one either when it was added. In 
standard frame pointer format rbp has to be at the place pointed to by the real 
rbp register with the return address directly on top of it. But pushing
%rbp below the pt_regs doesn't put it into this format, because
the return address is at the wrong place.

-Andi
