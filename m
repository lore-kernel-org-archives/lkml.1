Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbYCELvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbYCELvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762662AbYCELvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:51:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317AbYCELvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:51:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=arrRdR++UxqQr9BO+GXvVsj9JYJykDLj/la/xtHIWStWY5DPzmKFLixGTensU3p5r
	cqRRfvVg2YRbis0l3zu8Q==
Message-ID: <6599ad830803050351p91bdacahd47059e863f56817@mail.gmail.com>
Date: Wed, 5 Mar 2008 03:51:01 -0800
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
Cc: lkml <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>
In-Reply-To: <20080305110730.GB22217@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080304152341.GB5659@linux.vnet.ibm.com>
	 <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com>
	 <20080305103343.GA22217@linux.vnet.ibm.com>
	 <6599ad830803050241k590e4389ud95b9b3ef920f8b6@mail.gmail.com>
	 <20080305110730.GB22217@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 3:07 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>
>  OK. Hmm, I've not really thought about it. At first thought, it should
>  not be very difficult. Only thing I am not sure is the arbitrary
>  grouping of the groups (ok, a bit confusing).

I suspect that the main form of composite grouping is going to be
between parents and children. E.g. you might want to say things like:

create_group(A, memory=1G, cpu=100)
create_group(B, parent=A, memory=inherit, cpu=20)
create_group(C, parent=A, memory=inherit, cpu=30)

i.e. both B and C inherit/share their memory limit from their parent,
but have their own CPU groups (child groups of their parent?)

So this would result in a single group A in the memory hierarchy and a
top-level group A and child groups B and C in the cpu hierarchy. libcg
would abstract away the fact that when you moved a process into an
abstract group, it actually had to be moved into multiple real groups.

I think this kind of sharing is fairly easy to specify. Now, there's
no reason that it shouldn't support more complex group sharing as
well, but that might require the user to use lower-level operations,
such as creating resource groups in particular hierarchies, and
associating abstract groups with those resource groups.

The model above (children sharing resource groups with their parents
for some resources) is actually something that I figured could be
supported relatively straightforwardly in the kernel - essentially:

- each subsystem "foo" would have a foo.inherit file provided by
cgroups in each group directory

- setting the foo.inherit flag (i.e. writing 1 to it) would cause
tasks in that cgroup to share the "foo" subsystem state with the
parent cgroup

- from the subsystem's point of view, it would only need to worry
about its own foo_cgroup objects  and which task was associated with
each object; the subsystem wouldn't need to care about which tasks
were part of each cgroup, and which cgroups were sharing state; that
would all be taken care of by the cgroup framework

I'd sketched out a fairly nice design for how it would all work in my
head when I realised that it could actually all be done via multiple
hierarchies in userspace with something like the libcg operations I
suggested above.

Paul
