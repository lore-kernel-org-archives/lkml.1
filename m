Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYDILRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYDILRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYDILQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:16:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYDILQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:16:52 -0400
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
From: David Woodhouse <dwmw2@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080408113519.GA227@tv-sign.ru>
References: <20080329001230.D013726FA1D@magilla.localdomain>
	 <20080329001341.7F93826FA1D@magilla.localdomain>
	 <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
	 <20080408113519.GA227@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 12:16:27 +0100
Message-Id: <1207739787.27048.57.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-08 at 15:35 +0400, Oleg Nesterov wrote:
> Why do we need any flag? It looks a bit ugly. Isn't it better to introduce
> the new magic ERESTART_XXX which means ERESTARTNOHAND + restore-sigmask ?
> 
> We only need this flag as an implicit parameter to the arch dependent do_signal()
> which we can't call directly, and thus it must imply TIF_SIGPENDING, and it
> is not valid after do_signal() (should be cleared). This all looks like
> ERESTART_ magic, why should we add something else ?
> 
> See also http://marc.info/?l=linux-kernel&m=113734458516136
> 
> Of course, probably it is too late to change the implementation even if
> I am right, the question is: what I am missed?

Q: When ppoll() is interrupted by a signal, what signal mask should be
active when the signal handler is active?

I believe that the signal handler should run with the temporary sigmask
which was set by ppoll(), and the original sigmask should be restored
only when the handler completes -- and that's what we achieve with
TIF_RESTORE_SIGMASK.

So a signal which was originally enabled but is temporarily disabled by
the mask passed to ppoll() will not be able to interrupt the handler for
the signal which interrupted ppoll().

Your version will restore the original signal mask _before_ invoking the
signal handler which interrupted ppoll() -- which I believe is not the
intended semantics. And IIRC that was the whole point in implementing
ppoll() in kernel rather than trying to emulate it in userspace in the
first place.

-- 
dwmw2

