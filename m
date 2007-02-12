Return-Path: <linux-kernel-owner+w=401wt.eu-S964808AbXBLJUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbXBLJUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXBLJUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:20:12 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:44023 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964808AbXBLJUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:20:10 -0500
Date: Mon, 12 Feb 2007 01:18:43 -0800
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@osdl.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Message-Id: <20070212011843.c6e8f4ae.pj@sgi.com>
In-Reply-To: <20070212081521.808338000@menage.corp.google.com>
References: <20070212081521.808338000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - temporarily removed the "release agent" support.

ouch

> ... it can be re-added ... via a kernel thread that periodically polls containers ...

double ouch.

You'll have a rough time selling me on the idea that some kernel thread
should be waking up every few seconds, grabbing system-wide locks, on a
big honkin NUMA box, for the few times per hour, or less, that a cpuset is
abandoned.

Offhand, that sounds mildly insane to me.

And how would this get the edge-triggered, rather than level-triggered,
release?  In other words, if a new cpuset is created, and marked with
the notify_on_release flag, but otherwise not yet used (no child
cpusets and no tasks in it) then it is not to be released (removed.)
Only children and/or tasks are added, then later removed, is it a
candidate for release.  I guess you'll need yet another state bit, set
when the cpuset is abandoned (last child removed or last pid
exits/leaves), and cleared when this kernel thread visits the cpuset to
see if it should be removed.

Can you explain to me how this intruded on the reference counting?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
