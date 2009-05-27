Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbZE0TwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbZE0TwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbZE0Tvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:51:54 -0400
Received: from mta.netezza.com ([12.148.248.132]:58928 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757326AbZE0Tvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:51:54 -0400
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090527190513.GA32452@redhat.com>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	 <878wkjobbm.fsf@basil.nowhere.org> <20090527183109.GA30574@redhat.com>
	 <20090527185056.GW1065@one.firstfloor.org>
	 <20090527190513.GA32452@redhat.com>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Wed, 27 May 2009 15:49:43 -0400
Message-Id: <1243453783.29250.434.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 19:49:43.0850 (UTC) FILETIME=[480DD8A0:01C9DF04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 21:05 +0200, Oleg Nesterov wrote:
> On 05/27, Andi Kleen wrote:
> >
> > > Actually, I think there is a strong reason to handle signals during
> > > core dumping. The coredump can take a lot of time/resources, not good
> > > it looks like unkillable procees to users.
> >
> > One problem with that is if you send a process a string of signals that cause
> > a core dump and then kill. In the old case you would just get a full core dump
> > on the first signal and be done. With your change it would process
> > the second signal too and stop the dumping and you get none or a partial
> > core dump. That might well break existing setups.
> 
> I don't think we should worry about this particular case. Suppose a user
> does
> 
> 	kill(pid, SIGQUIT);
> 	kill(pid, SIGKILL);

I'm not sure about this.  Why even bother with SIGQUIT (or anything
else) if you're just going to immediately SIGKILL afterwards?  What
people do all the time, and I think should be supported, is something
like this:

	<do 5 times>
		kill(pid, SIGINT);
		sleep(1);
		<if pid is dead break>
	kill(pid, SIGKILL);

Often with other signals in the mix like SIGHUP or whatever.  The idea
is to give the process a chance to do "whatever it does" to clean up and
then, if it's still there we consider it too wedged to respond and send
a SIGKILL.  If the cleanup operations invoked by receiving the SIGINT
caused a core dump, then you wouldn't want the SIGKILL to stop the core
dump.

On the other hand I do agree that it would be nice to be able to smash a
core dump that was taking a long time or trying to write to an
unavailable resource like a stalled NFS mount or whatever.  Sigh.

