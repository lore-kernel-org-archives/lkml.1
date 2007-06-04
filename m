Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbXFDXUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbXFDXUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbXFDXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:20:47 -0400
Received: from mailhub.hp.com ([192.151.27.10]:60068 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbXFDXUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:20:46 -0400
X-Greylist: delayed 1938 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 19:20:46 EDT
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [bug] very high non-preempt latency in context_struct_compute_av()
Date: Mon, 4 Jun 2007 18:48:20 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Carter <jwcart2@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Joshua Brindle <method@manicmethod.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
References: <20070604112745.GA26350@elte.hu> <200706041711.42755.paul.moore@hp.com> <1180993140.14220.168.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1180993140.14220.168.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041848.21306.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 5:39:00 pm Stephen Smalley wrote:
> On Mon, 2007-06-04 at 17:11 -0400, Paul Moore wrote:
> > I'm not an expert on the SELinux security server guts like the other
> > people on the To/CC line of this thread, but here are my two cents on the
> > issue above.
> >
> > From what I can tell the nasty loop that is taking so long is the actual
> > access vector lookup which determines if the subject has access to the
> > object (i.e. can user/application X access resource Y on the system). 
> > While it may be possible to optimize this code I wonder if a
> > quicker/easier solution would be to refactor the lock.  At present
> > SELinux uses a read/write spinlock to protect the policy stored in the
> > kernel with macros to take and release the lock, POLICY_{RD,WR}LOCK and
> > POLICY_{RD,WR}UNLOCK.  From personal observations as well as a quick
> > check of the code, it appears that most of the time we only want to read
> > lock the policy and not write lock the policy - a spinlock, even a
> > read/write spinlock, seems a bit expensive here.
> >
> > If we were to convert from a read/write spinlock to a RCU locking
> > mechanism would this solve the preemption problem (I'm not a lock expert
> > either)?  If so, can anyone think of any reasons why converting the
> > policy lock to RCU is a bad idea (James, Stephen, the other James)?
>
> rcu_read_lock disables preemption in mainline (see rcupdate.h).
> Conversion to RCU is also complicated by conditional policy support
> (changing of policy boolean states via selinuxfs).  However, there were
> experimental patches to do that a while ago by KaiGai Kohei.

Okay, for some reason I thought someone had found a way to make 
RCU "preemptable" through the real-time work, maybe I'm just confused 
again :)  Regardless, it looks like there are better solutions possible.

Thanks.

-- 
paul moore
linux security @ hp
