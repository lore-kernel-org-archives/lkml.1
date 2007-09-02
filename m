Return-Path: <linux-kernel-owner+w=401wt.eu-S933529AbXIBPEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbXIBPEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXIBPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:04:25 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:35941 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXIBPEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:04:24 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: linux-kernel@vger.kernel.org
Subject: [RFD] new syscalls: suspend_other/resume_other?
Date: Sun, 2 Sep 2007 17:04:21 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709021704.22325.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

at the moment implementing a mark and sweep garbage collection 
subsystem is quite a hack, because you always have to use up
some signals for suspend/resume all threads to implement this.

For runtime environments (like D system libraries or JVMs) this is 
a hack, since you take away flexibility from the application.

A possible solution would be a syscall or a PTRACE extension
to realize the suspend/resume. I best describe the possible
syscall manpages here, so you get an idea.

NAME 
	suspend_other - suspends execution of all but the calling thread

SYNOPSIS
	long suspend_other(void);

RETURN VALUE
	Positive count suspended threads on success. 
        If 0, then suspend_other was a no-op and there is nothing to resume, but the
	call should still considered successful.
	If the number is -1, the errno has to be checked for possible error values.

ERRORS
	EDEADLK We run already a suspend_other() and the calling thread 
		has just been resumed.

	EPERM The calling thread is not allowed to do this. 
		(optional case due to security)
	
DESCRIPTION
	After sucessful return of this call, the affected process 
	is single threaded and only the calling thread runs 
	in this process (==MM struct).

	The thread, which calls this is responsible for resuming 
	all the suspended threads. One can iterate through 
	"/proc/self/task/", to verify for sure that one knows all threads,
	if the returned count doesn't match the expected value.

	Any per thread queued signals are deferred until resume_other()
	or process destruction.

NOTES
	This call might be restricted to the main thread.

------------

NAME 
	resume_other - resume execution of foreign thread in this process

SYNOPSIS
	long resume_other(pid_t tid)

RETURN VALUE
	Returns 0, if successful.
	Otherwise -1 is returned, the errno has to be checked for 
	possible error values and the call has no effect at all.

	Any non-blocked signals of that thread which happend during 
	suspend/resume are deliverd now.

ERRORS
	EINVAL The thread is running already. 
		(this is a severe caller BUG).
	ESRCH The thread with tid does not exist.
		(or doesn't belong to this process).
	EPERM The calling thread is not allowed to do this. 
		(optional case due to security)
	
DESCRIPTION
	After sucessful return of this call, the affected thread 
	is the the state it was before it was suspended 
	by calling suspend_other().

NOTES
	The value -1 for tid is reserved for future extension 
	(e.g. meaning ALL other threads).

	This call might be restricted to the main thread.

---------

Any opinions?


Best Regards

Ingo Oeser
