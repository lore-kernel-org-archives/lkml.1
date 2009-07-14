Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZGNReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZGNReT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZGNReT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:34:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZGNReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:34:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=s37DhCtTMxj5UtOYjiUi3ytfxq5fs6s6bbormpwnuwIzFTdKMCgFQ3xLhPrJ4dB8N
	XdSZaxW/cEFNmI+RkDO2g==
MIME-Version: 1.0
In-Reply-To: <20090714071617.GK5051@balbir.in.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090705063850.GX11273@balbir.in.ibm.com>
	 <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
	 <20090713121138.GC5051@balbir.in.ibm.com>
	 <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
	 <20090714055638.GI5051@balbir.in.ibm.com>
	 <6599ad830907132349u6cf52060t4fafb6637cbe4ed1@mail.gmail.com>
	 <20090714071617.GK5051@balbir.in.ibm.com>
Date: Tue, 14 Jul 2009 13:34:10 -0400
Message-ID: <2f86c2480907141034r5a985cfue9e8fdf64ad28465@mail.gmail.com>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
From: Benjamin Blum <bblum@google.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitzu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 3:16 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
> * menage@google.com <menage@google.com> [2009-07-13 23:49:16]:
>> As a first cut, we were planning to add an rwsem that gets taken for
>> read in cgroup_fork(), released in cgroup_post_fork(), and taken for
>> write when moving an entire process to a new cgroup; not ideal
>> performance-wise, but safe.
>>
>> If adding a field to task_struct is an option, then the rwsem could be
>> per thread-group leader, which would reduce contention.

That would indeed help, but would only improve system-wide performance
in the case with write-contention (no improvement at all if, say, the
threadgroup is the only one forking, or when nobody is writing to the
procs file). While that's preferable to a global lock, if we can add a
field to task_struct, a (lockless) flag-based approach might be
possible.

> We should also document that moving large processes with several
> threads can be expensive.

Indeed. Or more specifically, that moving fast-growing threadgroups
can be expensive.
