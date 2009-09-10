Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZIJQ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZIJQ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZIJQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:26:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49326 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZIJQ0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:26:54 -0400
Date: Thu, 10 Sep 2009 09:31:40 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v6][PATCH 9/9]: Document clone_with_pids() syscall
Message-ID: <20090910163140.GA14158@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com> <20090910061413.GH25883@us.ibm.com> <20090910082659.033ab8fd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910082659.033ab8fd.randy.dunlap@oracle.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the review. Will fix the typos.

Randy Dunlap [randy.dunlap@oracle.com] wrote:
| > +Example:
| > +
| > +	struct pid_set pid_set { 3, {0, 99, 177} };
| > +	void *child_stack = malloc(STACKSIZE);
| > +
| > +	/* set up child_stack, like with clone() */
| > +	rc = clone_with_pids(clone_flags, child_stack, NULL, NULL, &pid_set);
| > +
| > +	if (rc < 0) {
| > +		perror("clone_with_pids()");
| > +		exit(1);
| > +	}
| 
| What happens when one of the pids is busy?  Say the last one in the
| example above [177].  Are the first 2 children already cloned
| or are all pids checked for availability before cloning?

Only _one_ one child process is created (on success). With nested pid
namespaces a process is known by different pids (or pid numbers to be
precise) - one in each pid namespace.

(BTW, looks like we did not document pid-namespaces in the Documentation/
But please see the CLONE_NEWPID section of a recent version of clone(2)).

In short, the above clone_with_pids() tries to create a single child process
with the given pids.

| If the latter, is there a race there?
| and what value is returned?

There is no race - bc just a single process is being created.

If any of the pids are not available, the child process is not created
and the system call returns -EBUSY (if the user requested say 99 and 99
is in use by another process)
