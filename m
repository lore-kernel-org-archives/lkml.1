Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYGJR05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYGJR05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbYGJR0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:26:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312AbYGJR0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:26:47 -0400
Date: Thu, 10 Jul 2008 13:25:46 -0400
From: Rik van Riel <riel@redhat.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710132546.264a89cd@cuia.bos.redhat.com>
In-Reply-To: <48763129.9060903@redhat.com>
References: <20080701191126.GA17376@redhat.com>
	<20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
	<20080703155446.GB9275@redhat.com>
	<6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
	<20080710104852.797fe79c@cuia.bos.redhat.com>
	<20080710154035.GA12043@redhat.com>
	<48763129.9060903@redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 08:56:25 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> Once the information is available, how is it used?  We'd have to pass
> additional information to the exec syscalls.  And it has to happen so
> that if the exec call fails the original process is not affected (i.e.,
> premature changing isn't an option).  The method also must be
> thread-safe in a limited way: executing failing exec syscalls in
> multiple threads mustn't disturb the process.

One easy way is to have a "migrate on exec" option added to the
process group code.  Instead of moving yourself to a new process
group before exec, you do the same invocation but with a "migrate
me lazily at exec time" flag.

At exec time, your current resources will be subtracted from the
old process group (most of it automatically in exit_mmap) and your 
new resources will be added to the new process group on the other 
side of exec.

The exec syscall itself does not need to change.

> There is one set of problems which I don't care about but others likely
> will: what happens if some program uses the syscalls directly?  And what
> happens with old libcs and old statically linked programs?  It's exactly
> the kind of problem why I tell people to never linked statically but
> some people don't listen.

Those people will have to move their processes around between
process groups manually (or with shell scripts).  Having per
program process groups is essentially bonus functionality
over the "start daemon in own process group" and "start user
in own process group" functionalities.

Whether and how we want to implement this is open for discussion.

Personally I suspect that a kernel side rule-based engine with
user loadable rules may not be the best idea :)

-- 
All Rights Reversed
