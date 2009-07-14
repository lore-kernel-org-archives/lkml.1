Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZGNAuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZGNAuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZGNAuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:50:02 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZGNAuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:50:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=N4jhRvrvO4+NUEIbqLBSxd72yf7lShQ3h6uHyAjF+Zx0Dhw+YGJmbSH2o3rpJe90E
	odGFZibL7AoYEVAUw1a6g==
MIME-Version: 1.0
In-Reply-To: <4A4DC81B.3050608@cn.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021133.14469.35140.stgit@menage.mtv.corp.google.com>
	 <4A4DC81B.3050608@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 17:49:56 -0700
Message-ID: <6599ad830907131749i171f664ey878d6c778132c290@mail.gmail.com>
Subject: Re: [PATCH 8/9] [RFC] Example multi-bindable subsystem: a per-cgroup 
	notes field
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 1:58 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> If it's not per cgroup, it can be a global value.

No it can't, since the notes subsystem can be mounted on multiple
hierarchies simultaneously.

> But why not make it per cgroup?

Setting notes.size to a large value allows userspace to create large
kmalloc'd objects; so if it's per-cgroup, then it's not safe to
delegate control of part of a cgroups hierarchy to untrusted users.
(E.g. we want to be able to give an untrusted user process the power
to create sub-cgroups in the CPU scheduler hierarchy, so that it can
give different CPU guarantees to each of its threadpools).

I guess that an alternative would be to have a per-cgroup size field,
and use the min of the cgroup and all its ancestors when doing length
checking.

>> +     if (nbytes > cg_info(cgrp->top_cgroup)->max_len)
>> +             return -E2BIG;
>> +     if (nbytes) {
>> +             notes = kmalloc(nbytes, GFP_USER);
>> +             if (!notes)
>> +                     return -ENOMEM;
>> +             if (copy_from_user(notes, userbuf, nbytes))
>
> missing kfree(notes)
>

Good catch, thanks. Fixed (and all the newlines added).

Paul
