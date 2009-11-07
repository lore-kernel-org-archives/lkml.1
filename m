Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZKGUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZKGUJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZKGUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:09:23 -0500
Received: from aa.81.b6.static.xlhost.com ([207.182.129.170]:57362 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZKGUJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:09:23 -0500
X-Greylist: delayed 1583 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Nov 2009 15:09:22 EST
Date: Sat, 7 Nov 2009 14:43:03 -0500
From: angelo.borsotti@gmail.com
Reply-To: angelo.borsotti@gmail.com
To: linux-kernel@vger.kernel.org
Message-ID: <13000625.11257622983772.JavaMail.root@wombat>
In-Reply-To: <Pine.LNX.4.64.0607061217320.3869@g5.osdl.org>
Subject: Re: Re: Strange Linux behaviour with blocking syscalls and stop
  signals+SIGCONT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would venture to suggest a possible solution. But let's fist see what
could be a reasoneable goal to achieve. Compatibility with existing
applications is a must, so, solutions must not break it.
Easy porting applications written for other Unixes is also a desirable
feature. Being able to write correct programs that cope with stopping/
continuing is also a must.
The very last (correctness) cannot be achieved with the existing API:
suppose you are implementing a library, and you want to cope with
stopping (i.e. make the process using the library continue properly
after having been stopped). You cannot simply restart calls (the 16
ones that are interrupted by stop signals) because EINTR can be
returned also when other signals have been catched. You cannot either
rely on some flags set in a handler for SIGCONT because handlers
might be already in place when your library functions are called
(and you cannot change them since they are out of your control).
A possible solution to consider is to have the kernel store the number
of the signal that interrupted a call so that user code can decide
the action that is most appropriate for the signal received.
Since this adds to the existing API, it cannot break existing programs.
People that want to port code from other Unixes can do that simply
writing wrappers for the 16 syscalls that restart them when a stop
signal is received. People that want to cope with stop signals in new
code can restart them testing the signal that interrupted the calls
(it would use a feature that is not in the POSIX standard, but it
would work).

--
This message was sent on behalf of angelo.borsotti@gmail.com at openSubscriber.com
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/4393984.html
