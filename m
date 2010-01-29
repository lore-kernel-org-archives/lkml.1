Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832Ab0A2Xls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0A2Xls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806Ab0A2Xlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:41:47 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:5470 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0A2Xlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:41:46 -0500
Date: Fri, 29 Jan 2010 16:41:45 -0700
From: Alex Chiang <achiang@hp.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
Message-ID: <20100129234145.GC5177@ldl.fc.hp.com>
References: <20100129214039.17745.38679.stgit@bob.kio> <adar5p8ldxv.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar5p8ldxv.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier <rdreier@cisco.com>:
> 
> Have you considered drivers/infiniband/core/user_mad.c and ucm.c?

Ah, darn. I had not considered those drivers. You're gonna make
me learn a lot more about IB than I'd originally intended. ;)

> I think user_mad.c is somewhat more important, as that is what
> allows an adapter to be used for running the SM.  So I think
> we're still left with some potential issues around lots of
> adapters in one system.  (I think use of ucm by real apps is
> minimal to nonexistent, but someday we should deal with that
> too)

Ok, a quick glance through those drivers shows:

	enum {
		IB_UMAD_MAX_PORTS  = 64,
		IB_UMAD_MAX_AGENTS = 32,

		IB_UMAD_MAJOR      = 231,
		IB_UMAD_MINOR_BASE = 0
	};

and

	enum {
		IB_UCM_MAJOR = 231,
		IB_UCM_BASE_MINOR = 224,
		IB_UCM_MAX_DEVICES = 32
	};

They're all sharing the same major number, so they'll all have to
get the same treatment as the uverbs driver wrt overflow (to
prevent minor number overlap).

What I'm a little unsure of is, does IB_UMAD_MAX_AGENTS need to
double too? We don't export the agent id in the filesystem
anywhere, but we do give it to the user via an ioctl. That's just
used for book keeping purposes but...

Currently, there are 2x as many ports as there are agents. Do we
want to keep that ratio, or would it be ok to have 4x as many
ports as there are agents?

Thanks (and sorry for the n00b questions).

/ac
