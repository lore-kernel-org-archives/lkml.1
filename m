Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbXH1HWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbXH1HWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXH1HV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:21:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:35765 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXH1HV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zb3zExC7HJfGgXaLhLLY34zMo30qWDMo5HG/QegWQBlf26McJFPi4MeKChYmQJBPhocTTn6mmmGYfzYEKgrIxBtLWtu2KXjyYksNYZY+farTk8VoJ5QlKGoWOBdBDlJO+/YWJYtgBZ2HjJh/5rg/Pr418qjeDKhEVpeHpJcgaNs=
Message-ID: <24c1515f0708280021w5025953fld3e95c585d66def5@mail.gmail.com>
Date: Tue, 28 Aug 2007 10:21:55 +0300
From: "Janne Karhunen" <janne.karhunen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: NFSv3 lock recovery
In-Reply-To: <18131.49452.211244.327585@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <24c1515f0708272322h2875ea28k7a28b8651513132a@mail.gmail.com>
	 <18131.49452.211244.327585@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Neil Brown <neilb@suse.de> wrote:

> > Brief question about NFSv3 lock recovery to those who might
> > know - does Linux implementation (or NLM/NSM protocol)
> > properly support the case in which client and server state
> > change simultaneously?
>
> If both crash, there is nothing for a client to reclaim and nothing
> for a server to discard, so it is hard to see where a problem could
> lie.

What I'm getting is a usual stale lock case - node(s) bootup
gets stuck to first attempted file lock (wtmp in this case).


> > Reason I'm asking is that this very case is occasionally giving
> > me stale locks. Given that NFSv3 server crashes it's possible
> > that client 'rooting' from it crashes as well. Now, once the
> > server comes back up it tries to notify the client that just
> > crashed. Hardly surprisingly, this notification doesn't go
> > anywhere and server discards the notification/client. And once
> > the client starts to boot again it tries to notify the server which
> > instantly whines about SM_NOTIFY when no-one is being
> > monitored. Thus, whole notification cycle is busted and lock
> > states go haywire :/. Is this even supposed to work?
> >
>
> More details.  What, exactly, goes "haywire"...

Wtmp is locked and client remains waiting for it to be
released. It's as if server lock state was persistent over
crash and both ways busted notification cycle makes
sure lock is never released. Server never grants a new
lock to this file.

But I take it that lock state(s) are not supposed to be
persistent over crash? Umm.


> If your client is diskless and mounting root from the server, then it
> should be mounting the root with "-o nolock" and there should be no
> locking issues at all.

Sure, but I need the locks..


> Please explain in detail your configuration (What is mounted where and
> with what options etc) and what happens (why does the client crash
> just because the server crashed - it shouldn't), and what actually
> fails that you expected to work.

Client has root on top of NFS. Thus, if the server goes
away it's 'quite likely' for things to jam in the client and
in this case we have a HA setup that reacts to this.

One more thing. Restarting server statd once clients
are up helps instantly.


-- 
// Janne
