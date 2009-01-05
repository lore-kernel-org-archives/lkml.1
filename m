Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZAEN0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZAEN0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZAEN0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:26:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54813 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZAEN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:26:04 -0500
Date: Mon, 5 Jan 2009 14:24:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, ebiederm@xmission.com,
       bastian@waldi.eu.org, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6][v5] Protect cinit from unblocked SIG_DFL signals
Message-ID: <20090105132407.GC3313@redhat.com>
References: <20081227204658.GA27197@us.ibm.com> <20081227205319.GC27337@us.ibm.com> <20081231001942.F35E2FC278@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231001942.F35E2FC278@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30, Roland McGrath wrote:
>
> I'd just make the flag a parameter to send_signal() directly.
> Then you can just change kill_pid_info_as_uid (or its replacement)
> to call send_signal() with that new flag (and the 'group' flag)
> directly instead of using the trivial __group_send_sig_info wrapper.

Ah, good. Can't understand why I didn't think about this before!

But, perhaps, it is better to add the new helper, __send_signal()
or whatever which has the new "from_ancestor_ns" argument. Then,

	static int send_signal(...)
	{
		bool from_ancestor_ns = 0;

	#ifdef CONFIG_PID_NS
		if (!is_si_special(info) && SI_FROMUSER(info)) {
			from_ancestor_ns = !task_pid_nr_ns(current, task_active_pid_ns(t));
		}
	#endif

		return __send_signal(..., from_ancestor_ns);
	}

but this is cosmetic issue.

Oleg.

