Return-Path: <linux-kernel-owner+w=401wt.eu-S1751402AbZIQV7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbZIQV7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZIQV7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:59:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZIQV7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:59:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=guK5o9Iwtb49AAbQ3nPBLieWz7sqD1qbnuPz8QnQ9LW/AIS7bM9Z16UwRuv+vuAqG
	tkx3LQVOLWYE69DU9kXvg==
Date: Thu, 17 Sep 2009 14:59:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Paris <eparis@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Greg KH <greg@kroah.com>,
       linux-hotplug@vger.kernel.org
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
In-Reply-To: <1253223119.5213.359.camel@dhcp231-106.rdu.redhat.com>
Message-ID: <alpine.DEB.1.00.0909171446230.22063@chino.kir.corp.google.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com> <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com> <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com> <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
 <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com> <1253222149.5213.352.camel@dhcp231-106.rdu.redhat.com> <alpine.DEB.1.00.0909171417020.19006@chino.kir.corp.google.com> <1253223119.5213.359.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Eric Paris wrote:

> Absolutely 100% udevd related.  It always pops right when udev starts.
> Every time.  I don't know how to get that to come out on the serial
> port, you only get to see the kernel messages (although there is nothing
> on the screen other than "Starting udev"
> 
> Reverting 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921 causes the problem to
> go away.  I now am running a 79b520e87e kernel + your patch (adding
> console_verbose()) + reverting 3f2aa307c4d2 and it seems to be working.
> 

Isolating udevd down to an interactivity scheduling change isn't _that_ 
bizarre.  I think the setting of UDEVD_PRIORITY is already mostly 
arbitrary anyway and it'll allow 192 children on your 512M machine by 
default unless you changed UDEVD_MAX_CHILDS for uid 0.

The default timeout for idle workers is 3 seconds, which may just happen 
to be long enough to panic your machine because of low memory.  If that's 
the case, I don't believe that it's a scheduler issue but rather a root 
abuse of setting all udevd threads to be OOM_DISABLE.

What is your udevd --version?  The latest is udev-146 released last month.

Maybe linux-hotplug (added to cc) already knows about this issue?
