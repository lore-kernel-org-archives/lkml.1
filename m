Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXGQIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXGQIvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbXGQIv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:51:29 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:7741 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXGQIv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Rv4tA+ooT7nUC4x2aAxa8Xwqpx010ajH7auE1Y+HZb0SHyXQyYkTOJ8xeOHo/lePel/oLaG8mJpXojSESVzG1xqqrsbZYIotP19+wniFllgBsQsHFHp6T8fI4Cg9lDpGhfmQbczsH8tddgst99fD2Hw5wCNv8h8nQPNq6hLtj4o=
Message-ID: <d9a6586e0707170151r799ccff1gcd0a84e7f3524cd5@mail.gmail.com>
Date: Tue, 17 Jul 2007 01:51:27 -0700
From: "Shawn Rutledge" <shawn.t.rutledge@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: attempting to open a VT from elsewhere and take raw keyboard input
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm messing around with framebuffer graphics stuff and trying to write
a keyboard driver similar to the one in X, which will allow you to
start up the graphics system from any tty (not just a virtual
console), find an available VT, switch to that VT, and then take input
from the physically attached keyboard rather than necessarily from the
controlling tty (which might not be a VT).  I have looked at the X
implementation (hw/dmx/input/lnx-keyboard.c) which seems
straightforward but I am not getting the same results when I try to do
the same thing, so must be missing something.  I started with this
very simple program:

void main()
{
        int i;
        char c;
        int fd;

        fd = open("/dev/tty1", O_RDWR | O_ASYNC, 0);
        printf("opened /dev/tty1 as fd %d\n", fd);
        if(ioctl(fd, KDSKBMODE, K_RAW) < 0) perror(
                "Warning: failed to change the virtual console to Raw mode.");

        while((i = read(fd, &c, 1)) == 1)
        {
                if( (c &= 255) == 0xBE) /* Cancel */
                        break;
                printf( "%x\n\r", c);
        }
        printf("read returned %d\n", i);
        if(ioctl(fd, KDSKBMODE, K_XLATE) < 0) perror(
                "Warning: failed to change the virtual console to XLATE mode.");

}

If I have the test machine already on VT 1, run the program remotely
over ssh, and start banging on the test machine's keyboard, usually it
seems I do not see any scan codes at first.  If I start by holding
down a key other than the Enter key, there isn't much hope at all.  If
I hold down the Enter key, sometimes I see scan codes fairly soon, and
sometimes it requires several tries.

I tried turning the ICANON flag off via tcsetattr; it doesn't help.  I
tried copying the flags being set in kbdLinuxOn in the X code; it also
doesn't help.  If I use non-blocking I/O, then every read returns -1
regardless if a key has been pressed, regardless which key was being
held down and regardless how long.  If I use blocking I/O and select()
to check if a keystroke is available, then I get one keystroke
whenever there has been so much input that the line has wrapped, plus
an extra one in between; but most of the keystrokes never show up.

Oddly what did help was this scenario:  on the test machine I had an
open ssh session on VT 1, going to another machine.  From the other
machine I opened an ssh session to the test machine and ran the
program; so now the keyboard input which would have gone from the test
machine to the ssh client running on VT 1, was going to my program
instead (also on VT 1 because it opened /dev/tty1 directly).  I got
every keystroke instantly.  So I copied from openssh the tcsetattr
stuff (enter_raw_mode); no change in behavior.  I looked at kdrive
too... but regular X is the only program I know of that can use a VT
despite not having been started in a situation in which stdin is
itself a VT.  I want mine to work like that.

FWIW I'm testing mostly on a Zaurus but get similar results on my main
Linux PC so it's not just a Zaurus thing.

Sorry for bothering the list with this silly userspace stuff but I'm
running out of options, and there might even be a bug in there
somewhere.
