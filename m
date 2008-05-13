Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYEMGLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYEMGLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbYEMGLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:11:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbYEMGLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:11:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=dWQs4SkFg4R6JAngy5vU2fskxhGbaBpL2NQ/6ho3n/bqCRwhwsTevCbXoZO84zQ9D
	jp340S7CQQpTMcmHNcryA==
Message-ID: <6599ad830805122310q2f403745kd114ec11a8e51b1d@mail.gmail.com>
Date: Mon, 12 May 2008 23:10:48 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [Libcg-devel] cgroupstats, plans?
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, vivk@us.ibm.com,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "Balaji Rao" <balajirrao@gmail.com>
In-Reply-To: <481ADB66.1010007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429122019.GE9585@linux.vnet.ibm.com>
	 <6599ad830805011852t7dc6de32qd4c105a51c2fee06@mail.gmail.com>
	 <481ADB66.1010007@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 2:14 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  I would prefer to select the controller from user stats and then dump the stats
>  from the kernel for that controller using cgroupstats.
>

Yes, that's fine if you're not worried about the cost of some stats
being excessive. I'm not sure whether that's going to be the case or
not. What about those control files that are of type string? Do we
want to return them as stats?

If we're going to use the cgroupstats API, I think we should avoid
having to have each controller have to publish a binary API - we have
the name->type information already in the control file structures.

So how about something like this as the hard-coded part of the API?
(probably needs to be tidied up to fit into the taskstats format)

a new command CGROUP_STATS_GET_API which returns a sequence of
structures of the form:

struct cgroup_stat_subsys {
  u32 reclen;
  u32 id;
  u32 numstats;
  char name[];
};

enum {
  CGROUP_STAT_TYPE_U64,
  CGROUP_STAT_TYPE_S64,
  CGROUP_STAT_TYPE_STRING, /* maybe */
  CGROUP_STAT_TYPE_U64MAP,
};

struct cgroup_stat_type {
  u32 reclen;
  u32 id;
  u32 type;
  char name[];
};

When the user sends a CGROUP_STATS_GET_API request they get a sequence
of cgroup_stat_subsys records (one for each subsystem on that
hierarchy), each followed by the stats available for that subsystem.
E.g.

{ 0, 3, "memory" }
{ 0, CGROUP_STAT_TYPE_U64, "usage_in_bytes" }
{ 1, CGROUP_STAT_TYPE_U64, "limit_in_bytes" }
{ 2, CGROUP_STAT_TYPE_U64MAP, "stat" }
{ 1, 1, "cpuacct" }
{ 0, CGROUP_STAT_TYPE_U64, "usage" }

a new command CGROUP_SET_STATS_REQUEST that lets you tie a particular
set of stats to a given socket. E.g. the parameter structure could be
something like a sequence of records of the form:

struct cgroup_stats_request {
  u32 subsys_id;
  u32 stat_id;
}

Following a successful CGROUP_SET_STATS_REQUEST command, the user
could send a CGROUP_DUMP_STATS command on the same socket to get a
dump of the requested stats in the specified order.

Paul
