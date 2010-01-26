Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0AZMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0AZMd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590Ab0AZMdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:33:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49328 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab0AZMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:33:54 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
References: <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com>
	<20100126060705.GF19799@ZenIV.linux.org.uk>
	<20100126164018.1D59.A69D9226@jp.fujitsu.com>
	<2375c9f91001260045s7d01c427g64bc10f5bf4db4d@mail.gmail.com>
	<m1vdepxm6w.fsf@fess.ebiederm.org>
	<2375c9f91001260132l21e43fc4v2eed9ac39f433b8d@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 26 Jan 2010 04:33:38 -0800
In-Reply-To: <2375c9f91001260132l21e43fc4v2eed9ac39f433b8d@mail.gmail.com>
 (=?utf-8?Q?=22Am=C3=A9rico?= Wang"'s message of "Tue\, 26 Jan 2010
 17\:32\:59 +0800")
Message-ID: <m1ljflxcyl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0QCYS54015890

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Tue, Jan 26, 2010 at 5:14 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Américo Wang <xiyou.wangcong@gmail.com> writes:
>>
>>> On Tue, Jan 26, 2010 at 3:45 PM, KOSAKI Motohiro
>>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> Hi
>>>>
>>>>> On Tue, Jan 26, 2010 at 02:01:12PM +0800, Am??rico Wang wrote:
>>>>>
>>>>> > I agree, it seems that patch is useless, since we already
>>>>> > do lock_kernel() before calling __f_setown()...
>>>>>
>>>>> What's to prevent pid from being freed under us?  BKL won't...
>>>>
>>>> I don't understand this issue at all. so, this is stupid dumb question.
>>>> Why can't we write following code?
>>>>
>>>>
>>>>                enum pid_type type;
>>>>                struct pid *pid;
>>>>                if (!waitqueue_active(&tty->read_wait))
>>>>                        tty->minimum_to_wake = 1;
>>>>                spin_lock_irqsave(&tty->ctrl_lock, flags);
>>>>                if (tty->pgrp) {
>>>>                        pid = tty->pgrp;
>>>>                        type = PIDTYPE_PGID;
>>>>                } else {
>>>>                        pid = task_pid(current);
>>>>                        type = PIDTYPE_PID;
>>>>                }
>>>>                get_pid(pid)                                    // insert here
>>>>                spin_unlock_irqrestore(&tty->ctrl_lock, flags);
>>>>                retval = __f_setown(filp, pid, type, 0);
>>>>                put_pid(pid)                                    // insert here
>>>>
>>>
>>> Yeah, this seems reasonable for me, but not sure if this is the best fix.
>>
>> That or tweak __f_setown to use irqsave/irqrestore variants for it's
>> locks, __f_setown is already atomic.  I prefer that direction because the
>> code is just a little simpler.
>>
>
> Oh, very good advice!
>
> Patch is below.
>
> -------------->
> Commit 703625118 causes a lockdep warning:
>
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.33-rc5 #77
> ---------------------------------------------------------
> emacs/1609 just changed the state of lock:
>  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>]
> tty_fasync+0xe8/0x190
> but this lock took another, HARDIRQ-unsafe lock in the past:
>  (&(&sighand->siglock)->rlock){-.....}
>
> This is due to we use write_lock_irq() in __f_setown() which turns
> the IRQ on in write_unlock_irq(), causes this warning.
>
> Switch it ot write_lock_irqsave() and write_unlock_irqrestore(),
> as suggested by Eric.
>
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> ----
>
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 97e01dc..556b404 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -199,7 +199,8 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>  static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
>                       int force)
>  {
> -	write_lock_irq(&filp->f_owner.lock);
> +	int flags;

Minor nit.  This should be "unsigned long flags;"

> +	write_lock_irqsave(&filp->f_owner.lock, flags);
>  	if (force || !filp->f_owner.pid) {
>  		put_pid(filp->f_owner.pid);
>  		filp->f_owner.pid = get_pid(pid);
> @@ -211,7 +212,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
>  			filp->f_owner.euid = cred->euid;
>  		}
>  	}
> -	write_unlock_irq(&filp->f_owner.lock);
> +	write_unlock_irqrestore(&filp->f_owner.lock, flags);
>  }
>  
>  int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,

Eric
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
