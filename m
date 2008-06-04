Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYFDOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYFDOnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFDOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:43:05 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:51128 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYFDOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:43:04 -0400
Message-ID: <4846A9F4.40003@skyrush.com>
Date: Wed, 04 Jun 2008 08:43:00 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com> <20080602155133.GC933@devserv.devel.redhat.com>
In-Reply-To: <20080602155133.GC933@devserv.devel.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, Jun 02, 2008 at 09:26:48AM -0600, Joe Peterson wrote:
>> P.S.  My stty process sits in "T" - did you say that it would be in "R"
>> if straced and that is correct?
> 
> T would be correct. I'll put together a small diff to printk useful stuff
> when it happens and sent it you tonight/tomorrow

[Alan, thanks for the tips on where to instrument this]

What I have verified so far is that when the problem occurs, it gets to
this point in [tty_io.c] tty_check_change():

1229         kill_pgrp(task_pgrp(current), SIGTTOU, 1);
1230         set_thread_flag(TIF_SIGPENDING);
1231         ret = -ERESTARTSYS;
1232 out:
1233         return ret;

So the error that gets returned to set_termios() is -512.

Also, the various checks before this point (of course) did not pass
(current->signal->tty != tty, !tty->pgrp, task_pgrp(current) ==
tty->pgrp, is_ignored(SIGTTOU), is_current_pgrp_orphaned()).  I have not
printed out the various values from these - let me know if this would be
helpful.  I wanted to pass this info along now in case it is of help.

						-Joe
