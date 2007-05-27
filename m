Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXE0MzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXE0MzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXE0My5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:54:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:38950 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXE0My4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=ENzMOJi4MgFRDxX2ttRY3AMxuSL1Hq/dxKc1EEN9/yaJ8ceXVgddBhpqF+s020VZwF33YEQg2GN7W21N2cu0KFkpR1rhfy+XOvtcBWhs8vgtdwjlaqoXlhHzI1Hp1PMA9wso++xZzMwqxvRSFVwJgD4T8Pd6TLMTmDCZbzzBig4=
Message-ID: <3d8471ca0705270554q22e77169wb21658108e15420b@mail.gmail.com>
Date: Sun, 27 May 2007 14:54:54 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Unexpected PTY beeping in canonical mode and O_NONBLOCK
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 24f1f21731cfadbf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am experiencing a buffer full condition on a pty, except that I use it with
O_NONBLOCK so I expect it to eat as much data as it can without overflowing.

Here is a simple testcase in Python, asyncore is Python's way to use select(2):

---------8<---------8<---------8<---------8<---------8<---------8<---------8<---

#!/usr/bin/env python

import asyncore
import os
import pty
import sys
import termios
import time

class sh_dispatcher(asyncore.file_dispatcher):
    def __init__(self, fd):
        asyncore.file_dispatcher.__init__(self, fd)
        self.buffer  = ''
        #self.buffer += 'stty -icanon\n'
        self.buffer += 'echo 12345\n' * 460
        self.buffer += 'echo $((3+3))\n'
        self.buffer += 'echo ...BAD..GOOD\n'
        self.printing = False

    def handle_read(self):
        buf = self.recv(4096)
        bells = buf.count('\a')
        if bells:
            print bells, 'BELLS!'
    	if not self.printing:
    	    i = buf.find('6')
    	    if i >= 0:
    	        buf = buf[i:]
    	        self.printing = True
    	if self.printing:
    	    sys.stdout.write(buf)

    def writable(self):
        return self.buffer != ''

    def handle_write(self):
        #time.sleep(0.01)
        sent = self.send(self.buffer)
        self.buffer = self.buffer[sent:]

pid, fd = pty.fork()
if pid == 0:
    os.execlp('sh', 'sh')

sh_dispatcher(fd)
asyncore.loop()

---------8<---------8<---------8<---------8<---------8<---------8<---------8<---

And its output should be:

6
sh-3.1$ echo ...BAD..GOOD
...BAD..GOOD

but actually is:

7 BELLS!
6
sh-3.1$ echo ...BAD
...BAD

This testcase spawns a shell in its own pty, it floods this pty with
'echo 12345\n', then a single 'echo $((3+3))\n' and when it reads back the '6'
it starts printing the output.
The problem is that the 'echo ...BAD..GOOD\n' command is replaced by
'echo ...BAD\n' as the '..GOOD' is replaced by a series of '\a'.

The problem disappears with these (independent) workarounds:

o Putting the pty in non-canonical mode: self.buffer += 'stty -icanon\n'.
This is not satisfactory as I depend on Ctrl-D being interpreted as EOF.

o Delaying the sending to let the shell empty its buffer: time.sleep(0.01).
Well, this is ugly.

o The following patch:
--- linux-2.6.22-rc3/drivers/char/tty_ioctl.c
+++ linux-2.6.22-rc3/drivers/char/tty_ioctl.c
@@ -352,7 +352,6 @@ static void change_termios(struct tty_st
 	if (canon_change) {
 		memset(&tty->read_flags, 0, sizeof tty->read_flags);
 		tty->canon_head = tty->read_tail;
-		tty->canon_data = 0;
 		tty->erasing = 0;
 	}
 	

But this line was even in linux-1.0 so it must be right ;-).

The following comment in n_tty.c explains the problem:

static void n_tty_set_room(struct tty_struct *tty)
{
	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;

	/*
	 * If we are doing input canonicalization, and there are no
	 * pending newlines, let characters through without limit, so
	 * that erase characters will be handled.  Other excess
	 * characters will be beeped.
	 */
	if (left <= 0)
		left = tty->icanon && !tty->canon_data;

	tty->receive_room = left;
}

But it is intended for very long lines, while mine are short. It triggers anyway
because the shell keeps alternating between icanon and -icanon modes so
tty->canon_data is always reset and the pending newlines are not seen, hence the
patch. When in -icanon mode, the alternation does not happend, that's why
'stty -icanon' makes the problem disappear.

Thanks in advance for any help.


-- 
Guillaume
