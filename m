Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZFASkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZFASkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZFASkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:40:37 -0400
Received: from mta.netezza.com ([12.148.248.132]:63714 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751480AbZFASkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:40:36 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090601184934.1fc54411@lxorguk.ukuu.org.uk>
References: <1243748019.7369.319.camel@homebase.localnet>
	 <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	 <20090601161234.GA10486@redhat.com>
	 <1243877766.8547.38.camel@psmith-ubeta.netezza.com>
	 <20090601184934.1fc54411@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Mon, 01 Jun 2009 14:39:04 -0400
Message-Id: <1243881544.8547.66.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2009 18:39:04.0410 (UTC) FILETIME=[3D3763A0:01C9E2E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 18:49 +0100, Alan Cox wrote:
> > On the other hand, IMO all other signals, including SIGINT and SIGQUIT,
> > should be ignored during core dumping.  Allowing SIGKILL gives a method
> > for getting rid of core dumps in the relatively rare situation where
> > people want/need to do so, and I don't see any real benefit to adding
> > more signals to the list of things you can't do if you want robust
> > cores.  Isn't one enough?
> 
> I also want usability. SIGINT/SIGQUIT are never sent except by user
> requests to terminate a process so they can safely be allowed. If the
> alternatives are the status quo or SIGKILL only then I'd favour the
> status quo particularly having experienced the alternatives on some old
> Unix systems.

SIGINT/SIGQUIT are sent all the time in situations where the user might
not want the core dump to be canceled.  This is what I meant by "wanted
to actually interrupt the core"; it implies the user knows that a core
is being dumped and explicitly decides they do not want to have that
happen in this situation and takes some affirmative action to stop it.

If a program seems to be unresponsive the user could ^C, without
realizing that it was really dumping core.  Now when they are asked to
produce the core so the problem can be debugged, they can't do it.  Or,
a worker process might appear unresponsive due to a core being dumped
and the parent would decide to shoot it with SIGINT based on various
timeouts etc.  Again we have no core available.

If the user has problems with coredumps there are all sorts of ways to
manage that.  You can disable core dumps altogether via ulimit.  You can
set core_pattern to dump to a fully-qualified pathname on faster media
instead of whatever working directory you're using.

Or, with this change, you can kill -9 the PID that's dumping core.

These things seem to me to provide a lot of usability features.

On the other hand there's no way to ensure full, reliable core dumps
with today's behavior.

