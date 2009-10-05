Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZJER7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZJER7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZJER7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:59:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35303 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZJER7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:59:17 -0400
Date: Mon, 5 Oct 2009 10:58:55 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091005175855.GB30442@us.ibm.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021918.GB21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004021918.GB21006@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| No changes in compiled code. The patch adds the new helper, si_fromuser()
| and changes check_kill_permission() to use this helper.
| 
| The real effect of this patch is that from now we "officially" consider
| SEND_SIG_NOINFO signal as "from user-space" signals. This is already true
| if we look at the code which uses SEND_SIG_NOINFO, except __send_signal()
| has another opinion - see the next patch.
| 
| The naming of these special SEND_SIG_XXX siginfo's is really bad imho.

I agree :-)

| >From __send_signal()'s pov they mean
| 
| 	SEND_SIG_NOINFO		from user

Just to complicate further, all 'SEND_SIG_NOINFO' signals are from user,
but not all 'from user' signals are SEND_SIG_NOINFO.

| 	SEND_SIG_PRIV		from kernel

SEND_SIG_PRIV also means there is no real info, just that sender is
privileged.

| 	SEND_SIG_FORCED		no info

Are 'forced' signals considered 'from kernel' too ?

Separate from this patch, but would be good if we could fix the naming.

| 
| Signed-off-by: Oleg Nesterov <oleg@redhat.com>
| ---
| 
|  include/linux/sched.h |    5 -----
|  kernel/signal.c       |   16 +++++++++++++---
|  2 files changed, 13 insertions(+), 8 deletions(-)
| 
| --- TTT_32/include/linux/sched.h~FU_1_HELPER	2009-09-24 21:38:54.000000000 +0200
| +++ TTT_32/include/linux/sched.h	2009-10-04 02:21:49.000000000 +0200
| @@ -2081,11 +2081,6 @@ static inline int kill_cad_pid(int sig, 
|  #define SEND_SIG_PRIV	((struct siginfo *) 1)
|  #define SEND_SIG_FORCED	((struct siginfo *) 2)
| 
| -static inline int is_si_special(const struct siginfo *info)
| -{
| -	return info <= SEND_SIG_FORCED;
| -}
| -
|  /* True if we are on the alternate signal stack.  */
| 
|  static inline int on_sig_stack(unsigned long sp)
| --- TTT_32/kernel/signal.c~FU_1_HELPER	2009-09-24 21:38:54.000000000 +0200
| +++ TTT_32/kernel/signal.c	2009-10-04 02:21:55.000000000 +0200
| @@ -584,6 +584,17 @@ static int rm_from_queue(unsigned long m
|  	return 1;
|  }
| 
| +static inline int is_si_special(const struct siginfo *info)
| +{
| +	return info <= SEND_SIG_FORCED;
| +}
| +
| +static inline bool si_fromuser(const struct siginfo *info)
| +{
| +	return info == SEND_SIG_NOINFO ||
| +		(!is_si_special(info) && SI_FROMUSER(info));
| +}
| +

This change makes sense, but can we even drop the SEND_SIG_NOINFO
altogether and simply check for NULL:

	return (!info || (is_si_special(info)) && SI_FROMUSER(info))

Sukadev
