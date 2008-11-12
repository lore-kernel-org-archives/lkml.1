Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYKLTIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYKLTIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYKLTH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:07:56 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40760 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbYKLTHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:07:55 -0500
Date: Wed, 12 Nov 2008 11:04:21 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, daniel@hozac.com,
       Nadia Derbey <Nadia.Derbey@bull.net>, serue@us.ibm.com, clg@fr.ibm.com,
       Containers <containers@lists.osdl.org>, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Signals to cinit
Message-ID: <20081112190421.GE3230@us.ibm.com>
References: <20081101180505.GA24268@us.ibm.com> <20081110173839.GA11121@redhat.com> <20081110193228.GA15519@redhat.com> <20081111022405.GB20891@us.ibm.com> <20081112150555.GB13269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112150555.GB13269@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 11/10, sukadev@linux.vnet.ibm.com wrote:
| >
| > Also, what happens if a fatal signal is first received from a descendant
| > and while that is still pending, the same signal is received from ancestor
| > ns ?  Won't the second one be ignored by legacy_queue() for the non-rt case ?

On second thoughts, cinit is a normal process in its ancestor ns so it
might very well ignore the second instance of the signal (as long as it
does not ignore SIGKILL/SIGSTOP)

| 
| Please see my another email:
| 
| 	We must also change sig_ignored() to drop SIGKILL/SIGSTOP early when
| 	it comes from the same ns. Otherwise, it can mask the next SIGKILL
| 	from the parent ns.

Ok.

| 
| 	But this perhaps makes sense anyway, even without containers.
| 	Currently, when the global init has the pending SIGKILL, we can't
| 	trust __wait_event_killable/etc, and this is actually wrong.
| 
| We can drop other SIG_DFL signals from the same namespace early as well.

I think Eric's patchset did this and iirc, we ran into the problem of
blocked SIG_DFL signals ?

| I seem to already did something like sig_init_ignored(), but I forgot.

Yes, I think we had that in the patchset but that was not merged.

| 
| Or, we can just ignore this (imho) minor problem.

I think so too.

| The ancestor ns
| must know it can't reliably kill cinit with (say) SIGTERM. It can
| be ignored, or it can have have a handler, and it can be lost because
| SIGTERM is already pending. Only SIGKILL is special.
| 
| Actually. I personally think that if we manage to achieve that
| 
| 	- the sub-namespace can't kill its init
| 
| 	- the ancestor can always kill cinit with SIGKILL

Yep.

| 
| then imho we should not worry very much about other issues ;)
| 
| Oleg.
