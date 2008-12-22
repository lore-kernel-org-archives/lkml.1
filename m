Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYLWAAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYLWAAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYLWAAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:00:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:45751 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbYLWAAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:00:03 -0500
Date: Mon, 22 Dec 2008 15:58:37 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()
Message-ID: <20081222235837.GC13079@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005424.GD5025@us.ibm.com> <20081222222604.GA1536@redhat.com> <20081222230133.GD1536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222230133.GD1536@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 12/22, Oleg Nesterov wrote:
| >
| > On 12/20, Sukadev Bhattiprolu wrote:
| > >
| > > + * TODO:
| > > + * 	  Making SI_ASYNCIO a kernel signal could make this less hacky.
| > > + */
| > > +#ifdef CONFIG_PID_NS
| > > +static inline int siginfo_from_user(siginfo_t *info)
| > > +{
| > > +	if (!is_si_special(info) && SI_FROMUSER(info) &&
| >
| > OK, if we can trust SI_FROMUSER(), then it is better, i agree.
| 
| Aaah, forgot to mention...
| 
| But could you explain how are you going to fix another problem,
| .si_pid mangling? This was another reason for (yes, ugly, agreed)
| SIG_FROM_USER in .si_signo.

Good point.

I was going through the ->si_pid assignments to try and fix them at
source (like the mqueue patch I sent last week).

The two cases that don't fit the model are sys_kill() and sys_tkill().
For that I was hoping we could use siginfo_from_user() again. i.e

	if (siginfo_from_user())
		masquerade_si_pid()

in the default: case of send_signal(). To be safe, masquerade_si_pid()
could do it only iff si_code is either SI_USER or SI_TKILL.

IOW, with some tweaks, I am trying to see if we can use siginfo_from_user()
in place of the SIG_FROM_USER.
