Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbXB1XkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbXB1XkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXB1XkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:40:00 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47160 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXB1Xj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:39:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Albert Cahalan <acahalan@gmail.com>
Subject: Re: PID entries in /proc sorted by number, not start time in 2.6.19
References: <45E601D9.1050503@redhat.com>
Date: Wed, 28 Feb 2007 16:39:43 -0700
In-Reply-To: <45E601D9.1050503@redhat.com> (Chuck Ebbert's message of "Wed, 28
	Feb 2007 17:27:37 -0500")
Message-ID: <m1irdlg8cg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> Starting with kernel 2.6.19, the process directories in
> /proc are sorted by number. They were sorted by process
> start time in 2.6.18 and earlier. This makes the output
> of procps come out in that order too, pissing off users
> who are used to the old way.
>
> To reproduce:
> 	1. Wrap your PID numbers.
> 	2. Do ls -fl /proc
> 	3. Look at output of ps command.
>
> Compare 2.6.18 to 2.6.19.
>
> See also:
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=230227

Apologies, but this was a bug fix for a more serious issue.  The code
to report the directory entries by start time was fundamentally broken.
In particular the sequence:
opendir
readdir
readdir
readdir
....
closedir

can miss processes that exist for the entire duration of that
sequence.  Which is non-posix, non-intuitive, and has no reasonable
work around.

The sorting by pid happened as a side effect of finding a stable token
we can come back to so we can at least guarantee normal readdir
semantics.  That objects that exist for the entire readdir are
guaranteed to be displayed.  That objects that come into existence or
are deleted during the readdir may be missed.  That isn't perfect but
it is a useable semantic. 

Eric
