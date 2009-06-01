Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZFARhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZFARhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZFARhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:37:46 -0400
Received: from mta.netezza.com ([12.148.248.132]:61645 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751502AbZFARhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:37:46 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090601161234.GA10486@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	 <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	 <20090601161234.GA10486@redhat.com>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Mon, 01 Jun 2009 13:36:06 -0400
Message-Id: <1243877766.8547.38.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2009 17:36:06.0605 (UTC) FILETIME=[717817D0:01C9E2DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 18:12 +0200, Oleg Nesterov wrote:
> I agree, we should make the coredumping interruptible.
> 
> But I don't know which signal should intterrupt. At least SIGKILL should,
> I think. As for other unhandled sig_fatal() signals, I am nor sure.
> I can make a patch, but first I need to know what this patch should do.
> Again, please look at:
> 
> 	killable/interruptible coredumps
> 	http://marc.info/?l=linux-kernel&m=121665710711931

Ideally interrupting a core dump is something that should only ever be
done because you wanted to actually interrupt the core, and would never
happen as a side effect of some other behavior that may have been
intended for the process before it dumped core.

In my setup, which is more like an embedded system where I can reboot
the device easily, I'd rather have the core dump hang if I happen to try
to write it to an unavailable resource than to lose cores if someone
sends an errant signal to the process (assuming these are the only two
choices).  I realize that opinions about this differ based on the
purpose of the system (desktops and many types of servers probably would
rather have their pages back and don't care so much about cores).

My preference would be that no signal would ever cancel a core and there
would be some completely out-of-band method for this (something like
setting a flag via /proc/<pid> or similar) to be used if it was
necessary.  However, I can't justify that complexity.  So, SIGKILL seems
like a reasonable compromise.

On the other hand, IMO all other signals, including SIGINT and SIGQUIT,
should be ignored during core dumping.  Allowing SIGKILL gives a method
for getting rid of core dumps in the relatively rare situation where
people want/need to do so, and I don't see any real benefit to adding
more signals to the list of things you can't do if you want robust
cores.  Isn't one enough?

My $0.02.

