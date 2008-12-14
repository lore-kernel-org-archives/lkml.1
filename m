Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYLNWA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYLNWA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYLNWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:00:13 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61702 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYLNWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=fChP5Te0G6dfP+eXtbL3qywJo8dTIIAoAOVcTHQqTPxkV6PUTFNW0NpRcbGJnnQgVp
         E2vogQ7buJitwuX0b1FKxUy0fYoAx2tZTaC8xawdKHZtNk4RL+vizExDzTGKj1uCXZuR
         DzZqrHlqIaUYWrwrsNovyMfyk7bL0m6540wlQ=
Message-ID: <494581D7.6000203@gmail.com>
Date: Sun, 14 Dec 2008 22:59:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: oleg@tv-sign.ru
CC: kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: broken do_each_pid_{thread,task}
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting
`if (type == PIDTYPE_PID)' is unreachable
warning from kernel/exit.c. The preprocessed code looks like:
do {
         struct hlist_node *pos___;
         if (pgrp != ((void *)0))
                 for (LIST ITERATION) {
                         {
                          if (!((p->state & 4) != 0))
                           continue;
                          retval = 1;
                          break;
                         }
                         if (PIDTYPE_PGID == PIDTYPE_PID)
                                 break;
                 }
} while (0);
and it's obviously wrong.

After investigating this code usage all around, it's broken on many places
this or similar way.

For do_each_pid_thread(), even this code snippet from fs/ioprio.c is broken
due to double do {} while expansion:
do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
  ret = set_task_ioprio(p, ioprio);
  if (ret)
    break;
} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);

Any idea how to get rid of this issue?
