Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbYJPEFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbYJPEFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 00:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYJPEFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 00:05:46 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:42830 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYJPEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 00:05:45 -0400
Message-ID: <48F6BD8E.4050402@nttdata.co.jp>
Date: Thu, 16 Oct 2008 13:05:34 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       akpm@linux-foundation.org
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp> <20081009164836.GA5480@us.ibm.com> <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp> <20081015012916.GF6874@linux.vnet.ibm.com>
In-Reply-To: <20081015012916.GF6874@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 04:05:38.0740 (UTC) FILETIME=[72D1BF40:01C92F44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> A few comments below -- some rcu_dereference()s are needed.
This list doesn't use RCU since it is for Write-Once-Read-Many 
situation (i.e. no-update and no-delete). TOMOYO Linux uses this list 
for storing policy elements. Most of elements are allocated when the 
kernel is loaded, and they are referred during lifetime of the kernel.

Since read_lock is not needed when referring this list, code of 
TOMOYO keeps its simplicity. If TOMOYO used RCU or reader/writer lock,
the code would be a jumble of read_lock and it would be almost 
impossible to maintain and review the code... X-p This is the reason 
why TOMOYO uses this WORM list.

Though size of policy increases with learning mode, the same 
pathnames once learned will be reused. So memory usage of TOMOYO 
doesn't increase infinitely; if still worried, we can set memory 
quota.

> The general idea looks sound, at least as long as the lists remain
> short.  Otherwise, the list scan in list1_add_tail_mb() will take
> too long.
Typically less than 100. The length of list won't matter since the 
frequency of append is very low.

Paul, would you review this list from the perspective of WORM list?

Regards,

