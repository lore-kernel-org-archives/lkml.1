Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZGBFEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZGBFEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZGBFEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:04:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZGBFEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:04:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oY2tV3S6plG93jsNgDXp0LrF1V6gtiilAsuJuonkv33TkcGiqf4YYWs/SS3PBPrie
	sLKZK4u+YEKs3EZi+TaYA==
MIME-Version: 1.0
In-Reply-To: <20090702121626.7676c7d4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021128.14469.3360.stgit@menage.mtv.corp.google.com>
	 <20090702114555.b7253edf.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907011952t2e698e77j1e8dba21402bc9a9@mail.gmail.com>
	 <20090702121626.7676c7d4.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Jul 2009 22:04:19 -0700
Message-ID: <6599ad830907012204i20fed7a9ud4ae5610cfc9a6ae@mail.gmail.com>
Subject: Re: [PATCH 7/9] [RFC] Support multiply-bindable cgroup subsystems
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 8:16 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hm, then, moving SUBSYS() macro to linux/cgroup_subsys.h is a sane way, I think.
> IMHO, it's not very good habit that cgroup_subsys.h is parsed in different ways in
> cgroup.h and cgroup.c
>
> I think cgroup_subsys.h like following is much simpler even if it's not very
> sophisticated.


> ==
> #define SUBSYSID(_name)         _name ## _subsys_id,
> #define SUBSYSP(_name)          &_name ## _subsys,

You'd also need a macro for the extern declaration of each *_subsys
variable. So it would be 8 lines of boilerplate for each subsystem,
plus adding to the CGROUP_ALL_* macros below. Yes, it could be done
that way, but I'm not convinced that it's hugely simpler.

The state of things prior to this patch series is that to do something
at compile time that involves all subsystems (currently we have three
cases - defining the subsys_id enum, declaring the extern subsys
structures, and defining the array of subsys structure pointers) you
just define the macro SUBSYS to expand to the code fragment you want
to repeat and include cgroup_subsys.h. This is very simple from the
subsystem writer's PoV, and not too tricky in the core framework.

I agree that this patch does increase the complexity in the framework
code, since the framework code needs to deal with all the non-multi
subsystems ahead of all multi-subsystems, and so has to do two passes
through the file.

OK, thinking more about this, your earlier suggestion of splitting
cgroup_subsys.h and using a single SUBSYS macro would achieve this
more simply after all. Let me try that and see how it looks.

Paul
