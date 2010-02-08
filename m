Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0BHKNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:13:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:29309 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0BHKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:13:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZdYZzgu8DzzJci1ADkvNiCtoiNRyCxSMo3ekOGrvobcL9YjPB7xbfGb9CLTGFNgzqg
         yAOXaCAiWEzZcw8AnMTMQscxVg71B7x1xurKGXnE6vaQuN8TRLSCuw8+OCZWDgYOJ0bU
         u3Uqf28+PzesFDBOT6HM2Axsk/ZvLANbuwE8w=
MIME-Version: 1.0
In-Reply-To: <20100207171615.GA9854@redhat.com>
References: <20100207171615.GA9854@redhat.com>
Date: Mon, 8 Feb 2010 18:13:15 +0800
Message-ID: <2375c9f91002080213n6de036br7690e14294ede27b@mail.gmail.com>
Subject: Re: [PATCH] coredump: set ->group_exit_code for other CLONE_VM tasks 
	too
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frank Heckenbach <f.heckenbach@fh-soft.de>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o18ADxmE018965

On Mon, Feb 8, 2010 at 1:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:> User visible change.>> do_coredump() kills all threads which share the same ->mm but only> the coredumping process gets the proper exit_code. Other tasks which> share the same ->mm die "silently" and return status == 0 to parent.>> This is historical behaviour, not actually a bug. But I think Frank> Heckenbach rightly dislikes the current behaviour. Simple test-case:>>        #include <stdio.h>>        #include <unistd.h>>        #include <signal.h>>        #include <sys/wait.h>>>        int main(void)>        {>                int stat;>>                if (!fork()) {>                        if (!vfork())>                                kill(getpid(), SIGQUIT);>                }>>                wait(&stat);>                printf("stat=%x\n", stat);>                return 0;>        }>> Before this patch it prints "stat=0" despite the fact the child was> killed by SIGQUIT. After this patch the output is "stat=3" which> obviously makes more sense.>> Even with this patch, only the task which originates the coredumping> gets "|= 0x80" if the core was actually dumped, but at least the> coredumping signal is visible to do_wait/etc.

Nice changelog!
>> Reported-by: Frank Heckenbach <f.heckenbach@fh-soft.de>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Thank you!
> --->>  fs/exec.c |    8 ++++---->  1 file changed, 4 insertions(+), 4 deletions(-)>> --- V1/fs/exec.c~CD_STATUS      2009-12-18 00:20:50.000000000 +0100> +++ V1/fs/exec.c        2010-02-07 17:28:24.000000000 +0100> @@ -1536,12 +1536,13 @@ out:>        return ispipe;>  }>> -static int zap_process(struct task_struct *start)> +static int zap_process(struct task_struct *start, int exit_code)>  {>        struct task_struct *t;>        int nr = 0;>>        start->signal->flags = SIGNAL_GROUP_EXIT;> +       start->signal->group_exit_code = exit_code;>        start->signal->group_stop_count = 0;>>        t = start;> @@ -1566,8 +1567,7 @@ static inline int zap_threads(struct tas>        spin_lock_irq(&tsk->sighand->siglock);>        if (!signal_group_exit(tsk->signal)) {>                mm->core_state = core_state;> -               tsk->signal->group_exit_code = exit_code;> -               nr = zap_process(tsk);> +               nr = zap_process(tsk, exit_code);>        }>        spin_unlock_irq(&tsk->sighand->siglock);>        if (unlikely(nr < 0))> @@ -1616,7 +1616,7 @@ static inline int zap_threads(struct tas>                        if (p->mm) {>                                if (unlikely(p->mm == mm)) {>                                        lock_task_sighand(p, &flags);> -                                       nr += zap_process(p);> +                                       nr += zap_process(p, exit_code);>                                        unlock_task_sighand(p, &flags);>                                }>                                break;>>���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
