Return-Path: <linux-kernel-owner+w=401wt.eu-S1161223AbXCGCcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161223AbXCGCcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161225AbXCGCcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:32:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161223AbXCGCcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:32:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=V/6Sc47XjAlL1lvn1Thir8UOFqtMGDPtqzejwI3BTGSZVz1Erivoap2YjXnBJyk5e
	9u2PJXgYw9e4NF4FrrIrg==
Message-ID: <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
Date: Tue, 6 Mar 2007 18:32:07 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: ebiederm@xmission.com, sam@vilain.net, akpm@linux-foundation.org,
       pj@sgi.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070301133543.GK15509@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vatsa,

Sorry for the delayed reply - the last week has been very busy ...

On 3/1/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> Paul,
>         Based on some of the feedback to container patches, I have
> respun them to avoid the "container" structure abstraction and instead use
> nsproxy structure in the kernel. User interface (which I felt was neat
> in your patches) has been retained to be same.

I'm not really sure that I see the value of having this be part of
nsproxy rather than the previous independent container (and
container_group) structure. As far as I can see, you're putting the
container subsystem state pointers and the various task namespace
pointers into the same structure (nsproxy) but then they're remaining
pretty much independent in terms of code.

The impression that I'm getting (correct me if I'm wrong) is:

- when you do a mkdir within an rcfs directory, the nsproxy associated
with the parent is duplicated, and then each rcfs subsystem gets to
set a subsystem-state pointer in that nsproxy

- when you move a task into an rcfs container, you create a new
nsproxy consisting of the task's old namespaces and its new subsystem
pointers. Then you look through the current list of nsproxy objects to
see if you find one that matches. If you do, you reuse it, else you
create a new nsproxy and link it into the list

- when you do sys_unshare() or a clone that creates new namespaces,
then the task (or its child) will get a new nsproxy that has the rcfs
subsystem state associated with the old nsproxy, and one or more
namespace pointers cloned to point to new namespaces. So this means
that the nsproxy for the task is no longer the nsproxy associated with
any directory in rcfs. (So the task will disappear from any "tasks"
file in rcfs?)

You seem to have lost some features, including fork/exit subsystem callbacks


>
> What follows is the core (big) patch and the cpu_acct subsystem to serve
> as an example of how to use it. I suspect we can make cpusets also work
> on top of this very easily.

I'd like to see that. I suspect it will be a bit more fiddly than the
simple cpu_acct subsystem.

Paul
