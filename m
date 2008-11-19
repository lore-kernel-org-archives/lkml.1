Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYKSCbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYKSCbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYKSCbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:31:44 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55267 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYKSCbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:31:43 -0500
Date: Tue, 18 Nov 2008 18:28:17 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][v2] Define/use siginfo_from_ancestor_ns()
Message-ID: <20081119022817.GA20290@us.ibm.com>
References: <20081115212133.GA32140@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115212133.GA32140@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| @@ -864,6 +902,9 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
|  		 * and sent by user using something other than kill().
|  		 */
|  			return -EAGAIN;
| +
| +		if (from_ancestor_ns)
| +			return -ENOMEM;
|  	}
| 
|  out_set:

We had wanted to start with a check like above and improve later.

But if sender is from ancestor namespace, we must post the signal even if
we don't have the siginfo right ?  Otherwise, a SIGKILL from ancestor may
get the -ENOMEM ?

Conversely, if a signal from same namespace is being posted to cinit, and
we don't have siginfo, ->si_pid would be 0 and get_signal_to_deliver()
would mistake that the sender is an ancestor ns and process the signal
(which should have been ignored).

So, maybe we should start with the reverse check ?

	if (same_ns && (t->signal->flags & SIGNAL_UNKILLABLE))
		return -ENOMEM;

Sukadev
