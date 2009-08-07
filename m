Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZHGUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZHGUxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZHGUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:53:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:46745 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZHGUxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:53:08 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Paris <eparis@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and write permissions set
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	<1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
	<87prb7v0dr.fsf@devron.myhome.or.jp>
	<1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
Date: Sat, 08 Aug 2009 05:53:04 +0900
In-Reply-To: <1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com> (Eric
	Paris's message of "Fri, 07 Aug 2009 16:38:01 -0400")
Message-ID: <87eirnqrbj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

>> > I was thinking about this and kept telling myself I was going to test v2
>> > before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
>> > process didn't have permission to change the ATTR_SIZE.
>> >
>> > Acked-by: Eric Paris <eparis@redhat.com>
>> 
>> BTW, Do you know why doesn't security modules fix the handling of
>> do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
>> pass ATTR_FORCE for it?
>
> I'm not sure what you mean.  I understood ATTR_FORCE to mean 'I am magic
> and get to override all security checks."  Which is why nothing should
> ever be using ATTR_FORCE with things other than SUID.
>
> I guess we could somehow force logic into the LSM to make it only apply
> to SUID and friends but I'm not sure it buys us anything.

Yes, I think it's good way. Don't we want to do the following?

	if (permission check of job)
		return error;
	if (do job at once)
        	return error;

But currently way is,

	if (permission check of first part)
        	return error
	if (do first part of job)
        	return error
	if (permission check of second part)
        	return error
	if (do second part of job)
        	return error

So, if second part was error, we may want to undo the job of first part
in theory. But, to undo is just hard and strange.

This is why I think ATTR_FORCE is good way. What do you think?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
