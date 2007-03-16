Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbXCPVX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbXCPVX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965962AbXCPVX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:23:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42853 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965961AbXCPVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:23:55 -0400
Date: Fri, 16 Mar 2007 14:23:56 -0700
From: Paul Jackson <pj@sgi.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: vatsa@in.ibm.com, menage@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, akpm@linux-foundation.org
Subject: Re: Summary of resource management discussion
Message-Id: <20070316142356.3b9a5597.pj@sgi.com>
In-Reply-To: <20070316141915.GA6572@MAIL.13thfloor.at>
References: <20070312124226.GD17151@in.ibm.com>
	<6599ad830703150424t3478cd55mf9d2699f3669c9f0@mail.gmail.com>
	<20070315170435.GA28692@in.ibm.com>
	<20070316141915.GA6572@MAIL.13thfloor.at>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert wrote:
> looks good to me, except for the potential issue with
> the double indirection introducing too much overhear

It's not the indirection count that I worry about.

It's the scalability of the locking.  We must avoid as
much as possible adding any global locks on key code paths.
This means:
 1) be reluctant to add them to fork/exit
 2) just RCU locks on per-job (or finer grain) data when on
	the normal page allocation path
 3) nothing outside the current task context for the normal
	task scheduling code path.

A global lock on the wrong code path is fatal for scaling
big NUMA boxes.

... now whether or not that is an issue here, I don't claim
to know.   I'm just worried that it could be.

Atomic data, such as global counters, is just as bad.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
