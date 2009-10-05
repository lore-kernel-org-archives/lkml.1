Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZJED3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZJED3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZJED3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:29:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45449 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZJED3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:29:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <3e8340490910042022y6182414bg5bfb10b8a3100c4@mail.gmail.com>
References: <20091005114236.5F8C.A69D9226@jp.fujitsu.com> <3e8340490910042022y6182414bg5bfb10b8a3100c4@mail.gmail.com>
Message-Id: <20091005122551.5F8F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  5 Oct 2009 12:29:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Oct 4, 2009 at 10:48 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > +                       } else {
> > +                               len = mm->env_end - mm->env_start;
> > +                               if (len > PAGE_SIZE - res)
> > +                                       len = PAGE_SIZE - res;
> > +                               res += access_process_vm(task, mm->env_start,
> > +                                                        buffer+res, len, 0);
> > +                               res = strnlen(buffer, res);
> > +                       }
> 
> 
> This bug was in the original code, but since you're touching it
> anyway, it should be fixed now; if this access_process_vm fails
> (perhaps due to the target unmapping the page in question in between
> the two calls), bad things might happen if (error code) + res < 0, as
> then strnlen will get a huge value in its length (possibly leading to
> OOPS etc). It should be changed to check for an error return here and
> fail out properly if there is an error in this second check.

AFAIK, access_process_vm() never return negative value.

===================================================================
int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
{
        mm = get_task_mm(tsk);
        if (!mm)
                return 0;

        down_read(&mm->mmap_sem);
        /* ignore errors, just check how much was successfully transferred */
        while (len) {
(snip)

        }
        up_read(&mm->mmap_sem);
        mmput(mm);

        return buf - old_buf;
}


