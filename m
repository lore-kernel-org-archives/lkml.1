Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab0BGHAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 02:00:36 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33588 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0BGHAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 02:00:34 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, gregkh@suse.de,
       taviso@google.com, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       jdike@addtoit.com, jln@google.com, mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in tty_fasync
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp>
	<alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
	<20100207064643.GA15533@hack>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 06 Feb 2010 23:00:20 -0800
In-Reply-To: <20100207064643.GA15533@hack> (=?utf-8?Q?=22Am=C3=A9rico?=
 Wang"'s message of "Sun\, 7 Feb 2010 14\:46\:56 +0800")
Message-ID: <m18wb58r97.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Sat, Feb 06, 2010 at 10:31:30PM -0800, Linus Torvalds wrote:
>>
>>
>>On Sun, 7 Feb 2010, Tetsuo Handa wrote:
>>> 
>>> Below problem (which was introduced between 2.6.33-rc4 and 2.6.33-rc5) is
>>> not yet fixed as of 2.6.33-rc7.
>>> "git bisect start v2.6.33-rc5 v2.6.33-rc4" reported that
>>> 703625118069f9f8960d356676662d3db5a9d116 tty: fix race in tty_fasync
>>> is first bad commit.
>>
>>Yeah. I think we need to just revert that commit.
>>
>>Or maybe we could just do the following, rather than revert it outright: 
>>just get a ref to the 'struct pid' while holding the spinlock, and then 
>>releasing it after doing the __f_setown() call.
>
> We already fixed this, a better fix:
>
> http://lkml.org/lkml/2010/1/26/338
>
> I sent a same fix with Greg's.

That fix is present. See below.  Why does lockdep still warn?
Do we have lockdep bug?

Given that there is the only place we take f_owner.lock for write I
don't see how f_owner.lock can be unsafe to be called with irqs
disabled.

commit b04da8bfdfbbd79544cab2fadfdc12e87eb01600
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Tue Jan 26 15:04:02 2010 -0800

    fnctl: f_modown should call write_lock_irqsave/restore
    
    Commit 703625118069f9f8960d356676662d3db5a9d116 exposed that f_modown()
    should call write_lock_irqsave instead of just write_lock_irq so that
    because a caller could have a spinlock held and it would not be good to
    renable interrupts.
    
    Cc: Eric W. Biederman <ebiederm@xmission.com>
    Cc: Al Viro <viro@ZenIV.linux.org.uk>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Cc: Tavis Ormandy <taviso@google.com>
    Cc: stable <stable@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 97e01dc..5ef953e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -199,7 +199,9 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      int force)
 {
-       write_lock_irq(&filp->f_owner.lock);
+       unsigned long flags;
+
+       write_lock_irqsave(&filp->f_owner.lock, flags);
        if (force || !filp->f_owner.pid) {
                put_pid(filp->f_owner.pid);
                filp->f_owner.pid = get_pid(pid);
@@ -211,7 +213,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                        filp->f_owner.euid = cred->euid;
                }
        }
-       write_unlock_irq(&filp->f_owner.lock);
+       write_unlock_irqrestore(&filp->f_owner.lock, flags);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,


