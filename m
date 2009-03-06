Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZCFWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZCFWHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZCFWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:07:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:39806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZCFWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=hHMtinc8/Q8F08Etwvjoll0piHxrzK2phAZhwvWdX4o+ALv7+KQWUjmXPGvIQkI8nz
         2hFdT66xHZU/me+FWZHo56y6TDEnBqCtOm+OHjz4xPfaQeY2gDJBYdDK3Z6npLYjjnXY
         GOnaGfqnEsrYSSC4NS6by2DVZyeBhFwoT4yPU=
MIME-Version: 1.0
Date: Sat, 7 Mar 2009 01:07:22 +0300
Message-ID: <eed7af970903061407q391fcae1xaf86b0c93f2570de@mail.gmail.com>
Subject: [BUG] parport_pc: ECP+EPP mode doesn't work
From: Max Dmitrichenko <dmitrmax@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've been facing a strange bug (at least in 2.6.24 and 2.6.26). I've
got a PC with SuperIO controller which supports (de jure non-standard
but de facto very common) mode of LPT which is called ECP+EPP, along
with the standard modes "EPP only" and "ECP only". But kernel detects
port to have only [SPP, TRISTATE] when I switch the SuperIO into this
mode in BIOS. ECP mode is not detected since CONFIG_PARPORT_PC_FIFO is
turned off, so its OK. But why it fails to detect EPP?

I've investigated parport_pc code and that's what I found. Have a look
at parport_EPP_supported() function.

1932         /* If EPP timeout bit clear then EPP available */
1933         if (!clear_epp_timeout(pb)) {
1934                 return 0;  /* No way to clear timeout */
1935         }
1936
1937         /* Check for Intel bug. */
1938         if (priv->ecr) {
1939                 unsigned char i;
1940                 for (i = 0x00; i < 0x80; i += 0x20) {
1941                         ECR_WRITE (pb, i);
1942                         if (clear_epp_timeout (pb)) {
1943                                 /* Phony EPP in ECP. */
1944                                 return 0;
1945                         }
1946                 }
1947         }

Here, if ECP mode is supported by SuperIO, the code checkes for some
bug. Semantics is that it puts ECP port into every supported mode
(Standard mode, Byte mode, FIFO mode and ECP FIFO Mode) except the EPP
mode. In every mode it tries to clear EPP timeout condition. If it
succeeds to clear EPP timeout then bug is found. I don't know anything
about this bug, but let's suppose that author of this code thought so,
because EPP timeout can't be cleared in non-EPP mode.

I've found that EPP mode is not detected because this function return
at line 1944 (i.e. code decides that this strange bug is found). But
what happens in clear_epp_timeout() function?

 250 static int clear_epp_timeout(struct parport *pb)
 251 {
 252         unsigned char r;
 253
 254         if (!(parport_pc_read_status(pb) & 0x01))
 255                 return 1;
 ....
 265 }

So, if timeout bit is not asserted (i.e. nothing to clear) then
function returns a success. From one side, we have a code which finds
success of this function to be a bug (if non-EPP mode is active), from
the other side, it is definitely normal that in non-EPP mode there is
nothing to clear so this function has no option to fail.

So does anybody know something about this strange "intel bug"? I think
if this bug exists then it should be handled in a different way,
because now it prevents the EPP mode to be detected when ECP+EPP mode
enabled.

I also appreciate if someone can test a fairy recent kernel with the
LPT port configured into ECP+EPP mode in BIOS and check whether EPP is
detected along with ECP.

--
  Max
