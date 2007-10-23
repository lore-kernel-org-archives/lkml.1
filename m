Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXJWIzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXJWIzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXJWIzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:55:23 -0400
Received: from sacred.ru ([62.205.161.221]:48267 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXJWIzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:55:22 -0400
Message-ID: <471DB710.1060603@openvz.org>
Date: Tue, 23 Oct 2007 12:55:44 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>, riel@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xemul@openvz.org,
       raven@themaw.net
Subject: Re: futex strangeness in 2.6.23-mm1/UML
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>	<20071022145321.195d929b@bree.surriel.com>	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>	<20071022172926.03ca122a@bree.surriel.com>	<20071022200742.6f3acbb2@bree.surriel.com> <20071022171624.0c00f8da.akpm@linux-foundation.org> <E1IkEJP-0004Qp-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1IkEJP-0004Qp-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 23 Oct 2007 12:55:01 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> I guess we can debug it in the old-fashioned ways.  The first of which is
>> to palm the problem off on Pavel ;)

I look at the 2.6.23-mm1 and see that there's one hunk lost. This
is the one Oleg re-sent some days ago (the mail thread subject was
2.6.23-mm1 thread exit_group issue). Here it is (sent 13 oct 2007):

--- kernel/fork.c~	2007-10-13 15:41:35.000000000 +0400
+++ kernel/fork.c	2007-10-13 15:41:41.000000000 +0400
@@ -1443,6 +1443,9 @@ long do_fork(unsigned long clone_flags,
 			task_pid_nr_ns(p, current->nsproxy->pid_ns) :
 				task_pid_vnr(p);
 
+		if (clone_flags & CLONE_PARENT_SETTID)
+			put_user(nr, parent_tidptr);
+
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);

Please, try with this patch.

>> I don't recall seeing a simple step-by-step way by which others can
>> reproduce this?
> 
> My method is this:
> 
> - enable CONFIG_FUSE_FS
> - compile fuse from CVS:
>  cvs -d:pserver:anonymous@fuse.cvs.sourceforge.net:/cvsroot/fuse co -P fuse
>  cd fuse
>  ./makeconf.sh
>  ./configure
>  make
>  make -C test
> 
> - in one shell:
>  mkdir /tmp/fuse
>  example/fusexmp_fh -d /tmp/fuse
> 
> - in another shell:
>  mkdir /tmp/test
>  test/test /tmp/fuse/tmp/test
> 
> The result is normally a completed run with "1 tests failed".  On
> 2.6.23-mm1, it just hangs after the first test.
> 
> I've only tried under UML, but since Rick is seeing it on real HW, I
> guess this method may work there as well.
> 
> Miklos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

