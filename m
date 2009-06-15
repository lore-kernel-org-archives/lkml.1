Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZFOSUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZFOSUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbZFOSTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:19:47 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:46826 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933718AbZFOSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QEjdKmExpF1mNYxJR8Ufa+TNgwLqdWGPf1WR+XP5A4+b7I7QpkY0CM76OVt6ClkEk/
         MZVOeqDBTB9B1UNTXoD8qSyqhlH7nVzeei6A6d5tWEt9+zW05rMkXifChAnPuKTBDbf+
         ekFnfVcy1++RkzkpNPk+eHv6HA6Yp9AdtzssE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906151013080.3305@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
	 <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
	 <1245077891.23207.48.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906151101580.23995@gentwo.org>
	 <1245078661.23207.50.camel@penberg-laptop>
	 <84144f020906150827k1b8c0ce4q5ed4d140f7ca869@mail.gmail.com>
	 <alpine.LFD.2.01.0906151013080.3305@localhost.localdomain>
Date: Mon, 15 Jun 2009 21:19:46 +0300
X-Google-Sender-Auth: 81a4302443648ef3
Message-ID: <84144f020906151119y4d725c28j36a7d16b22e409e0@mail.gmail.com>
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 15 Jun 2009, Pekka Enberg wrote:
>> Actually, there's a slight complication here. If I push gfp mask to
>> __might_sleep(), lockdep_trace_alloc() and so on, the mask is
>> effective _everywhere_ even outside of slab. Yes, it makes sense if we
>> push the masking right down to the page allocator but I wonder if
>> that's something we want to do at this point?

On Mon, Jun 15, 2009 at 8:15 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> This actually doesn't sound like a complication to me, but a potential
> cleanup.
>
> Right now we already have that magic "system_state" test in __might_sleep.
> Maybe we could get rid of that, and replace it with that test for gpf
> bits. So we'd have just _one_ magic special case, and it's directly
> related to memory allocation (which is really the reason for that system
> state thing too).
>
> But maybe we have other reasons for that system_state special case, that
> are independent. I have not checked.

I'll double-check this but I think we can do that. The only
problematic one is __lockdep_trace_alloc() which is used by the page
allocator and the slab allocator but we only want to do masking in the
latter one. But I guess we can just introduce a
lockdep_trace_slab_alloc() or something that does it before calling
the internal function.

                                   Pekka
