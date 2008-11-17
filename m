Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYKQTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYKQTWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYKQTWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:22:24 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:48028 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYKQTWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PQ4HGtDIaPw0VSjrukMmQ0EzqtXmvUA9KvTASDzRT479Xt9+OeKlbtqGBk+bklrxxl
         wQPurAaMVgFfy6x9Pnbmy0gXp0Uv4DBwYTysyRzpv20UbaKGv74OIp7cWKHYpvhRMcSi
         PJbAwl/yAiHtFnUZ6KtQMRfC4J1PGOP2syejc=
Date: Mon, 17 Nov 2008 22:22:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [RFC] x86: save_args out of line
Message-ID: <20081117192216.GA9944@localhost>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm> <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117125317.GK6703@one.firstfloor.org> <1226936257.32609.1285214311@webmail.messagingengine.com> <20081117182340.GN6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117182340.GN6703@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Mon, Nov 17, 2008 at 07:23:40PM +0100]
...
| 
| Ok. Hopefully it's worth the effort. The branch misprediction bubble
| should not be too bad, perhaps it'll make up for the other cycles
| you're adding. But even if it doesn't decreasing cache line foot print is 
| always a good thing.
...

May I turn in? :)

Original .macro interrupt func has

	testl $3, CS(%rdi)
	je 1f
	SWAPGS
1:	incl %gs:pda_irqcount
	jne 2f
	pop %rax
	mov %gs:pda_irqstackptr,%rsp
	push %rax
2:	TRACE_IRQS_OFF

Wouldn't we help the branch predictor a bit by

	testl $3, CS(%rdi)
	je 1f
	SWAPGS
	jne 2f
1:	pop %rax
	mov %gs:pda_irqstackptr,%rsp
	push %rax	
2:	incl %gs:pda_irqcount
	TRACE_IRQS_OFF

I hope I didn't miss anything but maybe it's just a churning
or plain wrong. Don't shoot me :)

		- Cyrill -
