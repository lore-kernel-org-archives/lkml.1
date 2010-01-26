Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623Ab0AZP4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0AZP4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030Ab0AZP4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:56:11 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:46590 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0AZP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ejh4r54mr+5kcjNiQfdIWpBS9nPLuiyQwgBSguhtOoPQESwPgEQOWVgZaT00GmwqCl
         6EX6LiMxXNzIth/ZT+h4oyq8J3Cj3bAe3jadMot0nyVSXad/Z9YQVXv9vNXTwSsIWy89
         3UiJATmpjgxim5/4qN4Bi/vHEXVa9B/btT6c8=
Date: Tue, 26 Jan 2010 23:58:19 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [Patch] fix the lockdep warning in tty_fasync()
Message-ID: <20100126155819.GB3780@hack>
References: <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com> <20100126060705.GF19799@ZenIV.linux.org.uk> <20100126164018.1D59.A69D9226@jp.fujitsu.com> <2375c9f91001260045s7d01c427g64bc10f5bf4db4d@mail.gmail.com> <m1vdepxm6w.fsf@fess.ebiederm.org> <2375c9f91001260132l21e43fc4v2eed9ac39f433b8d@mail.gmail.com> <m1ljflxcyl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1ljflxcyl.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:33:38AM -0800, Eric W. Biederman wrote:
>>>
>>> That or tweak __f_setown to use irqsave/irqrestore variants for it's
>>> locks, __f_setown is already atomic.  I prefer that direction because the
>>> code is just a little simpler.
>>>
>>
>> Oh, very good advice!
>>
>> Patch is below.
>>
>> -------------->
>> Commit 703625118 causes a lockdep warning:
>>
>> [ INFO: possible irq lock inversion dependency detected ]
>> 2.6.33-rc5 #77
>> ---------------------------------------------------------
>> emacs/1609 just changed the state of lock:
>>  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>]
>> tty_fasync+0xe8/0x190
>> but this lock took another, HARDIRQ-unsafe lock in the past:
>>  (&(&sighand->siglock)->rlock){-.....}
>>
>> This is due to we use write_lock_irq() in __f_setown() which turns
>> the IRQ on in write_unlock_irq(), causes this warning.
>>
>> Switch it ot write_lock_irqsave() and write_unlock_irqrestore(),
>> as suggested by Eric.
>>
>> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
>> ----
>>
>> diff --git a/fs/fcntl.c b/fs/fcntl.c
>> index 97e01dc..556b404 100644
>> --- a/fs/fcntl.c
>> +++ b/fs/fcntl.c
>> @@ -199,7 +199,8 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>>  static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
>>                       int force)
>>  {
>> -	write_lock_irq(&filp->f_owner.lock);
>> +	int flags;
>
>Minor nit.  This should be "unsigned long flags;"
>

Right... Below is an updated version.

Thanks.

------------>

Commit 703625118 causes a lockdep warning:
 
[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc5 #77
---------------------------------------------------------
emacs/1609 just changed the state of lock:
 (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>]
tty_fasync+0xe8/0x190
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&sighand->siglock)->rlock){-.....}

This is due to we use write_lock_irq() in __f_setown() which turns
the IRQ on in write_unlock_irq(), causes this warning.

Switch it to write_lock_irqsave() and write_unlock_irqrestore(),
as suggested by Eric.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

---
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 97e01dc..82cc8a7 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -199,7 +199,8 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      int force)
 {
-	write_lock_irq(&filp->f_owner.lock);
+	unsigned long flags;
+	write_lock_irqsave(&filp->f_owner.lock, flags);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -211,7 +212,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
 			filp->f_owner.euid = cred->euid;
 		}
 	}
-	write_unlock_irq(&filp->f_owner.lock);
+	write_unlock_irqrestore(&filp->f_owner.lock, flags);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,


