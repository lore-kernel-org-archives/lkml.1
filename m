Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYBYG4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYBYG4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYBYGzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:55:54 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:51347 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYBYGzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:55:53 -0500
From: Srinivasa DS <srinivasa@in.ibm.com>
Organization: IBM
To: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] [PATCH] To refuse users from probing preempt_schedule()
Date: Mon, 25 Feb 2008 12:25:53 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com
References: <200802251127.40579.srinivasa@in.ibm.com> <1203920424.6662.14.camel@nimitz.home.sr71.net>
In-Reply-To: <1203920424.6662.14.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251225.53732.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 11:50:24 am Dave Hansen wrote:
> On Mon, 2008-02-25 at 11:27 +0530, srinivasa wrote:
> > This patch prohibits user from probing preempt_schedule(). One way of
> > prohibiting the user from probing functions is by marking such
> > functions with __kprobes. But this method doesn't work for those
> > functions, which are already marked to different section like
> > preempt_schedule() (belongs to __sched section). So we use blacklist
> > approach to refuse user from probing these functions.
>
> preempt_schedule() does sound really, really important.  But, what kinds
> of functions can't be kprobed?  
      
Normally we don't allow user to probe those functions, which are used by 
kprobes internally while registering probe on user specified address.  For 
example kprobes internally makes use of preempt_disable()(this in turn calls 
add_preempt_count()), so we prohibit users from probing add_preempt_count() 
function.  To get comprehensive list of functions which are prohibited from 
probing, please have a look at functions which are marked under __kprobes. 
 
> It would be nice to give that blacklist 
> a nice comment on the topic. :)

Yes, I  have added comments on the blacklist approach in 
     1)init_kprobes(), where we populate entries  for kprobe blacklist.
     2) in_kprobe_function(), where we verify the user specified address with 
the start and end of the blacklisted function.

>
> Also, have you strained your brains to think of other functions that
> this should be applied to?  Is it just for functions that are sensitive
> and already have an assigned section? 

Yes, this kprobes blacklist approach is only for those functions which are 
sensitive and are already assigned to different sections. Right now, 
there is no other function, except preempt_schedule() which satisfies above 
condition. But in future if we encounter any such functions we surely add 
them kprobe blacklist.



