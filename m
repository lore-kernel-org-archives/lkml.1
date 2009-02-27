Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbZB0AEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbZB0AEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbZB0AEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:04:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbZB0AES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:04:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: mtk.manpages@gmail.com
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linux API <linux-api@vger.kernel.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
In-Reply-To: Michael Kerrisk's message of  Friday, 27 February 2009 10:19:08 +1300 <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
References: <20090226133339.875832967@linutronix.de>
	<cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
X-Shopping-List: (1) Psychiatric generic hootenanny bugs
   (2) Electronic Johnny Carson lookalikes
   (3) Insolent momentous persecuters
   (4) Diplomatic meretricious lion defusers
   (5) Indigent lotion
Message-Id: <20090227000352.7D32BFC339@magilla.sf.frob.com>
Date: Thu, 26 Feb 2009 16:03:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any rationale for rt_tgsigqueueinfo and rt_sigqueueinfo to
differ in their treatment of si_pid/si_uid (whatever that is).  It just
seems like common sense that they would match.

Oleg and/or Sukadev have some patches floating around (maybe all in -mm?)
that relate to setting those.

I notice that POSIX says that si_pid and si_uid have reliable values
whenever si_code <= 0 (what we call SI_FROMUSER() in asm/siginfo.h).
(POSIX only has sigqueue() and kill() et al to send these, so a POSIX
application never explicitly supplies the values.  libc/libpthread do.
The {t,tg,}kill syscalls all set si_pid to tgid already.)
This means a POSIX-conformant application might check si_pid and si_uid and
rely on them not being forged by some other process/user.  Firstly this
means that si_pid must be the POSIX PID, i.e. tgid, not the Linux TID
(which is not a useful value in POSIX interfaces).  Secondly it means the
kernel should guarantee the correctness of these values (at least when
crossing processes, might as well do always).

I don't recall if the pending changes already use tgid, I think they do.

I think what both calls should do is set si_pid to tgid and si_uid to uid
whenever SI_FROMUSER().  This satisfies the POSIX and security trust
concern, and makes them uniform.  (In Sukadev's version, what si_pid value
they fill in here depends on pid_ns details of sender and recipient.)

Vis a vis Sukadev's changes, I also notice that si_uid ought to be
translated for the recipient user_ns.


Thanks,
Roland
