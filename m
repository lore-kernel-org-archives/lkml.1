Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZEZJJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZEZJJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZEZJJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:09:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46647 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZEZJJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:09:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-man@vger.kernel.org
Subject: poll never return EBADF?
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090526175622.687B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 May 2009 18:09:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have one stupid question.

"man poll" describe this error code.

>ERRORS
>       EBADF  An invalid file descriptor was given in one of the sets.

but current kernel implementation ignore invalid file descriptor,
not return EBADF.


================ cut code ========================================
static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
{
        unsigned int mask;
        int fd;

        mask = 0;
        fd = pollfd->fd;
        if (fd >= 0) {					//// here
                int fput_needed;
                struct file * file;

                file = fget_light(fd, &fput_needed);
                mask = POLLNVAL;
                if (file != NULL) {			//// and here
                        mask = DEFAULT_POLLMASK;
                        if (file->f_op && file->f_op->poll)
                                mask = file->f_op->poll(file, pwait);
                        /* Mask out unneeded events. */
                        mask &= pollfd->events | POLLERR | POLLHUP;
                        fput_light(file, fput_needed);
                }
        }
================ end code ========================================

In the other hand, SUSv3 talk about 

> POLLNVAL
>    The specified fd value is invalid. This flag is only valid in the
>    revents member; it shall ignored in the events member.

and

> If the value of fd is less than 0, events shall be ignored, and revents 
> shall be set to 0 in that entry on return from poll().

but, no desribe EBADF.
(see http://www.opengroup.org/onlinepubs/009695399/functions/poll.html)

So, I think the implementation is correct.


Why don't we remove EBADF description?



