Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYIMI2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYIMI2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYIMI1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:27:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:28631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYIMI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hiUEGzfCBgoyjo5176DTf+uLctrQbR+IuRdI++04v660cEZbdmdIas0xSADYb1zejX
         DEZZ+xl0SYKIgjjsNnthUx3CetA0r681jF+aheSBRqB4LSUQAaGMZfR+6uwG+LU2wH8G
         VryUYJq7IMgU0NgHB+ziRCP2iFqnwO3PDGmok=
Message-ID: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com>
Date: Sat, 13 Sep 2008 13:57:28 +0530
From: "karthikeyan S" <karthispeaks@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: A bug (probably) in stop_all_threads
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies if I am posting this message in an incorrect mailing list
and for bringing up an issue with older kernel version (2.4), and if
the issue had been brought up earlier and I missed it.

There seems to be a bug with stop_all_threads function in 2.4. The
function sends SIGSTOP to all the threads in the thread group and
waits until all the threads get their state changed accordingly.

While waiting, if it finds that the event has not occurred, it tires
to yield the processor to other processes by calling
schedule_timeout().

Bur before calling schedule_timeout() it does not set the task state
to either TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.
So schedule_timeout() does not do anything effectively.

This causes a problem in our device which uses kernel 2.4. When we
have a sigsegv from the task which runs at highest priority, the
control is stuck waiting for all the threads in the thread group to
change their task state. But the other threads never get a chance to
run and the SIGSTOP sent to them is of no effect.

When  I changed the stop_all_threads function to set the task state to
TASK_INTERRUPTIBLE, the problem disappears.

So is this a real issue that stop_all_threads() does not set the
current task to TASK_INTERRUPTIBLE before calling schedule_timeout()?

Please provide your feedback. Thanks a lot.

-karthik
