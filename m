Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXC0GgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXC0GgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXC0GgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:36:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48791 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbXC0GgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:36:01 -0400
Message-ID: <20070327023559.y7gvoty7ksg4kw44@imap.linux.ibm.com>
Date: Tue, 27 Mar 2007 02:35:59 -0400
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: balbir@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
References: <20070325164746.GI11794@in.ibm.com>
	<4606B6CF.6040306@in.ibm.com> <20070326115046.GK11794@in.ibm.com>
	<20070326105813.5678ea5d.pj@sgi.com>
In-Reply-To: <20070326105813.5678ea5d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Jackson <pj@sgi.com>:

> vatsa wrote:
>> Well, someone may have attached to this cpuset while we were waiting on the
>> mutex_lock(). So we need to do a atomic_read again to ensure it is still
>> unused.
>
> I don't see how this could happen. If we hold the task lock that now
> (thanks to your good work) guards this pointer, and if we decrement to
> zero the reference count on the cpuset to which it points and then
> -overwrite- this last remaining visible pointer to that cpuset with a
> pointer to a different cpuset, then aren't we guaranteed to be holding
> the last remaining reference to the old cpuset in our local variable,
> making it impossible for anyone else to attach to it in any way?

Yes, but the cpuset is not made invisible to userspace (in filesystem)  
yet. So as cpuset_exit() discovers that cpuset B has zero refcount now  
and blocks on mutex_lock(&manage_mutex) [ to do a check_for_release  
later ], someone could have done a attach_task to that cpuset.

