Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZAVQaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZAVQaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZAVQaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:30:06 -0500
Received: from spaceboyz.net ([87.106.131.203]:42440 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZAVQaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:30:04 -0500
X-Greylist: delayed 1335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 11:30:04 EST
Subject: [BUG] inotify_destroy infinite loop (unbalanced lock?)
From: David LAMPARTER <lists@diac24.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 22 Jan 2009 17:07:44 +0100
Message-Id: <1232640464.8054.54.camel@arkology.n2.diac24.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending to LKML because MAINTAINERS outdated?)
  rml, novell com
    SMTP error from remote mail server after RCPT TO:<rml@novell.com>:
    host prv2-mx.provo.novell.com [130.57.1.12]: 550 Mailbox not found
  ttb, tentacle dhs org
    Unrouteable address

Hi,

on my box (2.6.27.9-grsec*) I seem to have hit an infinite loop in
inotify_destroy; it chews away all the CPU, is unkillable, stays within
the function in the call trace.

(*grsecurity should not have modified anything here)

Call Trace:
 <EOI>  [<ffffffff807af8a7>] _cond_resched+0x11/0x38
 [<ffffffff802d28d5>] pin_to_kill+0x53/0xd6
 [<ffffffff807afdb0>] mutex_lock+0xd/0x1e
 [<ffffffff802d3318>] inotify_destroy+0x81/0xd9
 [<ffffffff802d34da>] inotify_release+0x23/0xe4
 [<ffffffff802aa574>] __fput+0xb1/0x179
 [<ffffffff802a7bb7>] filp_close+0x5b/0x62
 [<ffffffff802a7c51>] sys_close+0x93/0xcb
 [<ffffffff80217e9b>] system_call_fastpath+0x16/0x1b

(obtained by echo 'l' > /proc/sysrq-trigger)
I repeatedly requested traces and was able to build a rough graph:

(if unreadable go to
http://celeste.diac24.net/kbug-jupiter-20080122-inotify/trace.txt )

inotify_destroy+0x21/0xd9, mutex_lock+0xd/0x1e, _cond_resched+0xa/0x38
inotify_destroy+0x21/0xd9, mutex_lock+0xd/0x1e, mutex_lock+0x13/0x1e
inotify_destroy+0x67/0xd9, inotify_destroy+0x69/0xd9
inotify_destroy+0x67/0xd9, inotify_destroy+0x72/0xd9
inotify_destroy+0x67/0xd9, inotify_destroy+0x79/0xd9
inotify_destroy+0x67/0xd9, pin_to_kill+0x1d/0xd6
inotify_destroy+0x67/0xd9, pin_to_kill+0x28/0xd6
inotify_destroy+0x67/0xd9, pin_to_kill+0x2d/0xd6, pin_to_kill+0x33/0xd6
inotify_destroy+0x67/0xd9, pin_to_kill+0x2d/0xd6, pin_to_kill+0x38/0xd6
inotify_destroy+0x67/0xd9, pin_to_kill+0x2d/0xd6, _spin_lock+0xa/0x15
inotify_destroy+0x67/0xd9, pin_to_kill+0x53/0xd6, mutex_unlock+0xa/0xb
inotify_destroy+0x67/0xd9, pin_to_kill+0x53/0xd6, pin_to_kill+0x58/0xd6
inotify_destroy+0x81/0xd9, mutex_lock+0xd/0x1e, mutex_lock+0x10/0x1e
inotify_destroy+0x81/0xd9, mutex_lock+0xd/0x1e, mutex_lock+0x13/0x1e
inotify_destroy+0x81/0xd9, mutex_lock+0xd/0x1e, pin_to_kill+0x53/0xd6, 
                                                _cond_resched+0x11/0x38
inotify_destroy+0x94/0xd9, idr_find+0x22/0x5d
inotify_destroy+0x94/0xd9, idr_find+0x3/0x5d
inotify_destroy+0x94/0xd9, idr_find+0xe/0x5d
inotify_destroy+0xc7/0xd9, deactivate_super+0x20/0x77,
                           _atomic_dec_and_lock+0x23/0x50
inotify_destroy+0xc7/0xd9, deactivate_super+0x20/0x77,
                           __cond_resched+0x1c/0x43,
                           _atomic_dec_and_lock+0x23/0x50
inotify_destroy+0xc7/0xd9, inotify_destroy+0x19/0xd9
inotify_destroy+0xc7/0xd9, unpin_and_kill+0x18/0x40,
                           deactivate_super+0x14/0x77
inotify_destroy+0xc7/0xd9, unpin_and_kill+0x18/0x40,
                           deactivate_super+0x1b/0x77
inotify_destroy+0xc7/0xd9, unpin_and_kill+0x18/0x40, 
                           put_inotify_watch+0x0/0x4d
inotify_destroy+0xc7/0xd9, unpin_and_kill+0x18/0x40,
                           put_inotify_watch+0x12/0x4d


Trying to figure out what's happening, i noticed that ih->mutex is
locked twice in inotify_destroy, but i'm not too kernel fluent there.

Keywords: inotify, unbalanced lock, infinite loop

Please Cc, also any suggestions on killing (or
freezing) the process w/o rebooting the box welcome...


-David


# cat /proc/version 
Linux version 2.6.27.9-grsec (equinox@arkology) (gcc version 4.3.2
(Gentoo 4.3.2 p1.0) ) #12 SMP Sun Jan 4 11:23:58 CET 2009
# ps u 1631
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
user      1631 94.1  0.0  15360  1604 ?        R    Jan21 1060:16 imap
(imap from dovecot-1.1.8)
# ls -lA /proc/1631/fd
l-wx------ 1 root root 64 22. Jan 14:40 2 -> pipe:[263870706]
lrwx------ 1 root root 64 22. Jan 14:40 6 -> anon_inode:[eventpoll]

(probably cannot reproduce this, will keep the task running for a few
days in case anyone wants to inspect /dev/kmem or something.)



