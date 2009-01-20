Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZATCXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZATCXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZATCXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:23:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:4841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZATCXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:23:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=L5wheYYWopaFFutvnER3PeTK1lQVWFbenrsf2A/Ty8zEsszAz14S7gP5votSxjYtp
	aAaCx099sWUUP/7XSNPtg==
MIME-Version: 1.0
In-Reply-To: <20090120110221.005e116c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
	 <20090120110221.005e116c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 18:23:03 -0800
Message-ID: <6599ad830901191823q556faeeub28d02d39dda7396@mail.gmail.com>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.69
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 6:02 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Ah, this is related to CSS ID scanning. No real problem to current codes.
>
> Now, in my patch, CSS ID is attached just after create().
>
> Then, "scan by CSS ID" can find a cgroup which is not populated yet.
> I just wanted to skip them for avoiding mess.
>
> For example, css_tryget() can succeed against css which belongs to not-populated
> cgroup. If creation of cgroup fails, it's destroyed and freed without RCU synchronize.
> This may breaks CSS ID scanning's assumption that "we're safe under rcu_read_lock".
> And allows destroy css while css->refcnt > 1.

So for the CSS ID case, we could solve this by not populating
css_id->css until creation is guaranteed to have succeeded? (We'd
still allocated the css_id along with the subsystem, just not complete
its initialization). cgroup.c already knows about and hides the
details of css_id, so this wouldn't be hard.

The question is whether other users of css_tryget() might run into
this problem, without using CSS IDs. But currently no-one's using
css_tryget() apart from you, so that's a problem we can solve as it
arises.

I think we're safe from css_get() being used in this case, since
css_get() can only be used on css references obtained from a locked
task, or from other pointers that are known to be ref-counted, which
would be impossible if css_tryget() can't succeed on a css in the
partially-completed state.


Paul
